-- Run this in Supabase SQL Editor for a shared database.
create extension if not exists pgcrypto;
create table if not exists public.markets (
 id uuid primary key default gen_random_uuid(),
 name text not null unique check (char_length(name) between 2 and 100),
 active boolean not null default true,
 created_at timestamptz not null default now()
);
create table if not exists public.results (
 id uuid primary key default gen_random_uuid(),
 market_id uuid not null references public.markets(id) on delete cascade,
 result_date date not null,
 open_panel text check (open_panel is null or char_length(open_panel) <= 12),
 jodi text check (jodi is null or char_length(jodi) <= 8),
 close_panel text check (close_panel is null or char_length(close_panel) <= 12),
 published boolean not null default false,
 updated_at timestamptz not null default now(),
 unique(market_id, result_date)
);
create table if not exists public.site_settings (
 id integer primary key check (id = 1),
 notice text not null default 'Welcome to Guruji Matka Result',
 updated_at timestamptz not null default now()
);
insert into public.site_settings (id, notice) values (1, 'Welcome to Guruji Matka Result — check published records and historical charts.') on conflict (id) do nothing;
alter table public.markets enable row level security;
alter table public.results enable row level security;
alter table public.site_settings enable row level security;
-- Public can read active markets and published records only.
drop policy if exists "Public read active markets" on public.markets;
create policy "Public read active markets" on public.markets for select using (active = true);
drop policy if exists "Public read published results" on public.results;
create policy "Public read published results" on public.results for select using (published = true);
drop policy if exists "Public read site notice" on public.site_settings;
create policy "Public read site notice" on public.site_settings for select using (id = 1);
-- Only authenticated admin users may mutate data. In Supabase, add your admin's auth UUID below.
create table if not exists public.site_admins (user_id uuid primary key references auth.users(id) on delete cascade);
alter table public.site_admins enable row level security;
drop policy if exists "Admin can read own admin record" on public.site_admins;
create policy "Admin can read own admin record" on public.site_admins for select to authenticated using (user_id = auth.uid());
create or replace function public.is_site_admin() returns boolean language sql stable security definer set search_path = public as $$ select exists (select 1 from public.site_admins where user_id = auth.uid()) $$;
drop policy if exists "Admins manage markets" on public.markets;
create policy "Admins manage markets" on public.markets for all to authenticated using (public.is_site_admin()) with check (public.is_site_admin());
drop policy if exists "Admins manage results" on public.results;
create policy "Admins manage results" on public.results for all to authenticated using (public.is_site_admin()) with check (public.is_site_admin());
drop policy if exists "Admins manage settings" on public.site_settings;
create policy "Admins manage settings" on public.site_settings for all to authenticated using (public.is_site_admin()) with check (public.is_site_admin());

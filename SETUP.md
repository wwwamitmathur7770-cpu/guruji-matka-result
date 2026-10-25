# Guruji Matka Result — deployable starter

This is a Next.js website starter with a public results/history page and a separate authenticated admin panel. It is **not publicly hosted yet**. Real shared publishing requires a Supabase project and deployment on a hosting provider.

## 1. What is included
- Gold + dark navy responsive public page
- Market search and result cards
- Historical results table with All / Jodi Chart / Panel Chart views
- Admin sign-in, market creation/deletion, date-wise result publishing/updating, history deletion, and public notice editing
- Supabase/Postgres schema with row-level security policies
- Privacy/terms starter page

The home page shows masked illustrative placeholders in preview mode until a database is connected. Do not publish fake/example result numbers as real records.

## 2. Create the shared database
1. Create a project at https://supabase.com/.
2. Open **SQL Editor** and run all of `supabase/schema.sql`.
3. In Supabase **Authentication → Users**, create your own admin user with an email/password.
4. Copy that user's UUID. In SQL Editor run (replace UUID):
   `insert into public.site_admins (user_id) values ('YOUR-AUTH-USER-UUID');`
5. In Project Settings → API, copy the Project URL and anon/public key.
6. Copy `.env.example` to `.env.local` and fill in `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY`.

Never put a Supabase `service_role` key in browser code or in `NEXT_PUBLIC_*` variables. The browser only uses the anon key; database policies restrict writes to the admin UUID allowlist.

## 3. Run locally
Requires Node.js 18.17+.
```bash
npm install
npm run dev
```
Open http://localhost:3000. Admin panel: http://localhost:3000/admin.

## 4. Publish to the internet
1. Upload this project to a private GitHub repository.
2. Import the repository into https://vercel.com/.
3. Add the two environment variables from `.env.local` in Vercel project settings.
4. Deploy. Vercel will provide a public `*.vercel.app` URL.
5. Test public results, admin login, publishing and history on a second device/browser before sharing the link.
6. To use a custom domain, purchase one from a domain registrar and add it in Vercel project settings.

## 5. Google Search
After the public site is live:
1. Add the domain in https://search.google.com/search-console/.
2. Verify ownership using the DNS method if using a custom domain.
3. Add a `sitemap.xml` and `robots.txt`, then submit the sitemap in Search Console.
4. Make sure the homepage has a descriptive title, useful original content, working mobile layout, HTTPS and no login wall on public pages.
5. Indexing is not instant and is not guaranteed. A new domain can take days or longer to appear.

## Before public launch
- Review local law and obtain qualified legal advice; “no money” alone does not settle legality.
- Replace the starter privacy/terms with reviewed policies and add a contact/reporting channel.
- Do not expose admin credentials. Enable strong passwords and MFA in the provider where possible.
- If you later enable community submissions, add server-side validation, rate limits, moderation and a deletion/report process.
- The prediction field in this starter is intentionally draft-only; it is not saved or shown publicly.

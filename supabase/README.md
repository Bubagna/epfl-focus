# Leaderboard setup

The app is a static page, so accounts and a shared leaderboard need a backend.
Supabase gives email + password with verification and a Postgres database on a free plan.

1. **supabase.com** → sign in with GitHub → **New project**.
   Name `epfl-focus`, region **Frankfurt (eu-central-1)**, set a database password and keep it.
2. Wait for the project to finish provisioning (about two minutes).
3. **SQL Editor** → paste all of `schema.sql` → **Run**. It should say "Success".
4. **Authentication → Sign In / Providers → Email**: leave *Confirm email* **on**, so a new
   account has to click the link in the mail before it can play.
5. **Project Settings → API** → copy two values:
   - **Project URL**, looks like `https://abcdefgh.supabase.co`
   - **anon public** key, a long token starting with `eyJ`

Both of those are meant to ship inside the page — they identify the project, they do not grant
access. The row level security policies in `schema.sql` are what actually protect the data.
The `service_role` key is the dangerous one: never put it in the app.

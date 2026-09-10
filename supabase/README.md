# Leaderboard setup

The app is a static page, so accounts and a shared leaderboard need a backend.
Supabase gives email + password with verification and a Postgres database on a free plan.

1. **supabase.com** → sign in with GitHub → **New project**.
   Name `epfl-focus`, region **Frankfurt (eu-central-1)**, set a database password and keep it.
2. **SQL Editor** → paste all of `schema.sql` → **Run**.
3. **Authentication → Sign In / Providers → Email → Confirm email: OFF.** *Required.*
   Accounts are name + surname; the app derives an address in the reserved `.invalid` domain,
   which by definition can never receive mail. With confirmation on, nobody can ever sign in.
4. **Project Settings → API** → copy the **Project URL** and the **publishable** key into
   `SB_URL` / `SB_KEY` at the top of the leaderboard section in `index.html`.

Both of those are meant to ship inside the page — they identify the project, they do not grant
access. The row level security policies in `schema.sql` are what protect the data.
The `service_role` key is the dangerous one: never put it in the app.

## Why there is no email

Accounts are **name + surname + password**. The app turns "Luigi Colella" into
`luigi.colella@epflfocus.invalid` and sends that to Supabase, which needs *some* address.
`.invalid` is reserved by IANA precisely so that it can never be delivered anywhere.

Nobody proves they own anything, so two people cannot share a name: the second one gets
"someone already signed up with that exact name". Fine for a group of friends, not fine if the
link goes public.

⚠️ Supabase's built-in mailer only sends **two messages per hour** and is meant for testing, which
is the other reason confirmation is off.

## If you ever want real email verification

Switch **Confirm email** back on, change the sign-up form to ask for a real address, and give the
project an SMTP provider — the built-in one will not do. Also set
**Authentication → URL Configuration → Site URL** to `https://bubagna.github.io/epfl-focus/`,
or the confirmation link lands on a dead `localhost:3000`.

### Your own SMTP

Any provider works; the ones that do **not** require you to own a domain are the practical
choice. Brevo, for example: free account → **Senders** → verify one address you control (a
Gmail address is fine) → **SMTP & API** → generate an SMTP key. Then in Supabase:

**Project Settings → Authentication → SMTP Settings → Enable custom SMTP**

| Field | Value |
|---|---|
| Host | `smtp-relay.brevo.com` |
| Port | `587` |
| Username | the login Brevo shows on the SMTP page |
| Password | the SMTP key |
| Sender email | the address you verified |
| Sender name | `EPFL Focus` |

Then **Authentication → Rate Limits** → raise "emails per hour" from the default 30 to whatever
you need. With custom SMTP the mails go to any address, not just your own team's.

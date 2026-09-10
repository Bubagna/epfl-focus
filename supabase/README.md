# Leaderboard setup

The app is a static page, so accounts and a shared leaderboard need a backend.
Supabase gives email + password with verification and a Postgres database on a free plan.

1. **supabase.com** → sign in with GitHub → **New project**.
   Name `epfl-focus`, region **Frankfurt (eu-central-1)**, set a database password and keep it.
2. **SQL Editor** → paste all of `schema.sql` → **Run**.
3. **Authentication → URL Configuration → Site URL**: set it to the address the app is served
   from, e.g. `https://bubagna.github.io/epfl-focus/`. The confirmation link in the mail points
   here; leave it at the default and people land on a dead `localhost:3000` page.
4. **Project Settings → API** → copy the **Project URL** and the **publishable** key into
   `SB_URL` / `SB_KEY` at the top of the leaderboard section in `index.html`.

Both of those are meant to ship inside the page — they identify the project, they do not grant
access. The row level security policies in `schema.sql` are what protect the data.
The `service_role` key is the dangerous one: never put it in the app.

## Sending the confirmation mails

⚠️ **Supabase's built-in mailer sends two messages per hour and is meant for testing only.**
With more than one person signing up you will hit `over_email_send_rate_limit` immediately.
Two ways out.

### Quick, no email at all

**Authentication → Sign In / Providers → Email → Confirm email: off.**
Sign-up then works instantly and the app signs you straight in — it already handles this case.
The cost is that nobody proves they own the address they typed. Fine for a group of friends,
not fine if the link is public.

### Proper: your own SMTP

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

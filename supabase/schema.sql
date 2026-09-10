-- EPFL Focus — leaderboard schema.
-- Paste this whole file into the Supabase SQL editor and press Run.
-- Every table is protected by row level security: a signed-in user can read
-- everyone's totals (that is the leaderboard) but can only write their own.

create table if not exists public.profiles (
  id         uuid primary key references auth.users on delete cascade,
  name       text not null check (char_length(name) between 2 and 24),
  created_at timestamptz not null default now()
);

-- one row per user per day, upserted by the app after every session
create table if not exists public.days (
  user_id    uuid not null references auth.users on delete cascade,
  day        date not null,
  minutes    int  not null default 0 check (minutes >= 0 and minutes <= 1440),
  completed  int  not null default 0,
  lost       int  not null default 0,
  updated_at timestamptz not null default now(),
  primary key (user_id, day)
);

alter table public.profiles enable row level security;
alter table public.days     enable row level security;

drop policy if exists "read all profiles" on public.profiles;
drop policy if exists "write own profile" on public.profiles;
drop policy if exists "read all days"     on public.days;
drop policy if exists "write own days"    on public.days;

create policy "read all profiles" on public.profiles
  for select to authenticated using (true);
create policy "write own profile" on public.profiles
  for all to authenticated using (auth.uid() = id) with check (auth.uid() = id);

create policy "read all days" on public.days
  for select to authenticated using (true);
create policy "write own days" on public.days
  for all to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- the leaderboard itself: minutes per person over a date range
create or replace function public.leaderboard(p_from date, p_to date)
returns table (name text, minutes bigint, days_active bigint)
language sql stable security invoker as $$
  select p.name,
         coalesce(sum(d.minutes), 0)::bigint,
         count(d.day)::bigint
  from public.profiles p
  left join public.days d
    on d.user_id = p.id and d.day between p_from and p_to
  group by p.name
  order by 2 desc, 1 asc
  limit 100;
$$;

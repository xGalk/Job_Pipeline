-- Run once: Supabase dashboard → SQL Editor → New query → Run
-- Then paste Project URL + anon public key into the app Settings (⚙).

create table if not exists public.pipeline_state (
  id text primary key default 'main',
  jobs jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.pipeline_state enable row level security;

drop policy if exists "pipeline_state_allow_all" on public.pipeline_state;

-- Open policy: anyone with your anon key can read/write this single row.
-- Fine for a personal tracker; do not use for secret data without auth.
create policy "pipeline_state_allow_all"
  on public.pipeline_state
  for all
  using (true)
  with check (true);

grant select, insert, update, delete on table public.pipeline_state to anon, authenticated;

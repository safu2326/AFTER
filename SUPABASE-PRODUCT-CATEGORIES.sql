-- FIX: product_categories permission denied
-- Run this entire script in Supabase Dashboard > SQL Editor as project owner.
-- Safe to re-run. It does not delete products or existing categories.

begin;

create table if not exists public.product_categories (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  created_at timestamptz not null default now()
);

create unique index if not exists product_categories_name_unique
  on public.product_categories (lower(name));

alter table public.product_categories enable row level security;

-- Explicit table privileges are needed in addition to RLS policies.
grant usage on schema public to anon, authenticated;
grant select on table public.product_categories to anon, authenticated;
grant insert, update, delete on table public.product_categories to authenticated;

-- Public visitors/admin page can load the category list.
drop policy if exists "Product categories are visible to everyone" on public.product_categories;
create policy "Product categories are visible to everyone"
  on public.product_categories
  for select
  to anon, authenticated
  using (true);

-- Only authenticated users listed in admin_users can change categories.
-- This assumes public.admin_users has a user_id column matching auth.uid().
drop policy if exists "Admins manage product categories" on public.product_categories;
create policy "Admins manage product categories"
  on public.product_categories
  for all
  to authenticated
  using (
    exists (
      select 1
      from public.admin_users a
      where a.user_id = (select auth.uid())
    )
  )
  with check (
    exists (
      select 1
      from public.admin_users a
      where a.user_id = (select auth.uid())
    )
  );

-- Add any existing product categories without duplicating names.
insert into public.product_categories (name)
select distinct trim(p.category)
from public.products p
where p.category is not null
  and trim(p.category) <> ''
  and not exists (
    select 1
    from public.product_categories c
    where lower(c.name) = lower(trim(p.category))
  );

commit;

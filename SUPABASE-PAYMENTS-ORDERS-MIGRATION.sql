-- AFTER: Supabase payment methods + orders + private payment-proof storage
-- Additive and re-runnable. Does NOT alter the existing products/shop settings tables.
-- Requires the existing public.admin_users(user_id) table used by the admin dashboard.

create table if not exists public.payment_methods (
  method_id text primary key,
  method_data jsonb not null default '{}'::jsonb,
  enabled boolean not null default true,
  sort_order integer not null default 0,
  updated_at timestamptz not null default now(),
  updated_by uuid null references auth.users(id) on delete set null
);
alter table public.payment_methods enable row level security;
grant select on public.payment_methods to anon, authenticated;
grant insert, update, delete on public.payment_methods to authenticated;

drop policy if exists "Visitors read enabled payment methods" on public.payment_methods;
create policy "Visitors read enabled payment methods"
  on public.payment_methods for select to anon using (enabled = true);
drop policy if exists "Authenticated users read payment methods" on public.payment_methods;
create policy "Authenticated users read payment methods"
  on public.payment_methods for select to authenticated
  using (
    enabled = true or exists (
      select 1 from public.admin_users a where a.user_id = auth.uid()
    )
  );
drop policy if exists "Admins insert payment methods" on public.payment_methods;
create policy "Admins insert payment methods"
  on public.payment_methods for insert to authenticated
  with check (exists (select 1 from public.admin_users a where a.user_id = auth.uid()));
drop policy if exists "Admins update payment methods" on public.payment_methods;
create policy "Admins update payment methods"
  on public.payment_methods for update to authenticated
  using (exists (select 1 from public.admin_users a where a.user_id = auth.uid()))
  with check (exists (select 1 from public.admin_users a where a.user_id = auth.uid()));
drop policy if exists "Admins delete payment methods" on public.payment_methods;
create policy "Admins delete payment methods"
  on public.payment_methods for delete to authenticated
  using (exists (select 1 from public.admin_users a where a.user_id = auth.uid()));

create table if not exists public.store_orders (
  order_id text primary key,
  order_data jsonb not null default '{}'::jsonb,
  payment_proof_path text null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists store_orders_created_at_idx on public.store_orders(created_at desc);
alter table public.store_orders enable row level security;
grant insert on public.store_orders to anon, authenticated;
grant select, update on public.store_orders to authenticated;

drop policy if exists "Customers submit orders" on public.store_orders;
create policy "Customers submit orders"
  on public.store_orders for insert to anon, authenticated
  with check (
    order_id like 'ORD-%'
    and jsonb_typeof(order_data) = 'object'
  );
drop policy if exists "Admins read orders" on public.store_orders;
create policy "Admins read orders"
  on public.store_orders for select to authenticated
  using (exists (select 1 from public.admin_users a where a.user_id = auth.uid()));
drop policy if exists "Admins update orders" on public.store_orders;
create policy "Admins update orders"
  on public.store_orders for update to authenticated
  using (exists (select 1 from public.admin_users a where a.user_id = auth.uid()))
  with check (exists (select 1 from public.admin_users a where a.user_id = auth.uid()));

-- Private bucket: visitors can upload proof images, but only admins can view them.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('payment-proofs', 'payment-proofs', false, 5242880,
        array['image/jpeg','image/png','image/webp','image/gif','image/avif'])
on conflict (id) do update set
  public = false,
  file_size_limit = 5242880,
  allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "Customers upload payment proofs" on storage.objects;
create policy "Customers upload payment proofs"
  on storage.objects for insert to anon, authenticated
  with check (
    bucket_id = 'payment-proofs'
    and lower(storage.extension(name)) in ('jpg','jpeg','png','webp','gif','avif')
  );
drop policy if exists "Admins view payment proofs" on storage.objects;
create policy "Admins view payment proofs"
  on storage.objects for select to authenticated
  using (
    bucket_id = 'payment-proofs'
    and exists (select 1 from public.admin_users a where a.user_id = auth.uid())
  );
drop policy if exists "Admins delete payment proofs" on storage.objects;
create policy "Admins delete payment proofs"
  on storage.objects for delete to authenticated
  using (
    bucket_id = 'payment-proofs'
    and exists (select 1 from public.admin_users a where a.user_id = auth.uid())
  );

-- Notes:
-- 1. The existing admin account must already be present in public.admin_users.
-- 2. Open Admin -> Customer Inbox and sign in with that Supabase Auth account once.
--    When payment_methods is empty, the dashboard copies its current payment settings to Supabase.
-- 3. Existing browser-local orders cannot be moved to Supabase by SQL; only new orders are cloud-saved.

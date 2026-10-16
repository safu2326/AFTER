-- AFTER Home Page Responsive Controls
-- Run once in Supabase Dashboard > SQL Editor. Safe to run again.
-- Adds only the settings/storage support needed for responsive home-page controls.
-- Existing products, orders, messages, payments and other data are not modified.

create table if not exists public.shop_settings (
  id text primary key default 'default' check (id = 'default'),
  settings jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  updated_by uuid null references auth.users(id) on delete set null
);

alter table public.shop_settings enable row level security;
grant select on public.shop_settings to anon, authenticated;
grant insert, update on public.shop_settings to authenticated;

drop policy if exists "Shop settings are public to read" on public.shop_settings;
create policy "Shop settings are public to read"
  on public.shop_settings for select to anon, authenticated
  using (true);

drop policy if exists "Admins insert shop settings" on public.shop_settings;
create policy "Admins insert shop settings"
  on public.shop_settings for insert to authenticated
  with check (exists (
    select 1 from public.admin_users a where a.user_id = auth.uid()
  ));

drop policy if exists "Admins update shop settings" on public.shop_settings;
create policy "Admins update shop settings"
  on public.shop_settings for update to authenticated
  using (exists (
    select 1 from public.admin_users a where a.user_id = auth.uid()
  ))
  with check (exists (
    select 1 from public.admin_users a where a.user_id = auth.uid()
  ));

-- Reuse the existing shop-assets bucket used by the current admin image uploader.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'shop-assets',
  'shop-assets',
  true,
  8388608,
  array['image/jpeg','image/png','image/webp','image/gif','image/avif']
)
on conflict (id) do update
set public = true,
    file_size_limit = 8388608,
    allowed_mime_types = excluded.allowed_mime_types;

-- Public visitors can view images. Only users registered in admin_users can upload.
drop policy if exists "AFTER home page images are publicly viewable" on storage.objects;
create policy "AFTER home page images are publicly viewable"
  on storage.objects for select to anon, authenticated
  using (bucket_id = 'shop-assets');

drop policy if exists "AFTER admins upload home page images" on storage.objects;
create policy "AFTER admins upload home page images"
  on storage.objects for insert to authenticated
  with check (
    bucket_id = 'shop-assets'
    and exists (select 1 from public.admin_users a where a.user_id = auth.uid())
  );

drop policy if exists "AFTER admins update home page images" on storage.objects;
create policy "AFTER admins update home page images"
  on storage.objects for update to authenticated
  using (
    bucket_id = 'shop-assets'
    and exists (select 1 from public.admin_users a where a.user_id = auth.uid())
  )
  with check (
    bucket_id = 'shop-assets'
    and exists (select 1 from public.admin_users a where a.user_id = auth.uid())
  );

-- Insert an empty settings row only if none exists; existing settings are preserved.
insert into public.shop_settings (id, settings)
values ('default', '{}'::jsonb)
on conflict (id) do nothing;

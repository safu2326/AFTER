-- AFTER product catalogue + public image storage setup
-- Run in Supabase Dashboard > SQL Editor as project owner.
-- The products table is assumed to already exist with the columns shown in your screenshot.

-- Public visitors can read the catalogue.
alter table public.products enable row level security;
-- The screenshot shows products.id is bigint, so the frontend must not send UUIDs into id.
-- client_id stores each website product's stable string ID and is used for safe upserts.
create unique index if not exists products_client_id_unique
on public.products (client_id)
where client_id is not null;

drop policy if exists "Products are visible to everyone" on public.products;
create policy "Products are visible to everyone"
on public.products for select to anon, authenticated using (true);

-- Only users listed in admin_users can add/edit/delete products.
drop policy if exists "Admins manage products" on public.products;
create policy "Admins manage products"
on public.products for all to authenticated
using (exists (select 1 from public.admin_users a where a.user_id = auth.uid()))
with check (exists (select 1 from public.admin_users a where a.user_id = auth.uid()));

-- Admin can verify their own membership row (needed by admin UI).
alter table public.admin_users enable row level security;
drop policy if exists "Users can read own admin membership" on public.admin_users;
create policy "Users can read own admin membership"
on public.admin_users for select to authenticated using (user_id = auth.uid());

-- Create a public bucket so product images can be displayed on the public GitHub Pages site.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('product-images', 'product-images', true, 8388608, array['image/jpeg','image/png','image/webp','image/gif','image/avif'])
on conflict (id) do update set public = true, file_size_limit = 8388608,
  allowed_mime_types = array['image/jpeg','image/png','image/webp','image/gif','image/avif'];

drop policy if exists "Public can view product images" on storage.objects;
create policy "Public can view product images"
on storage.objects for select to anon, authenticated
using (bucket_id = 'product-images');

drop policy if exists "Admins upload product images" on storage.objects;
create policy "Admins upload product images"
on storage.objects for insert to authenticated
with check (
  bucket_id = 'product-images'
  and exists (select 1 from public.admin_users a where a.user_id = auth.uid())
);

drop policy if exists "Admins update product images" on storage.objects;
create policy "Admins update product images"
on storage.objects for update to authenticated
using (
  bucket_id = 'product-images'
  and exists (select 1 from public.admin_users a where a.user_id = auth.uid())
)
with check (
  bucket_id = 'product-images'
  and exists (select 1 from public.admin_users a where a.user_id = auth.uid())
);

drop policy if exists "Admins delete product images" on storage.objects;
create policy "Admins delete product images"
on storage.objects for delete to authenticated
using (
  bucket_id = 'product-images'
  and exists (select 1 from public.admin_users a where a.user_id = auth.uid())
);


-- Multi-image product gallery (additive; preserves existing product data).
alter table public.products add column if not exists images jsonb not null default '[]'::jsonb;
update public.products set images = jsonb_build_array(image) where (images is null or images = '[]'::jsonb) and image is not null;

-- AFTER Shop Settings (safe, additive, rerunnable)
-- Run this once in Supabase Dashboard > SQL Editor.
-- Public visitors can READ shop presentation settings. Only authenticated users
-- listed in public.admin_users can INSERT/UPDATE them.
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
  on public.shop_settings for select to anon, authenticated using (true);

drop policy if exists "Admins insert shop settings" on public.shop_settings;
create policy "Admins insert shop settings"
  on public.shop_settings for insert to authenticated
  with check (exists (select 1 from public.admin_users a where a.user_id = auth.uid()));

drop policy if exists "Admins update shop settings" on public.shop_settings;
create policy "Admins update shop settings"
  on public.shop_settings for update to authenticated
  using (exists (select 1 from public.admin_users a where a.user_id = auth.uid()))
  with check (exists (select 1 from public.admin_users a where a.user_id = auth.uid()));

insert into public.shop_settings (id, settings)
values ('default', jsonb_build_object(
  'announcement', 'FREE DELIVERY ON ORDERS OVER ৳2,000 · NEW DROP EVERY WEEK',
  'brand', 'AFTER',
  'accent', '#b9824c',
  'heroEyebrow', 'SMART DEVICES / BETTER LIVING',
  'heroTitle', 'Technology, curated beautifully.',
  'heroText', 'A refined collection of everyday gadgets, smart accessories and useful tech — selected to make modern living feel effortless.',
  'heroButton', 'EXPLORE THE COLLECTION',
  'heroBadge', 'NEW SEASON',
  'heroImage', 'assets/hero-visual.jpg',
  'categoriesKicker', 'DISCOVER',
  'sectionCategories', 'Shop by category',
  'featuredKicker', 'THE EDIT',
  'sectionFeatured', 'Featured products',
  'newKicker', 'JUST IN',
  'sectionNew', 'New arrivals',
  'storyKicker', 'THE PHILOSOPHY',
  'storyTitle', 'Technology for everyday life.',
  'storyText', 'Thoughtfully selected devices and accessories that make everyday routines feel a little more effortless.',
  'storyImage', 'assets/hero-visual.jpg',
  'categoriesViewAll', 'VIEW ALL',
  'featuredViewAll', 'SCROLL TO NEW',
  'footerLeft', '© AFTER',
  'footerRight', 'TECH / LIFESTYLE / EVERYDAY',
  'trust1Title', 'Fast & Secure Delivery', 'trust1Text', 'Carefully packed, delivered to your door',
  'trust2Title', '1 Year Warranty', 'trust2Text', 'Support for your everyday tech',
  'trust3Title', '24/7 Support', 'trust3Text', 'We are here when you need us'
))
on conflict (id) do nothing;

-- AFTER Shop Settings image uploads (additive; does not alter existing product storage)
-- Creates a dedicated public bucket for hero/story images. Uploads require an
-- authenticated user listed in public.admin_users. Existing products are untouched.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'shop-assets',
  'shop-assets',
  true,
  8388608,
  array['image/jpeg','image/png','image/webp','image/gif','image/avif']
)
on conflict (id) do update set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

 drop policy if exists "Shop assets are public to read" on storage.objects;
create policy "Shop assets are public to read"
  on storage.objects for select to public
  using (bucket_id = 'shop-assets');

drop policy if exists "Admins upload shop assets" on storage.objects;
create policy "Admins upload shop assets"
  on storage.objects for insert to authenticated
  with check (
    bucket_id = 'shop-assets'
    and exists (
      select 1 from public.admin_users a
      where a.user_id = auth.uid()
    )
  );

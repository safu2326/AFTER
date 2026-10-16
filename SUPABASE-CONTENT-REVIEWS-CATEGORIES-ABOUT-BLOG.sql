-- AFTER additive content + review migration. Safe to run more than once.
-- Run in Supabase SQL Editor using the project owner role.
-- Does not drop or rewrite existing products/orders/payment tables.
create table if not exists public.product_reviews (
 id uuid primary key default gen_random_uuid(), product_id text not null, product_name text not null default '',
 customer_name text not null check (char_length(trim(customer_name)) between 2 and 80),
 rating smallint not null check (rating between 1 and 5),
 review_text text not null check (char_length(trim(review_text)) between 3 and 2000),
 is_approved boolean not null default false, is_visible boolean not null default true,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create index if not exists product_reviews_product_public_idx on public.product_reviews(product_id,is_approved,is_visible,created_at desc);
alter table public.product_reviews enable row level security;
grant select,insert on public.product_reviews to anon,authenticated;
grant update,delete on public.product_reviews to authenticated;
drop policy if exists "Visitors read approved reviews" on public.product_reviews;
create policy "Visitors read approved reviews" on public.product_reviews for select to anon,authenticated using(is_approved=true and is_visible=true);
drop policy if exists "Visitors submit reviews for moderation" on public.product_reviews;
create policy "Visitors submit reviews for moderation" on public.product_reviews for insert to anon,authenticated with check(is_approved=false and is_visible=true);
drop policy if exists "Admins manage all reviews" on public.product_reviews;
create policy "Admins manage all reviews" on public.product_reviews for all to authenticated using(exists(select 1 from public.admin_users a where a.user_id=auth.uid())) with check(exists(select 1 from public.admin_users a where a.user_id=auth.uid()));

create table if not exists public.site_content(content_key text primary key,content jsonb not null default '{}'::jsonb,updated_at timestamptz not null default now(),updated_by uuid null references auth.users(id) on delete set null);
alter table public.site_content enable row level security;
grant select on public.site_content to anon,authenticated;
grant insert,update on public.site_content to authenticated;
drop policy if exists "Public can read site content" on public.site_content;
create policy "Public can read site content" on public.site_content for select to anon,authenticated using(true);
drop policy if exists "Admins insert site content" on public.site_content;
create policy "Admins insert site content" on public.site_content for insert to authenticated with check(exists(select 1 from public.admin_users a where a.user_id=auth.uid()));
drop policy if exists "Admins update site content" on public.site_content;
create policy "Admins update site content" on public.site_content for update to authenticated using(exists(select 1 from public.admin_users a where a.user_id=auth.uid())) with check(exists(select 1 from public.admin_users a where a.user_id=auth.uid()));

create table if not exists public.store_categories(id text primary key,name text not null,slug text not null unique,description text not null default '',image_url text not null default '',sort_order integer not null default 0,is_active boolean not null default true,updated_at timestamptz not null default now());
alter table public.store_categories enable row level security;
grant select on public.store_categories to anon,authenticated;
grant insert,update,delete on public.store_categories to authenticated;
drop policy if exists "Visitors read active categories" on public.store_categories;
create policy "Visitors read active categories" on public.store_categories for select to anon,authenticated using(is_active=true);
drop policy if exists "Admins manage categories" on public.store_categories;
create policy "Admins manage categories" on public.store_categories for all to authenticated using(exists(select 1 from public.admin_users a where a.user_id=auth.uid())) with check(exists(select 1 from public.admin_users a where a.user_id=auth.uid()));

insert into public.site_content(content_key,content) values
('review_settings','{"ratings_enabled":true,"reviews_enabled":true,"moderation_required":true}'::jsonb),
('delivery_settings','{"delivery_charge":0,"currency":"BDT"}'::jsonb),
('about_page','{}'::jsonb),('blog_page','{"posts":[{"id":"b1","eyebrow":"GUIDE / 01","title":"How to build a calmer tech setup","text":"Small choices can make everyday technology feel better.","image":"assets/products/05-keyboard.svg"},{"id":"b2","eyebrow":"FIELD NOTES / 02","title":"The objects we keep close","text":"A closer look at useful things with good design.","image":"assets/products/03-watch.svg"},{"id":"b3","eyebrow":"AFTER HOURS / 03","title":"Buying less, choosing better","text":"Why thoughtful selection beats endless scrolling.","image":"assets/products/06-powerbank.svg"}]}'::jsonb),
('categories_page','{"eyebrow":"FIND YOUR EVERYDAY ESSENTIAL.","title":"Categories","text":"Explore the things that make everyday life a little better.","section_title":"Shop by mood"}'::jsonb)
on conflict(content_key) do nothing;

insert into storage.buckets(id,name,public,file_size_limit,allowed_mime_types) values
('categories','categories',true,8388608,array['image/jpeg','image/png','image/webp','image/gif','image/avif']),
('blog','blog',true,8388608,array['image/jpeg','image/png','image/webp','image/gif','image/avif']),
('about','about',true,8388608,array['image/jpeg','image/png','image/webp','image/gif','image/avif'])
on conflict(id) do update set public=true,file_size_limit=8388608,allowed_mime_types=excluded.allowed_mime_types;
drop policy if exists "AFTER content images public read" on storage.objects;
create policy "AFTER content images public read" on storage.objects for select to public using(bucket_id in('categories','blog','about'));
drop policy if exists "AFTER admins upload content images" on storage.objects;
create policy "AFTER admins upload content images" on storage.objects for insert to authenticated with check(bucket_id in('categories','blog','about') and exists(select 1 from public.admin_users a where a.user_id=auth.uid()));
drop policy if exists "AFTER admins update content images" on storage.objects;
create policy "AFTER admins update content images" on storage.objects for update to authenticated using(bucket_id in('categories','blog','about') and exists(select 1 from public.admin_users a where a.user_id=auth.uid())) with check(bucket_id in('categories','blog','about') and exists(select 1 from public.admin_users a where a.user_id=auth.uid()));
drop policy if exists "AFTER admins delete content images" on storage.objects;
create policy "AFTER admins delete content images" on storage.objects for delete to authenticated using(bucket_id in('categories','blog','about') and exists(select 1 from public.admin_users a where a.user_id=auth.uid()));

insert into public.store_categories(id,name,slug,description,image_url,sort_order) values
('audio','Audio','audio','Sound, speakers and listening essentials','assets/products/02-headphones.svg',1),
('wearables','Wearables','wearables','Smart watches and everyday wearables','assets/products/03-watch.svg',2),
('mobile','Mobile Tech','mobile','Useful mobile accessories and power','assets/products/06-powerbank.svg',3),
('desk','Desk Setup','desk','Thoughtful tools for your workspace','assets/products/05-keyboard.svg',4),
('smart-home','Smart Home','smart-home','Small upgrades for a smarter home','assets/products/07-lamp.svg',5)
on conflict(id) do nothing;

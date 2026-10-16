-- AFTER: enable multiple product images without changing existing columns/data.
-- Run once in Supabase Dashboard > SQL Editor.
alter table public.products
  add column if not exists images jsonb not null default '[]'::jsonb;

-- Preserve each product's existing main image as its initial gallery image.
update public.products
set images = jsonb_build_array(image)
where (images is null or images = '[]'::jsonb)
  and image is not null;

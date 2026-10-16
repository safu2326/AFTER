-- AFTER CUSTOM FOOTER / SOCIAL ICONS
-- Safe to rerun. This script creates the settings table only if missing, configures
-- footer settings access, and inserts footer defaults ONLY where footer keys are absent.
-- It does not delete or overwrite existing footer customizations or any non-footer data.

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

-- Create the default row only when it does not exist.
insert into public.shop_settings (id, settings)
values ('default', jsonb_build_object(
  'footerTagline', 'Technology, curated beautifully.',
  'footerCopyright', '© AFTER. All rights reserved.',
  'footerBottomNote', 'TECH / LIFESTYLE / EVERYDAY',
  'footerLinks', jsonb_build_array(
    jsonb_build_object('label','Home','url','index.html'),
    jsonb_build_object('label','Shop all','url','shop.html'),
    jsonb_build_object('label','Categories','url','categories.html'),
    jsonb_build_object('label','Our story','url','about.html'),
    jsonb_build_object('label','Journal','url','blog.html'),
    jsonb_build_object('label','Contact us','url','about.html#contact')
  ),
  'footerSocials', jsonb_build_array(
    jsonb_build_object('platform','Instagram','url',''),
    jsonb_build_object('platform','Facebook','url',''),
    jsonb_build_object('platform','WhatsApp','url','')
  )
))
on conflict (id) do nothing;

-- Add only missing footer keys to an existing row; existing values (including empty arrays)
-- and every non-footer setting remain unchanged.
update public.shop_settings
set settings = settings || jsonb_strip_nulls(jsonb_build_object(
  'footerTagline', case when settings ? 'footerTagline' then null else to_jsonb('Technology, curated beautifully.'::text) end,
  'footerCopyright', case when settings ? 'footerCopyright' then null else to_jsonb('© AFTER. All rights reserved.'::text) end,
  'footerBottomNote', case when settings ? 'footerBottomNote' then null else to_jsonb('TECH / LIFESTYLE / EVERYDAY'::text) end,
  'footerLinks', case when settings ? 'footerLinks' then null else jsonb_build_array(
    jsonb_build_object('label','Home','url','index.html'),
    jsonb_build_object('label','Shop all','url','shop.html'),
    jsonb_build_object('label','Categories','url','categories.html'),
    jsonb_build_object('label','Our story','url','about.html'),
    jsonb_build_object('label','Journal','url','blog.html'),
    jsonb_build_object('label','Contact us','url','about.html#contact')
  ) end,
  'footerSocials', case when settings ? 'footerSocials' then null else jsonb_build_array(
    jsonb_build_object('platform','Instagram','url',''),
    jsonb_build_object('platform','Facebook','url',''),
    jsonb_build_object('platform','WhatsApp','url','')
  ) end
)),
updated_at = now()
where id = 'default'
  and (not (settings ? 'footerTagline') or not (settings ? 'footerCopyright')
    or not (settings ? 'footerBottomNote') or not (settings ? 'footerLinks')
    or not (settings ? 'footerSocials'));

-- Run this in Supabase SQL Editor for the CLEAR MESSAGES button.
-- Allows only authenticated users listed in public.admin_users to delete rows from public.store_orders.
-- Does not modify any other table or data.
grant delete on table public.store_orders to authenticated;

drop policy if exists "Admins delete store orders" on public.store_orders;
create policy "Admins delete store orders"
  on public.store_orders
  for delete
  to authenticated
  using (
    exists (
      select 1
      from public.admin_users a
      where a.user_id = auth.uid()
    )
  );

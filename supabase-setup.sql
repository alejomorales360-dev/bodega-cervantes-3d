-- Bodega Cervantes 3D · stock compartido
-- Pegar completo en Supabase → SQL Editor → New query → Run.

-- 1) Tabla con cada stock publicado (se guarda el historial; la página muestra el último)
create table if not exists public.stock_snapshots (
  id          bigint generated always as identity primary key,
  created_at  timestamptz not null default now(),
  file        text,
  uploaded_by text,
  lotes       integer,
  volumen     numeric,
  payload     jsonb not null
);

-- 2) Quiénes pueden publicar
create table if not exists public.bodega_admins (
  email text primary key
);

create or replace function public.es_admin()
returns boolean
language sql stable security definer
set search_path = public
as $$
  select exists (select 1 from public.bodega_admins where lower(email) = lower(auth.jwt() ->> 'email'));
$$;

-- 3) Reglas de acceso (RLS)
alter table public.stock_snapshots enable row level security;
alter table public.bodega_admins  enable row level security;   -- sin políticas: nadie la lee desde la página

drop policy if exists "ver stock (usuarios con cuenta)" on public.stock_snapshots;
create policy "ver stock (usuarios con cuenta)" on public.stock_snapshots
  for select to authenticated using (true);

drop policy if exists "publicar stock (solo administradores)" on public.stock_snapshots;
create policy "publicar stock (solo administradores)" on public.stock_snapshots
  for insert to authenticated with check (public.es_admin());

-- 4) Avisos en vivo cuando se publica un stock nuevo
do $$ begin
  alter publication supabase_realtime add table public.stock_snapshots;
exception when duplicate_object then null; end $$;

-- 5) Administradores: reemplaza por los correos que podrán subir stock
insert into public.bodega_admins (email) values ('CORREO_ADMIN@ejemplo.cl')
on conflict do nothing;

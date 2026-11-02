# Stock en la nube (Supabase)

Con esto, el stock que publique un administrador queda guardado en la nube. Todo el equipo lo ve con su cuenta en https://alejomorales360-dev.github.io/bodega-cervantes-3d/ y se actualiza solo cuando se publica uno nuevo.

## 1. Crear el proyecto (una vez)

1. Entra a https://supabase.com, crea una cuenta gratis y presiona **New project**.
2. Ponle un nombre (por ejemplo `bodega-cervantes`) y elige la región **South America (São Paulo)**.

## 2. Crear la base de datos

1. En el proyecto, abre **SQL Editor → New query**.
2. Pega todo el contenido de [`supabase-setup.sql`](supabase-setup.sql).
3. En la última línea, cambia `CORREO_ADMIN@ejemplo.cl` por el correo de quien subirá el stock. Para varios administradores: `values ('uno@x.cl'), ('dos@x.cl')`.
4. Presiona **Run**.

## 3. Cerrar el registro público y crear las cuentas

1. Abre **Authentication → Sign In / Providers** y desactiva **Allow new users to sign up**. Así solo existen las cuentas que tú crees.
2. Abre **Authentication → Users → Add user → Create new user**:
   - Una cuenta por cada administrador, con el mismo correo que pusiste en el paso 2. Marca **Auto Confirm User**.
   - Una cuenta para el equipo que solo mira, por ejemplo `equipo@bodega-cervantes.cl`, con una clave que compartes con ellos. También puedes crear una cuenta por persona.

## 4. Conectar la página

1. Abre **Project Settings → API** y copia:
   - **Project URL**
   - **anon public** (la clave pública)
2. Pégalas en [`config.js`](config.js) y sube el cambio. O pásaselas a Claude y él las sube.

La clave `anon` es pública por diseño. Sin una cuenta válida no da acceso a nada, porque las reglas de la base de datos (RLS) lo impiden. **Nunca** pongas en la página la clave `service_role`.

## Cómo se usa

- **Ver:** abre la página, ingresa con tu correo y clave, y aparece el último stock publicado.
- **Publicar:** un administrador ingresa y carga el Excel con "Cargar stock". Se publica al tiro y todos los que tengan la página abierta lo ven actualizarse.
- **Historial:** cada publicación queda guardada en la tabla `stock_snapshots`. La página muestra la más reciente.

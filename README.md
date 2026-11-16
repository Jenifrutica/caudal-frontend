# CAUDAL Frontend

Aplicación web instalable (PWA) de **CAUDAL**, el cuaderno digital del acueducto veredal:

- **Fontanero:** registra la lectura del tanque desde el celular, también sin señal, y anota el cierre del día.
- **Junta:** ve el estado y el pronóstico del tanque, aprueba o modifica los turnos con motivo y publica el horario.
- **Familias:** consultan el horario sin datos personales y reportan daños.

React 19 · Vite · TypeScript · PWA sin conexión.

![Arquitectura del frontend](docs/images/arquitectura-frontend.png)

## Estado

**Funcionalidad de la v1.0.0 completa** (la etiqueta git `v1.0.0` aún no está creada; verificado el 2026-11-16 en `develop`, `c0e474c`: `pnpm build` pasa). Desplegada en https://caudal-frontend.vercel.app/. La aplicación cubre a los cinco actores: horario público y reporte de daños, sesión, fontanero (con cola sin conexión), Junta (tanque, propuestas, reglas, actas, incidentes, entidades y usuarios), equipo del proyecto y entidades de apoyo. Detalle por actor, rutas y verificación en [docs/Version-1.0.0.md](docs/Version-1.0.0.md).

## Documentación

- [docs/Version-1.0.0.md](docs/Version-1.0.0.md): qué incluye la versión 1.0.0, rutas, verificación, despliegue y faltas del contrato de la API.
- [AGENTS.md](AGENTS.md): reglas obligatorias para personas y agentes.
- [`.agents/`](.agents/): arquitectura, pantallas, cola sin conexión, tema visual, seguridad, patrones y pruebas.
- Documentación canónica del proyecto: [`caudal-backend/docs`](https://github.com/NicoalsD/caudal-backend/tree/develop/docs).
- [Política de seguridad](SECURITY.md) y [cómo contribuir](CONTRIBUTING.md).

## Arranque rápido

Sistema completo con un comando, desde `caudal-backend` (los cuatro repositorios como carpetas hermanas): `make up` construye este repositorio con su `Dockerfile` (Node 24 + pnpm para compilar y nginx sin privilegios para servir, con fallback de SPA y las mismas cabeceras de `vercel.json`) y lo publica en http://localhost:8081 contra la API local (`VITE_API_BASE_URL=http://localhost:8080/api/v1`). Guía: [Arranque local](https://github.com/Jenifrutica/caudal-backend/blob/develop/docs/Arranque-local.md). La cola sin conexión se justifica en [ADR-007](https://github.com/Jenifrutica/caudal-backend/blob/develop/docs/ADRs/ADR-007-cola-offline-indexeddb.md).

Solo esta imagen:

```bash
docker build --build-arg VITE_API_BASE_URL=http://localhost:8080/api/v1 -t caudal-web:local .
docker run --rm -p 8081:8080 caudal-web:local       # http://localhost:8081
```

## Cómo correrlo

```bash
cp .env.example .env.local
pnpm install
pnpm dev          # http://localhost:5173
```

Verificación antes de cada commit:

```bash
pnpm format:check
pnpm lint
pnpm typecheck
pnpm test:coverage
pnpm build
```

Pruebas end-to-end (Playwright, con axe): `pnpm e2e:install` una vez y después `pnpm e2e`. Otros comandos: `pnpm gen:api` (tipos desde `docs/openapi.json`).

## Equipo

Nicolas Diaz (`NicoalsD`) · Drako Salazar (`Drako2305`) · Nicolas Mora (`nicomora70`). Proyecto de la materia Patrones de Software.

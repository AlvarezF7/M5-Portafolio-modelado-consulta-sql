# M5 — Modelado y Consultas SQL (PostgreSQL)

## Descripción
El objetivo de esta actividad es reforzar los conceptos del módulo 5 sobre bases de datos mediante la implementación de los siguientes puntos:

- Modelo ER y normalización hasta 3FN.
- Creación de tablas: `usuario`, `producto`, `inventario`, `orden_compra`, `orden_item`.
- Consultas: oferta -20%, stock crítico, simular compra, reportes de diciembre 2022.
- Uso de claves foráneas, constraints y tabla intermedia para manejar relación muchos a muchos.

## Cómo ejecutar
1. Crear una base de datos en PostgreSQL.
2. Ejecutar `sql/script.sql` usando pgAdmin o psql.
3. Revisar los resultados de las consultas al final del script.

## Estructura del proyecto
- `sql/` — Contiene el script principal `script.sql` con la creación de tablas, inserción de datos y consultas.
- `er/` — Diagramas ER de los ejercicios.
- `README.md` — Este archivo.

## Consultas incluidas
- Actualización de precios (oferta -20%).
- Productos con stock crítico (≤ 5 unidades).
- Simulación de compra y cálculo de total con IVA.
- Reportes de ventas de diciembre 2022.
- Usuario con más compras durante 2022.

## Evidencias
- Diagramas ER en `er/`.
- Capturas de algunas consultas ejecutadas.
- Script en carpeta SQL.



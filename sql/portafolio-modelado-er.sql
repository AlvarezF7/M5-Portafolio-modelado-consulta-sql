----------------------------------------------------------------------------------
Ejercicio Portafolio Modelado ER consultas SQL
-----------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--MODELADO DE DIAGRAMA ENTIDAD-RELACION
--------------------------------------------------------------------------------
-- El diseño del diagrama se adjunta en formato PNG con ntación crown'
-- las relaciones  graficadas son:
-- usuarios 1..1 ordenes
-- ordenes 1..N orden_items
-- productos 1..N orden_items 
-- productos 1..1 inventario.

--------------------------------------------------------------------------------
--DDL CREACION TABLAS
--------------------------------------------------------------------------------
CREATE TABLE usuario (
    id_usuario SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT UNIQUE,
    creado_en TIMESTAMP DEFAULT NOW()
);

CREATE TABLE producto (
    id_producto SERIAL PRIMARY KEY,
    nombre TEXT NOT NULL,
    precio NUMERIC(10,2) NOT NULL,
    activo BOOLEAN DEFAULT TRUE
);

CREATE TABLE inventario (
    id_producto INT PRIMARY KEY,
    stock INT CHECK (stock >= 0),
    CONSTRAINT fk_inventario_producto
        FOREIGN KEY (id_producto)REFERENCES producto(id_producto)
        ON DELETE CASCADE
);

CREATE TABLE orden_compra (
    id_orden SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL,
    fecha DATE NOT NULL,
    total NUMERIC(12,2),
    CONSTRAINT fk_orden_usuario
        FOREIGN KEY (id_usuario)REFERENCES usuario(id_usuario)
        ON DELETE RESTRICT
);

CREATE TABLE orden_item (
    id_item SERIAL PRIMARY KEY,
    id_orden INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT CHECK (cantidad > 0),
    precio_unitario NUMERIC(10,2),
    CONSTRAINT fk_item_orden
        FOREIGN KEY (id_orden)REFERENCES orden_compra(id_orden)
        ON DELETE CASCADE,
    CONSTRAINT fk_item_producto
        FOREIGN KEY (id_producto)REFERENCES producto(id_producto),
    CONSTRAINT uq_orden_producto UNIQUE (id_orden, id_producto)
);
------------------------------------------------------------------------
--DML POBLAR TABLAS
------------------------------------------------------------------------

INSERT INTO usuario (nombre, email) VALUES
('Amara Pinto', 'amara.pinto@gmail.com'),
('Lucia Soto', 'lucia.soto@gmail.com'),
('Carmen Rabat', 'carmen.rabat@gmail.com'),
('Pablo Muñoz', 'pablo.munoz@gmail.com'),
('Mario López', 'mario.lopez@gmail.com');


INSERT INTO producto (nombre, precio) VALUES
('Boquillas Reposteras', 7000),
('Mezquinos', 9500),
('Bandeja', 10000),
('Capsulas Cupcake', 3000),
('Cortador de Galletas', 11000);


INSERT INTO inventario (id_producto, stock) VALUES
(1, 10),
(2, 50),
(3, 30),
(4, 15),
(5, 40);


INSERT INTO orden_compra (id_usuario, fecha, total) VALUES
(1, '2026-02-01', 16500),   -- Amara Pinto
(2, '2026-02-02', 29500),   -- Lucia Soto
(3, '2026-02-03', 13000),   -- Carmen Rabat
(4, '2026-02-04', 21000),   -- Pablo Muñoz
(5, '2026-02-05', 26000);   -- Mario López


INSERT INTO orden_item (id_orden, id_producto, cantidad, precio_unitario) VALUES
-- Orden 1: Amara Pinto
(1, 1, 1, 7000),
(1, 4, 3, 3000),

-- Orden 2: Lucia Soto
(2, 2, 2, 9500),
(2, 5, 1, 11000),

-- Orden 3: Carmen Rabat
(3, 4, 2, 3000),
(3, 1, 1, 7000),

-- Orden 4: Pablo Muñoz
(4, 3, 2, 10000),
(4, 4, 1, 3000),

-- Orden 5: Mario López
(5, 2, 1, 9500),
(5, 5, 1, 11000),
(5, 3, 1, 10000);
select * from usuario;

--------------------------------------------------------------------------------
--BLOQUE DE ÍNDICES
--------------------------------------------------------------------------------

CREATE INDEX idx_producto_nombre ON producto(nombre);
CREATE INDEX idx_producto_precio ON producto(precio);

CREATE INDEX idx_inventario_stock ON inventario(stock);

CREATE INDEX idx_orden_usuario ON orden_compra(id_usuario);
CREATE INDEX idx_orden_fecha ON orden_compra(fecha);

CREATE INDEX idx_item_orden ON orden_item(id_orden);
CREATE INDEX idx_item_producto ON orden_item(id_producto);

--------------------------------------------------------------------------------
--CONSULTAS REQUERIDAS
--------------------------------------------------------------------------------
-- 1 Oferta de verano
-------------------------------------------------------------------------------
UPDATE producto
SET precio = ROUND(precio * 0.80, 2);
--------------------------------------------------------------------------------
-- 2 stock critico menos de 5 und ( no hay articulos  en este rango)
--------------------------------------------------------------------------------
SELECT p.id_producto, p.nombre, i.stock
FROM inventario i
JOIN producto p USING (id_producto)
WHERE i.stock <= 5;
--------------------------------------------------------------------------------
---3 SIMULA COMPRA CON IVA 
--------------------------------------------------------------------------------
--a) Crear la orden y la captura automaticamente
INSERT INTO orden_compra (id_usuario, fecha, total)
VALUES (1, '2022-12-15', 0)
RETURNING id_orden;

-- b)Insertar ítems de la orden usando el id_orden capturado
-
INSERT INTO orden_item (id_orden, id_producto, cantidad, precio_unitario) VALUES
(6, 1, 2, 7000),
(6, 3, 1, 10000),
(6, 5, 1, 11000);

-- C)Actualizar total de la orden con IVA 19%----------------------------------------

UPDATE orden_compra
SET total = (
    SELECT SUM(cantidad * precio_unitario * 1.19)
    FROM orden_item
    WHERE id_orden = 6
)
WHERE id_orden = 6;

-- D)Mostrar subtotal y total con IVA para verificación----------------------------

SELECT 
    SUM(oi.cantidad * oi.precio_unitario) AS subtotal,
    ROUND(SUM(oi.cantidad * oi.precio_unitario) * 1.19, 2) AS total_con_iva
FROM orden_item oi
WHERE oi.id_orden = 6;
--------------------------------------------------------------------------------
-- 4) Total ventas diciembre 2022
--------------------------------------------------------------------------------

SELECT 
    o.fecha,
    o.id_orden,
    SUM(oi.cantidad * oi.precio_unitario) AS subtotal,
    ROUND(SUM(oi.cantidad * oi.precio_unitario) * 1.19, 2) AS total_con_iva
FROM orden_compra o
JOIN orden_item oi ON oi.id_orden = oi.id_orden
WHERE o.fecha BETWEEN '2022-12-01' AND '2022-12-31'
GROUP BY o.id_orden, o.fecha
ORDER BY o.fecha;
--------------------------------------------------------------------------------
-- 5) Usuario con más compras en 2022
--------------------------------------------------------------------------------
WITH por_usuario AS (
    SELECT id_usuario, COUNT(*) AS ordenes
    FROM orden_compra
    WHERE fecha BETWEEN '2022-01-01' AND '2022-12-31'
    GROUP BY id_usuario
)
SELECT u.nombre, pu.ordenes
FROM por_usuario pu
JOIN usuario u ON u.id_usuario = pu.id_usuario
ORDER BY pu.ordenes DESC
LIMIT 1;

--Inserta compras en diciembre  2022--------------------------------------------
INSERT INTO orden_compra (id_usuario, fecha, total) VALUES
(2, '2022-12-05', 16500),
(3, '2022-12-10', 29500);




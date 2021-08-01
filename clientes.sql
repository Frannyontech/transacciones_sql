DROP DATABASE prueba;

CREATE DATABASE prueba;

\c prueba

--1. Cargar el respaldo de la base de datos unidad2.sql.
-- psql -U frang prueba < unidad2.sql

-- 2. El cliente usuario01 ha realizado la siguiente compra:
-- ● producto: producto9
-- ● cantidad: 5
-- ● fecha: fecha del sistema
-- Mediante el uso de transacciones, realiza las consultas correspondientes para este
-- requerimiento y luego consulta la tabla producto para validar si fue efectivamente
-- descontado en el stock.


\set AUTOCOMMIT off


BEGIN TRANSACTION;
INSERT INTO compra(id, cliente_id,fecha,) VALUES (33, 1,'2021-07-30');
INSERT INTO detalle_compra (producto_id,compra_id,cantidad) VALUES (9,33,5);
UPDATE producto SET stock = stock - 5 WHERE id = 9;
ROLLBACK;
SELECT * FROM producto WHERE descripcion = 'producto9';


--  El cliente usuario02 ha realizado la siguiente compra:
-- ● producto: producto1, producto 2, producto 8
-- ● cantidad: 3 de cada producto
-- ● fecha: fecha del sistema
-- Mediante el uso de transacciones, realiza las consultas correspondientes para este
-- requerimiento y luego consulta la tabla producto para validar que si alguno de ellos
-- se queda sin stock, no se realice la compra.


BEGIN TRANSACTION;
    INSERT INTO compra(id, cliente_id, fecha) VALUES (34, 2,'2021-07-30');

    INSERT INTO detalle_compra(producto_id, compra_id, cantidad) VALUES (1,34,3);
    INSERT INTO detalle_compra(producto_id, compra_id, cantidad) VALUES(2,34,3);
    INSERT INTO detalle_compra(producto_id, compra_id, cantidad) VALUES(8,34,3);
    UPDATE producto SET stock = stock - 3 WHERE descripcion ='producto1';
    UPDATE producto SET stock = stock - 3 WHERE descripcion ='producto2';
    UPDATE producto SET stock = stock - 3 WHERE descripcion ='producto8';
COMMIT;

SELECT * FROM producto WHERE descripcion = 'producto1' OR descripcion = 'producto2' OR descripcion = 'producto8';


-- Consultar estado del AUTOCOMMIT
\echo :AUTOCOMMIT
-- Desabilitar AUTOCOMMIT
\set AUTOCOMMIT off
-- b. Insertar un nuevo cliente
INSERT INTO cliente (id,nombre,email) VALUES (11,'usuario011','usuario011@gmail.com');
-- c. Confirmar que fue agregado en la tabla cliente
SELECT * FROM cliente WHERE id = 11;
-- d. Realizar un ROLLBACK
ROLLBACK;
-- e. Confirmar que se restauró la información, sin considerar la inserción del punto b
SELECT * FROM cliente where id = 11;
-- f. Habilitar de nuevo el AUTOCOMMIT
\set AUTOCOMMIT ON

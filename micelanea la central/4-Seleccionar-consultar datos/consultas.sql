--ORDER BY, LIMIT y OFFSET
ORDER BY: Ordernar los resultados por una o más columnas
ASC: Ordenar ascendentemente
DESC: Ordenar descendentemente
LIMIT n: Muestrar los primeros n resultados
OFFSET n: Saltar los primeros n resultados antes de empezar a mostrar
PAGINACIÓN: Cargar datos por partes, se hace mezclando LIMIT y OFFSET
GROUP BY: Agrupa filas con el mismo valor en una columna, colapsándolas en uan sola fila por grupo
HAVING: filtrar grupos - Lo mismo que WHERE pero apicado después del agrupamiento
CASE: Es una expresión condicional. Funciona como un if / else if / else dentro de una consulta
UNION: Filas A más filas de B (SIN duplicados)
UNION ALL: Filas A más filas de B (CON duplicados)
INTERSECT: Solamente filas que están en A y también en B (Se puede simular)
MINUS / EXCEPT: Filas que están en A pero NO en B (Se puede simular)
JOIN: Basico

-- Reglas clave:
El orden de las cláusulas en SQL es: - FROM -> WHERE -> GROUP BY -> HAVING -> ORDER BY -> LIMIT


-- Consulta 1: Productos ordenados por precio detal de mayor a menor
SELECT nombre, precio_venta_detal, stock
FROM productos
ORDER BY precio_venta_detal DESC

-- Consulta 2: Alerta de inventario: Productos con menor stock primero
SELECT nombre, stock, stock_minimo
FROM productos
WHERE activo = TRUE
ORDER BY stock ASC

-- Consulta 3: Las 5 ventas más recientes
SELECT id, fecha, tipo, total
FROM ventas
ORDER BY fecha DESC
LIMIT 5

-- Consulta 4: Las 5 ventas más recientes pero con el nombre del cliente
SELECT v.id, c.nombre AS cliente, v.fecha, v.tipo, v.total
FROM ventas v
LEFT JOIN clientes c ON v.cliente_id = c.id
ORDER BY fecha DESC
LIMIT 5

-- Consulta 5: Los 3 productos más vendidos
SELECT p.nombre, SUM(dv.cantidad) AS total_vendido
FROM detalle_ventas dv
JOIN productos p ON dv.producto_id = p.id
GROUP BY p.id, p.nombre
ORDER BY total_vendido DESC
LIMIT 3

-- Consulta 6: Paginación: Traer los productos 3 páginas
SELECT id, nombre, precio_venta_detal, stock
FROM productos
LIMIT 5 OFFSET 10 -- Página 3
-- LIMIT 5 OFFSET 5 -- Página 2
-- LIMIT 5 OFFSET 0 -- Página 1

-- Consulta 7: Clientes con deuda ordenados de mayor a menor
SELECT nombre, tipo, saldo_deuda, limite_credito
FROM clientes
WHERE credito_habilitado = TRUE AND saldo_deuda > 0
ORDER BY saldo_deuda DESC


-- GROUP BY y HAVING
GROUP BY: Agrupa filas con el mismo valor en una columna, colapsándolas en uan sola fila por grupo
HAVING: filtrar grupos - Lo mismo que WHERE pero apicado después del agrupamiento

-- Consulta 8: Total de ventas por dia
SELECT fecha, total, COUNT(*) AS num_ventas, SUM(total) AS total_dia
FROM ventas
GROUP BY fecha
ORDER BY fecha DESC

-- Consulta 9: Ventas por tipo (detal vs por mayor)
SELECT tipo, 
	COUNT(*) AS num_ventas,
	SUM(total) AS total_vendido,
    AVG(total) AS promedio_venta
FROM ventas
GROUP BY tipo;

-- Consulta 10: Productos más vendidos segun la cantidad
SELECT p.nombre, SUM(dv.cantidad) AS unidades_vendidas, SUM(dv.subtotal) AS total_ingreso
FROM detalle_ventas dv 
JOIN productos p ON dv.producto_id = p.id
GROUP BY p.id, p.nombre
ORDER BY unidades_vendidas DESC;

-- Consulta 11: HAVING: Días con ventas totales mayores a $100.000
SELECT fecha, COUNT(*) AS num_ventas, SUM(total) AS total_dia
FROM ventas
GROUP by fecha
HAVING SUM(total) > 100000
ORDER BY total_dia;

-- CASE: Es una expresión condicional. Funciona como un if / else if / else dentro de una consulta
-- Consulta 12: Clasificar productos segun nivel de stock
SELECT nombre, 
	stock, 
    stock_minimo, 
    CASE 
    	WHEN stock <= stock_minimo THEN 'BAJO - Pedir urgente'
        WHEN stock <= stock_minimo * 2 THEN 'MEDIO - Vigilar'
        ELSE 'SUFICIENTE'
    END AS nivel_advertencia
FROM productos
WHERE activo = TRUE
ORDER BY stock ASC;

-- Consulta 13: Clasificar tamaño de las ventas (GRANDE, MEDIANA, PEQUEÑA) según el monto de la venta
SELECT 
	id, 
    fecha, 
    total,
    CASE
    	WHEN total < 20000 THEN 'Venta pequeña'
        WHEN total < 100000 THEN 'Venta mediana'
        ELSE 'Venta grande'
    END AS clasificacion_venta
FROM ventas
ORDER BY total DESC;

-- Operaciones de Conjuntos
UNION: Filas A más filas de B (SIN duplicados)
UNION ALL: Filas A más filas de B (CON duplicados)
INTERSECT: Solamente filas que están en A y también en B (Se puede simular)
MINUS / EXCEPT: Filas que están en A pero NO en B (Se puede simular)

-- Consulta 14: UNION ALL: Movimientos de dinero (Venta - Compra) del mes (No se pueden eliminar "repetidos" 
-- porque uno es un VENTA y el otro es una COMPRA así los datos sean repetidos
SELECT 'Venta' as tipo_movimiento, fecha, total, estado_pago
FROM ventas
WHERE MONTH(fecha) = 3 AND YEAR(fecha) = 2025

UNION ALL

SELECT 'Compra' as tipo_movimiento, fecha, total, estado_pago
FROM compras
WHERE MONTH(fecha) = 3 AND YEAR(fecha) = 2025

-- Consulta 15: UNION: Directorio unificado de contactos (eliminar repetidos)
SELECT nombre, telefono FROM clientes
UNION
SELECT nombre, telefono FROM proveedores

-- Consulta 16: INTERSECT (Simulado): Productos comprados y vendidos
SELECT DISTINCT p.id, p.nombre
FROM productos p
WHERE
	p.id IN (SELECT DISTINCT producto_id FROM detalle_compras)
    AND p.id IN (SELECT DISTINCT producto_id FROM detalle_ventas)

-- Consulta 17: MINUS (Simulado): Productos comprados y vendidos
SELECT DISTINCT p.id, p.nombre
FROM productos p
WHERE
	p.id IN (SELECT DISTINCT producto_id FROM detalle_compras)
    AND p.id NOT IN (SELECT DISTINCT producto_id FROM detalle_ventas);
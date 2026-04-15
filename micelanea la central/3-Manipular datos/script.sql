-- COMANDOS DE MANIPULACIÓN DE DATOS

-- Insertar datos
INSERT INTO gastos (tipo_gasto_id, fecha, monto, descripcion) VALUES
(1, '2025-03-31', 4280000, 'Nómina marzo 2025'),
(2, '2025-03-05', 1200000, 'Arriendo marzo 2025'),
(3, '2025-03-10', 85000, 'Factura agua marzo'),
(4, '2025-03-12', 320000, 'Factura luz marzo'),
(5, '2025-03-05', 75000, 'Internet marzo 2025'),
(6, '2025-03-28', 350000, 'Honorarios contador marzo');

-- Update:
UPDATE productos
SET stock = stock - 2
WHERE id = 1;

-- Delete:
DELETE FROM abonos_clientes
WHERE id = (SELECT MAX(id) FROM abonos_clientes);
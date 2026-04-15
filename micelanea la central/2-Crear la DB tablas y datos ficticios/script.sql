-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS miscelanea_la_central;

-- Crear la tabla "categorias"
CREATE TABLE categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255)
);

-- Insertar datos en "categorias"
INSERT INTO categorias (nombre, descripcion) VALUES 
('Lácteos', 'Productos a base de leche como: leche, queso, yogurt, manteniquilla... etc'),
('Granos y Legumbres', 'Arroz, frijoles, lentejas, maíz'),
('Bebidas', 'Jugos, gaseosas, agua, café'),
('Aceites y Grasas', 'Aceite vegetal, manteca'),
('Enlatados', 'Atún, sardinas, tomate enlatado'),
('Panadería', 'Pan, galletas, cereales'),
('Condimentos', 'Sal, azúcar, especias, salsas');

-- Crear la tabla de "productos"
CREATE TABLE productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    categoria_id INT NOT NULL,
    precio_compra DECIMAL(10,2) NOT NULL,
    precio_venta_detal DECIMAL(10,2) NOT NULL,
    precio_venta_mayor DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    stock_minimo INT NOT NULL DEFAULT 5,
    activo BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

-- insertar datos en "productos"
INSERT INTO productos (nombre, categoria_id, precio_compra, precio_venta_detal, precio_venta_mayor, stock, stock_minimo) VALUES
('Leche entera 1L', 1, 2800, 3500, 3100, 120, 20),
('Queso blanco 500g', 1, 8000, 10000, 9000, 45, 10),
('Arroz blanco 1kg', 2, 2200, 2800, 2500, 200, 30),
('Frijoles negros 500g', 2, 1800, 2400, 2100, 150, 20),
('Gaseosa Cola 2L', 3, 3500, 4500, 4000, 80, 15),
('Jugo de naranja 1L', 3, 3000, 4000, 3500, 60, 10),
('Agua 600ml', 3, 600, 1000, 800, 200, 30),
('Aceite vegetal 1L', 4, 7000, 9000, 8000, 70, 10),
('Atún en lata 160g', 5, 3500, 4500, 4000, 90, 15),
('Galletas soda x12', 6, 2500, 3200, 2900, 110, 20),
('Azúcar 1kg', 7, 2600, 3200, 2900, 180, 25),
('Sal 500g', 7, 800, 1200, 1000, 160, 20),
('Café molido 250g', 3, 5500, 7000, 6200, 55, 10),
('Sardinas en lata 125g', 5, 2800, 3500, 3100, 75, 10),
('Lentejas 500g', 2, 2000, 2600, 2300, 130, 20);

-- Clientes
CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    telefono VARCHAR(20),
    direccion VARCHAR(255),
    tipo ENUM('detal', 'mayor') NOT NULL DEFAULT 'detal',
    credito_habilitado BOOLEAN DEFAULT FALSE,
    limite_credito DECIMAL(10,2) DEFAULT 0.00,
    saldo_deuda DECIMAL(10,2) DEFAULT 0.00
);

INSERT INTO clientes (nombre, telefono, direccion, tipo, credito_habilitado, limite_credito, saldo_deuda) VALUES
('María López', '3001234567', 'Cra 5 #12-34', 'detal', FALSE, 0, 0),
('Supermercado El Ahorro', '3109876543', 'Av. Principal #100', 'mayor', TRUE, 500000, 120000),
('Carlos Martínez', '3157654321', 'Calle 8 #23-10', 'detal', TRUE, 80000, 35000),
('Tienda Don Pedro', '3204567890', 'Barrio Centro #5', 'mayor', TRUE, 300000, 0),
('Ana Gómez', '3012345678', 'Cra 10 #45-67', 'detal', FALSE, 0, 0),
('Distribuidora Norte', '3185432109', 'Zona Industrial #22', 'mayor', TRUE, 800000, 250000),
('Juan Pérez', '3001112233', 'Calle 15 #8-20', 'detal', FALSE, 0, 0);


-- Proveedores
CREATE TABLE proveedores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    telefono VARCHAR(20),
    direccion VARCHAR(255),
    ofrece_credito BOOLEAN DEFAULT FALSE,
    saldo_pendiente DECIMAL(10,2) DEFAULT 0.00
);

INSERT INTO proveedores (nombre, telefono, direccion, ofrece_credito, saldo_pendiente) VALUES
('Lácteos del Valle', '6041234567', 'Parque Industrial #10', TRUE, 180000),
('Distribuidora Granos S.A.', '6049876543', 'Zona Franca #5', TRUE, 0),
('Bebidas Refrescantes Ltda.', '6047654321', 'Av. Comercial #30', FALSE, 0),
('Aceites y Más', '6044567890', 'Cra Industrial #7', TRUE, 95000),
('Enlatados del Pacífico', '6045432109', 'Puerto Zona #2', FALSE, 0);

-- Compras
CREATE TABLE compras (
    id INT AUTO_INCREMENT PRIMARY KEY,
    proveedor_id INT NOT NULL,
    fecha DATE NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    estado_pago ENUM('pagado', 'credito', 'parcial') NOT NULL DEFAULT 'pagado',
    observaciones VARCHAR(255),
    FOREIGN KEY (proveedor_id) REFERENCES proveedores(id)
);

INSERT INTO compras (proveedor_id, fecha, total, estado_pago) VALUES
(1, '2025-03-01', 450000, 'credito'),
(2, '2025-03-02', 320000, 'pagado'),
(3, '2025-03-05', 280000, 'pagado'),
(4, '2025-03-08', 350000, 'credito'),
(1, '2025-03-15', 380000, 'pagado'),
(5, '2025-03-18', 210000, 'pagado'),
(2, '2025-03-22', 290000, 'pagado');

-- Detalle de compras
CREATE TABLE detalle_compras (
    id INT AUTO_INCREMENT PRIMARY KEY,
    compra_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) GENERATED ALWAYS AS (cantidad * precio_unitario) STORED,
    FOREIGN KEY (compra_id) REFERENCES compras(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

INSERT INTO detalle_compras (compra_id, producto_id, cantidad, precio_unitario) VALUES
(1, 1, 60, 2800), (1, 2, 15, 8000),
(2, 3, 80, 2200), (2, 4, 50, 1800), (2, 15, 40, 2000),
(3, 5, 40, 3500), (3, 6, 20, 3000), (3, 7, 60, 600), (3, 13, 10, 5500),
(4, 8, 30, 7000),
(5, 1, 50, 2800), (5, 2, 10, 8000),
(6, 9, 30, 3500), (6, 14, 25, 2800),
(7, 3, 60, 2200), (7, 11, 50, 2600), (7, 12, 40, 800);


-- Ventas
CREATE TABLE ventas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    fecha DATE NOT NULL,
    tipo ENUM('detal', 'mayor') NOT NULL DEFAULT 'detal',
    total DECIMAL(10,2) NOT NULL,
    estado_pago ENUM('pagado', 'credito', 'parcial') NOT NULL DEFAULT 'pagado',
    observaciones VARCHAR(255),
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);

INSERT INTO ventas (cliente_id, fecha, tipo, total, estado_pago) VALUES
(1, '2025-03-01', 'detal', 18500, 'pagado'),
(2, '2025-03-02', 'mayor', 120000, 'credito'),
(3, '2025-03-03', 'detal', 35000, 'credito'),
(4, '2025-03-05', 'mayor', 95000, 'pagado'),
(5, '2025-03-07', 'detal', 12000, 'pagado'),
(NULL, '2025-03-08', 'detal', 8500, 'pagado'),
(2, '2025-03-10', 'mayor', 85000, 'pagado'),
(6, '2025-03-12', 'mayor', 250000, 'credito'),
(1, '2025-03-14', 'detal', 22000, 'pagado'),
(7, '2025-03-15', 'detal', 9500, 'pagado'),
(3, '2025-03-18', 'detal', 15000, 'parcial'),
(4, '2025-03-20', 'mayor', 110000, 'pagado'),
(NULL, '2025-03-22', 'detal', 6000, 'pagado'),
(6, '2025-03-25', 'mayor', 180000, 'credito'),
(5, '2025-03-28', 'detal', 14000, 'pagado');

-- Detalles de venta
CREATE TABLE detalle_ventas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    venta_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) GENERATED ALWAYS AS (cantidad * precio_unitario) STORED,
    FOREIGN KEY (venta_id) REFERENCES ventas(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario) VALUES
(1, 1, 2, 3500), (1, 3, 3, 2800), (1, 12, 1, 1200),
(2, 3, 20, 2500), (2, 4, 15, 2100), (2, 11, 10, 2900),
(3, 8, 2, 9000), (3, 9, 3, 4500), (3, 10, 2, 3200),
(4, 1, 10, 3100), (4, 3, 15, 2500), (4, 5, 5, 4000),
(5, 7, 6, 1000), (5, 12, 2, 1200), (5, 10, 1, 3200),
(6, 13, 1, 7000), (6, 10, 1, 3200),
(7, 3, 15, 2500), (7, 11, 8, 2900), (7, 8, 2, 8000),
(8, 3, 30, 2500), (8, 8, 10, 8000), (8, 11, 15, 2900),
(9, 1, 3, 3500), (9, 9, 2, 4500), (9, 6, 1, 4000),
(10, 7, 4, 1000), (10, 12, 3, 1200), (10, 10, 1, 3200),
(11, 2, 1, 10000), (11, 9, 1, 4500),
(12, 3, 20, 2500), (12, 4, 15, 2100), (12, 15, 10, 2300),
(13, 7, 3, 1000), (13, 12, 1, 1200), (13, 10, 1, 3200),
(14, 8, 8, 8000), (14, 3, 20, 2500), (14, 11, 10, 2900),
(15, 1, 2, 3500), (15, 6, 1, 4000), (15, 13, 1, 7000);

-- Abonos de clientes
CREATE TABLE abonos_clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    venta_id INT NOT NULL,
    fecha DATE NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    observaciones VARCHAR(255),
    FOREIGN KEY (cliente_id) REFERENCES clientes(id),
    FOREIGN KEY (venta_id) REFERENCES ventas(id)
);

INSERT INTO abonos_clientes (cliente_id, venta_id, fecha, monto) VALUES
(2, 2, '2025-03-10', 50000),
(3, 3, '2025-03-12', 20000),
(6, 8, '2025-03-20', 100000),
(3, 11, '2025-03-25', 8000),
(6, 14, '2025-03-30', 80000);

-- Abonos proveedores
CREATE TABLE abonos_proveedores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    proveedor_id INT NOT NULL,
    compra_id INT NOT NULL,
    fecha DATE NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    observaciones VARCHAR(255),
    FOREIGN KEY (proveedor_id) REFERENCES proveedores(id),
    FOREIGN KEY (compra_id) REFERENCES compras(id)
);

INSERT INTO abonos_proveedores (proveedor_id, compra_id, fecha, monto) VALUES
(1, 1, '2025-03-10', 150000),
(1, 1, '2025-03-20', 120000),
(4, 4, '2025-03-18', 200000);

-- Trabajadores
CREATE TABLE trabajadores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    cargo VARCHAR(100) NOT NULL,
    salario DECIMAL(10,2) NOT NULL,
    fecha_ingreso DATE NOT NULL,
    activo BOOLEAN DEFAULT TRUE
);

INSERT INTO trabajadores (nombre, cargo, salario, fecha_ingreso) VALUES
('Luis Herrera', 'Administrador', 1800000, '2020-01-15'),
('Sandra Ríos', 'Vendedora', 1160000, '2021-03-01'),
('Miguel Torres', 'Bodeguero', 1160000, '2022-06-15'),
('Paula Díaz', 'Cajera', 1160000, '2023-01-10');

-- Tipo de gasto
CREATE TABLE tipos_gasto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255)
);

INSERT INTO tipos_gasto (nombre, descripcion) VALUES
('Nómina', 'Pago de salarios a trabajadores'),
('Arriendo', 'Pago mensual de arriendo del local'),
('Agua', 'Servicio público de acueducto'),
('Luz', 'Servicio público de energía eléctrica'),
('Internet', 'Servicio de conectividad'),
('Honorarios contables', 'Pago al contador externo');

-- Gastos
CREATE TABLE gastos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo_gasto_id INT NOT NULL,
    fecha DATE NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    descripcion VARCHAR(255),
    FOREIGN KEY (tipo_gasto_id) REFERENCES tipos_gasto(id)
);

INSERT INTO gastos (tipo_gasto_id, fecha, monto, descripcion) VALUES
(1, '2025-03-31', 4280000, 'Nómina marzo 2025'),
(2, '2025-03-05', 1200000, 'Arriendo marzo 2025'),
(3, '2025-03-10', 85000, 'Factura agua marzo'),
(4, '2025-03-12', 320000, 'Factura luz marzo'),
(5, '2025-03-05', 75000, 'Internet marzo 2025'),
(6, '2025-03-28', 350000, 'Honorarios contador marzo');


-- COMANDOS DE MANIPULACIÓN DE DATOS
-- Update:
UPDATE productos
SET stock = stock - 2
WHERE id = 1;

-- Delete:
INSERT INTO abonos_clientes (cliente_id, venta_id, fecha, monto)
VALUES (2, 2, CURDATE(), 30000)

-- SQL 
CREATE DATABASE gamer_pro_xela
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LOCALE_PROVIDER = 'libc'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
	
CREATE SCHEMA empleados
    AUTHORIZATION postgres;

CREATE SCHEMA productos
    AUTHORIZATION postgres;
	
CREATE SCHEMA clientes
    AUTHORIZATION postgres;
	
CREATE SCHEMA ventas
    AUTHORIZATION postgres;
	
CREATE SCHEMA sucursales
    AUTHORIZATION postgres;
	
--CREACION DE TABLAS

CREATE TABLE sucursales.sucursal
(
    id_sucursal integer NOT NULL,
    nombre character varying NOT NULL,
    direccion character varying NOT NULL,
    PRIMARY KEY (id_sucursal)
);

CREATE TABLE productos.producto
(
    codigo integer NOT NULL,
    nombre character varying(50) NOT NULL,
    descripcion text NOT NULL,
    precio numeric(10, 2),
    PRIMARY KEY (codigo)
);

CREATE TABLE sucursales.producto_sucursal
(
    id_producto_s serial NOT NULL,
    codigo_producto integer NOT NULL,
    id_sucursal integer NOT NULL,
    PRIMARY KEY (id_producto_s),
    CONSTRAINT fk_producto_sucursal FOREIGN KEY (codigo_producto)
        REFERENCES productos.producto (codigo) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
        NOT VALID,
    CONSTRAINT fk_id_sucursal FOREIGN KEY (id_sucursal)
        REFERENCES sucursales.sucursal (id_sucursal) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
        NOT VALID
);

CREATE TABLE sucursales.bodega
(
    id_bodega integer NOT NULL,
    id_sucursal integer NOT NULL,
    PRIMARY KEY (id_bodega),
    CONSTRAINT fk_bodega_sucursal FOREIGN KEY (id_sucursal)
        REFERENCES sucursales.sucursal (id_sucursal) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
        NOT VALID
);

CREATE TABLE sucursales.inventario_bodega
(
    id_inventario_bodega serial NOT NULL,
    id_bodega integer NOT NULL,
    codigo_producto integer NOT NULL,
    cantidad_disponible integer NOT NULL,
    PRIMARY KEY (id_inventario_bodega),
    CONSTRAINT fk_invb_bodega FOREIGN KEY (id_bodega)
        REFERENCES sucursales.bodega (id_bodega) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
        NOT VALID,
    CONSTRAINT fk_invb_producto FOREIGN KEY (codigo_producto)
        REFERENCES productos.producto (codigo) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
        NOT VALID
);


CREATE TABLE sucursales.estanteria
(
    id_estanteria integer NOT NULL,
    id_sucursal integer NOT NULL,
    PRIMARY KEY (id_estanteria),
    CONSTRAINT fk_estanteria_sucursal FOREIGN KEY (id_sucursal)
        REFERENCES sucursales.sucursal (id_sucursal) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
        NOT VALID
);

CREATE TABLE sucursales.inventario_estanteria
(
    id_inventario_estanteria serial NOT NULL,
    id_estanteria integer NOT NULL,
    codigo_producto integer NOT NULL,
    pasillo integer NOT NULL,
    cantidad_disponible integer NOT NULL,
    PRIMARY KEY (id_inventario_estanteria),
    CONSTRAINT fk_inve_estanteria FOREIGN KEY (id_estanteria)
        REFERENCES sucursales.estanteria (id_estanteria) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
        NOT VALID,
    CONSTRAINT fk_inve_producto FOREIGN KEY (codigo_producto)
        REFERENCES productos.producto (codigo) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
        NOT VALID
);

CREATE TABLE empleados.empleado
(
    id_empleado serial NOT NULL,
    contrasenia character varying NOT NULL,
    dpi character varying(30) NOT NULL,
    usuario character varying(50) NOT NULL,
    nombre character varying(100) NOT NULL,
    apellido character varying(100) NOT NULL,
    id_sucursal integer NOT NULL,
    tipo_empleado character varying(50) NOT NULL,
    numero_caja integer,
    PRIMARY KEY (id_empleado),
    CONSTRAINT fk_empleado_sucursal FOREIGN KEY (id_sucursal)
        REFERENCES sucursales.sucursal (id_sucursal) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
        NOT VALID
);


CREATE TABLE clientes.tipo_tarjeta
(
    id_tipo integer NOT NULL,
    nombre character varying(50) NOT NULL,
    cantidad_adquisicion integer NOT NULL,
    puntos_descuento integer NOT NULL,
    PRIMARY KEY (id_tipo)
);

CREATE TABLE clientes.tarjeta_descuento
(
    id_tarjeta serial NOT NULL,
    puntos integer NOT NULL,
    tipo_tarjeta integer NOT NULL,
    PRIMARY KEY (id_tarjeta),
    CONSTRAINT fk_tarjeta_tipo FOREIGN KEY (tipo_tarjeta)
        REFERENCES clientes.tipo_tarjeta (id_tipo) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
        NOT VALID
);

CREATE TABLE clientes.cliente
(
    nit character varying(50) NOT NULL,
    nombre character varying(50) NOT NULL,
    apellido character varying(50),
    telefono integer,
    direccion character varying(100),
    sucursal_registrada integer NOT NULL,
    tarjeta_descuento integer,
    PRIMARY KEY (nit),
    CONSTRAINT fk_cliente_sucursal FOREIGN KEY (sucursal_registrada)
        REFERENCES sucursales.sucursal (id_sucursal) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
        NOT VALID,
    CONSTRAINT fk_cliente_tarjeta FOREIGN KEY (tarjeta_descuento)
        REFERENCES clientes.tarjeta_descuento (id_tarjeta) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
        NOT VALID
);

CREATE TABLE clientes.solicitud_tarjeta
(
    id_solicitud serial NOT NULL,
    id_tipo_tarjeta integer NOT NULL,
    estado boolean DEFAULT FALSE,
    nit_cliente character varying(50) NOT NULL,
    PRIMARY KEY (id_solicitud),
    CONSTRAINT fk_solicitud_tipo FOREIGN KEY (id_tipo_tarjeta)
        REFERENCES clientes.tipo_tarjeta (id_tipo) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
        NOT VALID,
    CONSTRAINT fk_solicitud_cliente FOREIGN KEY (nit_cliente)
        REFERENCES clientes.cliente (nit) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
        NOT VALID
);

CREATE TABLE ventas.pedido
(
    id_pedido serial NOT NULL,
    id_sucursal integer NOT NULL,
    nit_cliente character varying(50),
    nombre_cliente character varying(50) NOT NULL,
    consumidor_final boolean DEFAULT FALSE,
    total numeric(10, 2),
    total_descuento numeric(10, 2),
    estado boolean DEFAULT FALSE,
    fecha_pedido date NOT NULL,
    PRIMARY KEY (id_pedido),
    CONSTRAINT fk_pedido_sucursal FOREIGN KEY (id_sucursal)
        REFERENCES sucursales.sucursal (id_sucursal) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
        NOT VALID,
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (nit_cliente)
        REFERENCES clientes.cliente (nit) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
        NOT VALID
);

CREATE TABLE ventas.detalle_pedido
(
    id_detalle_p serial NOT NULL,
    id_pedido integer NOT NULL,
    codigo_producto integer NOT NULL,
    costo_u numeric(10, 2) NOT NULL,
    cantidad integer NOT NULL,
    costo_total numeric(10, 2) NOT NULL,
    PRIMARY KEY (id_detalle_p),
    CONSTRAINT fk_detalle_pedido FOREIGN KEY (id_pedido)
        REFERENCES ventas.pedido (id_pedido) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
        NOT VALID,
    CONSTRAINT fk_detallep_producto FOREIGN KEY (codigo_producto)
        REFERENCES productos.producto (codigo) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
        NOT VALID
);

CREATE TABLE ventas.venta
(
    numero_factura serial NOT NULL,
    id_empleado integer NOT NULL,
    id_pedido integer NOT NULL,
    total numeric(10, 2),
    total_descuento numeric(10, 2),
    descuento numeric(10, 2),
    fecha_venta date,
    PRIMARY KEY (numero_factura),
    CONSTRAINT fk_venta_empleado FOREIGN KEY (id_empleado)
        REFERENCES empleados.empleado (id_empleado) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
        NOT VALID,
    CONSTRAINT fk_venta_pedido FOREIGN KEY (id_pedido)
        REFERENCES ventas.pedido (id_pedido) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
        NOT VALID
);

CREATE TABLE ventas.detalle_venta
(
    id_detalle_v serial NOT NULL,
    numero_factura integer NOT NULL,
    codigo_producto integer NOT NULL,
    cantidad integer NOT NULL,
    costo_u numeric(10, 2) NOT NULL,
    costo_total numeric(10, 2),
    PRIMARY KEY (id_detalle_v),
    CONSTRAINT fk_detalle_factura FOREIGN KEY (numero_factura)
        REFERENCES ventas.venta (numero_factura) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
        NOT VALID,
    CONSTRAINT fk_detallev_producto FOREIGN KEY (codigo_producto)
        REFERENCES productos.producto (codigo) MATCH SIMPLE
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
        NOT VALID
);


	
	-- INSERTAR SUCURSALES 
	
	INSERT INTO sucursales.sucursal (id_sucursal, nombre, direccion) VALUES 
	(1111,'Sucursal Parque','Zona 1, Parque Central Xela' ),
	(2222, 'Sucursal Centro1', 'Zona 2, 8av, Centro Xela'),
	(3333, 'Sucursal Centro2','Zona 3, 9av, Centro 2 Xela' );
	
	-- crear bodegas 
	INSERT INTO sucursales.bodega( id_bodega, id_sucursal) VALUES
	(1114, 1111),(2224, 2222),(3334, 3333);
	
	-- crear estanterias
	INSERT INTO sucursales.estanteria(id_estanteria, id_sucursal) VALUES 
	(1115, 1111), (2225,2222),(3335,3333);
	
	-- INSERTAR PRODUCTOS 
	INSERT INTO productos.producto (codigo, nombre, descripcion, precio) VALUES 
	(100, 'Black Myth: Wukong PS5', 'Sigue las aventuras del rey mono', 500),
	(101, 'ASTRO BOT PS5', 'Un desafiante juego de estrategia',250),
	(102, 'Juego PS5 Ratchet & Clank: Rift Apart', 'Ábrete paso a lo grande por una aventura interdimensional con Ratchet y Clank', 729),
	(103, 'PS5 Marvels Spider-Man: Miles Morales', 'Juego PS5 Spider-Man: Miles Morales.', 529.99),
	(104, 'PS5 Gran Turismo 7', 'Juego PS5 Gran Turismo 7', 709.99),
	(105, 'PS5 Mortal Kombat 11 Ultimate', 'Juego PS5 Mortal Kombat 11 Ultimate', 279),
	(106, 'PS5 Resident Evil Village', 'Género: Acción/Terror', 299.99),
	(107, 'Juego PS4 EA SPORTS FC™ 24', 'Admite hasta 22 jugadores online que tengan PS Plus', 479),
	(108, 'PS4 Assassins Creed Mirage', 'Juego PS4 Assassins Creed Mirage LE Deluxe Edition', 649),
	(109, 'PS4 Call of Duty: Modern Warfare III', 'Juego PS4 Call of Duty: Modern Warfare III', 709),
	(110, 'PS4 The Last of Us Remastered', 'Juego PS4 The Last of Us Remastered', 149.99),
	(111, 'Juego PS4 God of War: Ragnarok', 'Kratos y Atreus se embarcan en una mítica aventura en busca de respuestas y aliados antes de la llegada del Ragnarok', 649.99),
	(112, 'PS4 Gran Turismo Sport', 'Género: Conducción/Carreras', 148),
	(113, 'PS4 Spider-Man Game of the Year', 'Juego PS4 Spider-Man Game of the Year Edition', 328.99),
	(114, 'PS4 Plants vs. Zombies', 'Juego PS4 Plants vs. Zombies: Battle for Neighborville', 178),
	(115, 'Juego PS4 Street Fighter 6', 'Street Fighter 6 ofrece un sistema de combate muy pulido', 429),
	(116, 'Juego PS4 EA SPORTS FC 25', 'Género: Deportes', 646),
	(117, 'Counter-Strike 2', 'Durante más de dos décadas, Counter-Strike ha brindado una experiencia competitiva de élite', 200),
	(118, 'Warhammer 40,000: Space Marine 2', 'Encarna la habilidad y la brutalidad sobrehumanas de un marine espacial', 250.99),
	(119, 'Frostpunk 2', 'Develop, expand, and advance your city in a society survival game set 30 years after an apocalyptic blizzard', 150.99),
	(120, 'FINAL FANTASY XVI', 'Una fantasía oscura épica donde el destino lo deciden los Eikons y los Dominantes que los controlan', 400),
	(121, 'ELDEN RING', 'Levántate, tiznado, y déjate guiar por la gracia para esgrimir el poder del Anillo de Elden', 410.99),
	(122, 'DRAGON BALL: Sparking! ZERO', 'toma el legendario estilo de juego de la saga Budokai Tenkaichi', 200),
	(123, 'Dota 2', 'Cada día, millones de jugadores de todo el mundo entran en batalla', 200),
	(300, 'NINTENDO SWITCH OLED BLANCA', 'Consola nueva color Blanco', 2899.99),
	(301, 'Nintendo Switch Oled Mario Edition', 'Consola Nueva Edición Mario', 3099),
	(302, 'Playstation 4 Slim 1 TB', 'Consola Usada, excelente estado', 1999.99),
	(303, 'PLAYSTATION 5 SLIM 1TB', 'Consola nueva sellada', 5299),
	(304, 'XBOX SERIES S', 'Consola Nueva Sellada', 3149.99),
	(305, 'XBOX SERIES S 1TB', 'Consola Nueva 1TB SSD', 4259.99),
	(306, 'XBOX SERIES X', 'Consola nueva sellada', 4799),
	(307, 'Playstation 5 Fat 825GB', 'sada en Óptimas condiciones', 3899.99),
	(308, 'XBOX ONE S 1TB', 'Consola Usada, excelente estado', 1799.99),
	(309, 'NINTENDO SWITCH OLED NEÓN', 'Consola nueva color Neón', 2899),
	(310, 'PLAYSTATION 5 SLIM 1TB Digital', 'Versión Slim Digital', 4599.99),
	(311, 'Laptop HP Victus Gaming 15-fb0114la de 15.6', 'Procesador AMD Ryzen 7 5800H', 9298),
	(312, 'Laptop Lenovo LOQ 15IRX9', 'Pantalla de 15.6 FHD (1920x1080) IPS 300nits 144Hz', 14999),
	(313, 'Laptop Asus FA506NF-HN005W', 'Procesador AMD Ryzen 5 7535U', 8499),
	(314, 'Laptop Lenovo LOQ 15ARP9', 'FHD procesador AMD Ryzen 5 7235HS, 16GB RAM, 512GB SSD, RTX3050 6GB', 9999.99),
	(315, 'Laptop Lenovo Legion Slim 5 16HP9', 'procesador AMD Ryzen 7 8845HS, 16GB RAM, 1TB SSD, RTX4070 8GB', 19999.99),
	(316, 'Laptop HP Victus 15-fa0000la', '16GB RAM, 512GB SSD, RTX3050 4GB', 9999),
	(317, 'Monitor Dell Alienware AW2724HF', 'Gaming Full HD, 360Hz, 0.5ms, AMD FreeSync Premium', 4990.99),
	(318, 'Monitor LG 24MP60G', 'Gaming, Full HD IPS, 1ms, 75Hz, AMD FreeSync', 1299),
	(319, 'Monitor Samsung Odyssey G4', 'FHD con Panel IPS, 240Hz, 1ms, Nvidia G-Sync', 2999),
	(320, 'Monitor Dell S2421HN', 'Gaming FHD, AMD FreeSync', 1398),
	(210, 'Control Para Nintendo Switch  Power A', 'Marca Power A, Spectra 8 Colores', 374.99),
	(211, 'Control para xbox series SX RAZER', 'Inalámbrico/ultima Generación', 649.99),
	(212, 'Control Pro de Switch Edición Monster', 'Monster Hunter Rise: Sunbreak Original', 749),
	(213, 'Control Pro de Switch Edición Splatoon 2', 'Nuevo Sellado, Edición especial Splatoon 2', 824),
	(214, 'Control Pro de Wii Genérico', 'Compatible con Nintendo Wii', 100),
	(215, 'Control Pro de Wii U Blanco', 'Genérico Inalámbrico, Compatible con Nintendo Wii U', 224.99),
	(216, 'Control Pro Switch AAA Splatoon 2', 'Control Pro Switch Inalámbrico Edición Splatoon 2', 399.99),
	(217, 'Control Pro Switch AAA Xenoblade', 'Control Pro Switch Inalámbrico Edición Xenoblade', 449.99),
	(218, 'Control Ps3 AAA Menta', 'Control Ps3 Inalámbrico Menta', 174.99),
	(219, 'Control PS4 AAA 500 Millones', 'Edición limitada 500 millones', 424),
	(220, 'Control PS4 Original Green Camouflage', 'Control Ps4 2da. Gen. Inalámbrico Green Camouflage', 539.99),
	(221, 'Control Razer Raiju Mobile', 'Control RAZER Raiju Mobile,Compatible con Android', 547.99),
	(222, 'Control Scuf Prestige Azul Wireless', 'Control Xbox One Scuf Prestige', 1499.99),
	(223, 'Control Wii Mote + Nunchuk', 'Control Inalámbrico Wii Mote + Nunchuck Celeste', 274),
	(224, 'Control Xbox 360 Blanco', 'Control Xbox 360 Inalámbrico Blanco', 224.99),
	(225, 'Control Xbox 360 Negro', 'Control Xbox 360 Inalámbrico Negro', 224.99),
	(226, 'Control Xbox Elite Series 2', 'Control Xbox Elite Series 2 Core Blue', 1399.99),
	(227, 'Control Xbox One 3ra Gen. CyberPunk 2077', 'Edición Limitada CyberPunk 2077', 424),
	(228, 'Control Xbox One 3ra Gen. Design Lab', 'Compatible con Xbox One/Series X/S/PC', 499),
	(229, 'Control Xbox One 3ra Gen. Rojo', 'Usado en Óptimas condiciones', 374.99),
	(230, 'Control Xbox Series S|X Astral Purple', 'Inalámbrico/ultima generación', 674.99),
	(231, 'Control Xbox Series S|X Carbon', 'Carbon Black Open Box', 449.99),
	(232, 'Control Xbox Series S|X Daystrike Camo', 'Compatible con todas las consolas', 649.99),
	(233, 'Control Xbox Series S|X Dream Vapor', 'Compatible con todas las consolas', 674),
	(234, 'Control Xbox Series S|X Forza', 'Forza Horizon 5 – Personalizado', 549.99),
	(235, 'Control Xbox Series S|X Mineral', 'Control Xbox Series S|X Mineral Camo Open Box', 549.99),
	(236, 'DualSense Control Ps5 Original', 'Compatible con Playstation 5', 649.99),
	(237, 'DualSense Control Ps5 Sterling Silver', 'Control DualSense PS5', 699.99),
	(400, 'Adaptador de Micro SD Nintendo Gamecube', 'Compatible con Nintendo Gamecube', 84.99),
	(401, 'Batería para control PRO de Nintendo Switch', 'Batería para Control PRO de Nintendo Switch', 89.99),
	(402, 'Batería para control PS3', 'Compatible con control PS3', 90),
	(403, 'Batería para control PS4', 'Batería genérica para control PS4', 100),
	(404, 'Batería para DS Lite', 'Compatible con DS Lite', 85),
	(405, 'Batería para GamePad de Wii U', 'Compatible con GamePad de Wii U', 134.99),
	(406, 'Batería para Joycon de Nintendo Switch', 'Compatible con Joycon de Nintendo Switch', 109.99),
	(407, 'Batería para PS Vita Fat', 'Batería para Consola PS Vita Fat', 124.99),
	(408, 'Batería para PS Vita Slim', 'Batería para Consola PS Vita Slim', 149.99),
	(409, 'Batería para PSP 1000', 'Batería para Consola PSP', 100),
	(410, 'Bocina para Nintendo Switch', 'Producto Usado en Excelentes Condiciones', 149.99),
	(411, 'Botón de Encendido PS2 Slim', 'Botón de Encendido para Playstation 2', 34.99),
	(412, 'Botón de Encendido para Xbox One S', 'Botón/Placa de Encendido para Xbox One S', 249.99),
	(413, 'Carcasa para Nintendo Switch', 'Carcasa AAA para Nintendo Switch', 175),
	(414, 'Fuente de Poder para PS4', 'Pro300 CR De 4 Pines', 749.99),
	(415, 'Lente para PS4 Fat KES 860A', 'Modelo: KES 860A', 374.99),
	(416, 'Fuente de Poder para Xbox One S', 'Usada Excelentes Condiciones', 349.99),
	(417, 'Lente para PS3 Slim', 'Modelo: KES 450DAA', 299),
	(418, 'Módulo Wifi para Xbox One', 'Placa Wifi para Xbox One', 250),
	(419, 'Lente para PS3 Fat KES 400A', 'Compatible con PS3 Fat', 249.99),
	(420, 'Ventilador para Play Station 4 Fat 1200', 'Compatible con Play Station 4 Fat 1200', 174.99),
	(421, 'Puerto de Carga para PS Vita', 'Compatible con PS Vita Fat', 174.99),
	(422, 'Pantalla para PSP Go', 'Compatible con PSP Go', 124.99),
	(423, 'Touch para Pantalla de Nintendo Switch', 'Compatible con Nintendo Switch', 125),
	(424, 'Lector de Micro SD', 'Compatible con Nintendo Switch V1/V2', 99.99),
	(425, 'Puerto HDMI para Play Station 4', 'Compatible con Play Station 4 Slim/Pro', 99.99),
	(426, 'Stick para Control de Nintendo 64', 'Stick Genérico', 99.99),
	(427, 'Puerto HDMI para Xbox One S', 'Compatible con Xbox One S', 99.99);
	
	--PRODUCTOS SUCURSAL 
	INSERT INTO sucursales.producto_sucursal (codigo_producto, id_sucursal) VALUES 
	(100, 1111), (101, 1111), (102, 1111), (103, 1111), (104, 1111), (105, 1111), (106, 1111), (107, 1111), (108, 1111), (109, 1111),
	(110, 1111), (111, 1111), (112, 1111), (113, 1111), (114, 1111), (115, 1111), (116, 1111), (117, 1111), (118, 1111), (119, 1111),
	(120, 1111), (121, 1111), (122, 1111), (123, 1111), (300, 1111), (301, 1111), (302, 1111), (303, 1111), (304, 1111), (305, 1111),
	(306, 1111), (307, 1111), (308, 1111), (309, 1111), (310, 1111), (311, 1111), (312, 1111), (313, 1111), (314, 1111), (315, 1111),
	(316, 1111), (317, 1111), (318, 1111), (319, 1111), (320, 1111), (210, 1111), (211, 1111), (212, 1111), (213, 1111), (214, 1111),
	(215, 1111), (216, 1111), (217, 1111), (218, 1111), (219, 1111), (220, 1111), (221, 1111), (222, 1111), (223, 1111), (224, 1111),
	(225, 1111), (226, 1111), (227, 1111), (228, 1111), (229, 1111), (230, 1111), (231, 1111), (232, 1111), (233, 1111), (234, 1111),
	(235, 1111), (236, 1111), (237, 1111), (400, 1111), (401, 1111), (402, 1111), (403, 1111), (404, 1111), (405, 1111), (406, 1111),
	(407, 1111), (408, 1111), (409, 1111), (410, 1111), (411, 1111), (412, 1111), (413, 1111), (414, 1111), (415, 1111), (416, 1111),
	(417, 1111), (418, 1111), (419, 1111), (420, 1111), (421, 1111), (422, 1111), (423, 1111), (424, 1111), (425, 1111), (426, 1111),
	(100, 2222), (101, 2222), (102, 2222), (103, 2222), (104, 2222), (105, 2222), (106, 2222), (107, 2222), (108, 2222), (109, 2222),
	(110, 2222), (111, 2222), (112, 2222), (113, 2222), (114, 2222), (115, 2222), (116, 2222), (117, 2222), (118, 2222), (119, 2222),
	(120, 2222), (121, 2222), (122, 2222), (123, 2222), (300, 2222), (301, 2222), (302, 2222), (303, 2222), (304, 2222), (305, 2222),
	(306, 2222), (307, 2222), (308, 2222), (309, 2222), (310, 2222), (311, 2222), (312, 2222), (313, 2222), (314, 2222), (315, 2222),
	(316, 2222), (317, 2222), (318, 2222), (319, 2222), (320, 2222), (210, 2222), (211, 2222), (212, 2222), (213, 2222), (214, 2222),
	(215, 2222), (216, 2222), (217, 2222), (218, 2222), (219, 2222), (220, 2222), (221, 2222), (222, 2222), (223, 2222), (224, 2222),
	(225, 2222), (226, 2222), (227, 2222), (228, 2222), (229, 2222), (230, 2222), (231, 2222), (232, 2222), (233, 2222), (234, 2222),
	(407, 2222), (408, 2222), (409, 2222), (410, 2222), (411, 2222), (412, 2222), (413, 2222), (414, 2222), (415, 2222), (416, 2222),
	(110, 3333), (111, 3333), (112, 3333), (113, 3333), (114, 3333), (115, 3333), (116, 3333), (117, 3333), (118, 3333), (119, 3333),
	(120, 3333), (121, 3333), (122, 3333), (123, 3333), (300, 3333), (301, 3333), (302, 3333), (303, 3333), (304, 3333), (305, 3333),
	(306, 3333), (307, 3333), (308, 3333), (309, 3333), (310, 3333), (311, 3333), (312, 3333), (313, 3333), (314, 3333), (315, 3333),
	(316, 3333), (317, 3333), (318, 3333), (319, 3333), (320, 3333), (210, 3333), (211, 3333), (212, 3333), (213, 3333), (214, 3333),
	(215, 3333), (216, 3333), (217, 3333), (218, 3333), (219, 3333), (220, 3333), (221, 3333), (222, 3333), (223, 3333), (224, 3333),
	(235, 3333), (236, 3333), (237, 3333), (400, 3333), (401, 3333), (402, 3333), (403, 3333), (404, 3333), (405, 3333), (406, 3333),
	(407, 3333), (408, 3333), (409, 3333), (410, 3333), (411, 3333), (412, 3333), (413, 3333), (414, 3333), (415, 3333), (416, 3333),
	(417, 3333), (418, 3333), (419, 3333), (420, 3333), (421, 3333), (422, 3333), (423, 3333), (424, 3333), (425, 3333), (427, 3333);
	
	--INVENTARIO BODEGA
	INSERT INTO sucursales.inventario_bodega (id_bodega, codigo_producto, cantidad_disponible) VALUES 
	(1114, 100, 20), (1114, 101, 10), (1114, 102, 15), 
	(1114, 103, 16), (1114, 104, 14), (1114, 105, 17), (1114, 106, 18), 
	(1114, 107, 20), (1114, 108, 21), (1114, 109, 22),
	(1114, 110, 23), (1114, 111, 24), (1114, 112, 20), (1114, 113, 8),
	(1114, 114, 7), (1114, 115, 3), (1114, 116, 4), (1114, 117, 10), 
	(1114, 118, 12), (1114, 119, 14), (1114, 120, 17), (1114, 121, 18), 
	(1114, 122, 20), (1114, 123, 31), (1114, 300, 30), (1114, 301, 31), 
	(1114, 302, 32), (1114, 303, 10), (1114, 304, 4), (1114, 305, 2),
	(1114, 306, 4), (1114, 307, 10), (1114, 308, 12), (1114, 309, 14), 
	(1114, 310, 17), (1114, 311, 18), (1114, 312, 17), (1114, 313, 20), 
	(1114, 314, 21), (1114, 315, 22), (1114, 316, 23), (1114, 317, 24),
	(1114, 318, 10), (1114, 319, 11), (1114, 320, 12), (1114, 210, 13), 
	(1114, 211, 14), (1114, 212, 15), (1114, 213, 40), (1114, 214, 7),
	(1114, 215, 45), (1114, 216, 41), (1114, 217, 21), (1114, 218, 25), 
	(1114, 219, 10), (1114, 220, 17), (1114, 221, 12), (1114, 222, 14), 
	(1114, 223, 18), (1114, 224, 45), (1114, 225, 22), (1114, 226, 23), 
	(1114, 227, 24), (1114, 228, 24), (1114, 229, 22), (1114, 230, 23), 
	(1114, 231, 14), (1114, 232, 12), (1114, 233, 11), (1114, 234, 41),
	(1114, 235, 7), (1114, 236, 8), (1114, 237, 9), (1114, 400, 1), 
	(1114, 401, 12), (1114, 402, 14), (1114, 403, 13), (1114, 404, 12), 
	(1114, 405, 4), (1114, 406, 12), (1114, 407, 8), (1114, 408, 5), 
	(1114, 409, 6), (1114, 410, 4), (1114, 411, 3), (1114, 412, 4), 
	(1114, 413, 8), (1114, 414, 9), (1114, 415, 10), (1114, 416, 11),
	(1114, 417, 12), (1114, 418, 13), (1114, 419, 14), (1114, 420, 15), 
	(1114, 421, 16), (1114, 422, 12), (1114, 423, 11), (1114, 424, 7), 
	(1114, 425, 5), (1114, 426, 5),
	(2224, 100, 12), (2224, 101, 14), (2224, 102, 12), (2224, 103, 10), 
	(2224, 104, 11), (2224, 105, 4), (2224, 106, 1), (2224, 107, 25), 
	(2224, 108, 30), (2224, 109, 2), (2224, 110, 12), (2224, 111, 15), 
	(2224, 112, 17), (2224, 113, 48), (2224, 114, 20), (2224, 115, 21), 
	(2224, 116, 23), (2224, 117, 24), (2224, 118, 20), (2224, 119, 10),
	(2224, 120, 12), (2224, 121, 14), (2224, 122, 15), (2224, 123, 12), 
	(2224, 300, 11), (2224, 301, 13), (2224, 302, 14), (2224, 303, 12), 
	(2224, 304, 13), (2224, 305, 14), (2224, 306, 15), (2224, 307, 17),
	(2224, 308, 12), (2224, 309, 14), (2224, 310, 14), (2224, 311, 4),
	(2224, 312, 5), (2224, 313, 4), (2224, 314, 6), (2224, 315, 7),
	(2224, 316, 8), (2224, 317, 4), (2224, 318, 7), (2224, 319, 4),
	(2224, 320, 7), (2224, 210, 8), (2224, 211, 9), (2224, 212, 7),
	(2224, 213, 12), (2224, 214, 14), (2224, 215, 15), (2224, 216, 17), 
	(2224, 217, 18), (2224, 218, 16), (2224, 219, 14), (2224, 220, 12),
	(2224, 221, 13), (2224, 222, 14), (2224, 223, 15), (2224, 224, 16),
	(2224, 225, 14), (2224, 226, 14), (2224, 227, 15), (2224, 228, 6),
	(2224, 229, 7), (2224, 230, 7), (2224, 231, 8), (2224, 232, 9),
	(2224, 233, 10), (2224, 234, 11), (2224, 407, 12), (2224, 408, 13),
	(2224, 409, 14), (2224, 410, 15), (2224, 411, 17), (2224, 412, 15), 
	(2224, 413, 4), (2224, 414, 4), (2224, 415, 5), (2224, 416, 6),
	(3334, 110, 7), (3334, 111, 8), (3334, 112, 9), (3334, 113, 1), 
	(3334, 114, 10), (3334, 115, 11), (3334, 116, 12), (3334, 117, 13), 
	(3334, 118, 14), (3334, 119, 15), (3334, 120, 16), (3334, 121, 17), 
	(3334, 122, 18), (3334, 123, 19), (3334, 300, 20), (3334, 301, 1),
	(3334, 302, 2), (3334, 303, 3), (3334, 304, 4), (3334, 305, 5),
	(3334, 306, 6), (3334, 307, 7), (3334, 308, 8), (3334, 309, 9),
	(3334, 310, 10), (3334, 311, 11), (3334, 312, 12), (3334, 313, 13),
	(3334, 314, 14), (3334, 315, 15), (3334, 316, 16), (3334, 317, 17),
	(3334, 318, 18), (3334, 319, 19), (3334, 320, 20), (3334, 210, 21),
	(3334, 211, 22), (3334, 212, 23), (3334, 213, 24), (3334, 214, 25),
	(3334, 215, 23), (3334, 216, 1), (3334, 217, 2), (3334, 218, 3),
	(3334, 219, 4), (3334, 220, 5), (3334, 221, 6), (3334, 222, 7), 
	(3334, 223, 8), (3334, 224, 9), (3334, 235, 10), (3334, 236, 11),
	(3334, 237, 12), (3334, 400, 13), (3334, 401, 14), (3334, 402, 15),
	(3334, 403, 16), (3334, 404, 17), (3334, 405, 17), (3334, 406, 12),
	(3334, 407, 2), (3334, 408, 3), (3334, 409, 4), (3334, 410, 5), 
	(3334, 411, 6), (3334, 412, 7), (3334, 413, 8), (3334, 414, 9), 
	(3334, 415, 10), (3334, 416, 11), (3334, 417, 12), (3334, 418, 13), 
	(3334, 419, 14), (3334, 420, 15), (3334, 421, 16), (3334, 422, 14), 
	(3334, 423, 15), (3334, 424, 16), (3334, 425, 14), (3334, 427, 11);
	
	--INVENTARIO ESTANTERIA
	INSERT INTO sucursales.inventario_estanteria (id_estanteria, codigo_producto, pasillo, cantidad_disponible) VALUES 
	(1115, 100, 5, 20), (1115, 101, 2, 10), (1115, 102, 3, 15), 
	(1115, 103, 4, 16), (1115, 104, 1, 14), (1115, 105, 4, 17), (1115, 106, 1, 18), 
	(1115, 107, 6, 20), (1115, 108, 2, 21), (1115, 109, 5, 22),
	(1115, 110, 7, 23), (1115, 111, 3, 24), (1115, 112, 6, 20), (1115, 113, 2, 8),
	(1115, 114, 1, 7), (1115, 115, 4, 3), (1115, 116, 7, 4), (1115, 117, 3, 10), 
	(1115, 118, 2, 12), (1115, 119, 2, 14), (1115, 120, 8, 17), (1115, 121, 4, 18), 
	(1115, 122, 3, 20), (1115, 123, 6, 31), (1115, 300, 9, 30), (1115, 301, 5, 31), 
	(1115, 302, 4, 32), (1115, 303, 7, 10), (1115, 304, 1, 4), (1115, 305, 6, 2),
	(1115, 306, 5, 4), (1115, 307, 8, 10), (1115, 308, 2, 12), (1115, 309, 7, 14), 
	(1115, 310, 6, 17), (1115, 311, 9, 18), (1115, 312, 3, 17), (1115, 313, 8, 20), 
	(1115, 314, 7, 21), (1115, 315, 1, 22), (1115, 316, 4, 23), (1115, 317, 9, 24),
	(1115, 318, 8, 10), (1115, 319, 2, 11), (1115, 320, 5, 12), (1115, 210, 1, 13), 
	(1115, 211, 9, 14), (1115, 212, 3, 15), (1115, 213, 6, 40), (1115, 214, 2, 7),
	(1115, 215, 1, 45), (1115, 216, 4, 41), (1115, 217, 7, 21), (1115, 218, 3, 25), 
	(1115, 219, 2, 10), (1115, 220, 5, 17), (1115, 221, 8, 12), (1115, 222, 4, 14), 
	(1115, 223, 3, 18), (1115, 224, 6, 45), (1115, 225, 9, 22), (1115, 226, 5, 23), 
	(1115, 227, 4, 24), (1115, 228, 7, 24), (1115, 229, 1, 22), (1115, 230, 6, 23), 
	(1115, 231, 5, 14), (1115, 232, 8, 12), (1115, 233, 2, 11), (1115, 234, 7, 41),
	(1115, 235, 6, 7), (1115, 236, 9, 8), (1115, 237, 3, 9), (1115, 400, 8, 1), 
	(1115, 401, 7, 12), (1115, 402, 1, 14), (1115, 403, 4, 13), (1115, 404, 7, 12), 
	(1115, 405, 8, 4), (1115, 406, 2, 12), (1115, 407, 5, 8), (1115, 408, 9, 5), 
	(1115, 409, 9, 6), (1115, 410, 3, 4), (1115, 411, 6, 3), (1115, 412, 1, 4), 
	(1115, 413, 1, 8), (1115, 414, 4, 9), (1115, 415, 7, 10), (1115, 416, 2, 11),
	(1115, 417, 2, 12), (1115, 418, 5, 13), (1115, 419, 8, 14), (1115, 420, 3, 15), 
	(1115, 421, 3, 16), (1115, 422, 6, 12), (1115, 423, 9, 11), (1115, 424, 4, 7), 
	(1115, 425, 4, 5), (1115, 426, 7, 5),
	(2225, 100, 1, 12), (2225, 101, 1, 14), (2225, 102, 1, 12), (2225, 103, 1, 10), 
	(2225, 104, 2, 11), (2225, 105, 2, 4), (2225, 106, 2, 1), (2225, 107, 2, 25), 
	(2225, 108, 3, 30), (2225, 109, 3, 2), (2225, 110, 3, 12), (2225, 111, 3, 15), 
	(2225, 112, 4, 17), (2225, 113, 4, 48), (2225, 114, 4, 20), (2225, 115, 4, 21), 
	(2225, 116, 5, 23), (2225, 117, 5, 24), (2225, 118, 5, 20), (2225, 119, 5, 10),
	(2225, 120, 6, 12), (2225, 121, 6, 14), (2225, 122, 6, 15), (2225, 123, 6, 12), 
	(2225, 300, 7, 11), (2225, 301, 7, 13), (2225, 302, 7, 14), (2225, 303, 7, 12), 
	(2225, 304, 8, 13), (2225, 305, 8, 14), (2225, 306, 8, 15), (2225, 307, 8, 17),
	(2225, 308, 9, 12), (2225, 309, 9, 14), (2225, 310, 9, 14), (2225, 311, 9, 4),
	(2225, 312, 1, 5), (2225, 313, 1, 4), (2225, 314, 1, 6), (2225, 315, 1, 7),
	(2225, 316, 2, 8), (2225, 317, 2, 4), (2225, 318, 2, 7), (2225, 319, 2, 4),
	(2225, 320, 3, 7), (2225, 210, 3, 8), (2225, 211, 3, 9), (2225, 212, 3, 7),
	(2225, 213, 4, 12), (2225, 214, 4, 14), (2225, 215, 4, 15), (2225, 216, 4, 17), 
	(2225, 217, 5, 18), (2225, 218, 5, 16), (2225, 219, 5, 14), (2225, 220, 5, 12),
	(2225, 221, 6, 13), (2225, 222, 6, 14), (2225, 223, 6, 15), (2225, 224, 6, 16),
	(2225, 225, 7, 14), (2225, 226, 7, 14), (2225, 227, 7, 15), (2225, 228, 7, 6),
	(2225, 229, 8, 7), (2225, 230, 8, 7), (2225, 231, 8, 8), (2225, 232, 8, 9),
	(2225, 233, 9, 10), (2225, 234, 9, 11), (2225, 407, 9, 12), (2225, 408, 9, 13),
	(2225, 409, 1, 14), (2225, 410, 1, 15), (2225, 411, 1, 17), (2225, 412, 1, 15), 
	(2225, 413, 2, 4), (2225, 414, 2, 4), (2225, 415, 2, 5), (2225, 416, 2, 6),
	(3335, 110, 1, 7), (3335, 111, 1, 8), (3335, 112, 1, 9), (3335, 113, 1, 1), 
	(3335, 114, 2, 10), (3335, 115, 2, 11), (3335, 116, 2, 12), (3335, 117, 2, 13), 
	(3335, 118, 3, 14), (3335, 119, 3, 15), (3335, 120, 3, 16), (3335, 121, 3, 17), 
	(3335, 122, 4, 18), (3335, 123, 4, 19), (3335, 300, 4, 20), (3335, 301, 4, 1),
	(3335, 302, 5, 2), (3335, 303, 5, 3), (3335, 304, 5, 4), (3335, 305, 5, 5),
	(3335, 306, 6, 6), (3335, 307, 6, 7), (3335, 308, 6, 8), (3335, 309, 6, 9),
	(3335, 310, 7, 10), (3335, 311, 7, 11), (3335, 312, 7, 12), (3335, 313, 7, 13),
	(3335, 314, 8, 14), (3335, 315, 8, 15), (3335, 316, 8, 16), (3335, 317, 8, 17),
	(3335, 318, 9, 18), (3335, 319, 9, 19), (3335, 320, 9, 20), (3335, 210, 9, 21),
	(3335, 211, 1, 22), (3335, 212, 1, 23), (3335, 213, 1, 24), (3335, 214, 1, 25),
	(3335, 215, 2, 23), (3335, 216, 2, 1), (3335, 217, 2, 2), (3335, 218, 2, 3),
	(3335, 219, 3, 4), (3335, 220,3, 5), (3335, 221, 3, 6), (3335, 222, 3, 7), 
	(3335, 223, 4, 8), (3335, 224, 4, 9), (3335, 235, 4, 10), (3335, 236, 4, 11),
	(3335, 237, 5, 12), (3335, 400, 5, 13), (3335, 401, 5, 14), (3335, 402, 5, 15),
	(3335, 403, 6, 16), (3335, 404, 6, 17), (3335, 405, 6, 17), (3335, 406, 6, 12),
	(3335, 407, 7, 2), (3335, 408, 7, 3), (3335, 409, 7, 4), (3335, 410, 7, 5), 
	(3335, 411, 8, 6), (3335, 412, 8, 7), (3335, 413, 8, 8), (3335, 414, 8, 9), 
	(3335, 415, 9, 10), (3335, 416, 9, 11), (3335, 417, 9, 12), (3335, 418, 9, 13), 
	(3335, 419, 1, 14), (3335, 420, 1, 15), (3335, 421, 1, 16), (3335, 422, 1, 14), 
	(3335, 423, 2, 15), (3335, 424, 2, 16), (3335, 425, 2, 14), (3335, 427, 2, 11);
	
	
	--tipos de tarjetas
	INSERT INTO clientes.tipo_tarjeta (id_tipo, nombre, cantidad_adquisicion, puntos_descuento) VALUES 
(111, 'comun', 0, 5),(222, 'oro',10000, 10),(333, 'platino',20000,20),(444, 'diamante', 30000,30);

--INSERTANDO CAJEROS
INSERT INTO empleados.empleado (contrasenia, dpi, usuario, nombre, apellido, id_sucursal, tipo_empleado, numero_caja) VALUES
('$2y$10$j6hfk2KK5npZZ0xJ9bRgJulmFzNuV/IzhrZGKknLp7WYAl7fDu6Gm', '78984565', 'cajero1S1', 'Juan', 'Carlos',1111, 'cajero', 1),
('$2y$10$z/xMZF5cQNm2pC9wwKTCXerIAWQj60qcmZM1Cmtqw4tFqzbbCVkRa', '32251045', 'cajero2S1', 'Pedro', 'Sanchez',1111, 'cajero', 2),
('$2y$10$rE9alFNnqbKcqgOFrOw47.b4cqZIcBnTUf0yJcU8MirJFARrnmSmy', '36968574', 'cajero3S1', 'Guillermo', 'Ramos',1111, 'cajero', 3),
('$2y$10$0hNH3OgZ/DtH71YhG8WKPeEy/YLDDShwBz3Cv9tjFkGkxUJsq3ik.', '78124598', 'cajero4S1', 'Julian', 'Alvarez',1111, 'cajero', 4),
('$2y$10$lJ8XPcstEM83hCHA9uduguRR5kwze/BbQby4z1NU/wgTbuDlEZ2Uu', '20146358', 'cajero5S1', 'Jose', 'Ramon',1111, 'cajero', 5),
('$2y$10$j7tatziX3Ewer0KNEHc6guxjb5Hq5DGCataUBf5NXV5Z.Mo3Qqwci', '96321047', 'cajero6S1', 'Ana', 'Maria',1111, 'cajero', 6),
('$2y$10$AdS.dFHlnVW6wjQ/utV/xOnLp6dmR7wjtNkORFWt3FYcS21qI/00y', '23548936', 'cajero1S2', 'Adolfo', 'Casas',2222, 'cajero', 1),
('$2y$10$RMK1iMs.xTvk24WMmaVKQ.UzvUx1/Lx1r7Muw3n9JFlTM4vZVCLnq', '32251045', 'cajero2S2', 'Laura', 'Vega',2222, 'cajero', 2),
('$2y$10$GeF9gQshhEzhT8UDHaVtqeTBVux3oXuAS3vLpmNghkRiD8FiJmKMW', '52589663', 'cajero3S2', 'Gerardo', 'Rascon',2222, 'cajero', 3),
('$2y$10$Lszh9DnfoSCLgonzTcQKnuhXTK83k9DJPqp0HhvQ7VqEtOGiSP.2.', '96142565', 'cajero4S2', 'Jorge', 'Arbeloa',2222, 'cajero', 4),
('$2y$10$8l4t9YveAXzdz810qoUCQOfs0CDDGRBooW5NoBSlofmv8CD07l7wm', '01324574', 'cajero5S2', 'Samanta', 'Leon',2222, 'cajero', 5),
('$2y$10$lR5Ky9hc1hCJcrLYHhMaYuQOZj0AltcGyRrpDTfxhT4UPOnsN0WEq', '35789512', 'cajero6S2', 'Kevin', 'Thompson',2222, 'cajero', 6),
('$2y$10$fv7hw2A1XBvWBBbYP/CW6..nLf3WT3aGXty6GXZRwGPXBzeMyIbGK', '31649789', 'cajero1S3', 'Santiago', 'Rosas',3333, 'cajero', 1),
('$2y$10$YnHG5ewl40K6lcrM.8oxmuElWPWhIKK5NIcdAu8LrOkwdVmS5d2k2', '98731965', 'cajero2S3', 'Laura', 'Vega',3333, 'cajero', 2),
('$2y$10$hP.8W4waOCjh08WBp1jsguNl2uwA2or6poQLKaiP77xLEKoBrxvw2', '74962585', 'cajero3S3', 'Leonel', 'Messi',3333, 'cajero', 3),
('$2y$10$peT0.IkgzHAeerTAZc4fV.Oz8O2cZknxCOb.SJ.8LIiH27dZK3Kvi', '00112233', 'cajero4S3', 'Jonatan', 'Cabrera',3333, 'cajero', 4),
('$2y$10$.c.lZnzsQmNPpRCTdjup4u2qqyHVO0w6rfTe8HMpemtA.Ig59bDJy', '88997744', 'cajero5S3', 'Melisa', 'Roman',3333, 'cajero', 5),
('$2y$10$mrkibu.HDGmMJKUO5Nmdy.GjrEDw6RT2li.j09sWZsQn7xNcOHI6.', '44775588', 'cajero6S3', 'David', 'Pop',3333, 'cajero', 6);

--INSERTANDO USUARIO BODEGA E INVENTARIO
INSERT INTO empleados.empleado (contrasenia, dpi, usuario, nombre, apellido, id_sucursal, tipo_empleado) VALUES
('$2y$10$U8OoYwMH5ZFvv4iicDrB4Oyt9YhV5tZWgKtTQ2czg1cHcMJkUhxIy', '66332211', 'inventario1S1', 'John', 'Russel',1111, 'inventario'),
('$2y$10$2V5a9MFeg8rWXRY.8lc4nu4HaWxSMlJY8tujBDg2dDfoF.CwrNlRK', '30353631', 'inventario2S1', 'Steven', 'King',1111, 'inventario'),
('$2y$10$14M4m7rucCADWnVnjAr1S.h6mIcMX1x19I6llEM6tXRzc6N7WMu0i', '74757879', 'inventario3S1', 'Neena', 'Kochar',1111, 'inventario'),
('$2y$10$KTWYf8yzGAHiknH5bTVWCedCKmacSD/wWpvKyf0Syf71F01Mf37Cm', '87858986', 'inventario4S1', 'Lex', 'Han',1111, 'inventario'),
('$2y$10$K94EBlVL4zY4Lo3Eelwoze7Xt8fwTdyd9y8zm/GtEOLcjXNf98vbK', '63626564', 'bodega1S1', 'Alexander', 'Hunold',1111, 'bodega'),
('$2y$10$lwpCsHpYR2qY.RUBAdYK8.VE58mc1MOqytFAFBQpO4MuVzhxsmube', '12141512', 'inventario1S2', 'Bruce', 'Ernest',2222, 'inventario'),
('$2y$10$kxbhcGYa8fY.ZX/hLm/zkOtIPID5j9Io7LZRwInlIKgMyerljtMem', '54575859', 'inventario2S2', 'Vali', 'Pataballa',2222, 'inventario'),
('$2y$10$1fJEDDj.QGUuKSz2UZ3iD.JfkJllhZegUjU6MYt/SHvWNBaWi4To.', '21232022', 'inventario3S2', 'Diana', 'Lorentz',2222, 'inventario'),
('$2y$10$.plwPUjM2Yb0.8wXTmqhl.HaorCX162.sYngvq7qqzCFrmejVUC9W', '40424345', 'inventario4S2', 'Nancy', 'Gonzales',2222, 'inventario'),
('$2y$10$FWBHZIayA9u2Zn87FEt02O3BvGhEDDN.YSJm3B.Mybazzs/XfAYZq', '11223344', 'bodega1S2', 'Ismael', 'Sierra',2222, 'bodega'),
('$2y$10$HzXK2pIo52KIUndf6rKzhuM9VVPDHcb7v6o7joBF/eOv2vTUPScaa', '99887744', 'inventario1S3', 'Manuel', 'Urman',3333, 'inventario'),
('$2y$10$9iVpNgByEJkEfKfBw5frv.mJzv9XRCAb8TTOx2fjUN1o7iscAEruO', '88878985', 'inventario2S3', 'Sheli', 'Baida',3333, 'inventario'),
('$2y$10$HucQ9Fxx/uYECU/R7xyznuDl7h6dEotTFsKIwRc1IoOrihDsOnkXm', '77747578', 'inventario3S3', 'Sigal', 'Tobias',3333, 'inventario'),
('$2y$10$J.UXdnG.d.NSePMgHJMlAuqY.LaLAS3evxRTmnRkF4svgqJbEoNdS', '85555654', 'inventario4S3', 'Guy', 'Himuro',3333, 'inventario'),
('$2y$10$Y3pK5EgQ4SRtEoUFJTLp5.AreyUSH2zrdCnmmXpdqS7I1exnMudcm', '23353639', 'bodega1S3', 'Karen', 'Kolmenares',3333, 'bodega'),
('$2y$10$v2RtdPmIX66ZT2asVyvYd.nipFbDQ9TBzovyC7/Zv93Hve5riLLJm', '12543233', 'admin1S1', 'Adan', 'Fritz',1111, 'admin'),
('$2y$10$o/rT8XRMt8Trsq4TUUqNIe9KQ4IyKYHY08eQYLauUgpcTD9SV/HoW', '44414548', 'admin2S2', 'Shanta', 'Bolman',2222, 'admin'),
('$2y$10$yi.AYNub3p3fakuxiLcj/e7zZhD/ACwz5svNcIUqu7uuRoKkYaUjO', '32251095', 'admin3S3', 'Irene', 'Cifuentes',3333, 'admin');
	
	--insertando clientes 
	INSERT INTO clientes.cliente(nit, nombre, apellido, telefono,direccion, sucursal_registrada) VALUES
('cliente1-01', 'Maria', 'Palacios', 12451232, 'zona 1', 1111),
('cliente2-02', 'Pedro', 'Reyes', 21213225, 'zona 2', 2222),
('cliente3-03', 'Adriana', 'Calel', 20145232, 'zona 3', 3333),
('cliente4-04', 'Carlos', 'Alfredo', 33221111, 'zona 4', 1111),
('cliente5-05', 'Marina', 'Chaj', 74102130, 'zona 5', 1111),
('cliente6-06', 'Marta', 'Coyoy', 10010111, 'zona 6', 2222),
('cliente7-07', 'Luis', 'Barreno', 20203030, 'zona 7', 3333),
('cliente8-08', 'Alejandra', 'Gutierrez', 11112222, 'zona 8', 2222);

--insertando pedidos
INSERT INTO ventas.pedido(id_sucursal, nit_cliente, nombre_cliente, consumidor_final, total, estado, fecha_pedido) VALUES
(1111, 'cliente1-01', 'Maria', false, 799.98, true, '2024-01-12'),
(1111, 'cliente1-01', 'Maria', false,648, true, '2024-02-12'),
(1111, 'cliente2-02', 'Pedro', false, 20249.99, true, '2024-03-12'),
(1111, 'cliente2-02', 'Pedro', false, 9999, true, '2024-04-12'),
(1111, 'cliente3-03', 'Adriana', false, 4990.9, true, '2024-05-12'),
(2222, 'cliente3-03', 'Adriana', false, 500, true, '2024-06-12'),
(2222, 'cliente4-04', 'Carlos', false, 500, true, '2024-07-12'),
(2222, 'cliente4-04', 'Carlos', false, 19999.99, true, '2024-08-12'),
(2222, 'cliente5-05', 'Marina', false, 19999.99, true, '2024-08-12'),
(2222, 'cliente5-05', 'Marina', false, 9999, true, '2024-09-12'),
(3333, 'cliente6-06', 'Marta', false, 4990.99, true, '2024-10-12'),
(3333, 'cliente6-06', 'Marta', false, 500, true, '2024-11-12'),
(3333, 'cliente6-06', 'Marta', false, 19999.99, true, '2024-01-15'),
(3333, 'cliente7-07', 'Luis', false, 799.99, true, '2024-02-16'),
(3333, 'cliente7-07', 'Luis', false, 648, true, '2024-04-18'); 

--insertando detalles
INSERT INTO ventas.detalle_pedido(id_pedido, codigo_producto, costo_u, cantidad, costo_total) VALUES
(1, 110, 149.99,1, 149.99),
(1,111, 649.99, 1, 649.99),
(2, 112, 148, 1, 148),
(2, 100, 500, 1, 500),
(3, 101, 250, 1, 250),
(3, 315, 19999.99, 1, 19999.99),
(4, 316, 9999, 1, 9999),
(5, 317, 4990.99, 1, 4990.9),
(6, 100, 500, 1, 500),
(7, 100, 500, 1, 500),
(8, 315, 19999.99, 1, 19999.99),
(9, 315, 19999.99, 1, 19999.99),
(10, 316, 9999, 1, 9999),
(11, 317, 4990.99, 1, 4990.9),
(12, 100, 500, 1, 500),
(13, 315, 19999.99, 1, 19999.99),
(14, 110, 149.99,1, 149.99),
(14,111, 649.99, 1, 649.99),
(15, 112, 148, 1, 148),
(15, 100, 500, 1, 500);

--insertando ventas
INSERT INTO ventas.venta (id_empleado, id_pedido, total, total_descuento, fecha_venta) VALUES
(1, 1, 799.98, 799.98, 0, '2024-01-12'),
(2,2,648,648, 0, '2024-02-12'),
(3, 3, 20249.99, 20249.99, 0, '2024-03-12'),
(4, 4,9999, 9999, 0, '2024-04-12'),
(5,5,  4990.99, 4990.99, 0, '2024-05-12'),
(7,6, 500, 500, 0, '2024-06-12'),
(8, 7, 500, 500, 0, '2024-07-12'),
(9, 8,  19999.99, 19999.99, 0, '2024-08-12'),
(10,9, 19999.99, 19999.99, 0, '2024-08-12'),
(11,10, 9999, 9999, 0, '2024-09-12'),
(13,11,  4990.99, 4990.99, 0, '2024-10-12'),
(14,12, 500, 500, 0, '2024-11-12'),
(15,13,  19999.99, 19999.99, 0, '2024-01-15'),
(16,14, 799.99, 799.99, 0, '2024-02-16'),
(17,15, 648, 648, 0, '2024-04-18');

--insertando detalles ventas
INSERT INTO ventas.detalle_venta(numero_factura, codigo_producto, costo_u, cantidad, costo_total) VALUES
(1, 110, 149.99,1, 149.99),
(1,111, 649.99, 1, 649.99),
(2, 112, 148, 1, 148),
(2, 100, 500, 1, 500),
(3, 101, 250, 1, 250),
(3, 315, 19999.99, 1, 19999.99),
(4, 316, 9999, 1, 9999),
(5, 317, 4990.99, 1, 4990.9),
(6, 100, 500, 1, 500),
(7, 100, 500, 1, 500),
(8, 315, 19999.99, 1, 19999.99),
(9, 315, 19999.99, 1, 19999.99),
(10, 316, 9999, 1, 9999),
(11, 317, 4990.99, 1, 4990.9),
(12, 100, 500, 1, 500),
(13, 315, 19999.99, 1, 19999.99),
(14, 110, 149.99,1, 149.99),
(14,111, 649.99, 1, 649.99),
(15, 112, 148, 1, 148),
(15, 100, 500, 1, 500);


	--CREANDO UN USUARIO CLIENTE
	CREATE ROLE acceso_cliente WITH
	LOGIN
	NOSUPERUSER
	NOCREATEDB
	NOCREATEROLE
	INHERIT
	NOREPLICATION
	NOBYPASSRLS
	CONNECTION LIMIT -1
	PASSWORD 'cliente';
	
	--USOS PARA EL CLIENTE
	GRANT USAGE ON SCHEMA sucursales TO acceso_cliente;
	GRANT SELECT ON TABLE sucursales.sucursal TO acceso_cliente;
	GRANT USAGE ON SCHEMA productos TO acceso_cliente;
	GRANT SELECT, TRIGGER ON TABLE productos.producto TO acceso_cliente;
	GRANT SELECT, TRIGGER ON TABLE sucursales.inventario_estanteria TO acceso_cliente;
	GRANT SELECT, TRIGGER ON TABLE sucursales.estanteria TO acceso_cliente;
	GRANT USAGE ON SCHEMA ventas TO acceso_cliente;
	GRANT SELECT, INSERT, UPDATE, TRIGGER, REFERENCES ON TABLE ventas.pedido TO acceso_cliente;
	GRANT USAGE ON SCHEMA clientes TO acceso_cliente;
	GRANT INSERT, SELECT, UPDATE, REFERENCES, TRIGGER ON TABLE clientes.cliente TO acceso_cliente;
	GRANT ALL ON SEQUENCE ventas.pedido_id_pedido_seq TO acceso_cliente;
	GRANT INSERT, SELECT, UPDATE, REFERENCES, TRIGGER ON TABLE ventas.detalle_pedido TO acceso_cliente;
	GRANT ALL ON SEQUENCE ventas.detalle_pedido_id_detalle_p_seq TO acceso_cliente;
	
	GRANT SELECT, TRIGGER, REFERENCES ON TABLE clientes.tipo_tarjeta TO acceso_cliente;
	GRANT INSERT, SELECT, TRIGGER, REFERENCES ON TABLE clientes.solicitud_tarjeta TO acceso_cliente;
	GRANT ALL ON SEQUENCE clientes.solicitud_tarjeta_id_solicitud_seq TO acceso_cliente;
	
	
	-CREANDO ROL PARA CAJERO 
	CREATE ROLE acceso_cajero WITH
	LOGIN
	NOSUPERUSER
	NOCREATEDB
	NOCREATEROLE
	INHERIT
	NOREPLICATION
	NOBYPASSRLS
	CONNECTION LIMIT -1
	PASSWORD 'cajero';
	
	GRANT USAGE ON SCHEMA ventas TO acceso_cajero;
	GRANT SELECT, UPDATE, REFERENCES, TRIGGER ON TABLE ventas.pedido TO acceso_cajero;
	GRANT USAGE ON SCHEMA productos TO acceso_cajero;
	GRANT SELECT, TRIGGER, REFERENCES ON TABLE ventas.detalle_pedido TO acceso_cajero;
	GRANT SELECT, TRIGGER, REFERENCES ON TABLE productos.producto TO acceso_cajero;
	GRANT USAGE ON SCHEMA clientes TO acceso_cajero;
	
	GRANT ALL ON TABLE ventas.venta TO acceso_cajero;
GRANT ALL ON TABLE ventas.detalle_venta TO acceso_cajero;
GRANT USAGE ON SCHEMA sucursales TO acceso_cajero;
GRANT SELECT, TRIGGER, REFERENCES ON TABLE sucursales.estanteria TO acceso_cajero;
GRANT REFERENCES, TRIGGER, SELECT, UPDATE ON TABLE sucursales.inventario_estanteria TO acceso_cajero;
GRANT SELECT, REFERENCES, TRIGGER ON TABLE clientes.cliente TO acceso_cajero;
GRANT SELECT, REFERENCES, TRIGGER ON TABLE clientes.tipo_tarjeta TO acceso_cajero;
GRANT SELECT, UPDATE, REFERENCES, TRIGGER ON TABLE clientes.tarjeta_descuento TO acceso_cajero;
GRANT ALL ON SEQUENCE ventas.venta_numero_factura_seq TO acceso_cajero;
GRANT ALL ON SEQUENCE ventas.detalle_venta_id_detalle_v_seq TO acceso_cajero;

	
	-- ROL ACCESO BODEGA
CREATE ROLE acceso_bodega WITH
	LOGIN
	NOSUPERUSER
	NOCREATEDB
	NOCREATEROLE
	INHERIT
	NOREPLICATION
	NOBYPASSRLS
	CONNECTION LIMIT -1
	PASSWORD 'bodega';

GRANT USAGE ON SCHEMA productos TO acceso_bodega;
GRANT INSERT, SELECT, UPDATE, REFERENCES, TRIGGER ON TABLE productos.producto TO acceso_bodega;
GRANT USAGE ON SCHEMA sucursales TO acceso_bodega;
GRANT SELECT, REFERENCES, TRIGGER ON TABLE sucursales.sucursal TO acceso_bodega;
GRANT ALL ON TABLE sucursales.bodega TO acceso_bodega;
GRANT ALL ON TABLE sucursales.inventario_bodega TO acceso_bodega;	
GRANT ALL ON TABLE sucursales.producto_sucursal TO acceso_bodega;
GRANT ALL ON SEQUENCE sucursales.producto_sucursal_id_producto_s_seq TO acceso_bodega;
GRANT ALL ON SEQUENCE sucursales.inventario_bodega_id_inventario_bodega_seq TO acceso_bodega;
	
	
	-- ROL PARA INVENTARIO
	CREATE ROLE acceso_inventario WITH
	LOGIN
	NOSUPERUSER
	NOCREATEDB
	NOCREATEROLE
	INHERIT
	NOREPLICATION
	NOBYPASSRLS
	CONNECTION LIMIT -1
	PASSWORD 'inventario';
	
	GRANT USAGE ON SCHEMA productos TO acceso_inventario;
	GRANT SELECT, TRUNCATE, REFERENCES, TRIGGER ON TABLE productos.producto TO acceso_inventario;
	GRANT USAGE ON SCHEMA sucursales TO acceso_inventario;
	GRANT ALL ON TABLE sucursales.inventario_estanteria TO acceso_inventario;
	GRANT ALL ON TABLE sucursales.estanteria TO acceso_inventario;
	GRANT SELECT, UPDATE, REFERENCES, TRIGGER ON TABLE sucursales.inventario_bodega TO acceso_inventario;
	GRANT SELECT, REFERENCES, TRIGGER ON TABLE sucursales.bodega TO acceso_inventario;
	GRANT ALL ON SEQUENCE sucursales.inventario_estanteria_id_inventario_estanteria_seq TO acceso_inventario;
	
	CREATE OR REPLACE FUNCTION ventas.registrar_pedido(
    p_id_sucursal INTEGER,
    p_nit_cliente VARCHAR,
    p_nombre_cliente VARCHAR,
    p_consumidor_final BOOLEAN,
    p_apellido_cliente VARCHAR
) RETURNS INTEGER AS $$
DECLARE
    v_id_pedido INTEGER;
BEGIN
    IF p_consumidor_final THEN
        -- Insertar pedido sin NIT
        INSERT INTO ventas.pedido (id_sucursal, nombre_cliente, consumidor_final, fecha_pedido)
        VALUES (p_id_sucursal, p_nombre_cliente, p_consumidor_final, CURRENT_DATE)
        RETURNING id_pedido INTO v_id_pedido;
    ELSE
        IF NOT EXISTS (
            SELECT 1 FROM clientes.cliente WHERE nit = p_nit_cliente
        ) THEN
		
            INSERT INTO clientes.cliente (nit, nombre, apellido, sucursal_registrada)
            VALUES (p_nit_cliente, p_nombre_cliente, p_apellido_cliente, p_id_sucursal);
        END IF;

        INSERT INTO ventas.pedido (id_sucursal, nit_cliente, nombre_cliente, consumidor_final, fecha_pedido)
        VALUES (p_id_sucursal, p_nit_cliente, p_nombre_cliente, p_consumidor_final, CURRENT_DATE)
        RETURNING id_pedido INTO v_id_pedido;
    END IF;

    RETURN v_id_pedido;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION ventas.registrar_detalle_pedido(
    id_pedido_input INTEGER, 
    productos jsonb  
) RETURNS VOID AS $$
DECLARE
    producto jsonb;
    codigo_producto INTEGER;
    cantidad INTEGER;
    costo_unitario NUMERIC(10, 2);
    costo_total NUMERIC(10, 2);
    total_pedido NUMERIC(10, 2) := 0;
BEGIN
    
    FOR producto IN SELECT * FROM jsonb_array_elements(productos)
    LOOP
        
        codigo_producto := (producto->>'id_producto')::INTEGER;
        cantidad := (producto->>'cantidad')::INTEGER;
        costo_unitario := (producto->>'precio')::NUMERIC;
        costo_total := costo_unitario * cantidad;
        
        INSERT INTO ventas.detalle_pedido(id_pedido, codigo_producto, costo_u, cantidad, costo_total)
        VALUES (id_pedido_input, codigo_producto, costo_unitario, cantidad, costo_total);
        
        total_pedido := total_pedido + costo_total;
    END LOOP;
    
    -- Actualizar el total del pedido en la tabla de pedidos
    UPDATE ventas.pedido
    SET total = total_pedido
    WHERE id_pedido = id_pedido_input;
END;
$$ LANGUAGE plpgsql;


CREATE VIEW clientes.vista_tarjeta_cliente AS
SELECT 
    COALESCE(SUM(v.total), 0) AS total_ventas,  
    tt.nombre AS tipo_tarjeta,
    td.puntos AS puntos_tarjeta,
    cl.nit
FROM clientes.cliente cl
LEFT JOIN ventas.pedido pe ON pe.nit_cliente = cl.nit
LEFT JOIN ventas.venta v ON v.id_pedido = pe.id_pedido
LEFT JOIN clientes.tarjeta_descuento td ON td.id_tarjeta = cl.tarjeta_descuento
LEFT JOIN clientes.tipo_tarjeta tt ON tt.id_tipo = td.tipo_tarjeta
GROUP BY cl.nit, tt.nombre, td.puntos;

GRANT SELECT, REFERENCES, TRIGGER ON TABLE clientes.vista_tarjeta_cliente TO acceso_cliente;
GRANT TRIGGER, REFERENCES, SELECT ON TABLE clientes.vista_tarjeta_cliente TO acceso_cajero;


CREATE OR REPLACE FUNCTION ventas.registrar_venta(
    p_id_empleado INTEGER,
    p_id_pedido INTEGER
) RETURNS INTEGER AS $$
DECLARE
    v_id_factura INTEGER;
BEGIN

        INSERT INTO ventas.venta (id_empleado, id_pedido, fecha_venta)
        VALUES (p_id_empleado, p_id_pedido, CURRENT_DATE)
        RETURNING numero_factura INTO v_id_factura;
		
		UPDATE ventas.pedido 
		SET estado = TRUE 
		WHERE id_pedido = p_id_pedido;

    RETURN v_id_factura;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION ventas.registrar_detalle_venta(
    id_factura_input INTEGER, 
    productos jsonb,
    id_sucursal_input INTEGER,
    descuento_input INTEGER,
    p_nit_cliente VARCHAR,
    p_consumidor_final BOOLEAN
) RETURNS VOID AS $$
DECLARE
    producto jsonb;
    codigo_producto_in INTEGER;
    cantidad INTEGER;
    costo_unitario NUMERIC(10, 2);
    costo_total NUMERIC(10, 2);
    total_venta NUMERIC(10, 2) := 0;
    id_estanteria_v INTEGER;
    puntos_descuento INTEGER;
    puntosG INTEGER;
    tarjeta_id INTEGER;
    puntos_actuales INTEGER;
BEGIN
    
    -- Registrar los productos en el detalle de venta
    FOR producto IN SELECT * FROM jsonb_array_elements(productos)
    LOOP
        codigo_producto_in := (producto->>'id_producto')::INTEGER;
        cantidad := (producto->>'cantidad')::INTEGER;
        costo_unitario := (producto->>'precio')::NUMERIC;
        costo_total := costo_unitario * cantidad;
        
        INSERT INTO ventas.detalle_venta(numero_factura, codigo_producto, cantidad, costo_u, costo_total)
        VALUES (id_factura_input, codigo_producto_in, cantidad, costo_unitario, costo_total);
        
        -- Actualizar la cantidad disponible en la estantería
        UPDATE sucursales.inventario_estanteria ie
        SET cantidad_disponible = ie.cantidad_disponible - cantidad
        FROM sucursales.estanteria e
        WHERE ie.id_estanteria = e.id_estanteria
        AND e.id_sucursal = id_sucursal_input
        AND ie.codigo_producto = codigo_producto_in;
        
        total_venta := total_venta + costo_total;
    END LOOP;

    -- Actualizar el total, total_descuento y descuento en la tabla venta
    UPDATE ventas.venta
    SET total = total_venta,
        total_descuento = total_venta - descuento_input,
        descuento = descuento_input
    WHERE numero_factura = id_factura_input;

    -- Si el cliente no es consumidor final, actualizamos la tarjeta de descuento
    IF NOT p_consumidor_final THEN
        -- Verificar si el cliente tiene una tarjeta de descuento
        SELECT tarjeta_descuento INTO tarjeta_id 
        FROM clientes.cliente 
        WHERE nit = p_nit_cliente;

        IF tarjeta_id IS NOT NULL THEN
            -- Obtener los puntos de descuento del tipo de tarjeta
            SELECT tt.puntos_descuento 
            INTO puntos_descuento
            FROM clientes.tipo_tarjeta tt
            JOIN clientes.tarjeta_descuento td ON td.tipo_tarjeta = tt.id_tipo
            WHERE td.id_tarjeta = tarjeta_id;

            -- Calcular los puntos ganados
            puntosG := FLOOR((total_venta / 200) * puntos_descuento);

            -- Obtener los puntos actuales de la tarjeta
            SELECT puntos INTO puntos_actuales 
            FROM clientes.tarjeta_descuento 
            WHERE id_tarjeta = tarjeta_id;

            -- Actualizar los puntos en la tarjeta de descuento
            UPDATE clientes.tarjeta_descuento
            SET puntos = puntos_actuales + puntosG - descuento_input
            WHERE id_tarjeta = tarjeta_id;
        END IF;
    END IF;

END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sucursales.actualizar_existencia_bodega(
    p_id_sucursal INTEGER, 
    p_codigo_producto INTEGER, 
    p_cantidad_adicional INTEGER
) RETURNS VOID AS $$
DECLARE
    v_id_bodega INTEGER;
BEGIN
    -- Obtener el id de la bodega asociada a la sucursal
    SELECT id_bodega INTO v_id_bodega
    FROM sucursales.bodega
    WHERE id_sucursal = p_id_sucursal;
    
    -- Actualizar la cantidad disponible sumando la cantidad adicional
    UPDATE sucursales.inventario_bodega
    SET cantidad_disponible = cantidad_disponible + p_cantidad_adicional
    WHERE id_bodega = v_id_bodega
    AND codigo_producto = p_codigo_producto;
    
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sucursales.agregar_producto_a_bodega(
    p_codigo_producto INTEGER, 
    p_nombre VARCHAR, 
    p_descripcion TEXT, 
    p_precio NUMERIC(10, 2), 
    p_id_sucursal INTEGER, 
    p_cantidad INTEGER
) RETURNS VOID AS $$
DECLARE
    v_id_bodega INTEGER;
BEGIN
    -- Insertar el producto en la tabla productos.producto
    INSERT INTO productos.producto (codigo, nombre, descripcion, precio)
    VALUES (p_codigo_producto, p_nombre, p_descripcion, p_precio)
    ON CONFLICT (codigo) DO NOTHING;

    -- Insertar la relación entre el producto y la sucursal en producto_sucursal
    INSERT INTO sucursales.producto_sucursal (codigo_producto, id_sucursal)
    VALUES (p_codigo_producto, p_id_sucursal);

    --  Obtener el id de la bodega asociada a la sucursal
    SELECT id_bodega INTO v_id_bodega
    FROM sucursales.bodega
    WHERE id_sucursal = p_id_sucursal;

    -- Insertar el producto en el inventario de la bodega
    INSERT INTO sucursales.inventario_bodega (id_bodega, codigo_producto, cantidad_disponible)
    VALUES (v_id_bodega, p_codigo_producto, p_cantidad);

END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION sucursales.actualizar_inventario_estanteria(
    p_id_sucursal INTEGER,
    p_codigo_producto INTEGER,
    p_cantidad_a_trasladar INTEGER
) RETURNS VOID AS $$
DECLARE
    v_id_estanteria INTEGER;
    v_id_bodega INTEGER;
    v_cantidad_bodega INTEGER;
    v_existente_en_estanteria INTEGER;
BEGIN
    -- Obtener el id_estanteria de la sucursal
    SELECT id_estanteria INTO v_id_estanteria
    FROM sucursales.estanteria
    WHERE id_sucursal = p_id_sucursal;

    -- Verificar si el producto ya está en la estantería
    SELECT cantidad_disponible INTO v_existente_en_estanteria
    FROM sucursales.inventario_estanteria
    WHERE id_estanteria = v_id_estanteria
    AND codigo_producto = p_codigo_producto;

    IF FOUND THEN
        -- Si el producto ya está en la estantería, sumar la cantidad
        UPDATE sucursales.inventario_estanteria
        SET cantidad_disponible = cantidad_disponible + p_cantidad_a_trasladar
        WHERE id_estanteria = v_id_estanteria
        AND codigo_producto = p_codigo_producto;
    ELSE
        -- Si el producto no está, insertar un nuevo registro en la estantería
        INSERT INTO sucursales.inventario_estanteria (id_estanteria, codigo_producto, pasillo, cantidad_disponible)
        VALUES (v_id_estanteria, p_codigo_producto, 1, p_cantidad_a_trasladar);
    END IF;

    -- Obtener el id_bodega correspondiente a la sucursal
    SELECT id_bodega INTO v_id_bodega
    FROM sucursales.bodega
    WHERE id_sucursal = p_id_sucursal;

    -- Obtener la cantidad disponible en bodega del producto
    SELECT cantidad_disponible INTO v_cantidad_bodega
    FROM sucursales.inventario_bodega
    WHERE id_bodega = v_id_bodega
    AND codigo_producto = p_codigo_producto;

    IF v_cantidad_bodega >= p_cantidad_a_trasladar THEN
        -- Restar la cantidad trasladada en la bodega
        UPDATE sucursales.inventario_bodega
        SET cantidad_disponible = cantidad_disponible - p_cantidad_a_trasladar
        WHERE id_bodega = v_id_bodega
        AND codigo_producto = p_codigo_producto;
    ELSE
        -- Si no hay suficientes productos en la bodega, lanzar un error
        RAISE EXCEPTION 'No hay suficiente cantidad en bodega para realizar el traslado.';
    END IF;
    
END;
$$ LANGUAGE plpgsql;

--VISTAS REPÓRTES

CREATE VIEW ventas.historial_descuentos AS
SELECT 
    v.numero_factura,
    v.id_empleado,
    e.nombre AS nombre_empleado,
    cl.nit,
    p.nombre_cliente AS nombre_cliente,
    v.descuento,
    v.fecha_venta
FROM 
    ventas.venta v
INNER JOIN 
    empleados.empleado e ON v.id_empleado = e.id_empleado
INNER JOIN 
    ventas.pedido p ON v.id_pedido = p.id_pedido
INNER JOIN 
    clientes.cliente cl ON p.nit_cliente = cl.nit;



CREATE VIEW ventas.top_ventas AS
SELECT 
    v.numero_factura,
    v.id_empleado,
    e.nombre AS nombre_empleado,
    cl.nit,
    p.nombre_cliente AS nombre_cliente,
    v.total,
    v.fecha_venta
FROM 
    ventas.venta v
LEFT JOIN 
    empleados.empleado e ON v.id_empleado = e.id_empleado
LEFT JOIN 
    ventas.pedido p ON v.id_pedido = p.id_pedido
LEFT JOIN 
    clientes.cliente cl ON p.nit_cliente = cl.nit;
	

CREATE VIEW ventas.top_ingresos_sucursales AS
SELECT 
    e.id_sucursal,
    s.nombre AS nombre_sucursal,
    SUM(v.total) AS total_ingresos
FROM 
    ventas.venta v
INNER JOIN 
    empleados.empleado e ON v.id_empleado = e.id_empleado
INNER JOIN 
    sucursales.sucursal s ON e.id_sucursal = s.id_sucursal
GROUP BY 
    e.id_sucursal, s.nombre
ORDER BY 
    total_ingresos DESC;


CREATE VIEW ventas.top_articulos_mas_vendidos AS
SELECT 
    d.codigo_producto,
    p.nombre AS nombre_producto,
    SUM(d.cantidad) AS total_vendidos
FROM 
    ventas.detalle_venta d
INNER JOIN 
    productos.producto p ON d.codigo_producto = p.codigo
GROUP BY 
    d.codigo_producto, p.nombre
ORDER BY 
    total_vendidos DESC;
	
	
CREATE VIEW ventas.top_clientes_mas_dinero_gastado AS
SELECT 
    cl.nit,
    cl.nombre,
    COALESCE(SUM(v.total), 0) AS total_gastado
FROM 
    clientes.cliente cl
LEFT JOIN 
    ventas.pedido pe ON pe.nit_cliente = cl.nit
LEFT JOIN 
    ventas.venta v ON v.id_pedido = pe.id_pedido
GROUP BY 
    cl.nit, cl.nombre
ORDER BY 
    total_gastado DESC;
	
	
	
CREATE VIEW clientes.vista_solicitudes_tarjetas AS
SELECT 
    s.id_solicitud, 
    s.id_tipo_tarjeta,
    s.nit_cliente, 
    c.nombre AS nombre_cliente, 
    t.nombre AS nombre_tarjeta
FROM 
    clientes.solicitud_tarjeta s
INNER JOIN 
    clientes.cliente c ON c.nit = s.nit_cliente
INNER JOIN 
    clientes.tipo_tarjeta t ON t.id_tipo = s.id_tipo_tarjeta
WHERE 
    s.estado = false;
	
	
CREATE OR REPLACE FUNCTION clientes.aceptar_solicitud_tarjeta(
    p_id_solicitud INTEGER,
    p_id_tipo_tarjeta INTEGER,
    p_nit_cliente VARCHAR
)
RETURNS VOID AS
$$
DECLARE
    v_id_tarjeta INTEGER;
BEGIN
    -- Verificar si el cliente ya tiene una tarjeta de descuento asignada
    SELECT tarjeta_descuento 
    INTO v_id_tarjeta 
    FROM clientes.cliente 
    WHERE nit = p_nit_cliente;

    -- Si el cliente no tiene tarjeta, insertamos una nueva
    IF v_id_tarjeta IS NULL THEN
        INSERT INTO clientes.tarjeta_descuento (puntos, tipo_tarjeta)
        VALUES (0, p_id_tipo_tarjeta)
        RETURNING id_tarjeta INTO v_id_tarjeta;
        
        -- Asignar la nueva tarjeta al cliente
        UPDATE clientes.cliente
        SET tarjeta_descuento = v_id_tarjeta
        WHERE nit = p_nit_cliente;
        
    -- Si ya tiene tarjeta, actualizamos el tipo de tarjeta
    ELSE
        UPDATE clientes.tarjeta_descuento
        SET tipo_tarjeta = p_id_tipo_tarjeta
        WHERE id_tarjeta = v_id_tarjeta;
    END IF;

    -- Cambiar el estado de la solicitud a true
    UPDATE clientes.solicitud_tarjeta
    SET estado = TRUE
    WHERE id_solicitud = p_id_solicitud;

END;
$$
LANGUAGE plpgsql;
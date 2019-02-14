CREATE DATABASE DBInventario2017065NOFICIAL;
GO
USE DBInventario2017065NOFICIAL;
GO

CREATE TABLE Ubicaciones
(
	Ubicacion  INT NOT NULL IDENTITY(1,1) PRIMARY KEY, 
	Descripcion VARCHAR(80),
	Direccion VARCHAR(100)
);
GO

CREATE TABLE TipoProducto
(
	CodigoTipoProducto INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Descripcion VARCHAR(80),
	FechaCreacion DATETIME,
	FechaModificacion DATETIME
);
GO

CREATE TABLE Proveedores
(
	CodigoProveedor INT NOT NULL IDENTITY (1,1) PRIMARY KEY,
	RazonSocial VARCHAR(100),
	NIT VARCHAR(20),
	DireccionProveedor VARCHAR(100),
	PaginaWeb VARCHAR(50),
);
GO

CREATE TABLE TelefonoProveedor
(
	CodigoTelefonoProveedor INT NOT NULL IDENTITY (1,1) PRIMARY KEY,
	Numero VARCHAR(20),
	Descripcion VARCHAR(80),
	CodigoProveedor INT,
	FOREIGN KEY(CodigoProveedor)REFERENCES Proveedores(CodigoProveedor)
);
GO

CREATE TABLE Productos
(
	CodigoProducto INT IDENTITY(1,1)NOT NULL PRIMARY KEY,
	NombreProducto VARCHAR(80),
	FechaCreacion DATETIME,
	FechaModificacion DATETIME,
	CodigoTipoProducto INT,
	CodigoProveedor INT,
	FOREIGN KEY (CodigoTipoProducto)REFERENCES TipoProducto(CodigoTipoProducto),
	FOREIGN KEY (CodigoProveedor)REFERENCES Proveedores(CodigoProveedor)
);

GO
CREATE TABLE DETUbicacionesMes
(
	Año INT ,
	Mes INT ,
	Ubicacion INT  NOT NULL,
	CodigoProducto INT NOT NULL,
	Entrada DECIMAL(11,4),
	Salida DECIMAL(11,4),
	CostoEntrada DECIMAL(11,4),
	CostoSalida DECIMAL(11,4),
	Saldo DECIMAL (11,4),
	UltimoCosto DECIMAL(11,4),
	VentaTotal DECIMAL(11,4),
	IVA DECIMAL(11,4),
	PRIMARY KEY(Año,Mes,Ubicacion,CodigoProducto),
	FOREIGN KEY(CodigoProducto)REFERENCES Productos(CodigoProducto),
	FOREIGN KEY(Ubicacion)REFERENCES Ubicaciones(Ubicacion)
);
GO
CREATE TABLE DETUbicaciones
(
	Ubicacion  INT,
	CodigoProducto INT,
	Existencia INT,
	PrecioCosto DECIMAL(11,4),
	PrecioVenta DECIMAL(11,4),
	ProductoIva DECIMAL(11,4),
	FechaCreacion DATETIME,
	FechaModificacion DATETIME,
	PRIMARY KEY(Ubicacion,CodigoProducto),
	FOREIGN KEY(Ubicacion)REFERENCES Ubicaciones(Ubicacion),
	FOREIGN KEY(CodigoProducto)REFERENCES Productos(CodigoProducto)
);
GO
CREATE TABLE Compras
(
	FacturaCompra INT NOT NULL IDENTITY (1,1) PRIMARY KEY,
	CodigoProveedor INT,
	Descripcion VARCHAR(80),
	FechaCompra DATETIME,
	Ubicacion INT,
	FOREIGN KEY(CodigoProveedor)REFERENCES Proveedores(CodigoProveedor),
	FOREIGN KEY(Ubicacion)REFERENCES Ubicaciones(Ubicacion)
);
GO

CREATE TABLE DETCompras
(
	FacturaCompra INT,
	Linea INT,
	PrecioCompra DECIMAL(11,4),
	Cantidad INT,
	CodigoProducto INT,
	Ubicacion INT,
	PrecioIva DECIMAL(11,4),
	PrecioCosto DECIMAL(11,4),
	PRIMARY KEY(FacturaCompra,Linea),
	FOREIGN KEY(FacturaCompra)REFERENCES Compras(FacturaCompra),
	FOREIGN KEY(CodigoProducto)REFERENCES Productos(CodigoProducto),
	FOREIGN KEY(Ubicacion)REFERENCES Ubicaciones(Ubicacion)
);
GO
CREATE TABLE Clientes
(
	CodigoCliente INT NOT NULL IDENTITY (1,1) PRIMARY KEY,
	NombreCliente VARCHAR(80),
	ApellidoCliente VARCHAR(80),
	DireccionCliente VARCHAR(100),
	NitCliente VARCHAR(20),
	FechaCreacion DATETIME,
	FechaModificacion DATETIME
);
GO
CREATE TABLE TelefonoClientes
(
	CodigoTelefonoCliente INT NOT NULL IDENTITY (1,1) PRIMARY KEY,
	Telefono VARCHAR(20),
	Descripcion VARCHAR(80),
	CodigoCliente INT,
	FOREIGN KEY(CodigoCliente)REFERENCES Clientes(CodigoCliente)
);
GO
CREATE TABLE EmailClientes
(
	CodigoEmailCliente INT NOT NULL IDENTITY (1,1) PRIMARY KEY ,
	Email VARCHAR(50),
	Descripcion VARCHAR(80),
	CodigoCliente int,
	FOREIGN KEY(CodigoCliente)REFERENCES Clientes(CodigoCliente)
);
CREATE TABLE Facturas
(
	CodigoFactura INT NOT NULL IDENTITY (1,1) PRIMARY KEY,
	NumeroFactura INT,
	FechaVenta DATETIME,
	NitCliente VARCHAR(20),
	TotalVenta DECIMAL(11,4),
	CodigoCliente INT,
	Ubicacion INT,
	FOREIGN KEY(Ubicacion)REFERENCES Ubicaciones(Ubicacion),
	FOREIGN KEY(CodigoCliente)REFERENCES Clientes(CodigoCliente),
);
GO
CREATE TABLE DETFacturas
(
	CodigoFactura INT NOT NULL,
	Linea INT,
	Cantidad INT,
	PrecioVenta DECIMAL(11,4),
	CostoUnitario DECIMAL(11,4),
	Ubicacion INT,
	CodigoProducto INT,
	IVA DECIMAL(11,3),
	PRIMARY KEY(CodigoFactura,Linea),
	FOREIGN KEY(CodigoFactura)REFERENCES Facturas(CodigoFactura),
	FOREIGN KEY(Ubicacion)REFERENCES ubicaciones(Ubicacion)
);


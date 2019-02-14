---------Cristian Fernando Hernandez Tello 
---------IN5BM
---------Carne:2017065
CREATE DATABASE DBInventario20170651;
GO
USE DBInventario20170651;
GO

CREATE TABLE Ubicaciones
(
	Ubicacion  INT IDENTITY PRIMARY KEY, 
	Descripcion VARCHAR(80),
	Direccion VARCHAR(100)
);
GO

CREATE TABLE TipoProducto
(
	CodigoTipoProducto INT IDENTITY PRIMARY KEY,
	Descripcion VARCHAR(80),
	FechaCreacion DATE,
	FechaModificacion DATE
);
GO

CREATE TABLE Proveedores
(
	CodigoProveedor INT IDENTITY PRIMARY KEY,
	RazonSocial VARCHAR(100),
	NIT VARCHAR(20),
	DireccionProveedor VARCHAR(100),
	PaginaWeb VARCHAR(50),
);
GO

CREATE TABLE TelefonoProveedor
(
	CodigoTelefonoProveedor INT IDENTITY PRIMARY KEY,
	Numero VARCHAR(20),
	Descripcion VARCHAR(80),
	CodigoProveedor INT,
	FOREIGN KEY(CodigoProveedor)REFERENCES Proveedores(CodigoProveedor)
);
GO

CREATE TABLE Productos
(
	CodigoProducto INT IDENTITY PRIMARY KEY,
	NombreProducto VARCHAR(80),
	FechaCreacion DATE,
	FechaModificacion DATE,
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
	Ubicacion INT IDENTITY (1,1),
	CodigoProducto INT,
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
	Ubicacion  INT IDENTITY (1,1),
	CodigoProducto INT,
	Existencia INT,
	PrecioCosto DECIMAL(11,4),
	PrecioVenta DECIMAL(11,4),
	ProductoIva DECIMAL(11,4),
	FechaCreacion DATE,
	FechaModificacion DATE,
	PRIMARY KEY(Ubicacion,CodigoProducto),
	FOREIGN KEY(Ubicacion)REFERENCES Ubicaciones(Ubicacion),
	FOREIGN KEY(CodigoProducto)REFERENCES Productos(CodigoProducto)
);
GO
CREATE TABLE Compras
(
	FacturaCompra INT IDENTITY PRIMARY KEY,
	CodigoProveedor INT,
	Descripcion VARCHAR(80),
	FechaCompra DATE,
	Ubicacion INT,
	FOREIGN KEY(CodigoProveedor)REFERENCES Proveedores(CodigoProveedor),
	FOREIGN KEY(Ubicacion)REFERENCES Ubicaciones(Ubicacion)
);
GO

CREATE TABLE DETCompras
(
	CodigoDetCompra INT NOT NULL IDENTITY(1,1),
	FacturaCompra INT,
	Linea INT,
	PrecioCompra DECIMAL(11,4),
	Cantidad INT,
	CodigoProducto INT,
	Ubicacion INT,
	PrecioIva DECIMAL(11,4),
	PrecioCosto DECIMAL(11,4),
	PRIMARY KEY(CodigoDetCompra,FacturaCompra,Linea),
	FOREIGN KEY(FacturaCompra)REFERENCES Compras(FacturaCompra),
	FOREIGN KEY(CodigoProducto)REFERENCES Productos(CodigoProducto),
	FOREIGN KEY(Ubicacion)REFERENCES Ubicaciones(Ubicacion)
);
GO
CREATE TABLE Clientes
(
	CodigoCliente INT IDENTITY(1,1) PRIMARY KEY,
	NombreCliente VARCHAR(80),
	ApellidoCliente VARCHAR(80),
	DireccionCliente VARCHAR(100),
	NitCliente VARCHAR(20),
	FechaCreacion DATE,
	FechaModificacion DATE
);
GO
CREATE TABLE TelefonoClientes
(
	CodigoTelefonoCliente INT IDENTITY(1,1) PRIMARY KEY,
	Telefono VARCHAR(20),
	Descripcion VARCHAR(80),
	CodigoCliente INT,
	FOREIGN KEY(CodigoCliente)REFERENCES Clientes(CodigoCliente)
);
GO
CREATE TABLE EmailClientes
(
	CodigoEmailCliente INT PRIMARY KEY IDENTITY(1,1),
	Email VARCHAR(50),
	Descripcion VARCHAR(80),
	CodigoCliente int,
	FOREIGN KEY(CodigoCliente)REFERENCES Clientes(CodigoCliente)
);
CREATE TABLE Facturas
(
	CodigoFactura INT IDENTITY (1,1) PRIMARY KEY,
	NumeroFactura INT,
	FechaVenta DATE,
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
	CodigoDetFactura INT NOT NULL IDENTITY,
	CodigoFactura INT NOT NULL,
	Linea INT,
	Cantidad INT,
	PrecioVenta DECIMAL(11,4),
	CostoUnitario DECIMAL(11,4),
	Ubicacion INT,
	CodigoProducto INT,
	IVA DECIMAL(11,3),
	PRIMARY KEY(CodigoDetFactura,CodigoFactura,Linea),
	FOREIGN KEY(CodigoFactura)REFERENCES Facturas(CodigoFactura),
	FOREIGN KEY(Ubicacion)REFERENCES ubicaciones(Ubicacion)
);
GO
-------------------------PROCEDIMIENTOS----------UBICACIONES-------------------------------------------------------------------------------------------------
CREATE PROCEDURE sp_AgregarUbicaciones @Descripcion VARCHAR(80),
	@Direccion VARCHAR(100)
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				INSERT INTO Ubicaciones(Descripcion,Direccion) 
					VALUES (@Descripcion,@Direccion);
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_AgregarUbicaciones 'Sucursal Las Charcas','4 calle 8-19 zona 11' ;
EXECUTE sp_AgregarUbicaciones 'Tienda Central',' 10 avenida 5-89 zona 13' ;
EXECUTE sp_AgregarUbicaciones 'Sucursal Municipalidad','5 avenida 12-85 zona 4' ;
EXECUTE sp_AgregarUbicaciones 'Sucursal Calzada San Juan','14 calle 25-01 zona 7 ' ;
EXECUTE sp_AgregarUbicaciones 'Sucursal Paseo de la Sexta','6 avenida 7-25 zona 1' ;
GO
CREATE PROCEDURE sp_EliminarUbicaciones @Ubicacion INT
AS
	BEGIN 
		BEGIN TRY
			BEGIN TRAN
				DELETE Ubicaciones WHERE Ubicacion=@Ubicacion;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_EliminarUbicaciones 3;
GO

CREATE PROCEDURE sp_ModificarUbicaciones @Ubicacion INT,
	@Descripcion VARCHAR(80),@Direccion VARCHAR(100)
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				UPDATE Ubicaciones SET Descripcion=@Descripcion,
					Direccion=@Direccion WHERE Ubicacion=@Ubicacion;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN; 
		END CATCH
	END;
GO
EXECUTE sp_ModificarUbicaciones 2,'Sucursal Miraflores','12 avenida zona 7,Calzada Roosvelt' ;
GO

CREATE PROCEDURE sp_BuscarUbicaciones @Ubicacion INT
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT Ubicacion,Descripcion,Direccion FROM Ubicaciones
				WHERE Ubicacion=@Ubicacion;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_BuscarUbicaciones 2;
GO

CREATE PROCEDURE sp_ListarUbicaciones 
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN 
				SELECT Ubicacion,Descripcion,Direccion FROM Ubicaciones;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_ListarUbicaciones ;
GO
---------------------------------------------------PROCEDIMIENTOS--------------TIPO--------PRODUCTO----------------------------------------------------------------------------------------
CREATE PROCEDURE sp_AgregarTipoProducto @Descripcion VARCHAR(50),
	@FechaCreacion DATE,@FechaModificacion DATE
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				INSERT INTO TipoProducto(Descripcion,FechaCreacion,FechaModificacion)
					VALUES(@Descripcion,@FechaCreacion,@FechaModificacion);
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_AgregarTipoProducto 'Importado de China','12-05-2010','12-07-2010' ;
EXECUTE sp_AgregarTipoProducto 'Desperfecto de Fabrica','01-10-2011','01-12-2011' ;
EXECUTE sp_AgregarTipoProducto 'Roto','01-05-2011','01-07-2011' ;
EXECUTE sp_AgregarTipoProducto 'No viene el otro par','02-05-2011','02-07-2011' ;
EXECUTE sp_AgregarTipoProducto 'Sobreexistencia','02-19-2010','02-20-2011' ;	
GO

CREATE PROCEDURE sp_EliminarTipoProducto @CodigoTipoProducto INT
AS
	BEGIN 
		BEGIN TRY
			BEGIN TRAN
				DELETE TipoProducto WHERE CodigoTipoProducto=@CodigoTipoProducto;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_EliminarTipoProducto 5;
GO

CREATE PROCEDURE sp_ModificarTipoProducto @CodigoTipoProducto INT,
	@Descripcion VARCHAR(80),@FechaCreacion DATE,@FechaModificacion DATE
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				UPDATE TipoProducto SET Descripcion=@Descripcion,
					FechaCreacion=@FechaCreacion,FechaModificacion=@FechaModificacion
					WHERE CodigoTipoProducto=@CodigoTipoProducto;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_ModificarTipoProducto 4,'Sin Descripcion','08-20-2012','08-25-2012' ;
GO

CREATE PROCEDURE sp_BuscarTipoProducto @CodigoTipoProducto INT
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT CodigoTipoProducto,Descripcion,FechaCreacion,FechaModificacion
					 FROM TipoProducto WHERE CodigoTipoProducto=@CodigoTipoProducto;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_BuscarTipoProducto 3;
GO

CREATE PROCEDURE sp_ListarTipoProducto 
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT CodigoTipoProducto,Descripcion,FechaCreacion,
					FechaModificacion FROM TipoProducto;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_ListarTipoProducto ;
GO

--------------------------PROCEDIMIENTOS----------------------------------------PROVEEDORES-------------------------------------------------------------------
CREATE PROCEDURE sp_AgregarProveedor @RazonSocial VARCHAR(100),
	@NIT VARCHAR(12),@DireccionProveedor VARCHAR(100),@PaginaWeb VARCHAR(50)
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				INSERT INTO Proveedores(RazonSocial,NIT,DireccionProveedor,PaginaWeb)
					VALUES(@RazonSocial,@NIT,@DireccionProveedor,@PaginaWeb);
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_AgregarProveedor 'Venta de Papelería','505623-9','4 avenida 4-89 zona 5','www.ArreoPapeles.gt' ;
EXECUTE sp_AgregarProveedor 'Venta de Equipo de Computo','215623-9f','23 calle 19-4 zona 10','www.teniequiposgt.org.gt' ;
EXECUTE sp_AgregarProveedor 'Contratar personal','856923-f','12 avenida 4-44 zona 14','www.buissinespersonal.com' ;
EXECUTE sp_AgregarProveedor 'Venta de Cajas de Empaque','148596-l5','48 calle 3-58 zona 12','www.cartondeguatemala.gt' ;
EXECUTE sp_AgregarProveedor 'Venta de Plastico','4289-69-a','18 calle 5-42 zona 13','www.platixguate.com.gt' ;
GO

CREATE PROCEDURE sp_EliminarProveedor @CodigoProveedor INT
AS
	BEGIN 
		BEGIN TRY
			BEGIN TRAN
				DELETE Proveedores WHERE CodigoProveedor=@CodigoProveedor;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_EliminarProveedor 3;
GO

CREATE PROCEDURE sp_ModificarProveedor @CodigoProveedor INT,
	@RazonSocial VARCHAR(100),@NIT VARCHAR(20),
	@DireccionProveedor VARCHAR(100),@PaginaWeb VARCHAR(50)
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				UPDATE Proveedores SET RazonSocial=@RazonSocial,
					NIT=@NIT,DireccionProveedor=@DireccionProveedor,PaginaWeb=@PaginaWeb
					WHERE CodigoProveedor=@CodigoProveedor;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_ModificarProveedor 2,'Venta de Sellos','421593-t','4 calle 2-83 zona 1 de Mixco','www.sellosdeguate.gt.com';
GO

CREATE PROCEDURE sp_BuscarProveedor @CodigoProveedor INT
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT CodigoProveedor,RazonSocial,NIT,DireccionProveedor,PaginaWeb
					 FROM Proveedores WHERE CodigoProveedor=@CodigoProveedor;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_BuscarProveedor 4;
GO

CREATE PROCEDURE sp_ListarProveedores 
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT CodigoProveedor,RazonSocial,NIT,DireccionProveedor,PaginaWeb 
					FROM Proveedores;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_ListarProveedores;
GO
----------------------------PROCEDIMIENTOS--------------------TELEFONOS-----------PROVEEDORES-----------------------------------------------------------------
CREATE PROCEDURE sp_AgregarTelefonoProveedor @Numero VARCHAR(20),
	@Descripcion VARCHAR(100),@CodigoProveedor INT
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				INSERT INTO TelefonoProveedor(Numero,Descripcion,CodigoProveedor)
					VALUES(@Numero,@Descripcion,@CodigoProveedor);
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_AgregarTelefonoProveedor '42265977','Celular','1';
EXECUTE sp_AgregarTelefonoProveedor '14895623','Celular','2';
EXECUTE sp_AgregarTelefonoProveedor '24486014','Oficina','3';
EXECUTE sp_AgregarTelefonoProveedor '55886699','Personal','4';
EXECUTE sp_AgregarTelefonoProveedor '25807456','PBX','5';
GO

CREATE PROCEDURE sp_EliminarTelefonoProveedor @CodigoTelefonoProveedor INT
AS
	BEGIN 
		BEGIN TRY
			BEGIN TRAN
				DELETE TelefonoProveedor WHERE CodigoTelefonoProveedor=@CodigoTelefonoProveedor;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_EliminarTelefonoProveedor 3;
GO

CREATE PROCEDURE sp_ModificarTelefonoProveedor @CodigoTelefonoProveedor INT,
	@Numero VARCHAR(20),@Descripcion VARCHAR(80),@CodigoProveedor INT
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				UPDATE TelefonoProveedor SET Numero=@Numero,Descripcion=@Descripcion,
					CodigoProveedor=@CodigoProveedor
					WHERE CodigoTelefonoProveedor=@CodigoTelefonoProveedor;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_ModificarTelefonoProveedor 5,'11458695','Celular',1;
GO

CREATE PROCEDURE sp_BuscarTelefonoProveedor @CodigoTelefonoProveedor INT
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT CodigoTelefonoProveedor,Numero,Descripcion,CodigoProveedor
					 FROM TelefonoProveedor WHERE CodigoTelefonoProveedor=@CodigoTelefonoProveedor;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_BuscarTelefonoProveedor 5;
GO

CREATE PROCEDURE sp_ListarTelefonoProveedor 
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT CodigoTelefonoProveedor,Numero,Descripcion,CodigoProveedor
					FROM TelefonoProveedor;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_ListarTelefonoProveedor;
GO
------------------------PROCEDIMIENTOS------------------------PRODUCTOS--------------------------------------------------------------------------------------
CREATE PROCEDURE sp_AgregarProducto @NombreProducto VARCHAR(80),@FechaCreacion DATE,
			@FechaModificacion DATE,@CodigoTipoProducto INT,@CodigoProveedor INT
AS
	BEGIN 
		BEGIN TRY
			BEGIN TRAN
				INSERT INTO Productos(NombreProducto,FechaCreacion,FechaModificacion
					,CodigoTipoProducto,CodigoProveedor)
					VALUES(@NombreProducto,@FechaCreacion,@FechaModificacion,
						@CodigoTipoProducto,@CodigoProveedor);
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_AgregarProducto 'Hojas Bond 60 gramos','09-15-2012','09-20-2012',1,1 ;
EXECUTE sp_AgregarProducto 'Sello de Fecha','01-10-2012','09-29-2012',2,2 ;
EXECUTE sp_AgregarProducto 'Cajas de Empaque 20x20 cm','02-08-2013','03-09-2013',3,3 ;
EXECUTE sp_AgregarProducto 'Plastico para Forro','10-05-2012','10-20-2012',4,4;
EXECUTE sp_AgregarProducto 'Hojas Bond 100 gramos','01-15-2014','09-05-2014',5,5 ;
GO

CREATE PROCEDURE sp_EliminarProducto @CodigoProducto INT
AS
	BEGIN 
		BEGIN TRY
			BEGIN TRAN
				DELETE Productos WHERE CodigoProducto=@CodigoProducto;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_EliminarProducto 5;
GO

CREATE PROCEDURE sp_ModificarProducto @CodigoProducto INT,
	@NombreProducto VARCHAR(80),@FechaCreacion DATE,
	@FechaModificacion DATE,@CodigoTipoProducto INT,@CodigoProveedor INT
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				UPDATE Productos SET NombreProducto=@NombreProducto,
					FechaCreacion=@FechaCreacion,FechaModificacion=@FechaModificacion,
					CodigoTipoProducto=@CodigoTipoProducto,CodigoProveedor=@CodigoProveedor
						WHERE CodigoProducto=@CodigoProducto;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_ModificarProducto 2,'Sellos de caritas','10-02-2013','10-05-2013',3,2;
GO

CREATE PROCEDURE sp_BuscarProducto @CodigoProducto INT
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT CodigoProducto,NombreProducto,FechaCreacion,FechaModificacion,
				CodigoTipoProducto,CodigoProveedor
					 FROM Productos WHERE CodigoProducto=@CodigoProducto;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_BuscarProducto 4;
GO

CREATE PROCEDURE sp_ListarProductos
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT CodigoProducto,NombreProducto,FechaCreacion,
				FechaModificacion,CodigoTipoProducto,CodigoProveedor
					FROM Productos;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_ListarProductos;
GO
---------------------------------------PROCEDIMIENTOS----------------------COMPRAS----------------------------------------------------------------------------------------------------------
CREATE PROCEDURE sp_AgregarCompra @CodigoProveedor INT,
	@Descripcion VARCHAR(80),@FechaCompra DATE,@Ubicacion INT
AS
	BEGIN 
		BEGIN TRY
			BEGIN TRAN
				INSERT INTO Compras(CodigoProveedor,Descripcion,FechaCompra,Ubicacion)
					VALUES(@CodigoProveedor,@Descripcion,@FechaCompra,@Ubicacion);
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_AgregarCompra 2,'Hojas Bond Carta','12-05-2014','1';
EXECUTE sp_AgregarCompra 4,'Cajas de carton','10-20-2014','2';
EXECUTE sp_AgregarCompra 5,'1000 yardas de plastico','12-08-2014','3';
EXECUTE sp_AgregarCompra 1,'Papel manila','05-05-2015','4';
EXECUTE sp_AgregarCompra 2,'Sellos de Fecha','10-07-2013','5';
GO
CREATE PROCEDURE sp_EliminarCompra @FacturaCompra INT
AS
	BEGIN 
		BEGIN TRY
			BEGIN TRAN
				DELETE Compras WHERE FacturaCompra=@FacturaCompra;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_EliminarCompra 1;
GO

CREATE PROCEDURE sp_ModificarCompra @FacturaCompra INT,@CodigoProveedor INT,
	@Descripcion VARCHAR(80),@FechaCompra DATE,@Ubicacion INT
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				UPDATE Compras SET CodigoProveedor=@CodigoProveedor,
					Descripcion=@Descripcion,FechaCompra=@FechaCompra,Ubicacion=@Ubicacion
						WHERE FacturaCompra=@FacturaCompra;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_ModificarCompra 2,4,'Sellos de Estrella','02-05-2012',1;
GO

CREATE PROCEDURE sp_BuscarCompra @FacturaCompra INT
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT FacturaCompra,CodigoProveedor,Descripcion,FechaCompra,Ubicacion
					 FROM Compras WHERE FacturaCompra=@FacturaCompra;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_BuscarCompra 4;
GO

CREATE PROCEDURE sp_ListarCompra
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT FacturaCompra,CodigoProveedor,Descripcion,FechaCompra,Ubicacion
					FROM Compras;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_ListarCompra;
GO
------------------------------------------PROCEDIMIENTOS--------------------------------DETCOMPRAS-----------------------------------------------------------------------------------------
CREATE PROCEDURE sp_AgregarDETCompra @FacturaCompra INT,@Linea INT,@PrecioCompra DECIMAL(11,4),
	@Cantidad INT,@CodigoProducto INT,@Ubicacion INT
AS
	BEGIN 
		BEGIN TRY
			BEGIN TRAN
				INSERT INTO DETCompras(FacturaCompra,Linea,PrecioCompra,Cantidad,CodigoProducto,Ubicacion)
					VALUES(@FacturaCompra,@Linea,@PrecioCompra,@Cantidad,@CodigoProducto,@Ubicacion);
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_AgregarDETCompra 2,1,150.52,10,1,1;
EXECUTE sp_AgregarDETCompra 3,2,248.32,1,2,2;
EXECUTE sp_AgregarDETCompra 4,3,325.20,21,3,5;
EXECUTE sp_AgregarDETCompra 5,4,89.36,8,4,4;
EXECUTE sp_AgregarDETCompra 4,5,245.10,35,2,5;
GO
CREATE PROCEDURE sp_EliminarDETCompra @CodigoDetCompra INT
AS
	BEGIN 
		BEGIN TRY
			BEGIN TRAN
				DELETE DETCompras WHERE CodigoDetCompra=@CodigoDetCompra;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_EliminarDETCompra 5;
GO

CREATE PROCEDURE sp_ModificarDETCompra @CodigoDetCompra INT,@Linea INT,@FacturaCompra INT,
	@Cantidad INT,@CodigoProducto INT,@Ubicacion INT
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				UPDATE DETCompras SET FacturaCompra=@FacturaCompra,Linea=@Linea,
					Cantidad=@Cantidad,CodigoProducto=@CodigoProducto,Ubicacion=@Ubicacion
						WHERE CodigoDetCompra=@CodigoDetCompra;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_ModificarDETCompra 1,1,3,25,1,2 ;
GO

CREATE PROCEDURE sp_BuscarDETCompra @CodigoDetCompra INT
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT CodigoDetCompra,FacturaCompra,Linea,Cantidad,CodigoProducto,Ubicacion
					 FROM DETCompras WHERE CodigoDetCompra=@CodigoDetCompra;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_BuscarDETCompra 4;
GO

CREATE PROCEDURE sp_ListarDETCompra
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT CodigoDetCompra,Linea,FacturaCompra,Cantidad,CodigoProducto,Ubicacion
					FROM DETCompras;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_ListarDETCompra;
GO
------------------------------------------PROCEDIMIENTOS--------------------------------Clientes-------------------------------------------------------------------------------------------
CREATE PROCEDURE sp_AgregarCliente @NombreCliente VARCHAR(80),
	@ApellidoCliente VARCHAR(80),@DireccionCliente VARCHAR(100),
	@NitCliente VARCHAR(20),@FechaCreacion DATE,@FechaModificacion DATE
AS
	BEGIN 
		BEGIN TRY
			BEGIN TRAN
				INSERT INTO Clientes(NombreCliente,ApellidoCliente,
					DireccionCliente,NitCliente,FechaCreacion,FechaModificacion)
					VALUES(@NombreCliente,@ApellidoCliente,@DireccionCliente,
						@NitCliente,@FechaCreacion,@FechaModificacion);
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_AgregarCliente 'Jose','Juarez','12 calle 48-9 zona 11','1025-63','06-08-2016','06-10-2016' ;
EXECUTE sp_AgregarCliente 'Cristian','Tello','5 avenida 20-45 zona 5','804902-5','07-09-2016','07-12-2016' ;
EXECUTE sp_AgregarCliente 'Javier','Lopez','12 calle 48-9 zona 11','1025-63','08-10-2016','08-14-2016' ;
EXECUTE sp_AgregarCliente 'Luis','Manrique','12 calle 48-9 zona 11','1025-63','09-11-2016','09-16-2016' ;
EXECUTE sp_AgregarCliente 'Ferris','Gomez','12 calle 48-9 zona 11','1025-63','10-12-2016','10-18-2016' ;
GO

CREATE PROCEDURE sp_EliminarCliente @CodigoCliente INT
AS
	BEGIN 
		BEGIN TRY
			BEGIN TRAN
				DELETE Clientes WHERE CodigoCliente=@CodigoCliente ;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_EliminarCliente 4;
GO

CREATE PROCEDURE sp_ModificarCliente @CodigoCliente INT,
	@NombreCliente VARCHAR(80),@ApellidoCliente VARCHAR(80),
	@DireccionCliente VARCHAR(100),@NitCliente VARCHAR(20),@FechaCreacion DATE,
	@FechaModificacion DATE
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				UPDATE Clientes  SET NombreCliente=@NombreCliente,
					ApellidoCliente=@ApellidoCliente,DireccionCliente=@DireccionCliente,
					NitCliente=@NitCliente,FechaCreacion=@FechaCreacion,
					FechaModificacion=@FechaModificacion
						WHERE CodigoCliente=@CodigoCliente;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_ModificarCliente 2,'Hector','Martinez','23 calle 8-56 zona 12','2563985-f','07-08-2016','10-09-2017';
GO

CREATE PROCEDURE sp_BuscarCliente @CodigoCliente INT
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT CodigoCliente,NombreCliente,ApellidoCliente,DireccionCliente,
					NitCliente,FechaCreacion,FechaModificacion
					 FROM Clientes WHERE CodigoCliente=@CodigoCliente;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_BuscarCliente 5;
GO

CREATE PROCEDURE sp_ListarClientes 
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT CodigoCliente,NombreCliente,ApellidoCliente,DireccionCliente,
					NitCliente,FechaCreacion,FechaModificacion
					FROM Clientes;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_ListarClientes;
GO
------------------------------------------PROCEDIMIENTOS-------------------------------TELEFONOS-------CLIENTES----------------------------------------------------------------------
CREATE PROCEDURE sp_AgregarTelefonoCliente @Telefono VARCHAR(20),
@Descripcion VARCHAR(80),@CodigoCliente INT
AS
	BEGIN 
		BEGIN TRY
			BEGIN TRAN
				INSERT INTO TelefonoClientes(Telefono,Descripcion,CodigoCliente)
					VALUES(@Telefono,@Descripcion,@CodigoCliente);
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_AgregarTelefonoCliente '25698945','Celular',1;
EXECUTE sp_AgregarTelefonoCliente '12365948','Propio',2;
EXECUTE sp_AgregarTelefonoCliente '50263214','Empresarial',3;
EXECUTE sp_AgregarTelefonoCliente '12345678','PBX',5;
EXECUTE sp_AgregarTelefonoCliente '98745612','Personal',2;
GO

CREATE PROCEDURE sp_EliminarTelefonoCliente @CodigoTelefonoCliente INT
AS
	BEGIN 
		BEGIN TRY
			BEGIN TRAN
				DELETE TelefonoClientes WHERE CodigoTelefonoCliente=@CodigoTelefonoCliente ;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_EliminarTelefonoCliente 5;
GO

CREATE PROCEDURE sp_ModificarTelefonoCliente @CodigoTelefonoCliente INT,
	@Telefono VARCHAR(20),@Descripcion VARCHAR(80),@CodigoCliente INT
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				UPDATE TelefonoClientes SET Telefono=@Telefono,Descripcion=@Descripcion,
					CodigoCliente=@CodigoCliente 
						WHERE CodigoTelefonoCliente=@CodigoTelefonoCliente;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_ModificarTelefonoCliente 3,'56984521','Personal',2;
GO

CREATE PROCEDURE sp_BuscarTelefonoCLiente @CodigoTelefonoCliente INT
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT CodigoTelefonoCliente,Telefono,Descripcion,CodigoCliente
					 FROM TelefonoClientes WHERE CodigoTelefonoCliente=@CodigoTelefonoCliente;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_BuscarTelefonoCLiente 3;
GO

CREATE PROCEDURE sp_ListarTelefonoClientes
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT CodigoTelefonoCliente,Telefono,Descripcion,CodigoCliente
					FROM TelefonoClientes ;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_ListarTelefonoClientes;
GO

------------------------------------------PROCEDIMIENTOS--------------------------------EMAIL---------CLIENTES----------------------------------------------------------------
CREATE PROCEDURE sp_AgregarEmailCliente @Email VARCHAR(35),
	@Descripcion VARCHAR(80),@CodigoCliente INT
AS
	BEGIN 
		BEGIN TRY
			BEGIN TRAN
				INSERT INTO EmailClientes(Email,Descripcion,CodigoCliente)
					VALUES(@Email,@Descripcion,@CodigoCliente);
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;  
		END CATCH
	END;
GO
EXECUTE sp_AgregarEmailCliente 'fergo23@yahoo.com','correo personal',1 ;
EXECUTE sp_AgregarEmailCliente 'hugol@gmail.com','correo personal',2 ;
EXECUTE sp_AgregarEmailCliente 'joser@usac.edu.gt','correo institucional',3 ;
EXECUTE sp_AgregarEmailCliente 'chernandez@yahoo.com','correo personal',2 ;
EXECUTE sp_AgregarEmailCliente 'solala45@outlook.com','correo personal',5 ;
GO

CREATE PROCEDURE sp_EliminarEmailCliente @CodigoEmailCliente INT
AS
	BEGIN 
		BEGIN TRY
			BEGIN TRAN
				DELETE EmailClientes WHERE CodigoEmailCliente=@CodigoEmailCliente;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_EliminarEmailCliente 4;
GO

CREATE PROCEDURE sp_ModificarEmailCliente @CodigoEmailCliente INT,
	@Email VARCHAR(50),@Descripcion VARCHAR(80),@CodigoCliente INT
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				UPDATE EmailClientes  SET Email=@Email,Descripcion=@Descripcion,
											CodigoCliente=@CodigoCliente 
						WHERE CodigoEmailCliente=@CodigoEmailCliente;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_ModificarEmailCliente 5,'golopezz@hotmail.com','Correo Personal',1;
GO

CREATE PROCEDURE sp_BuscarEmailCliente @CodigoEmailCliente INT
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT CodigoEmailCliente,Email,Descripcion,CodigoCliente
					 FROM EmailClientes WHERE CodigoEmailCliente=@CodigoEmailCliente;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_BuscarEmailCliente 1;
GO

CREATE PROCEDURE sp_ListarEmailClientes
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT CodigoEmailCliente,Email,Descripcion,CodigoCliente
					FROM EmailClientes;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_ListarEmailClientes;
GO
------------------------------------------PROCEDIMIENTOS--------------------------------FACTURAS---------------------------------------------------------------------------------------
CREATE PROCEDURE sp_AgregarFactura @NumeroFactura INT,
	@FechaVenta DATE,@NitCliente VARCHAR(20),@CodigoCliente INT,@Ubicacion INT
AS
	BEGIN 
		BEGIN TRY
			BEGIN TRAN
				INSERT INTO Facturas(NumeroFactura,FechaVenta,NitCliente,CodigoCliente,Ubicacion)
					VALUES(@NumeroFactura,@FechaVenta,@NitCliente,@CodigoCliente,@Ubicacion);
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_AgregarFactura 123,'12-03-2015','236589-df',1,1 ;
EXECUTE sp_AgregarFactura 1231,'12-04-2015','123564-a',2,2 ;
EXECUTE sp_AgregarFactura 1232,'12-05-2015','as5452-8',3,4 ;
EXECUTE sp_AgregarFactura 1233,'12-06-2015','19648-4',5,2;
EXECUTE sp_AgregarFactura 1234,'12-07-2015','23698-p',1,5 ;  
GO

CREATE PROCEDURE sp_EliminarFactura @CodigoFactura INT
AS
	BEGIN 
		BEGIN TRY
			BEGIN TRAN
				DELETE Facturas WHERE CodigoFactura=@CodigoFactura;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_EliminarFactura 4;
GO

CREATE PROCEDURE sp_ModificarFactura @CodigoFactura INT,@NumeroFactura INT,
	@FechaVenta DATE,@NitCliente VARCHAR(20),@CodigoCliente INT,@Ubicacion INT
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				UPDATE Facturas SET NumeroFactura=@NumeroFactura,FechaVenta=@FechaVenta,NitCliente=@NitCliente,CodigoCliente=@CodigoCliente,Ubicacion=@Ubicacion
						WHERE CodigoFactura=@CodigoFactura;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_ModificarFactura 1,1,'05-05-2017','23651-h',1,1
GO

CREATE PROCEDURE sp_BuscarFactura @CodigoFactura INT
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT CodigoFactura,NumeroFactura,FechaVenta,NitCliente,CodigoCliente, Ubicacion
					 FROM Facturas WHERE CodigoFactura=@CodigoFactura;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_BuscarFactura 2;
GO

CREATE PROCEDURE sp_ListarFactura 
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT CodigoFactura,NumeroFactura,FechaVenta,NitCliente,CodigoCliente, Ubicacion
					FROM Facturas;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_ListarFactura;
GO

------------------------------------------PROCEDIMIENTOS--------------------------------DETFACTURAS-----------------------------------------------------------------------------------------
CREATE PROCEDURE sp_AgregarDETFactura @CodigoFactura INT,@Linea INT,
	@Cantidad INT,@Ubicacion INT,@CodigoProducto INT
AS
	BEGIN 
		BEGIN TRY
			BEGIN TRAN
				INSERT INTO DETFacturas(CodigoFactura,Linea,Cantidad,Ubicacion,CodigoProducto)
					VALUES(@CodigoFactura,@Linea,@Cantidad,@Ubicacion,@CodigoProducto)
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_AgregarDETFactura 1,2,10,1,1;
EXECUTE sp_AgregarDETFactura 2,3,20,2,2;
EXECUTE sp_AgregarDETFactura 3,5,300,4,3;	
EXECUTE sp_AgregarDETFactura 2,5,5,5,4;
EXECUTE sp_AgregarDETFactura 5,2,10,2,2;
GO

CREATE PROCEDURE sp_EliminarDetFactura @CodigoDetFactura INT
AS
	BEGIN 
		BEGIN TRY
			BEGIN TRAN
				DELETE DETFacturas  WHERE CodigoDetFactura=@CodigoDetFactura ;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_EliminarDetFactura 3;
GO

CREATE PROCEDURE sp_ModificarDetFactura @CodigoDetFactura INT,@CodigoFactura INT,@Linea INT,
	@Cantidad INT,@Ubicacion INT,@CodigoProducto INT
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				UPDATE DETFacturas  SET CodigoFactura=@CodigoFactura,Linea=@Linea,
						Cantidad=@Cantidad,Ubicacion=@Ubicacion,CodigoProducto=@CodigoProducto 
						WHERE CodigoDetFactura=@CodigoDetFactura;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_ModificarDetFactura 5,5,2,15,2,2;
GO

CREATE PROCEDURE sp_BuscarDetFactura @CodigoDetFactura INT
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT CodigoDetFactura,CodigoFactura,Linea,Cantidad,
					Ubicacion,CodigoProducto
					 FROM DETFacturas WHERE CodigoDetFactura=@CodigoDetFactura;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_BuscarDetFactura 2;
GO

CREATE PROCEDURE sp_ListarDetFactura 
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT CodigoDetFactura,CodigoFactura,Linea,Cantidad,Ubicacion,CodigoProducto
					FROM DETFacturas ;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_ListarDetFactura;
GO
---------------------------------------------------PROCEDIMIENTOS--------------------DETUbicacionMES---------------------------------------------------------------------------------
CREATE PROCEDURE sp_BuscarDetUbicacionesMes @CodigoDetUbicacionMes INT
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT CodigoDetUbicacionMes,Año,Mes,Ubicacion,CodigoProducto,
					Entrada,Salida,CostoEntrada,CostoSalida,Saldo,UltimoCosto,
					VentaTotal,IVA			
						FROM DETUbicacionesMes WHERE CodigoDetUbicacionMes=@CodigoDetUbicacionMes;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();				
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_BuscarDetUbicacionesMes 1;
GO

CREATE PROCEDURE sp_ListarDetUbicacionesMes
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT CodigoDetUbicacionMes,Año,Mes,Ubicacion,CodigoProducto,
					Entrada,Salida,CostoEntrada,CostoSalida,Saldo,UltimoCosto,
					VentaTotal,IVA	
						FROM DETUbicacionesMes ;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_ListarDetUbicacionesMes;
GO
----------------------------------------------------PROCEDIMIENTOS--------------------Ubicaciones--------------------------------------------------------------------------------------
CREATE PROCEDURE sp_BuscarDetUbicaciones @CodigoDetUbicacion INT
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT CodigoDetUbicacion,Ubicacion,CodigoProducto,Existencia,
					PrecioCosto,PrecioVenta,ProductoIva,FechaCreacion,FechaModificacion
					 FROM DETUbicaciones WHERE CodigoDetUbicacion=@CodigoDetUbicacion;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_BuscarDetUbicaciones 2;
GO

CREATE PROCEDURE sp_ListarDetUbicaciones 
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT CodigoDetUbicacion,Ubicacion,CodigoProducto,Existencia,
					PrecioCosto,PrecioVenta,ProductoIva,FechaCreacion,FechaModificacion
					FROM DETUbicaciones ;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
EXECUTE sp_ListarDetUbicaciones;
GO
--------------------------------------------TRIGGERS-----------------------------------------------------------------------------------------------------------------------

create TRIGGER tr_AgregarDetCompra
ON DetCompras
	AFTER INSERT
		AS BEGIN 
			DECLARE @Ubicacion INT,@Existencia INT,@PrecioCosto DECIMAL(11,4),
			@PrecioCompra DECIMAL(11,4),@Cantidad INT,@CodigoProducto INT,@CodigoDetCompra INT,
			@PrecioIva DECIMAL(11,4),@Fecha DATE

			--SET @Ubicacion= ISNULL((SELECT Ubicacion FROM DETCompras
			--						WHERE @CodigoProducto=(SELECT CodigoProducto FROM inserted)),0);
			SET @CodigoProducto= (SELECT CodigoProducto FROM DETCompras
									WHERE @CodigoDetCompra=(SELECT CodigoDetCompra FROM inserted));
			SET @PrecioCompra =(SELECT PrecioCompra FROM inserted);
			--set @PrecioCosto=(SELECT PrecioCosto FROM inserted
				--					WHERE @CodigoProducto=(SELECT CodigoProducto FROM inserted));

			Set @PrecioCosto=(select PrecioCosto from DETUbicaciones where Ubicacion= (select ubicacion from inserted) and CodigoProducto=(select CodigoProducto from inserted)); 

			SET @Fecha=(SELECT FechaCompra From Compras WHERE FacturaCompra=(SELECT FacturaCompra FROM inserted));

			UPDATE DETCompras
				SET PrecioCosto= @PrecioCompra*Cantidad/1.12
				 WHERE CodigoProducto=(SELECT CodigoProducto FROM inserted);
			UPDATE DETUbicacionesMes
				SET Año= YEAR (@Fecha) WHERE Ubicacion=(Select Ubicacion from inserted )and CodigoProducto=(SELECT CodigoProducto FROM inserted)

				--(Select year (@Fecha), Month (@Fecha), Ubicacion_DetComp ,CodProducto_DetComp, Cantidad_DetComp,0, PrecioCosto_DetComp*Cantidad_DetComp,0, PrecioCosto_DetComp*Cantidad_DetComp, PrecioCosto_DetComp, 0 from inserted
				--)

	END;
GO
EXECUTE sp_AgregarDETCompra 2,2,1256,12,1,4
execute sp_EliminarDETCompra 41
execute sp_AgregarUbicaciones 'prueba','54sadf '



	select * from DETCompras
	select * from DETUbicaciones
	select * from DETUbicacionesMes
	SELECT * FROM Ubicaciones
	select * from DETFacturas
	select * from Facturas
	select * from Compras
	select * from Productos
	SELECT * FROM TipoProducto
	SELECT * FROM Proveedores

	
insert into DETUbicacionesMes(CodigoDetUbicacionMes,Año,Mes,Ubicacion,CodigoProducto)values(1,2015,5,1,1)
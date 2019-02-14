USE DBInventario2017065NOFICIAL;
--------------------------PROCEDIMIENTOS----------------------------ALMACENADOS----------------------------------------------------------------------
go
-------------------PROCEDIMIENTOS DE AGREGAR------------------------------------------------------------------------------------------
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
------------------------------------------------------------
CREATE PROCEDURE sp_AgregarTipoProducto @Descripcion VARCHAR(50)
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				INSERT INTO TipoProducto(Descripcion,FechaCreacion,FechaModificacion)
					VALUES(@Descripcion,(SELECT GETDATE()),(SELECT GETDATE()));
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
-------------------------------------------
CREATE PROCEDURE sp_AgregarDetUbicacionMes @CodigoProducto INT,
	@Entrada DECIMAL(11,4),@Salida DECIMAL(11,4),@CostoEntrada DECIMAL(11,4),
	@CostoSalida DECIMAL(11,4),@Saldo DECIMAL (11,4),
	@UltimoCosto DECIMAL(11,4),@VentaTotal DECIMAL(11,4),@IVA DECIMAL(11,4)
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				INSERT INTO DETUbicacionesMes(Año,Mes,Ubicacion,
				CodigoProducto,Entrada,Salida,CostoEntrada,
				CostoSalida,Saldo,UltimoCosto,VentaTotal)
					VALUES((SELECT YEAR(GETDATE())),(SELECT YEAR(GETDATE())),@CodigoProducto,@Entrada,@Salida,
					@CostoEntrada,@CostoSalida,@Saldo,@UltimoCosto,@VentaTotal,@IVA);
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
		PRINT Error_Message();
		ROLLBACK TRAN;
		END CATCH
	END;
GO
-------------------------------------------
CREATE PROCEDURE sp_AgregarDetUbicacion @CodigoProducto INT,@Existencia INT,
	@PrecioCosto DECIMAL(11,4),@PrecioVenta DECIMAL(11,4),@ProductoIva DECIMAL(11,4)
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				INSERT INTO DETUbicaciones(CodigoProducto,Existencia,PrecioCosto,PrecioVenta,ProductoIva,FechaCreacion,FechaModificacion)
					VALUES(@CodigoProducto,@Existencia,@PrecioCosto,@PrecioVenta,@ProductoIva,(SELECT GETDATE()),(SELECT GETDATE()));
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
		PRINT Error_Message();
		ROLLBACK TRAN;
		END CATCH
	END;
GO
-------------------------------------------
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
-------------------------------------------
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
-------------------------------------------
CREATE PROCEDURE sp_AgregarProducto @NombreProducto VARCHAR(80),
				@CodigoTipoProducto INT,@CodigoProveedor INT
AS
	BEGIN 
		BEGIN TRY
			BEGIN TRAN
				INSERT INTO Productos(NombreProducto,FechaCreacion,FechaModificacion
					,CodigoTipoProducto,CodigoProveedor)
					VALUES(@NombreProducto,(SELECT GETDATE()),(SELECT GETDATE()),
						@CodigoTipoProducto,@CodigoProveedor);
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
-------------------------------------------
CREATE PROCEDURE sp_AgregarCompra @CodigoProveedor INT,
	@Descripcion VARCHAR(80),@Ubicacion INT
AS
	BEGIN 
		BEGIN TRY
			BEGIN TRAN
				INSERT INTO Compras(CodigoProveedor,Descripcion,FechaCompra,Ubicacion)
					VALUES(@CodigoProveedor,@Descripcion,(SELECT GETDATE()),@Ubicacion);
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
-------------------------------------------
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
-------------------------------------------
CREATE PROCEDURE sp_AgregarCliente @NombreCliente VARCHAR(80),
	@ApellidoCliente VARCHAR(80),@DireccionCliente VARCHAR(100),
	@NitCliente VARCHAR(20)
AS
	BEGIN 
		BEGIN TRY
			BEGIN TRAN
				INSERT INTO Clientes(NombreCliente,ApellidoCliente,
					DireccionCliente,NitCliente,FechaCreacion,FechaModificacion)
					VALUES(@NombreCliente,@ApellidoCliente,@DireccionCliente,
						@NitCliente,(SELECT GETDATE()),(SELECT GETDATE()));
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
-------------------------------------------
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
-------------------------------------------
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
-------------------------------------------
CREATE PROCEDURE sp_AgregarFactura @NumeroFactura INT,
	@NitCliente VARCHAR(20),@CodigoCliente INT,@Ubicacion INT
AS
	BEGIN 
		BEGIN TRY
			BEGIN TRAN
				INSERT INTO Facturas(NumeroFactura,FechaVenta,NitCliente,CodigoCliente,Ubicacion)
					VALUES(@NumeroFactura,(SELECT GETDATE()),@NitCliente,@CodigoCliente,@Ubicacion);
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
-------------------------------------------
CREATE PROCEDURE sp_AgregarDETFactura @CodigoFactura INT,
	@Linea INT,@Cantidad INT,@Ubicacion INT,@CodigoProducto INT
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
------------PROCEDIMIENTOS-------------ELIMINAR-------------------------------------------------------------------------------------------------
-------------------------------------------
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
-------------------------------------------
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
-------------------------------------------
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
-------------------------------------------
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
-------------------------------------------
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
-------------------------------------------
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
-------------------------------------------
CREATE PROCEDURE sp_EliminarDETCompra @FacturaCompra INT
AS
	BEGIN 
		BEGIN TRY
			BEGIN TRAN
				DELETE DETCompras WHERE FacturaCompra=@FacturaCompra;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
-------------------------------------------
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
-------------------------------------------
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
-------------------------------------------
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
-------------------------------------------
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
-------------------------------------------
CREATE PROCEDURE sp_EliminarDetFactura @CodigoFactura INT
AS
	BEGIN 
		BEGIN TRY
			BEGIN TRAN
				DELETE DETFacturas  WHERE CodigoFactura=@CodigoFactura ;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO


-------------------------------------------
-------------PROCEDIMIENTOS------------MODIFICAR----------------------------------------------------------------------------------------

-------------------------------------------
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
--EXECUTE sp_ModificarUbicaciones 2,'Sucursal Miraflores','12 avenida zona 7,Calzada Roosvelt' ;
GO
-------------------------------------------
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
--EXECUTE sp_ModificarTipoProducto 4,'Sin Descripcion','08-20-2012','08-25-2012' ;
GO
-------------------------------------------
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
--EXECUTE sp_ModificarProveedor 2,'Venta de Sellos','421593-t','4 calle 2-83 zona 1 de Mixco','www.sellosdeguate.gt.com';
GO
-------------------------------------------
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
--EXECUTE sp_ModificarTelefonoProveedor 5,'11458695','Celular',1;
GO
-------------------------------------------
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
--EXECUTE sp_ModificarProducto 2,'Sellos de caritas','10-02-2013','10-05-2013',3,2;
GO
-------------------------------------------
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
--EXECUTE sp_ModificarCompra 2,4,'Sellos de Estrella','02-05-2012',1;
GO
-------------------------------------------
CREATE PROCEDURE sp_ModificarDETCompra @Linea INT,@FacturaCompra INT,@PrecioCompra DECIMAL(11,4),
	@Cantidad INT,@CodigoProducto INT,@Ubicacion INT
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				UPDATE DETCompras SET FacturaCompra=@FacturaCompra,Linea=@Linea,PrecioCompra=@PrecioCompra,
					Cantidad=@Cantidad,CodigoProducto=@CodigoProducto,Ubicacion=@Ubicacion
						WHERE FacturaCompra=@FacturaCompra;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
-------------------------------------------
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
--EXECUTE sp_ModificarCliente 2,'Hector','Martinez','23 calle 8-56 zona 12','2563985-f','07-08-2016','10-09-2017';
GO
-------------------------------------------
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
--EXECUTE sp_ModificarTelefonoCliente 3,'56984521','Personal',2;
GO
-------------------------------------------
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
--EXECUTE sp_ModificarEmailCliente 5,'golopezz@hotmail.com','Correo Personal',1;
GO
-------------------------------------------
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
--EXECUTE sp_ModificarFactura 1,1,'05-05-2017','23651-h',1,1
GO
-------------------------------------------
CREATE PROCEDURE sp_ModificarDetFactura @CodigoFactura INT,@Linea INT,
	@Cantidad INT,@Ubicacion INT,@CodigoProducto INT
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				UPDATE DETFacturas  SET CodigoFactura=@CodigoFactura,Linea=@Linea,
						Cantidad=@Cantidad,Ubicacion=@Ubicacion,CodigoProducto=@CodigoProducto 
						WHERE CodigoFactura=@CodigoFactura;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
--EXECUTE sp_ModificarDetFactura 5,5,2,15,2,2;
GO


-----------------PROCEDIMIENTOS---------------BUSCAR-------------------------------------------------------------------------------------------------------
-------------------------------------------
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
-------------------------------------------
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
-------------------------------------------
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
-------------------------------------------
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
-------------------------------------------
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
-------------------------------------------
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
-------------------------------------------
CREATE PROCEDURE sp_BuscarDETCompra @FacturaCompra INT
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT FacturaCompra,Linea,Cantidad,CodigoProducto,Ubicacion
					 FROM DETCompras WHERE FacturaCompra=@FacturaCompra;
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
-------------------------------------------
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
-------------------------------------------
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
-------------------------------------------
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
-------------------------------------------
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
-------------------------------------------
CREATE PROCEDURE sp_BuscarDetFactura @CodigoFactura INT
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT CodigoFactura,Linea,Cantidad,PrecioVenta,
					CostoUnitario,Ubicacion,CodigoProducto ,IVA
					 FROM DETFacturas WHERE CodigoFactura=@CodigoFactura;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
-------------------------------------------
CREATE PROCEDURE sp_BuscarDetUbicacionesMes @Ubicacion INT
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT Año,Mes,Ubicacion,CodigoProducto,
					Entrada,Salida,CostoEntrada,CostoSalida,Saldo,UltimoCosto,
					VentaTotal,IVA			
						FROM DETUbicacionesMes WHERE Ubicacion=@Ubicacion;
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
-------------------------------------------
CREATE PROCEDURE sp_BuscarDetUbicaciones @Ubicacion INT
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT Ubicacion,CodigoProducto,Existencia,
					PrecioCosto,PrecioVenta,ProductoIva,FechaCreacion,FechaModificacion
					 FROM DETUbicaciones WHERE Ubicacion=@Ubicacion;
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

---------PROCEDIMIENTOS-----------------LISTAR--------------------------------------------------------------------------------------------------------------
-------------------------------------------
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
-------------------------------------------
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
-------------------------------------------
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
-------------------------------------------
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
-------------------------------------------
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
-------------------------------------------
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
-------------------------------------------
CREATE PROCEDURE sp_ListarDETCompra
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT FacturaCompra,Linea,PrecioCompra,Cantidad,CodigoProducto,Ubicacion,
					PrecioIva,PrecioCosto
					FROM DETCompras;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
-------------------------------------------
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
-------------------------------------------
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
-------------------------------------------
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
-------------------------------------------
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
-------------------------------------------
CREATE PROCEDURE sp_ListarDetFactura 
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT CodigoFactura,Linea,Cantidad,PrecioVenta,
						CostoUnitario,Ubicacion,CodigoProducto,IVA
					FROM DETFacturas ;
			COMMIT TRAN;
		END TRY
		BEGIN CATCH
			PRINT Error_Message();
			ROLLBACK TRAN;
		END CATCH
	END;
GO
-------------------------------------------
CREATE PROCEDURE sp_ListarDetUbicacionesMes
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT Año,Mes,Ubicacion,CodigoProducto,
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
-------------------------------------------
CREATE PROCEDURE sp_ListarDetUbicaciones 
AS
	BEGIN
		BEGIN TRY
			BEGIN TRAN
				SELECT Ubicacion,CodigoProducto,Existencia,
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

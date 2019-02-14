USE DBInventario2017065NOFICIAL;
GO
CREATE TRIGGER tr_AgregarDetCompras
ON DETCompras
	AFTER INSERT
		AS BEGIN
			DECLARE @Existencia INT,@Cantidad INT,@CodigoProducto INT,
			@PrecioCompra DECIMAL(11,4),@PrecioCosto DECIMAL(11,4)
			SET @CodigoProducto=(SELECT CodigoProducto FROM inserted);

			SET @Existencia=ISNULL((SELECT Existencia FROM DETUbicaciones
				WHERE CodigoProducto=(SELECT CodigoProducto FROM inserted)),0);

			SET @Cantidad=ISNULL((SELECT Cantidad FROM inserted),0);

			SET @PrecioCompra=ISNULL((SELECT PrecioCompra FROM inserted
									WHERE CodigoProducto=@CodigoProducto),0);

			SET @PrecioCosto=ISNULL((SELECT PrecioCosto FROM DETUbicaciones
				WHERE CodigoProducto=(SELECT CodigoProducto FROM inserted)),0)

			
			IF EXISTS(SELECT CodigoProducto,Ubicacion FROM DETUbicaciones
					WHERE CodigoProducto=@CodigoProducto and Ubicacion=(SELECT Ubicacion FROM inserted))
				BEGIN
				UPDATE DETCompras
							SET PrecioIva=(PrecioCompra*.12),
								PrecioCosto=PrecioCompra-(PrecioCompra*.12)
				UPDATE DETUbicaciones
					SET Existencia=@Existencia+@Cantidad,
						PrecioCosto= ((@Existencia*@PrecioCosto)+(@Cantidad*@PrecioCompra))/(@Existencia+@Cantidad),
						PrecioVenta= (PrecioCosto*1.30),
						ProductoIva=(PrecioVenta*1.12),
						FechaModificacion=(GETDATE())
						WHERE CodigoProducto=(SELECT CodigoProducto FROM inserted)
				END
				ELSE
				BEGIN
				INSERT INTO DETUbicaciones(Ubicacion,CodigoProducto,Existencia,PrecioCosto,
						PrecioVenta,ProductoIva,FechaCreacion,FechaModificacion)
						(SELECT Ubicacion,CodigoProducto,Cantidad,((@Existencia*@PrecioCosto)+(@Cantidad*@PrecioCompra))/(@Existencia+@Cantidad),
						(PrecioCompra*1.30),((PrecioCompra*1.30)/1.12),GETDATE(),GETDATE() FROM inserted)
					
						UPDATE DETCompras
							SET PrecioIva=(@PrecioCompra*.12),
								PrecioCosto=(@PrecioCompra/1.12)
				END;

			IF EXISTS(SELECT CodigoProducto,Ubicacion FROM DETUbicacionesMes
					WHERE CodigoProducto=@CodigoProducto and Ubicacion=(SELECT Ubicacion FROM inserted))
				BEGIN
				UPDATE DETUbicacionesMes
					SET Entrada=@Existencia+@Cantidad,
						Salida=0,
						CostoEntrada=((@Existencia*@PrecioCosto)+(@Cantidad*@PrecioCompra))/(@Existencia+@Cantidad),
						Saldo=@Cantidad,
						UltimoCosto=((@Existencia*@PrecioCosto)+(@Cantidad*@PrecioCompra))/(@Existencia+@Cantidad),
						VentaTotal=0 ,
						IVA= 0
						WHERE CodigoProducto=(SELECT CodigoProducto FROM inserted)
				
				END				
				ELSE
				INSERT INTO DETUbicacionesMes(Año,Mes,Ubicacion,CodigoProducto,Entrada,Salida,CostoEntrada,CostoSalida,Saldo,UltimoCosto,VentaTotal)
				(SELECT YEAR(GETDATE()),MONTH (GETDATE()),Ubicacion,CodigoProducto,@Cantidad,0,@PrecioCompra*@Cantidad,0,@Cantidad,((@Existencia*@PrecioCosto)+(@Cantidad*@PrecioCompra))/(@Existencia+@Cantidad),0 FROM inserted)

				END;
		

EXECUTE sp_AgregarUbicaciones 'Sucursal Las Charcas','4 calle 8-19 zona 11' ;
EXECUTE sp_AgregarUbicaciones 'Tienda Central',' 10 avenida 5-89 zona 13' ;
EXECUTE sp_AgregarUbicaciones 'Sucursal Municipalidad','5 avenida 12-85 zona 4' ;
EXECUTE sp_AgregarUbicaciones 'Sucursal Calzada San Juan','14 calle 25-01 zona 7 ' ;
EXECUTE sp_AgregarUbicaciones 'Sucursal Paseo de la Sexta','6 avenida 7-25 zona 1' ;

EXECUTE sp_AgregarProveedor 'Bic Guatemala','505623-9','4 avenida 4-89 zona 5','www.pilot.gt' ;
EXECUTE sp_AgregarProveedor 'Norma','215623-9f','23 calle 19-4 zona 10','www.normaguate.org.gt' ;
EXECUTE sp_AgregarProveedor 'Venta de Borradores','856923-f','12 avenida 4-44 zona 14','www.erasers.com' ;
EXECUTE sp_AgregarProveedor 'Venta de crayones','148596-l5','48 calle 3-58 zona 12','www.crayola.gt' ;
EXECUTE sp_AgregarProveedor 'Venta de goma','4289-69-a','18 calle 5-42 zona 13','www.resistol.com.gt' ;

EXECUTE sp_AgregarTipoProducto 'Lapiceros';
EXECUTE sp_AgregarTipoProducto 'Cuadernos';
EXECUTE sp_AgregarTipoProducto 'Borradores';
EXECUTE sp_AgregarTipoProducto 'Crayones' ;
EXECUTE sp_AgregarTipoProducto 'Pegamento' ;

EXECUTE sp_AgregarProducto 'Lapiceros Rojo punta fina',1,1 ;
EXECUTE sp_AgregarProducto 'Cuaderno Universitario',2,2 ;
EXECUTE sp_AgregarProducto 'Cuaderno Universitario',3,3 ;
EXECUTE sp_AgregarProducto 'Caja de crayones 24 colores',4,4;
EXECUTE sp_AgregarProducto 'Frasco de goma líquida',5,5 ;

EXECUTE sp_AgregarCompra 1,'Lapiceros de color rojo',1;
EXECUTE sp_AgregarCompra 2,'Cuaderno de cuadricula',2;
EXECUTE sp_AgregarCompra 3,'Cuaderno de lineas',3;
EXECUTE sp_AgregarCompra 4,'Caja de crayones doble punta',4;
EXECUTE sp_AgregarCompra 5,'Goma líquida 4oz',5;

EXECUTE sp_AgregarDETCompra 1,1,14,10,1,1;
EXECUTE sp_AgregarDETCompra 2,2,14.95,5,1,1;
EXECUTE sp_AgregarDETCompra 3,3,25,3,1,1;
EXECUTE sp_AgregarDETCompra 4,4,12,4,1,1;
EXECUTE sp_AgregarDETCompra 5,5,6,7,1,1;

EXECUTE sp_ListarUbicaciones ;
EXECUTE sp_ListarProveedores;
EXECUTE sp_ListarTipoProducto ;
EXECUTE sp_ListarProductos;
EXECUTE sp_ListarCompra;
EXECUTE sp_ListarDETCompra;
EXECUTE sp_ListarDetUbicaciones;
EXECUTE sp_ListarDetUbicacionesMes;
EXECUTE sp_ListarFactura;
EXECUTE sp_ListarDetFactura;
EXECUTE sp_ListarTelefonoProveedor;
EXECUTE sp_ListarTelefonoClientes;
EXECUTE sp_ListarEmailClientes;
EXECUTE sp_ListarClientes;
DROP DATABASE DBInventario2017065NOFICIAL

-------------------------------------TRIGGER-------ELIMINAR-----------------------------------------------------------------------------------------
CREATE TRIGGER tr_EliminarDetCompras
ON DETCompras
	AFTER DELETE
		AS BEGIN
			DECLARE @Existencia INT,@Cantidad INT,@CodigoProducto INT,
			@PrecioCompra DECIMAL(11,4),@PrecioCosto DECIMAL(11,4)
			SET @CodigoProducto=(SELECT CodigoProducto FROM deleted);

			SET @Existencia=ISNULL((SELECT Existencia FROM DETUbicaciones
				WHERE CodigoProducto=(SELECT CodigoProducto FROM deleted)),0);

			SET @Cantidad=ISNULL((SELECT Cantidad FROM deleted),0);

			SET @PrecioCompra=ISNULL((SELECT PrecioCompra FROM deleted),0);

			SET @PrecioCosto=ISNULL((SELECT PrecioCosto FROM DETUbicaciones
				WHERE CodigoProducto=(SELECT CodigoProducto FROM deleted)),0);
				
				UPDATE DETCompras
							SET PrecioIva=(PrecioCompra*.12),
								PrecioCosto=PrecioCompra-(PrecioCompra*.12)

			
			IF  EXISTS(SELECT CodigoProducto FROM DETUbicaciones
					WHERE CodigoProducto=@CodigoProducto)
			BEGIN
			UPDATE DETUbicaciones
				SET Existencia=Existencia-@Cantidad,
					PrecioCosto= ((Existencia*@PrecioCosto)-(@Cantidad*@PrecioCompra))/(Existencia-@Cantidad),
					PrecioVenta= (DETUbicaciones.PrecioCosto*1.30),
					ProductoIva=((DETUbicaciones.PrecioCosto*1.30)/1.12),
					FechaModificacion=(GETDATE())
					WHERE CodigoProducto=(SELECT CodigoProducto FROM deleted)

			UPDATE DETUbicacionesMes
				SET Entrada=Entrada-@Cantidad,
					Salida=0,
					CostoEntrada=((@Existencia*@PrecioCosto)-(@Cantidad*@PrecioCompra))/(@Existencia-@Cantidad),
					Saldo=@Existencia-@Cantidad ,
					UltimoCosto=((@Existencia*@PrecioCosto)-(@Cantidad*@PrecioCompra))/(@Existencia-@Cantidad) ,
					VentaTotal=0 ,
					IVA= 0
				WHERE CodigoProducto=(SELECT CodigoProducto FROM deleted)
				
			END
			ELSE
			BEGIN
			RAISERROR('NO SE PUEDE ELIMINAR',16,1)
			END
		END;

EXECUTE sp_EliminarDETCompra 2;
-------------------------------------TRIGGER-----------UPDATE---------DETCOMPRAS-----------------------------------------------------------------------------
CREATE TRIGGER tr_ModificarDETCompras
ON DETCompras
AFTER UPDATE
	AS BEGIN
		DECLARE @Existencia INT,@Cantidad INT,@CodigoProducto INT,
			@PrecioCompra DECIMAL(11,4),@PrecioCosto DECIMAL(11,4),
			@PrecioCompra1 DECIMAL(11,4),@PrecioCosto1 DECIMAL(11,4),
			@Existencia1 INT,@Cantidad1 INT

		SET @Existencia=ISNULL((SELECT Existencia FROM DETUbicaciones 
									WHERE Ubicacion=(SELECT Ubicacion FROM inserted)),0);

		SET @Cantidad1=ISNULL((SELECT Cantidad FROM inserted),0);

		SET @PrecioCompra1=ISNULL((SELECT PrecioCompra FROM inserted),0);

		SET @PrecioCosto1=ISNULL((SELECT PrecioCosto FROM DETUbicaciones
									WHERE Ubicacion=(SELECT Ubicacion FROM deleted)and
										CodigoProducto=(SELECT CodigoProducto FROM deleted)),0)

		SET @Cantidad=ISNULL((SELECT Cantidad FROM deleted),0);

		SET @PrecioCompra=ISNULL((SELECT PrecioCompra FROM deleted),0);

		SET @PrecioCosto=ISNULL((SELECT PrecioCosto FROM DETUbicaciones
									WHERE Ubicacion=(SELECT Ubicacion FROM inserted)and
										CodigoProducto=(SELECT CodigoProducto FROM inserted)),0)
						
							UPDATE DETCompras
							SET PrecioIva=(PrecioCompra*.12),
								PrecioCosto=PrecioCompra-(PrecioCompra*.12)		
		
			IF @Existencia-@Cantidad=0
						BEGIN
							UPDATE DETUbicaciones 
							SET Existencia=@Existencia-@Cantidad,
								PrecioCosto=0,
								PrecioVenta=0,
								ProductoIva=0,
								FechaModificacion=(GETDATE())
								WHERE Ubicacion=(SELECT Ubicacion FROM deleted)
								and CodigoProducto=(SELECT CodigoProducto FROM deleted);

							UPDATE DETUbicacionesMes
							SET Entrada=0,
								CostoEntrada=0

						END;
						ELSE
						BEGIN
							UPDATE DETUbicaciones
							SET Existencia=@Existencia-@Cantidad,
								PrecioCosto=((@Existencia*@PrecioCosto)-(@Cantidad*@PrecioCompra))/(@Existencia-@Cantidad),
								PrecioVenta=(PrecioCosto*1.30),
								ProductoIva=((DETUbicaciones.PrecioCosto*1.30)/1.12)							
								WHERE Ubicacion=(SELECT Ubicacion FROM deleted) AND
									CodigoProducto=(SELECT CodigoProducto FROM deleted);

							UPDATE DETUbicaciones
							SET Existencia=Existencia+@Cantidad1,
								PrecioCosto= ((@Existencia*@PrecioCosto1)+(@Cantidad1*@PrecioCompra1))/(@Existencia+@Cantidad1),
								PrecioVenta= (PrecioCosto*1.30),
								ProductoIva=(PrecioVenta*1.12),
								FechaModificacion=(GETDATE())
								WHERE Ubicacion=(SELECT Ubicacion FROM inserted) AND
									CodigoProducto=(SELECT CodigoProducto FROM inserted);

							UPDATE DETUbicacionesMes
								SET Entrada=Entrada-@Cantidad,
									Salida=0,
									CostoEntrada=((@Existencia*@PrecioCosto)-(@Cantidad*@PrecioCompra))/(@Existencia-@Cantidad),
									Saldo=@Existencia-@Cantidad ,
									UltimoCosto=((@Existencia*@PrecioCosto)-(@Cantidad*@PrecioCompra))/(@Existencia-@Cantidad) ,
									VentaTotal=0 ,
									IVA= 0
								WHERE CodigoProducto=(SELECT CodigoProducto FROM deleted)

							UPDATE DETUbicacionesMes
								SET Entrada=@Existencia+@Cantidad,
									Salida=0,
									CostoEntrada=((@Existencia*@PrecioCosto1)+(@Cantidad*@PrecioCompra1))/(@Existencia+@Cantidad1),
									Saldo=@Cantidad,
									UltimoCosto=((@Existencia*@PrecioCosto1)+(@Cantidad*@PrecioCompra1))/(@Existencia+@Cantidad1),
									VentaTotal=0 ,
									IVA= 0
									WHERE CodigoProducto=(SELECT CodigoProducto FROM inserted)

								
						END;
	END;

EXECUTE sp_ModificarDETCompra 1,1,23,15,1,1	

EXECUTE sp_ListarDETCompra;
EXECUTE sp_ListarDETFactura;
EXECUTE sp_ListarDetUbicaciones;
EXECUTE sp_ListarDetUbicacionesMes;



-------------------------------------TRIGGERS-----------DETFACTURAS----------------------------------------------------------------------------------
-------------------------------------------TRIGGERS-----------INSERTAR--------------------------------------------------------------------------------
CREATE TRIGGER tr_AgregarDETFacturas 
ON DETFacturas
AFTER INSERT 
	AS BEGIN
		DECLARE @Existencia INT,@Cantidad INT,@CodigoProducto INT,
					@PrecioCompra DECIMAL(11,4),@PrecioCosto DECIMAL(11,4),@CostoUnitario DECIMAL(11,4),@PrecioVenta DECIMAL(11,4)
					SET @CodigoProducto=(SELECT CodigoProducto FROM inserted);

					SET @Existencia=ISNULL((SELECT Existencia FROM DETUbicaciones
						WHERE CodigoProducto=(SELECT CodigoProducto FROM inserted)),0);

					SET @Cantidad=ISNULL((SELECT Cantidad FROM inserted),0);

					SET @PrecioVenta=ISNULL((SELECT PrecioVenta FROM DETUbicaciones
						WHERE CodigoProducto=(SELECT CodigoProducto FROM inserted) AND
							Ubicacion=(SELECT Ubicacion FROM inserted)),0);
					SET @CostoUnitario=ISNULL((SELECT CostoUnitario FROM inserted),0)

			
					IF EXISTS(SELECT CodigoProducto,Ubicacion FROM DETUbicaciones
						WHERE CodigoProducto=@CodigoProducto and Ubicacion=(SELECT Ubicacion FROM inserted))
						BEGIN
						UPDATE DETFacturas
									SET PrecioVenta=@PrecioVenta,
										CostoUnitario=((@Existencia*@PrecioCosto)+((@PrecioCompra*Cantidad)/1.12))
														/(@Existencia+@Cantidad),
										IVA=(PrecioVenta*.12)
									
						UPDATE DETUbicaciones
							SET Existencia=@Existencia-@Cantidad,
								PrecioCosto= ((@Existencia*PrecioCosto)+(@Cantidad*@PrecioCosto))/(@Existencia+@Cantidad),
								PrecioVenta= (PrecioCosto*1.30),
								ProductoIva=(PrecioVenta*1.12),
								FechaModificacion=(GETDATE())
								WHERE CodigoProducto=(SELECT CodigoProducto FROM inserted)
						END
						ELSE
						BEGIN
						RAISERROR('No se puede realizar la venta,porque no hay ninguna compra',16,1)
						END;
		END;
EXECUTE sp_AgregarTelefonoProveedor '42265977','Celular','1';
EXECUTE sp_AgregarTelefonoProveedor '14895623','Celular','2';

EXECUTE sp_AgregarCliente 'Jose','Juarez','12 calle 48-9 zona 11','205623-8';
EXECUTE sp_AgregarCliente 'Cristian','Tello','5 avenida 20-45 zona 5','804902-5';

EXECUTE sp_AgregarTelefonoCliente '25698945','Celular',1;
EXECUTE sp_AgregarTelefonoCliente '12365948','Propio',2;

EXECUTE sp_AgregarEmailCliente 'josejuar@yahoo.com','correo personal',1 ;
EXECUTE sp_AgregarEmailCliente 'ctello123@gmail.com','correo personal',2 ;

EXECUTE sp_AgregarFactura 1230,'205623-8',1,1 ;
EXECUTE sp_AgregarFactura 1231,'804902-5',2,2 ;

EXECUTE sp_AgregarDETFactura 1,1,7,1,1;
EXECUTE sp_AgregarDETFactura 2,2,6,2,2;



					
		




					
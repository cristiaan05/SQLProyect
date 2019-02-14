EXECUTE sp_AgregarUbicaciones 'Sucursal Las Charcas','4 calle 8-19 zona 11' ;
EXECUTE sp_AgregarUbicaciones 'Tienda Central',' 10 avenida 5-89 zona 13' ;
EXECUTE sp_AgregarUbicaciones 'Sucursal Municipalidad','5 avenida 12-85 zona 4' ;
EXECUTE sp_AgregarUbicaciones 'Sucursal Calzada San Juan','14 calle 25-01 zona 7 ' ;
EXECUTE sp_AgregarUbicaciones 'Sucursal Paseo de la Sexta','6 avenida 7-25 zona 1' ;

EXECUTE sp_AgregarTipoProducto 'Lapiceros';
EXECUTE sp_AgregarTipoProducto 'Importado de Mexico' ;
EXECUTE sp_AgregarTipoProducto 'Hecho en Guatemala' ;
EXECUTE sp_AgregarTipoProducto 'Hecho en El Salvador' ;
EXECUTE sp_AgregarTipoProducto 'Importado de Panamá' ;

EXECUTE sp_AgregarProveedor 'Bic Guatemala','505623-9','4 avenida 4-89 zona 5','www.pilot.gt' ;
EXECUTE sp_AgregarProveedor 'Venta de Cuadernos','215623-9f','23 calle 19-4 zona 10','www.papelcuaderno.org.gt' ;
EXECUTE sp_AgregarProveedor 'Venta de Borradores','856923-f','12 avenida 4-44 zona 14','www.erasers.com' ;
EXECUTE sp_AgregarProveedor 'Venta de crayones','148596-l5','48 calle 3-58 zona 12','www.crayola.gt' ;
EXECUTE sp_AgregarProveedor 'Venta de goma','4289-69-a','18 calle 5-42 zona 13','www.resistol.com.gt' ;

EXECUTE sp_AgregarTelefonoProveedor '42265977','Celular','1';
EXECUTE sp_AgregarTelefonoProveedor '14895623','Celular','2';
EXECUTE sp_AgregarTelefonoProveedor '24486014','Oficina','3';
EXECUTE sp_AgregarTelefonoProveedor '55886699','Personal','4';
EXECUTE sp_AgregarTelefonoProveedor '25807456','PBX','5';

EXECUTE sp_AgregarProducto 'Lapiceros Rojo punta fina',1,1 ;
EXECUTE sp_AgregarProducto 'Cuaderno Universitario',2,2 ;
EXECUTE sp_AgregarProducto 'Borrador',3,3 ;
EXECUTE sp_AgregarProducto 'Caja de crayones 24 colores',4,4;
EXECUTE sp_AgregarProducto 'Frasco de goma líquida',5,5 ;
GO

EXECUTE sp_AgregarCompra 1,'Lapiceros de color rojo',1;
EXECUTE sp_AgregarCompra 2,'Cuadernos con Lineas','10-20-2014',2;
EXECUTE sp_AgregarCompra 3,'Borradores medianos','12-08-2014',3;
EXECUTE sp_AgregarCompra 4,'Caja de crayones doble punta','05-05-2015',4;
EXECUTE sp_AgregarCompra 5,'Goma líquida 4oz','10-07-2013',5;

EXECUTE sp_AgregarDETCompra 1,1,1.50,10,1,1;
EXECUTE sp_AgregarDETCompra 3,2,248.32,1,2,2;
EXECUTE sp_AgregarDETCompra 4,3,325.20,21,3,5;
EXECUTE sp_AgregarDETCompra 5,4,89.36,8,4,4;
EXECUTE sp_AgregarDETCompra 4,5,245.10,35,2,5;

EXECUTE sp_AgregarCliente 'Jose','Juarez','12 calle 48-9 zona 11','205623-8','06-08-2016','06-10-2016' ;
EXECUTE sp_AgregarCliente 'Cristian','Tello','5 avenida 20-45 zona 5','804902-5','07-09-2016','07-12-2016' ;
EXECUTE sp_AgregarCliente 'Javier','Lopez','12 calle 48-9 zona 11','584596-q','08-10-2016','08-14-2016' ;
EXECUTE sp_AgregarCliente 'Luis','Manrique','12 calle 48-9 zona 11','256984-2','09-11-2016','09-16-2016' ;
EXECUTE sp_AgregarCliente 'Ferris','Gomez','12 calle 48-9 zona 11','2598-s','10-12-2016','10-18-2016' ;

EXECUTE sp_AgregarTelefonoCliente '25698945','Celular',1;
EXECUTE sp_AgregarTelefonoCliente '12365948','Propio',2;
EXECUTE sp_AgregarTelefonoCliente '50263214','Empresarial',3;
EXECUTE sp_AgregarTelefonoCliente '12345678','PBX',4;
EXECUTE sp_AgregarTelefonoCliente '98745612','Personal',5;

EXECUTE sp_AgregarEmailCliente 'josejuar@yahoo.com','correo personal',1 ;
EXECUTE sp_AgregarEmailCliente 'ctello123@gmail.com','correo personal',2 ;
EXECUTE sp_AgregarEmailCliente 'javilop32@usac.edu.gt','correo institucional',3 ;
EXECUTE sp_AgregarEmailCliente 'manluisrique@yahoo.com','correo personal',2 ;
EXECUTE sp_AgregarEmailCliente 'ferrigo45@outlook.com','correo personal',5 ;

EXECUTE sp_AgregarFactura 1230,'12-03-2015','236589-df',1,1 ;
EXECUTE sp_AgregarFactura 1231,'12-04-2015','123564-a',2,2 ;
EXECUTE sp_AgregarFactura 1232,'12-05-2015','as5452-8',3,4 ;
EXECUTE sp_AgregarFactura 1233,'12-06-2015','19648-4',5,2;
EXECUTE sp_AgregarFactura 1234,'12-07-2015','23698-p',1,5 ;  

EXECUTE sp_AgregarDETFactura 1,1,10,1,1;
EXECUTE sp_AgregarDETFactura 2,2,20,2,2;
EXECUTE sp_AgregarDETFactura 3,3,300,3,3;	
EXECUTE sp_AgregarDETFactura 2,4,5,4,4;
EXECUTE sp_AgregarDETFactura 5,5,10,5,5;

EXECUTE sp_EliminarUbicaciones 3;
EXECUTE sp_EliminarTipoProducto 5;
EXECUTE sp_EliminarProveedor 3;
EXECUTE sp_EliminarTelefonoProveedor 3;
EXECUTE sp_EliminarProducto 5;
EXECUTE sp_EliminarCompra 1;
EXECUTE sp_EliminarDETCompra 5;
EXECUTE sp_EliminarCliente 4;
EXECUTE sp_EliminarTelefonoCliente 5;
EXECUTE sp_EliminarEmailCliente 4;
EXECUTE sp_EliminarFactura 4;
EXECUTE sp_EliminarDetFactura 3;

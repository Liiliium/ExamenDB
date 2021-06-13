-- docker run  --name mariadb -p 3306:3306 -e MYSQL_DATABASE=examenDB -e MYSQL_USER=juan -e MYSQL_ROOT_PASSWORD=12345 -e MYSQL_PASSWORD=12345 -d mysql

--A

Create DataBase examenDB;

Use examenDB;

Create Table Cajeros(
    Cajero int Primary Key AUTO_INCREMENT,
    NomApels varchar(255)
)AUTO_INCREMENT=1;

Create Table Productos(
    Producto int Primary Key AUTO_INCREMENT,
    Nombre varchar(255),
    Precio decimal(10,2)
)AUTO_INCREMENT=1;

Create Table Maquinas_Registradoras(
    Maquina int Primary Key AUTO_INCREMENT,
    Piso int
)AUTO_INCREMENT=1;

Create Table Venta(
    Cajero int,
    Maquina int,
    Producto int,
    Foreign Key (Cajero) References Cajeros(Cajero),
    Foreign Key (Maquina) References Maquinas_Registradoras(Maquina),
    Foreign Key (Producto) References Productos(Producto);
);

--llenar tablas

--Cajeros
Insert Into Cajeros (NomApels) Values("Juan Sains");
Insert Into Cajeros (NomApels) Values("Carlos Sains");
Insert Into Cajeros (NomApels) Values("María Sains");

--Productos
Insert Into Productos (Nombre, Precio) Values('Computadora Dell', 11499.99);
Insert Into Productos (Nombre, Precio) Values('Computadora Lenovo', 18699.99);
Insert Into Productos (Nombre, Precio) Values('Tablet Android', 3999.99);

--Maquinas Registradoras
Insert Into Maquinas_Registradoras (Piso) Values (1);
Insert Into Maquinas_Registradoras (Piso) Values (2);
Insert Into Maquinas_Registradoras (Piso) Values (3);

--Ventas
Insert Into Venta (Cajero, Maquina, Producto) Values (1,3,1);
Insert Into Venta (Cajero, Maquina, Producto) Values (2,4,2);
Insert Into Venta (Cajero, Maquina, Producto) Values (3,5,3);

--consultas
--B
Select Productos.Producto, Productos.Nombre, COUNT(Venta.Producto) 
    From Productos 
    Left Join Venta On Venta.Producto = Productos.Producto 
    Group By Productos.Producto, Productos.Nombre 
    Order By COUNT(Venta.Producto) Desc;

--C
Select NomApels, Nombre, Precio, Piso
    From Cajeros as C 
    Inner Join(Productos as P 
    Inner Join(Maquinas_Registradoras as M 
    Inner Join Venta as V 
    ON V.Maquina = M.Maquina)
    On V.Producto = P.Producto)
    On V.Cajero = C.Cajero;

--D
Select Piso, SUM(Precio)
    From Venta as V, Productos as P, Maquinas_Registradoras as M 
    Where V.Producto = P.Producto And V.Maquina = M.Maquina
    Group By Piso;

--E
Select C.Cajero, C.NomApels, SUM(Precio)
    From Productos as P 
    Inner Join(Cajeros as C 
    Left Join Venta as V 
    On V.Cajero = C.Cajero)
    On V.Producto = P.Producto 
    Group By C.Cajero, NomApels;

--F
Select Cajero, NomApels 
    From Cajeros 
    Where Cajero 
    In(Select Cajero 
        From Venta 
        Where Maquina 
        In(Select Maquina 
            From Maquinas_Registradoras 
            Where Piso 
            In(Select Piso 
                From Venta as V, Productos as P, Maquinas_Registradoras as M 
                Where V.Producto = P.Producto And V.Maquina = M.Maquina 
                Group By Piso 
                HAVING SUM(Precio) < 5000)));

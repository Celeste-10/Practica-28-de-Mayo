/* Crear una base de datos llamada UniversidadDB la cual maneja dos modulos:
   academico y seguridad 
   
   Modulo Academico: Carrera y Estudiante.
   Modulo Seguridad: Cargo y usuario.
*/

use master
go

if exists (select * from sys.databases where name = 'UniversidadDB')
begin
	drop database UniversidadDB
end 
go

create database UniversidadDB
go

use UniversidadDB
go

--Schema: Es un contenedor logico que sirve para organizar objetos dentro de una base de datos.

create schema Academico
go

create schema Seguridad
go

create table Academico.Carrera(
	id int primary key identity(1,1),
	nombre nvarchar(100) not null,
	precio decimal(10,2),
	created_at datetime default getdate(),
	update_at datetime null,
	delete_at datetime
)
go

create table Academico.Estudiante(
	id int identity(1,1) primary key,
	cif varchar(8) unique not null,
	nombres nvarchar(60) not null,
	apellidos nvarchar(60) not null,
	fechaNac datetime null,
	email nvarchar(120) null,
	idCarrera int foreign key references Academico.Carrera(id)
)
go

create table Seguridad.Cargo(
	idCargo int identity(1,1) primary key,
	nombre nvarchar(60),
	created_at datetime default getdate(),
	update_at datetime null,
	delete_at datetime
)
go

create table Seguridad.Usuario(
	idUsuario int identity(1,1) primary key,
	cif varchar(8) unique not null,
	nombres nvarchar(60) not null,
	apellidos nvarchar(60) not null,
	fechaNac datetime null,
	pw varbinary (64) not null,
	email nvarchar(120) null,
	created_at datetime default getdate(),
	update_at datetime null,
	delete_at datetime
)
go

-- ================================
--      Aplicacion de cambios
-- ================================

--Restricciones not null
alter table Academico.Carrera
alter column nombre nvarchar(100) not null
go

alter table Academico.Carrera
alter column precio decimal (10,2) not null
go

alter table Academico.Carrera
alter column created_at datetime not null
go

alter table Academico.Estudiante
alter column cif varchar(8) not null
go

alter table Academico.Estudiante
alter column apellidos nvarchar(60) not null
go

alter table Academico.Estudiante
alter column fechaNac date not null
go

alter table Academico.Estudiante
alter column email nvarchar(120) not null
go

alter table Academico.Estudiante
alter column idCarrera int not null
go

alter table Seguridad.Cargo
alter column nombre nvarchar(60) not null
go

alter table Seguridad.Cargo
alter column created_at datetime not null
go

alter table Seguridad.Usuario 
alter column cif varchar(8) not null 
go 

alter table Seguridad.Usuario 
alter column nombres nvarchar(60) not null 
go 

alter table Seguridad.Usuario 
alter column apellidos nvarchar(60) not null 
go 

alter table Seguridad.Usuario 
alter column fechaNac date not null 
go

alter table Seguridad.Usuario 
alter column pw varbinary(64) not null 
go 

alter table Seguridad.Usuario 
alter column email nvarchar(120) not null 
go 

alter table Seguridad.Usuario 
alter column idUsuario int not null 
go 

alter table Seguridad.Usuario 
alter column created_at datetime not null 
go

--Unique
alter table Academico.Estudiante 
add constraint UQ_Estudiante_CIF 
unique(cif) 
go 

alter table Academico.Estudiante 
add constraint UQ_Estudiante_Email 
unique(email) 
go 

alter table Seguridad.Usuario 
add constraint UQ_Usuario_CIF 
unique(cif) 
go 

alter table Seguridad.Usuario 
add constraint UQ_Usuario_Email 
unique(email) 
go 

alter table Seguridad.Cargo 
add constraint UQ_Cargo_Nombre 
unique(nombre) 
go

--Check
alter table Academico.Carrera 
add constraint CK_Carrera_Precio 
check(precio > 0) 
go 

alter table Academico.Estudiante 
add constraint CK_Estudiante_CIF 
check(len(cif) = 8) 
go 

alter table Academico.Estudiante 
add constraint CK_Estudiante_Email 
check(email like '%_@_%._%') 
go 

alter table Academico.Estudiante 
add constraint CK_Estudiante_FechaNac 
check(fechaNac < getdate()) 
go

alter table Seguridad.Usuario 
add constraint CK_Usuario_CIF 
check(len(cif) = 8) 
go 

alter table Seguridad.Usuario 
add constraint CK_Usuario_Email 
check(email like '%_@_%._%') 
go 

alter table Seguridad.Usuario 
add constraint CK_Usuario_FechaNac 
check(fechaNac < getdate()) 
go 

alter table Seguridad.Usuario 
add constraint CK_Usuario_Password 
check(datalength(pw) >= 8) 
go

--Llaves foraneas
alter table Academico.Estudiante 
add constraint FK_Estudiante_Carrera foreign key(idCarrera) 
references Academico.Carrera(id) 
go

-- Se agrega la columna idCargo para relacionar la tabla Usuario con la tabla Cargo
alter table Seguridad.Usuario
add idCargo int
go

alter table Seguridad.Usuario 
add constraint FK_Usuario_Cargo foreign key(idCargo) 
references Seguridad.Cargo(idCargo) 
go

--Insercion de datos
insert into Academico.Carrera(nombre, precio) values 
('Ingenieria en Sistemas', 2500.00), 
('Arquitectura', 3200.00) 
go

insert into Seguridad.Cargo(nombre) values 
('Administrador'), 
('Docente') 
go

insert into Academico.Estudiante (cif, nombres, apellidos, fechaNac, email, idCarrera) values 
('25010549', 'Maria', 'Carrasco', '10-01-2008', 'maria@gmail.com', 1) 
go

insert into Seguridad.Usuario (cif, nombres, apellidos, fechaNac, pw, email, idCargo) values 
( '20250003', 'Carlos', 'Lopez', '2000-10-10', convert(varbinary(64), 'password123'), 'carlos@gmail.com', 1 ) 
go

--Consultas

select * from Academico.Carrera 
go 

select * from Academico.Estudiante 
go 

select * from Seguridad.Cargo 
go 

select * from Seguridad.Usuario 
go
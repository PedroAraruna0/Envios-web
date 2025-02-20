create database BDEditoral3142035IFSP

use BDEditoral3142035IFSP;

create table TBEstado3142035
(
	IDUF int not null primary key,
	NomeEstado varchar(50) not null
);
insert into TBEstado3142035 values
(1, 'Sao Paulo'),
(2, 'Parana');
select * from TBEstado3142035;

create table TBCidade3142035
(
	IDCidade int not null primary key,
	NomeCidade varchar(50) not null,
	PontoTuristico varchar(50) not null,
	CodUF int not null,
	foreign key (CodUF) references TBEstado3142035(IDUF)
);
insert into TBCidade3142035 values
(1, 'Barretos', '...', 1),
(2, 'Curitiba', '...', 2);
select * from TBCidade3142035;

create table TBEditora3142035
(
	IDEditora int not null primary key,
	NomeEditora varchar(50) not null,
	Endereco varchar(50) not null,
	Telefone int not null,
	CNPJ int not null,
	Email varchar(50) not null,
	Website varchar(50) not null,
	CodCidade int not null,
	foreign key (CodCidade) references TBCidade3142035(IDCidade)
);

create table TBPrateleira3142035
(
	IDPrateleira int not null primary key,
	Descricao varchar(50) not null
);

create table TBAssunto3142035
(
	IDAssunto int not null primary key,
	Observacao varchar(100) not null,
	Descricao varchar(100) not null
);

create table TBLivro3142035
(
	IDlivro int not null primary key,
	Titulo varchar(50) not null,
	Ano time not null,
	Edicao int not null,
	ISBN varchar(20),
	CodEditora int not null,
	CodPrateleira int not null
	foreign key (CodEditora) references TBEditora3142035(IDEditora),
	foreign key (CodPrateleira) references TBPrateleira3142035(IDPrateleira)
);

create table TBLivroAssunto3142035
(
	CodAssunto int not null,
	CodLivro int not null,
	Data date not null,
	foreign key (CodAssunto) references TBAssunto3142035(IDAssunto),
	foreign key (CodLivro) references TBLivro3142035(IDlivro)
);

create table TBAutor3142035
(
	IDAutor int not null primary key,
	NomeAutor varchar(50) not null,
	Endereco varchar(50) not null,
	Telefone int not null,
	RG int not null,
	CPF int not null,
	Email varchar(50) not null,
	CodCidade int not null,
	foreign key (CodCidade) references TBCidade3142035(IDCidade)
);

create table TBAutorLivro3142035
(
	CodLivro int not null,
	CodAutor int not null,
	Publicacao date not null,
	foreign key (CodLivro) references TBLivro3142035(IDlivro),
	foreign key (CodAutor) references TBAutor3142035(IDAutor)
);
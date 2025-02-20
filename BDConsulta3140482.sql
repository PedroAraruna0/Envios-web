Create database BDConsultaMedica3142035

use BDConsultaMedica3142035;

create table TBEstado3142035
(
	IDUF varchar(2) not null primary key,
	NomeEstado varchar(50)
);
insert into TBEstado3142035 values
(1, 'Sao Paulo'),
(2, 'Rio de Janeiro');
select * from TBEstado3142035;

create table TBCidade3142035
(
	IDCidade int not null primary key,
	NomeCidade varchar(50) not null,
	CodUF varchar(2) not null,
	foreign key (CodUF) references TBEstado3142035(IDUF)
);
insert into TBCidade3142035 values
(1, 'Sao Paulo', 1),
(2, 'Rio de Janeiro', 2);
select * from TBCidade3142035;

create table TBEspecialidade3142035
(
	IDEspecialidade int not null primary key,
	NomeEspecialidade varchar(50)
);

create table TBMedico3142035
(
	IDCRMMedico int not null primary key,
	NomeMedico varchar(50) not null,
	DataNascimento date not null,
	Sexo varchar(1),
	CodCidade int not null,
	foreign key (CodCidade) references TBCidade3142035(IDCidade)
);

create table TBMedicoEspecialidade
(
	CodCRM int not null primary key,
	CodEspecialidade int not null,
	Data date not null,
	foreign key (CodCRM) references TBMedico3142035(IDCRMMedico),
	foreign key (CodEspecialidade) references TBEspecialidade3142035(IDEspecialidade)
);

create table TBPaciente3142035
(
	IDPaciente int not null primary key,
	NomePaciente varchar(50) not null,
	DataNascimento date not null,
	Sexo varchar(1) not null,
	Endereco varchar(50) not null,
	Bairro varchar(50) not null,
	CEP int not null,
	CodCidade int not null,
	foreign key (CodCidade) references TBCidade3142035(IDCidade)
);

create table TBFuncionario3142035
(
	IDFuncionario int not null primary key,
	NomeFuncionario varchar(50) not null,
	DataNascimento date not null,
	Sexo varchar(1) not null,
	Endereco varchar(50) not null,
	Bairro varchar(50) not null,
	CEP int not null,
	DataAdmissao date not null,
	Salario decimal(10,2) not null,
	CodCidade int not null,
	foreign key (CodCidade) references TBCidade3142035(IDCidade)
);

create table TBConvenio3142035
(
	IDConvenio int not null primary key,
	NomeConvenio varchar(50) not null,
	ValorConsulta decimal(10,2) not null
);

create table TBConsulta3142035
(
	IDConsulta int not null primary key,
	DataConsulta date not null,
	Valor decimal(10,2) not null,
	Observacao varchar(200) not null,
	CodPaciente int not null,
	CodFuncionario int not null,
	CodConvenio int not null,
	CodEspecialidade int not null,
	CodMedico int not null,
	foreign key (CodPaciente) references TBPaciente3142035(IDPaciente),
	foreign key (CodFuncionario) references TBFuncionario3142035(IDFuncionario),
	foreign key (CodConvenio) references TBConvenio3142035(IDConvenio),
	foreign key (CodEspecialidade) references TBEspecialidade3142035(IDEspecialidade),
	foreign key (CodMedico) references TBMedico3142035(IDCRMMedico)
);
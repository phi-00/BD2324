-- Modelo Físico Agência Apollo 

-- Universidade do Minho
-- Bases de Dados 2024
-- Caso de Estudo: Agência Apollo

CREATE DATABASE IF NOT EXISTS AgenciaApollo;
USE AgenciaApollo;

-- Tabela Cliente
CREATE TABLE IF NOT EXISTS AgenciaApollo.Cliente (
	id INT NOT NULL,
	nome VARCHAR(45) NOT NULL,
	genero ENUM('F', 'M')  NOT NULL,
	NIF VARCHAR(15) NOT NULL ,
	CC VARCHAR(20) NOT NULL,
	distrito VARCHAR(45) NOT NULL,
	rua VARCHAR(45) NOT NULL,
	porta VARCHAR(45) NOT NULL,
	pais VARCHAR(45) NOT NULL,
	cod_postal VARCHAR(45) NOT NULL,
	PRIMARY KEY (id) 
);

-- Tabela Cliente_Email
CREATE TABLE IF NOT EXISTS AgenciaApollo.Cliente_Email (
	email VARCHAR(45) NOT NULL,
    cliente INT NOT NULL,
    PRIMARY KEY (email, cliente),
    FOREIGN KEY (cliente)
		 REFERENCES AgenciaApollo.Cliente (id)
);

-- Tabela Cliente_Telefone
CREATE TABLE IF NOT EXISTS AgenciaApollo.Cliente_Telefone (
	telefone VARCHAR(20) NOT NULL,
    cliente INT NOT NULL,
    PRIMARY KEY (telefone, cliente),
    FOREIGN KEY (cliente)
		 REFERENCES AgenciaApollo.Cliente (id)
);

-- Tabela Fatura
CREATE TABLE IF NOT EXISTS AgenciaApollo.Fatura (
	n_fatura INT NOT NULL,
	valor DECIMAL(12,2) NOT NULL,
	metodo_pagamento ENUM('Dinheiro', 'TransferenciaBancaria', 'CartaoCredito', 'CartaoDebito') NOT NULL,
	data_faturacao DATE NOT NULL,
	data_pagamento DATE NOT NULL,
	PRIMARY KEY (n_fatura)
);

-- Tabela Vitima 
CREATE TABLE IF NOT EXISTS AgenciaApollo.Vitima (
	id INT NOT NULL,
	nome VARCHAR(45) NOT NULL,
	data_nascimento DATE NOT NULL,
	genero ENUM('F','M') NOT NULL,
	estado_civil ENUM('Solteiro', 'Casado', 'Divorciado', 'Separado', 'Viuvo') NOT NULL,
	distrito VARCHAR(45) NOT NULL,
	rua VARCHAR(45) NOT NULL,
	porta VARCHAR(45) NOT NULL,
	país VARCHAR(45) NOT NULL,
	cod_postal VARCHAR(45) NOT NULL,
	PRIMARY KEY (id)
);

-- Tabela Vitima_Email
CREATE TABLE IF NOT EXISTS AgenciaApollo.Vitima_Email (
	email VARCHAR(45) NOT NULL,
    vitima INT NOT NULL,
    PRIMARY KEY (email, vitima),
    FOREIGN KEY (vitima)
		 REFERENCES AgenciaApollo.Vitima (id)
);         
    
-- Tabela Vitima_Telefone
CREATE TABLE IF NOT EXISTS AgenciaApollo.Vitima_Telefone (
	telefone VARCHAR(20) NOT NULL,
    vitima INT NOT NULL,
    PRIMARY KEY (telefone, vitima),
    FOREIGN KEY (vitima)
		 REFERENCES AgenciaApollo.Vitima (id)
);    

-- Tabela Envolvido
CREATE TABLE IF NOT EXISTS AgenciaApollo.Envolvido (
	id INT NOT NULL AUTO_INCREMENT,
    genero ENUM('F','M') NOT NULL,
    data_nascimento DATE NOT NULL,
    nome VARCHAR(45) NOT NULL,
    CC VARCHAR(20) NOT NULL,
    distrito VARCHAR(45) NOT NULL,
    rua VARCHAR(45) NOT NULL,
    porta VARCHAR(45) NOT NULL,
    pais VARCHAR(45) NOT NULL,
    cod_postal VARCHAR(45) NOT NULL,
    PRIMARY KEY(id) 
);
    
-- Tabela Envolvidos_email
CREATE TABLE IF NOT EXISTS AgenciaApollo.Envolvidos_Email (
    email VARCHAR(45) NOT NULL,
    envolvido INT NOT NULL,
    PRIMARY KEY (email, envolvido),
    FOREIGN KEY (envolvido)
			REFERENCES AgenciaApollo.Envolvido (id)
);
     
-- Tabela Envolvidos_telefone
CREATE TABLE IF NOT EXISTS AgenciaApollo.Envolvidos_Telefone (
    telefone VARCHAR(20) NOT NULL,
    envolvido INT NOT NULL,
    PRIMARY KEY (telefone, envolvido),
    FOREIGN KEY (envolvido)
			REFERENCES AgenciaApollo.Envolvido (id)
);

-- Tabela Funcionario
CREATE TABLE IF NOT EXISTS AgenciaApollo.Funcionario (
	id INT NOT NULL,
    genero ENUM('F','M') NOT NULL,
    NIF VARCHAR(15) NOT NULL,
    salario DECIMAL(12,2) NOT NULL,
    tipo ENUM('Detetive', 'Administrador') NOT NULL,
    cod_postal VARCHAR(45) NOT NULL,
    distrito VARCHAR(45) NOT NULL,
    rua VARCHAR(45) NOT NULL,
    porta VARCHAR(45) NOT NULL,
    data_inic_contrato DATE NOT NULL,
    data_fim_contrato DATE NULL,
		CONSTRAINT chk_data_contrato CHECK(data_fim_contrato > data_inic_contrato),
    nome VARCHAR(45) NOT NULL,
    data_nascimento DATE NOT NULL,
    CC VARCHAR(20) NOT NULL,
    coordenado_por INT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (coordenado_por)
		REFERENCES AgenciaApollo.Funcionario (id)
);

-- Tabela Funcionarios_email
CREATE TABLE IF NOT EXISTS AgenciaApollo.Funcionario_Emails (
    email VARCHAR(45) NOT NULL,
    funcionario INT NOT NULL,
    PRIMARY KEY (email, funcionario),
    FOREIGN KEY (funcionario)
			REFERENCES AgenciaApollo.Funcionario (id)
);
     
-- Tabela Funcionarios_telefone
CREATE TABLE IF NOT EXISTS AgenciaApollo.Funcionarios_Telemoveis (
    telefone VARCHAR(20) NOT NULL,
    funcionario INT NOT NULL,
    PRIMARY KEY (telefone, funcionario),
    FOREIGN KEY (funcionario)
			REFERENCES AgenciaApollo.Funcionario (id)
);
	
-- Tabela Caso
CREATE TABLE IF NOT EXISTS AgenciaApollo.Caso (
    id INT NOT NULL,
    prioridade ENUM('Urgente','Prioritario','Normal'),
    preco_por_dia DECIMAL (5,2) NOT NULL DEFAULT 0.00,
    -- Adicionar uma check constraint para impedir a inserção de valores negativos
		CONSTRAINT chk_preco_por_dia CHECK(preco_por_dia >= 0.00),
    data_inic DATE NOT NULL,
    data_encerramento DATE NULL,
		CONSTRAINT chk_data_casos CHECK(data_encerramento > data_inic),
    rel_vitima_cliente VARCHAR(45) NULL,
    descricao TEXT NOT NULL,
    estado ENUM('Aberto', 'Em espera', 'Encerrado', 'Arquivado') NOT NULL,
    vitima INT NOT NULL,
    requisitado_por INT NOT NULL,
    fatura INT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (vitima) 
			REFERENCES AgenciaApollo.Vitima (id),
	FOREIGN KEY (requisitado_por) 
			REFERENCES AgenciaApollo.Cliente(id),
	FOREIGN KEY (fatura)
			REFERENCES AgenciaApollo.Fatura (n_fatura)
);

-- Tabela Caso_Observacoes
CREATE TABLE IF NOT EXISTS AgenciaApollo.Caso_Observacoes (
	observacao LONGTEXT NOT NULL,
    caso_id INT NOT NULL,
    PRIMARY KEY (observacao(255),caso_id),
    FOREIGN KEY (caso_id)
		REFERENCES AgenciaApollo.Caso (id)
);

-- Tabela Casos_dos_Detetives
CREATE TABLE IF NOT EXISTS AgenciaApollo.Casos_dos_Detetives (
	caso INT NOT NULL,
    detetive INT NOT NULL,
    PRIMARY KEY (caso,detetive),
	FOREIGN KEY (caso)
		REFERENCES AgenciaApollo.Caso (id),
	FOREIGN KEY (detetive)
		REFERENCES AgenciaApollo.Funcionario (id)
);

-- Tabela Casos_dos_Envolvidos
CREATE TABLE IF NOT EXISTS AgenciaApollo.Caso_Envolvidos (
	envolvido INT NOT NULL,
    caso INT NOT NULL,
	rel_vitima VARCHAR(45) NULL,
    tipo ENUM('Suspeito', 'Testemunha') NOT NULL,
    PRIMARY KEY (envolvido, caso),
    FOREIGN KEY (envolvido)
			REFERENCES AgenciaApollo.Envolvido(id),
	FOREIGN KEY(caso) 
			REFERENCES AgenciaApollo.Caso(id)
);

-- Tabela Documento
CREATE TABLE IF NOT EXISTS AgenciaApollo.Documento (
	id INT NOT NULL AUTO_INCREMENT,
    descricao TEXT NOT NULL,
    data_emissao DATE NOT NULL,
    caso INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (caso)
			REFERENCES AgenciaApollo.Caso (id)
);            

-- Tabela Prova
CREATE TABLE IF NOT EXISTS AgenciaApollo.Prova( 
	id INT NOT NULL,
    descricao TEXT NOT NULL,
    data_obtida DATE NOT NULL,
    tipo ENUM('Encontrados','Análises') NOT NULL,
    cod_postal VARCHAR(45) NULL,
    cidade VARCHAR(45) NULL,
    distrito VARCHAR(45) NULL,
    pais VARCHAR(45) NULL,
    PRIMARY KEY (id)
);

-- Tabela Caso_Provas
CREATE TABLE IF NOT EXISTS AgenciaApollo.Caso_Provas (
	caso INT NOT NULL,
    prova INT NOT NULL,
    PRIMARY KEY (caso, prova),
    FOREIGN KEY (caso)
			REFERENCES AgenciaApollo.Caso (id),
	FOREIGN KEY (prova) 
			REFERENCES AgenciaApollo.Prova (id)
);
    
-- Flags para que o mySQL permita com que nós façamos coisas sem proteções
SET SQL_SAFE_UPDATES = 0;
SET GLOBAL log_bin_trust_function_creators = 1;


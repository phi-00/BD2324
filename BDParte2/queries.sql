-- Queries (Requisitos de Manipulação)

-- Query 1 ############################################################################################################################################################################
-- Deve ser possível obter a ficha de identificação de cada envolvido no caso
PREPARE FichaEnvolvido FROM
'SELECT 
    Tipo, 
    rel_vitima AS RelaçãoVítima, 
    id AS ID, 
    nome AS Nome, 
    genero AS Género, 
    data_nascimento AS DataNascimento, 
    CC, 
    CONCAT(cod_postal, '' '', porta, '' '', rua, '' '', distrito, '' '', pais) AS Morada
FROM 
    AgenciaApollo.EnvolvidosView
JOIN 
    AgenciaApollo.Caso_Envolvidos ON Caso_Envolvidos.envolvido =  EnvolvidosView.id
WHERE 
    Caso_Envolvidos.caso = ?';

-- Definir o valor do parâmetro
-- SET @id_caso = 10;
-- Executar a instrução preparada com o parâmetro
-- EXECUTE FichaEnvolvido USING @id_caso;

-- Despreparar a instrução para liberar recursos
-- DEALLOCATE PREPARE FichaEnvolvido;


-- Query 2 ############################################################################################################################################################################
-- Deve ser possível obter o tempo de duração da resolução de cada caso, fazendo a diferença entre a data de fim e a data de ínicio
PREPARE Duracao_Caso FROM 
'SELECT id, DATEDIFF(data_encerramento, data_inic) AS duracao
FROM Caso
WHERE id=?';

-- SET @caso=21;
-- EXECUTE Duracao_Caso USING @caso;

-- Query 3 ############################################################################################################################################################################
-- Deve ser possível obter, a qualquer momento, a informação associada a cada prova envolvida num dado caso
PREPARE ProvaInfo FROM
    'SELECT
        Id AS ID,
        descricao AS Descrição,
        data_obtida AS DataObtida,
        tipo AS Tipo,
		CONCAT(cod_postal, '' '', cidade, '' '', distrito, '' '', pais) AS Morada
	FROM
		AgenciaApollo.Prova 
	JOIN AgenciaApollo.Caso_Provas ON Caso_Provas.prova = Prova.id
     WHERE Caso_Provas.caso = ?';

    -- Definir o valor do parâmetro
	-- SET @id_caso = 9;
	-- Executar a instrução preparada com o parâmetro
	-- EXECUTE ProvaInfo USING @id_caso;


-- Query 4 ############################################################################################################################################################################
-- Deve ser possível, a qualquer momento, inserir ou remover alguma prova relativa a um dado caso
DELIMITER $$
CREATE PROCEDURE AddProva(
IN p_id INT,
IN p_descricao TEXT,
IN p_data_obtida DATE,
IN p_tipo ENUM('Encontrados', 'Análises'),
IN p_codigo_postal VARCHAR(45),
IN p_cidade VARCHAR(45),
IN p_distrito VARCHAR(45),
IN p_pais VARCHAR(45),
IN caso_id INT,
OUT mensagem VARCHAR(255))
AddProva: BEGIN
DECLARE caso_existe INT;
	DECLARE prova_existe INT;

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
   	BEGIN
        		SET mensagem = 'Erro ao inserir a prova.';
       		ROLLBACK;
    	END;

	START TRANSACTION;

	-- Verifica se o caso existe
	SELECT COUNT(*) INTO caso_existe
	FROM AgenciaApollo.Caso
	WHERE id = caso_id;
	
	IF caso_existe=0 THEN
SET mensagem = 'Erro ao inserir a prova. O caso com o id especificado não existe.';
       		 ROLLBACK;
        		LEAVE AddProva;
   	END IF;

	-- Verifica se o id da prova já existe
	SELECT COUNT(*) INTO prova_existe
	FROM AgenciaApollo.Prova
	WHERE id = p_id;
	
	IF prova_existe>0 THEN
		SET mensagem = 'Erro ao inserir a prova. Já existe uma prova com este id.';
		ROLLBACK;
		LEAVE AddProva;
	END IF;

	-- Inserir na tabela Prova
	INSERT INTO AgenciaApollo.Prova
	 (id, descricao, data_obtida, tipo, cod_postal, cidade, distrito, pais)
	VALUES
	(p_id, p_descricao, p_data_obtida, p_tipo, p_codigo_postal, p_cidade, p_distrito, p_pais);

	-- Inserir na tabela Caso_Provas
	INSERT INTO AgenciaApollo.Caso_Provas
	(caso, prova)
	VALUES
	(caso_id, p_id);

	COMMIT;
	SET mensagem = 'Prova inserida com sucesso.';
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE RemoveProva(IN p_id INT, OUT mensagem VARCHAR(255))
RProva: BEGIN
DECLARE prova_existe INT;

DECLARE EXIT HANDLER FOR SQLEXCEPTION
   	BEGIN
			SET mensagem = 'Erro ao remover a prova.';
		ROLLBACK;
	END;

	START TRANSACTION;

-- Verifica se o id da prova já existe
	SELECT COUNT(*) INTO prova_existe
	FROM AgenciaApollo.Prova
	WHERE id = p_id;
	
	IF prova_existe=0 THEN
		SET mensagem = 'Erro ao remover a prova. Não existe uma prova com este id.';
		ROLLBACK;
		LEAVE RProva;
	END IF;

	-- Remove prova da tabela Caso_Provas
	DELETE FROM AgenciaApollo.Caso_Provas
	WHERE prova = p_id;

	-- Remove prova da tabela Prova
	DELETE FROM AgenciaApollo.Prova
	WHERE id = p_id;

COMMIT;
SET mensagem = 'Prova removida com sucesso.';
END $$
DELIMITER ;

-- SET @mensagem = '';
-- CALL AddProva(100, 'Relatório de análise de ADN de mancha de sangue encontrada na casa da vítima', '2020-02-02', 'Análises', NULL, NULL, NULL, NULL, 12, @mensagem);
-- SELECT @mensagem;

-- Query 5 ############################################################################################################################################################################
-- Deve ser possivel ter acesso à lista de todos os funcionários da agência
-- SELECT 'A' as tipo, CONCAT(nome,' (',genero,')') as 'Nome', NIF,CC, salario, CONCAT(porta,' ',rua,' ',distrito,' (',cod_postal,')') as 'morada', data_nascimento, coordenado_por, data_inic_contrato, data_fim_contrato
-- FROM AgenciaApollo.FuncionariosView WHERE tipo='Administrador' AND data_fim_contrato IS NULL
-- UNION
-- SELECT 'D' as tipo, CONCAT(nome,' (',genero,')') as 'Nome', NIF,CC, salario, CONCAT(porta,' ',rua,' ',distrito,' (',cod_postal,')') as 'morada', data_nascimento, coordenado_por, data_inic_contrato, data_fim_contrato
--  FROM AgenciaApollo.FuncionariosView WHERE tipo='Detetive' AND data_fim_contrato IS NULL
-- UNION ALL
-- SELECT '*' as tipo, CONCAT(nome,' (',genero,')') as 'Nome', NIF,CC, salario, CONCAT(porta,' ',rua,' ',distrito,' (',cod_postal,')') as 'morada', data_nascimento, coordenado_por, data_inic_contrato, data_fim_contrato
--  FROM AgenciaApollo.FuncionariosView WHERE data_fim_contrato IS NOT NULL
--  ORDER BY tipo DESC;


-- Query 6 ############################################################################################################################################################################
-- No final do ano, deve ser possível saber o nº de casos encerrados desse ano
PREPARE CasosEncerrados FROM
'SELECT COUNT(*) AS numero_de_casos_encerrados 
FROM AgenciaApollo.Caso 
WHERE estado = ''Encerrado'' AND YEAR(data_encerramento) = ?';

-- SET @data_encerramento = 2023;
-- EXECUTE CasosEncerrados USING @data_encerramento;


-- Query 7 ############################################################################################################################################################################
-- Deve ser possivel, a qualquer momento, saber a quantidade de casos que existem de acordo com a sua prioridade
PREPARE Casos_por_Prioridade FROM
'SELECT COUNT(*) as Quantidade FROM Caso
WHERE prioridade = ?';

-- SET @prioridade = 'Prioritario';
-- EXECUTE Casos_por_Prioridade USING @prioridade;


-- Query 8 ############################################################################################################################################################################
-- Deve ser possivel obter o histórico de casos de um detetive
PREPARE CasosDoDetetive FROM
'SELECT id,prioridade,preco_por_dia,data_inic,data_encerramento,rel_vitima_cliente,descricao,estado,vitima,requisitado_por,fatura
FROM AgenciaApollo.Casos_dos_Detetives
LEFT JOIN AgenciaApollo.Caso ON Caso.id=Casos_dos_Detetives.caso
WHERE detetive=? ORDER BY data_inic ASC';

-- SET @id = 3;
-- EXECUTE CasosDoDetetive USING @id;

-- Query 9 ############################################################################################################################################################################
-- Deve ser possivel , a qualquer momento, obter a documentação de cada caso
PREPARE DocumentosCaso FROM
'SELECT 
    Documento.id AS documento_id,
    Documento.descricao AS descricao_documento,
    Documento.data_emissao
FROM AgenciaApollo.Documento
WHERE Caso=?';

-- SET @caso = 1;
-- EXECUTE DocumentosCaso USING @caso;


-- Query 10 ############################################################################################################################################################################
-- Deve ser possível inserir, a qualquer momento, a documentação necessária para o decorrer das investigações
DELIMITER $$
CREATE PROCEDURE InserirDocumento(
    IN p_descricao TEXT,
    IN p_data_emissao DATE,
    IN p_caso INT,
    OUT mensagem VARCHAR(255)
)
AddDoc:BEGIN
    DECLARE last_id_doc INT;
    DECLARE erro BOOLEAN DEFAULT FALSE;
	DECLARE CONTINUE HANDLER FOR SQLException SET erro = TRUE;
    
    START TRANSACTION;
    -- Inserir o novo Documento na tabela Documento
    INSERT INTO AgenciaApollo.Documento (descricao, data_emissao, caso)
        VALUES (p_descricao, p_data_emissao, p_caso);
    
    IF(erro = TRUE) THEN
		SET mensagem = 'Erro ao adicionar o novo documento';
        ROLLBACK;
        LEAVE AddDoc;
	END IF;

    -- Obter o id do novo documento inserido
    SET last_id_doc = LAST_INSERT_ID();
    
    IF(erro = TRUE) THEN
		SET mensagem = 'Erro ao associar os Documentos ao caso';
        ROLLBACK;
        LEAVE AddDoc;
	END IF;
	COMMIT;
    SET mensagem = 'Documento inserido com sucesso.';
END $$
DELIMITER ;

-- SET @mensagem = '';
-- CALL InserirDocumento('Descrição do documento', '2024-05-25', 1, @mensagem);
-- SELECT @mensagem;



-- Query 11 ############################################################################################################################################################################
-- Deve ser possível inserir, a qualquer momento, novos envolvidos ao caso
DELIMITER $$
CREATE PROCEDURE AddEnvolvido(
    IN p_genero ENUM('F','M'),
    IN p_data_nascimento DATE,
    IN p_nome VARCHAR(45),
    IN p_CC VARCHAR(20),
    IN p_distrito VARCHAR(45),
    IN p_rua VARCHAR(45),
    IN p_porta VARCHAR(45),
    IN p_pais VARCHAR(45),
    IN p_cod_postal VARCHAR(45),
    IN caso_id INT,
    IN rel_vitima VARCHAR(45),
    IN tipo ENUM('Suspeito', 'Testemunha'),
    IN email VARCHAR(45),
    IN telefone VARCHAR(20),
    OUT mensagem VARCHAR (100)
)
AddEnv:BEGIN
	DECLARE last_id INT;
    DECLARE caso_existe INT;
    DECLARE erro BOOLEAN DEFAULT FALSE;
	DECLARE CONTINUE HANDLER FOR SQLException SET erro = TRUE;

     START TRANSACTION;
     
     SELECT COUNT(*) INTO caso_existe
	 FROM AgenciaApollo.Caso
     WHERE id = caso_id;

     IF caso_existe = 0 THEN
        SET mensagem = 'Erro ao inserir o envolvido. O caso com o id especificado não existe.';
        ROLLBACK;
        LEAVE AddEnv;
     END IF;
     
    -- Inserir o novo envolvido na tabela Envolvido
    INSERT INTO AgenciaApollo.Envolvido 
    (genero, data_nascimento, nome, CC, distrito, rua, porta, pais, cod_postal)
    VALUES
    (p_genero, p_data_nascimento, p_nome, p_CC, p_distrito, p_rua, p_porta, p_pais, p_cod_postal);
    
    IF(erro = TRUE) THEN
		SET mensagem = 'Erro ao adicionar o novo envolvido';
        ROLLBACK;
        LEAVE AddEnv;
	END IF;

    -- Obter o id do novo envolvido inserido
    SET last_id = LAST_INSERT_ID();
    
    -- Inserir a associação na tabela Envolvido_Caso
    INSERT INTO AgenciaApollo.Caso_Envolvidos (envolvido, caso, rel_vitima, tipo)
    VALUES (last_id, caso_id, rel_vitima,tipo);
    
    IF(erro = TRUE) THEN
		SET mensagem = 'Erro ao associar os envolvidos ao caso';
        ROLLBACK;
        LEAVE AddEnv;
	END IF;
   
    -- Inserir os emails ao envolvido
    INSERT INTO AgenciaApollo.Envolvidos_Email(email,envolvido) 
    VALUES(email,last_id);
    
    IF(erro = TRUE) THEN
		SET mensagem = 'Erro ao inserir os emails do envolvido';
        ROLLBACK;
        LEAVE AddEnv;
	END IF;

    -- Inserir os contactos ao envolvido
    INSERT INTO AgenciaApollo.Envolvidos_Telefone(telefone,envolvido)
    VALUES(telefone,last_id);
    
	IF(erro = TRUE) THEN
		SET mensagem = 'Erro ao inserir os contactos do envolvido';
        ROLLBACK;
        LEAVE AddEnv;
	END IF;
    COMMIT;
    SET mensagem = 'Envolvido adicionado';
END $$
DELIMITER ;

-- CALL AddEnvolvido('M', '1990-05-20', 'João Silva', '12345678', 'Lisboa', 'Rua Maria Pia','12','Portugal','1350-297','10','amigo','Suspeito', "Joao1000@gmail.com",'922333444',@mensagem);
-- SELECT @mensagem;

-- seleciona os casos encerrados antes de 2020
-- SELECT *
-- FROM vwCasosEncerrados
-- WHERE YEAR(data_encerramento) < 2020;

-- Procedures para remover dados com segurança e mantendo a integridade da Base de Dados

-- Remover um funcionário ############################################################################################################################################################################

DELIMITER $$

CREATE PROCEDURE RemoverFuncionario
(IN id_func INT,OUT mensagem VARCHAR(100))
RemoveFunc: BEGIN

DECLARE erro BOOLEAN DEFAULT FALSE;
DECLARE CONTINUE HANDLER FOR SQLException SET erro = TRUE;

START TRANSACTION;

IF NOT EXISTS (SELECT * FROM AgenciaApollo.Funcionario WHERE id = id_func) THEN
	SET mensagem = 'Funcionário não encontrado';
    ROLLBACK;
    LEAVE RemoveFunc;
END IF;

-- Remover todas as suas participações nos casos
DELETE FROM AgenciaApollo.Casos_dos_Detetives WHERE detetive = id_func;

IF (erro = TRUE) THEN
	SET mensagem = 'Erro ao remover Funcionário dos seus casos associados';
    ROLLBACK;
    LEAVE RemoveFunc;
END IF;

-- Remover todos os emails do funcionario
DELETE FROM AgenciaApollo.funcionario_emails WHERE funcionario = id_func;

IF (erro = TRUE) THEN
	SET mensagem = 'Erro ao remover Emails do Funcionário';
    ROLLBACK;
    LEAVE RemoveFunc;
END IF;

-- Remover todos os telefones do funcionario
DELETE FROM AgenciaApollo.funcionarios_telemoveis WHERE funcionario = id_func;

IF (erro = TRUE) THEN
	SET mensagem = 'Erro ao remover Telefones do Funcionário';
    ROLLBACK;
    LEAVE RemoveFunc;
END IF;

-- Todos os funcionarios que eram coordenados por ele, coloca o coordenado_por a NULL
UPDATE AgenciaApollo.Funcionario set coordenado_por = NULL WHERE coordenado_por = id_func;

IF (erro = TRUE) THEN
	SET mensagem = 'Erro ao remover Funcionário como coordenador';
    ROLLBACK;
    LEAVE RemoveFunc;
END IF;

DELETE FROM AgenciaApollo.Funcionario f WHERE f.id = id_func;

IF (erro = TRUE) THEN
	SET mensagem = 'Erro ao remover Funcionário';
    ROLLBACK;
    LEAVE RemoveFunc;
END IF;

COMMIT;
SET mensagem = 'Funcionário Removido';

END $$

DELIMITER ;

-- DROP PROCEDURE RemoverFuncionario

-- CALL RemoverFuncionario(3,@msg);
-- select @msg;

-- Remover um Envolvido ############################################################################################################################################################################

DELIMITER $$

CREATE PROCEDURE RemoverEnvolvido
(IN id_env INT,OUT mensagem VARCHAR(100))
RemoveEnv: BEGIN

DECLARE erro BOOLEAN DEFAULT FALSE;
DECLARE CONTINUE HANDLER FOR SQLException SET erro = TRUE;

START TRANSACTION;

IF NOT EXISTS (SELECT * FROM AgenciaApollo.Envolvido WHERE id = id_env) THEN
	SET mensagem = 'Envolvido não encontrado';
    ROLLBACK;
    LEAVE RemoveEnv;
END IF;

-- Remover todas as suas participações nos casos
DELETE FROM AgenciaApollo.Caso_Envolvidos WHERE envolvido = id_env;

IF (erro = TRUE) THEN
	SET mensagem = 'Erro ao remover Envolvido dos seus casos associados';
    ROLLBACK;
    LEAVE RemoveEnv;
END IF;

-- Remover todos os emails do funcionario
DELETE FROM AgenciaApollo.envolvidos_email WHERE envolvido = id_env;

IF (erro = TRUE) THEN
	SET mensagem = 'Erro ao remover Emails do Envolvido';
    ROLLBACK;
    LEAVE RemoveEnv;
END IF;

-- Remover todos os telefones do funcionario
DELETE FROM AgenciaApollo.envolvidos_telefone WHERE envolvido = id_env;

IF (erro = TRUE) THEN
	SET mensagem = 'Erro ao remover Telefones do Envolvido';
    ROLLBACK;
    LEAVE RemoveEnv;
END IF;

-- Remover Envolvido
DELETE FROM AgenciaApollo.Envolvido WHERE id = id_env;

IF (erro = TRUE) THEN
	SET mensagem = 'Erro ao remover Envolvido';
    ROLLBACK;
    LEAVE RemoveEnv;
END IF;

COMMIT;
SET mensagem = 'Envolvido Removido';

END $$

DELIMITER ;

-- CALL RemoverEnvolvido(3,@msg);
-- select @msg;

-- Remover um Caso ############################################################################################################################################################################

DELIMITER $$

CREATE PROCEDURE RemoverCaso
(IN id_caso INT,OUT mensagem VARCHAR(100))
RemoveCaso: BEGIN

DECLARE fatura_n INT;
DECLARE erro BOOLEAN DEFAULT FALSE;
DECLARE CONTINUE HANDLER FOR SQLException SET erro = TRUE;

START TRANSACTION;

IF NOT EXISTS (SELECT * FROM AgenciaApollo.Caso WHERE id = id_caso) THEN
	SET mensagem = 'Caso não encontrado';
    ROLLBACK;
    LEAVE RemoveCaso;
END IF;

-- Remover todas as suas observações
DELETE FROM AgenciaApollo.Caso_Observacoes WHERE caso_id = id_caso;

IF (erro = TRUE) THEN
	SET mensagem = 'Erro ao remover Observações do caso indicado';
    ROLLBACK;
    LEAVE RemoveCaso;
END IF;

-- Remover todos as associações dos envolvidos
DELETE FROM AgenciaApollo.Caso_Envolvidos WHERE caso = id_caso;

IF (erro = TRUE) THEN
	SET mensagem = 'Erro ao remover Envolvidos desse caso';
    ROLLBACK;
    LEAVE RemoveCaso;
END IF;

-- Remover todos as associações dos detetives
DELETE FROM AgenciaApollo.Casos_dos_Detetives WHERE caso = id_caso;

IF (erro = TRUE) THEN
	SET mensagem = 'Erro ao remover Detetives desse caso';
    ROLLBACK;
    LEAVE RemoveCaso;
END IF;

-- Remover todos as associações das provas
DELETE FROM AgenciaApollo.Caso_Provas WHERE caso = id_caso;

IF (erro = TRUE) THEN
	SET mensagem = 'Erro ao remover Provas desse caso';
    ROLLBACK;
    LEAVE RemoveCaso;
END IF;

-- Remover todos as associações dos envolvidos
DELETE FROM AgenciaApollo.Documento WHERE caso = id_caso;

IF (erro = TRUE) THEN
	SET mensagem = 'Erro ao remover Documentos desse caso';
    ROLLBACK;
    LEAVE RemoveCaso;
END IF;

-- Remover todos as associações dos envolvidos
IF EXISTS (SELECT fatura FROM AgenciaApollo.Caso WHERE id = id_caso) THEN
SELECT fatura INTO fatura_n FROM AgenciaApollo.Caso WHERE id = id_caso;
UPDATE AgenciaApollo.Caso SET fatura = NULL WHERE id = id_caso;
DELETE FROM AgenciaApollo.Fatura WHERE n_fatura = fatura_n;

IF (erro = TRUE) THEN
	SET mensagem = 'Erro ao remover Fatura desse caso';
    ROLLBACK;
    LEAVE RemoveCaso;
END IF;
END IF;

-- Remover o Caso
DELETE FROM AgenciaApollo.Caso WHERE id = id_caso;

IF (erro = TRUE) THEN
	SET mensagem = 'Erro ao remover o Caso';
    ROLLBACK;
    LEAVE RemoveCaso;
END IF;

COMMIT;
SET mensagem = 'Caso Removido';

END $$

DELIMITER ;

-- CALL RemoverCaso(1,@msg);
-- select @msg;

-- Remover uma Vítima ############################################################################################################################################################################

DELIMITER $$

CREATE PROCEDURE RemoverVitima
(IN id_vit INT,OUT mensagem VARCHAR(100))
RemoveVit: BEGIN

DECLARE erro BOOLEAN DEFAULT FALSE;
DECLARE ciclo_terminado INT DEFAULT 0;
DECLARE caso_id INT;
DECLARE curs CURSOR FOR SELECT id FROM AgenciaApollo.Caso WHERE vitima = id_vit;
DECLARE CONTINUE HANDLER FOR SQLException SET erro = TRUE;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET ciclo_terminado = 1;

START TRANSACTION;

IF NOT EXISTS (SELECT * FROM AgenciaApollo.Vitima WHERE id = id_vit) THEN
	SET mensagem = 'Vítima não encontrada';
    ROLLBACK;
    LEAVE RemoveVit;
END IF;

-- Iniciar ciclo para remover todos os casos com essa vítima
    OPEN curs;

    ciclo: LOOP
        FETCH curs INTO caso_id;
        IF ciclo_terminado = 1 THEN
            LEAVE ciclo;
        END IF;

        -- Chama o procedimento RemoveCaso para cada id_caso
        CALL RemoverCaso(caso_id,@mensagem_caso);
        
		IF erro THEN
            SET mensagem = CONCAT('Erro ao remover caso id: ', caso_id,' (',@mensagem_caso,')');
            ROLLBACK;
            LEAVE RemoveVit;
        END IF;
        
    END LOOP;

    CLOSE curs;

IF (erro = TRUE) THEN
	SET mensagem = 'Erro ao remover Casos da vítima';
    ROLLBACK;
    LEAVE RemoveVit;
END IF;

-- Remover todos os emails da vítima
DELETE FROM AgenciaApollo.Vitima_Email WHERE vitima = id_vit;

IF (erro = TRUE) THEN
	SET mensagem = 'Erro ao remover Emails da vítima';
    ROLLBACK;
    LEAVE RemoveVit;
END IF;

-- Remover todos os telefones da vítima
DELETE FROM AgenciaApollo.Vitima_Telefone WHERE vitima = id_vit;

IF (erro = TRUE) THEN
	SET mensagem = 'Erro ao remover Telefones da vítima';
    ROLLBACK;
    LEAVE RemoveVit;
END IF;

-- Remover Vítima
DELETE FROM AgenciaApollo.Vitima WHERE id = id_vit;

IF (erro = TRUE) THEN
	SET mensagem = 'Erro ao remover Vítima';
    ROLLBACK;
    LEAVE RemoveVit;
END IF;

COMMIT;
SET mensagem = 'Vítima Removida';

END $$

DELIMITER ;

-- CALL RemoverVitima(4,@msg);
-- select @msg;

-- Remover um Cliente ############################################################################################################################################################################

DELIMITER $$

CREATE PROCEDURE RemoverCliente
(IN id_cli INT,OUT mensagem VARCHAR(100))
RemoveCli: BEGIN

DECLARE erro BOOLEAN DEFAULT FALSE;
DECLARE ciclo_terminado INT DEFAULT 0;
DECLARE caso_id INT;
DECLARE curs CURSOR FOR SELECT id FROM AgenciaApollo.Caso WHERE requisitado_por = id_cli;
DECLARE CONTINUE HANDLER FOR SQLException SET erro = TRUE;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET ciclo_terminado = 1;

START TRANSACTION;

IF NOT EXISTS (SELECT * FROM AgenciaApollo.Cliente WHERE id = id_cli) THEN
	SET mensagem = 'Cliente não encontrado';
    ROLLBACK;
    LEAVE RemoveCli;
END IF;

-- Iniciar ciclo para remover todos os casos com essa vítima
    OPEN curs;

    ciclo: LOOP
        FETCH curs INTO caso_id;
        IF ciclo_terminado = 1 THEN
            LEAVE ciclo;
        END IF;

        -- Chama o procedimento RemoveCaso para cada id_caso
        CALL RemoverCaso(caso_id,@mensagem_caso);
        
		IF erro THEN
            SET mensagem = CONCAT('Erro ao remover caso id: ', caso_id,' (',@mensagem_caso,')');
            ROLLBACK;
            LEAVE RemoveCli;
        END IF;
        
    END LOOP;

    CLOSE curs;

IF (erro = TRUE) THEN
	SET mensagem = 'Erro ao remover Casos do cliente';
    ROLLBACK;
    LEAVE RemoveCli;
END IF;

-- Remover todos os emails do cliente
DELETE FROM AgenciaApollo.Cliente_Email WHERE cliente = id_cli;

IF (erro = TRUE) THEN
	SET mensagem = 'Erro ao remover Emails do cliente';
    ROLLBACK;
    LEAVE RemoveCli;
END IF;

-- Remover todos os telefones do cliente
DELETE FROM AgenciaApollo.Cliente_Telefone WHERE cliente = id_cli;

IF (erro = TRUE) THEN
	SET mensagem = 'Erro ao remover Telefones do cliente';
    ROLLBACK;
    LEAVE RemoveCli;
END IF;

-- Remover Cliente
DELETE FROM AgenciaApollo.Cliente WHERE id = id_cli;

IF (erro = TRUE) THEN
	SET mensagem = 'Erro ao remover cliente';
    ROLLBACK;
    LEAVE RemoveCli;
END IF;

COMMIT;
SET mensagem = 'Cliente Removido';

END $$

DELIMITER ;

-- CALL RemoverCliente(6,@msg);
-- select @msg;

-- Remover uma Fatura ############################################################################################################################################################################

DELIMITER $$

CREATE PROCEDURE RemoverFatura
(IN id_fat INT,OUT mensagem VARCHAR(100))
RemoveFat: BEGIN

DECLARE erro BOOLEAN DEFAULT FALSE;
DECLARE CONTINUE HANDLER FOR SQLException SET erro = TRUE;

START TRANSACTION;

IF NOT EXISTS (SELECT * FROM AgenciaApollo.Fatura WHERE n_fatura = id_fat) THEN
	SET mensagem = 'Fatura não encontrada';
    ROLLBACK;
    LEAVE RemoveFat;
END IF;

-- Remover Faturas dos casos
UPDATE AgenciaApollo.Caso SET fatura=NULL WHERE fatura = id_fat;

IF (erro = TRUE) THEN
	SET mensagem = 'Erro ao remover fatura dos casos';
    ROLLBACK;
    LEAVE RemoveFat;
END IF;

-- Remover Fatura
DELETE FROM AgenciaApollo.Fatura WHERE n_fatura = id_fat;

IF (erro = TRUE) THEN
	SET mensagem = 'Erro ao remover fatura';
    ROLLBACK;
    LEAVE RemoveFat;
END IF;

COMMIT;
SET mensagem = 'Fatura Removida';

END $$

DELIMITER ;

-- CALL RemoverFatura(10,@msg);
-- select @msg;

-- Remover um Documento ############################################################################################################################################################################

DELIMITER $$

CREATE PROCEDURE RemoverDocumento
(IN id_doc INT,OUT mensagem VARCHAR(100))
RemoveDoc: BEGIN

DECLARE erro BOOLEAN DEFAULT FALSE;
DECLARE CONTINUE HANDLER FOR SQLException SET erro = TRUE;

START TRANSACTION;

IF NOT EXISTS (SELECT * FROM AgenciaApollo.Documento WHERE id = id_doc) THEN
	SET mensagem = 'Documento não encontrado';
    ROLLBACK;
    LEAVE RemoveDoc;
END IF;

-- Remover Fatura
DELETE FROM AgenciaApollo.Documento WHERE id = id_doc;

IF (erro = TRUE) THEN
	SET mensagem = 'Erro ao remover documento';
    ROLLBACK;
    LEAVE RemoveDoc;
END IF;

COMMIT;
SET mensagem = 'Documento Removido';

END $$

DELIMITER ;

-- CALL RemoverDocumento(4,@msg);
-- select @msg;

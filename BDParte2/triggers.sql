-- triggers

-- Trigger que atualiza o salário de um funcionario quando ele é associado a um caso
-- Inserir um Detetive a um Caso ############################################################################################################################################################################
DELIMITER $$

CREATE TRIGGER atualizaSalarioDetetivesInserir 
	AFTER INSERT ON AgenciaApollo.Casos_dos_Detetives
    FOR EACH ROW
BEGIN
	
 DECLARE numero INT;
 SELECT salario INTO numero FROM AgenciaApollo.FuncionariosView WHERE id=NEW.detetive;
	SET numero = numero + 50;
		UPDATE AgenciaApollo.Funcionario SET salario=numero WHERE id=NEW.detetive;
    
END $$

DELIMITER ;

-- Remover um detetive de um caso ############################################################################################################################################################################

DELIMITER $$

CREATE TRIGGER atualizaSalarioDetetivesApagar 
	AFTER DELETE ON AgenciaApollo.Casos_dos_Detetives
    FOR EACH ROW
BEGIN
	
 DECLARE numero INT;
 SELECT salario INTO numero FROM AgenciaApollo.FuncionariosView WHERE id=OLD.detetive;
	SET numero = numero - 50;
		UPDATE AgenciaApollo.Funcionario SET salario=numero WHERE id=OLD.detetive;
    
END $$

DELIMITER ;

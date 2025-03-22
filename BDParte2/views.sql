-- Views

-- ############################################################################################################################################################################
-- Listar todos os contactos
CREATE VIEW Contactos AS
SELECT 'Email' as tipo,'F' as origem,funcionario as id, email as 'contacto' FROM AgenciaApollo.Funcionario_Emails -- Funcionários
UNION ALL
SELECT 'Telefone' as tipo,'F' as origem,funcionario as id, telefone as 'contacto' FROM AgenciaApollo.Funcionarios_Telemoveis
UNION ALL
SELECT 'Email' as tipo,'C' as origem,cliente as id, email as 'contacto' FROM AgenciaApollo.Cliente_Email -- Clientes
UNION ALL
SELECT 'Telefone' as tipo,'C' as origem,cliente as id, telefone as 'contacto' FROM AgenciaApollo.Cliente_Telefone
UNION ALL
SELECT 'Email' as tipo,'V' as origem,vitima as id, email as 'contacto' FROM AgenciaApollo.Vitima_Email -- Vitimas
UNION ALL
SELECT 'Telefone' as tipo,'V' as origem,vitima as id, telefone as 'contacto' FROM AgenciaApollo.Vitima_Telefone
UNION ALL
SELECT 'Email' as tipo,'E' as origem,envolvido as id, email as 'contacto' FROM AgenciaApollo.Envolvidos_Email -- Envolvidos
UNION ALL
SELECT 'Telefone' as tipo,'E' as origem,envolvido as id, telefone as 'contacto' FROM AgenciaApollo.Envolvidos_Telefone;
-- DROP VIEW Contactos;

-- ############################################################################################################################################################################
-- Listar todos os funcionários adicionando a idade
CREATE VIEW FuncionariosView AS
SELECT id, genero, NIF, salario,tipo, cod_postal, distrito, rua, porta, data_inic_contrato, data_fim_contrato, nome, data_nascimento,
    (TIMESTAMPDIFF(YEAR,data_nascimento,CURDATE())) AS idade,
	CC,coordenado_por
    FROM AgenciaApollo.Funcionario;
-- DROP VIEW FuncionariosView

-- ############################################################################################################################################################################
-- Listar todos os envolvidos adicionando a idade
CREATE VIEW EnvolvidosView AS
SELECT id, genero, data_nascimento,
    (TIMESTAMPDIFF(YEAR,data_nascimento,CURDATE())) AS idade,
	nome, CC, distrito, rua, porta, pais, cod_postal
    FROM AgenciaApollo.Envolvido;
-- DROP VIEW FuncionariosView

-- ############################################################################################################################################################################
-- listar todas as informações dos casos
CREATE VIEW infoCaso AS
SELECT 'D' as Modelo , caso AS 'Caso', Documento.descricao AS 'Descricao', NULL AS 'Tipo'
FROM AgenciaApollo.Documento 
JOIN AgenciaApollo.Caso ON AgenciaApollo.Documento.caso = AgenciaApollo.Caso.id
UNION ALL
SELECT 'P' AS Modelo, Caso_provas.caso AS 'Caso', Prova.descricao AS 'Descricao', tipo AS 'Tipo'
FROM AgenciaApollo.Caso_provas 
JOIN AgenciaApollo.Prova ON AgenciaApollo.Prova.id = AgenciaApollo.Caso_provas.prova
UNION ALL
SELECT 'O' AS Modelo, Caso_Observacoes.caso_id AS 'Caso',AgenciaApollo.Caso_Observacoes.observacao AS 'Descrição', NULL AS 'Tipo'
FROM  AgenciaApollo.Caso_Observacoes 
JOIN AgenciaApollo.Caso ON AgenciaApollo.Caso.id = AgenciaApollo.Caso_Observacoes.caso_id;

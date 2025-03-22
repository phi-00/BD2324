-- Verificar os utilizadores ############################################################################################################################################################################
SELECT User, Host FROM mysql.User WHERE Host = 'localhost';

-- Ver as Tabelas ############################################################################################################################################################################
SELECT * FROM AgenciaApollo.Funcionario;
SELECT * FROM AgenciaApollo.Funcionarios_Telemoveis;
SELECT * FROM AgenciaApollo.Funcionario_Emails;
SELECT * FROM AgenciaApollo.Casos_dos_Detetives;
SELECT * FROM AgenciaApollo.Documento;
SELECT * FROM AgenciaApollo.Prova;
SELECT * FROM AgenciaApollo.Caso_Provas;
SELECT * FROM AgenciaApollo.Cliente;
SELECT * FROM AgenciaApollo.Cliente_Email;
SELECT * FROM AgenciaApollo.Cliente_Telefone;
SELECT * FROM AgenciaApollo.Fatura;
SELECT * FROM AgenciaApollo.Vitima;
SELECT * FROM AgenciaApollo.Vitima_Email;
SELECT * FROM AgenciaApollo.Vitima_Telefone;
SELECT * FROM AgenciaApollo.Envolvido;
SELECT * FROM AgenciaApollo.Envolvidos_Email;
SELECT * FROM AgenciaApollo.Envolvidos_Telefone;
SELECT * FROM AgenciaApollo.Caso_Envolvidos;
SELECT * FROM AgenciaApollo.Caso;
SELECT * FROM AgenciaApollo.Caso_Observacoes;

-- Ver as Views ############################################################################################################################################################################
SELECT * FROM FuncionariosView;
SELECT * FROM EnvolvidosView;
SELECT * FROM Contactos;
SELECT * FROM infoCaso;

-- Queries ############################################################################################################################################################################

-- Query 1
-- Deve ser possível obter a ficha de identificação de cada envolvido no caso
SET @id_caso = 10;
-- Executar a instrução preparada com o parâmetro
EXECUTE FichaEnvolvido USING @id_caso;



-- Query 2
-- Deve ser possível obter o tempo de duração da resolução de cada caso, fazendo a diferença entre a data de fim e a data de ínicio
SET @caso=21;
EXECUTE Duracao_Caso USING @caso;



-- Query 3 
-- Deve ser possível obter, a qualquer momento, a informação associada a cada prova envolvida num dado caso
SET @id_caso = 9;
-- Executar a instrução preparada com o parâmetro
EXECUTE ProvaInfo USING @id_caso;



-- Query 4 
-- Deve ser possível, a qualquer momento, inserir ou remover alguma prova relativa a um dado caso
CALL AddProva(100, 'Relatório de análise de ADN de mancha de sangue encontrada na casa da vítima', '2020-02-02', 'Análises', NULL, NULL, NULL, NULL, 12, @mensagem);
SELECT @mensagem;
SELECT * FROM Prova;

CALL RemoveProva(16, @mensagem);
SELECT @mensagem;
SELECT * FROM Prova;
SELECT * FROM Caso_Provas;

-- Query 5 
-- Deve ser possivel ter acesso à lista de todos os funcionários da agência
SELECT 'A' as tipo, CONCAT(nome,' (',genero,')') as 'Nome', NIF,CC, salario, CONCAT(porta,' ',rua,' ',distrito,' (',cod_postal,')') as 'morada', data_nascimento, coordenado_por, data_inic_contrato, data_fim_contrato
FROM AgenciaApollo.FuncionariosView WHERE tipo='Administrador' AND data_fim_contrato IS NULL
UNION
SELECT 'D' as tipo, CONCAT(nome,' (',genero,')') as 'Nome', NIF,CC, salario, CONCAT(porta,' ',rua,' ',distrito,' (',cod_postal,')') as 'morada', data_nascimento, coordenado_por, data_inic_contrato, data_fim_contrato
 FROM AgenciaApollo.FuncionariosView WHERE tipo='Detetive' AND data_fim_contrato IS NULL
UNION ALL
SELECT '*' as tipo, CONCAT(nome,' (',genero,')') as 'Nome', NIF,CC, salario, CONCAT(porta,' ',rua,' ',distrito,' (',cod_postal,')') as 'morada', data_nascimento, coordenado_por, data_inic_contrato, data_fim_contrato
 FROM AgenciaApollo.FuncionariosView WHERE data_fim_contrato IS NOT NULL
 ORDER BY tipo DESC;



-- Query 6 
-- No final do ano, deve ser possível saber o nº de casos encerrados desse ano
SET @data_encerramento = 2023;
EXECUTE CasosEncerrados USING @data_encerramento;



-- Query 7
-- Deve ser possivel, a qualquer momento, saber a quantidade de casos que existem de acordo com a sua prioridade
SET @prioridade = 'Prioritario';
EXECUTE Casos_por_Prioridade USING @prioridade;



-- Query 8 
-- Deve ser possivel obter o histórico de casos de um detetive
SET @id = 3;
EXECUTE CasosDoDetetive USING @id;



-- Query 9
-- Deve ser possivel , a qualquer momento, obter a documentação de cada caso
SET @caso = 1;
EXECUTE DocumentosCaso USING @caso;



-- Query 10
-- Deve ser possível inserir, a qualquer momento, a documentação necessária para o decorrer das investigações
CALL InserirDocumento('Descrição do documento', '2024-05-25', 1, @mensagem);
SELECT @mensagem;

SELECT * FROM Documento;

-- Query 11
-- Deve ser possível inserir, a qualquer momento, novos envolvidos ao caso
CALL AddEnvolvido('M', '1990-05-20', 'João Silva', '12345678', 'Lisboa', 'Rua Maria Pia','12','Portugal','1350-297','10','amigo','Suspeito', "Joao1000@gmail.com",'922333444',@mensagem);
SELECT @mensagem;



-- Ver as Funções ############################################################################################################################################################################
-- Calcular o preço de um caso (util para o calculo da fatura)
SET @preco = calculaPrecoCaso(19);
SELECT @preco;



-- Ver as Procedures ############################################################################################################################################################################

-- Remover um Funcionário
CALL RemoverFuncionario(3,@msg);
select @msg;

-- Remover um Envolvido
CALL RemoverEnvolvido(3,@msg);
select @msg;

-- Remover um Caso
CALL RemoverCaso(1,@msg);
select @msg;

-- Remover uma Vítima
CALL RemoverVitima(4,@msg);
select @msg;

-- Remover um Cliente
CALL RemoverCliente(6,@msg);
select @msg;

-- Remover uma Fatura
CALL RemoverFatura(10,@msg);
select @msg;

-- Remover um Documento
CALL RemoverDocumento(4,@msg);
select @msg;


-- Index ############################################################################################################################################################################

SHOW INDEX FROM AgenciaApollo.Caso;
SHOW INDEX FROM AgenciaApollo.Fatura;

SELECT * FROM AgenciaApollo.Caso WHERE prioridade = 'Urgente';
SELECT * FROM AgenciaApollo.Caso WHERE data_inic = '2024-05-01';
SELECT * FROM AgenciaApollo.Caso ORDER BY data_inic;
SELECT * FROM AgenciaApollo.Caso WHERE data_inic BETWEEN '2020-01-01' AND '2022-01-01';
SELECT * FROM AgenciaApollo.Fatura WHERE metodo_pagamento = 'Dinheiro';
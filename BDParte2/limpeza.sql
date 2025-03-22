-- SCRIPT para limpeza da Base de Dados

-- Limpeza dos dados das tabelas
DELETE FROM AgenciaApollo.Caso_Envolvidos;
DELETE FROM AgenciaApollo.Caso_Provas;
DELETE FROM AgenciaApollo.Documento;
DELETE FROM AgenciaApollo.Casos_dos_Detetives;
DELETE FROM AgenciaApollo.Caso_Observacoes;
DELETE FROM AgenciaApollo.Caso;
DELETE FROM AgenciaApollo.Envolvidos_Telefone;
DELETE FROM AgenciaApollo.Envolvidos_Email;
DELETE FROM AgenciaApollo.Envolvido;
DELETE FROM AgenciaApollo.Vitima_Telefone;
DELETE FROM AgenciaApollo.Vitima_Email;
DELETE FROM AgenciaApollo.Vitima;
DELETE FROM AgenciaApollo.Fatura;
DELETE FROM AgenciaApollo.Cliente_Telefone;
DELETE FROM AgenciaApollo.Cliente_Email;
DELETE FROM AgenciaApollo.Cliente;
DELETE FROM AgenciaApollo.Prova;
DELETE FROM AgenciaApollo.Funcionario_Emails;
DELETE FROM AgenciaApollo.Funcionarios_Telemoveis; 
UPDATE AgenciaApollo.Funcionario SET coordenado_por = NULL;
DELETE FROM AgenciaApollo.Funcionario;

-- Limpeza dos Triggers
DROP TRIGGER IF EXISTS atualizaSalarioDetetivesInserir;
DROP TRIGGER IF EXISTS atualizaSalarioDetetivesApagar;

-- Limpeza dos Indices
DROP INDEX idx_prioridade ON AgenciaApollo.Caso;
DROP INDEX idx_dataInicio ON AgenciaApollo.Caso;
DROP INDEX idx_pagamento ON AgenciaApollo.Fatura;

-- Limpeza das Tabelas
DROP TABLE IF EXISTS AgenciaApollo.Caso_Provas;
DROP TABLE IF EXISTS AgenciaApollo.Prova;
DROP TABLE IF EXISTS AgenciaApollo.Documento;
DROP TABLE IF EXISTS AgenciaApollo.Caso_Envolvidos;
DROP TABLE IF EXISTS AgenciaApollo.Casos_dos_Detetives;
DROP TABLE IF EXISTS AgenciaApollo.Caso_Observacoes;
DROP TABLE IF EXISTS AgenciaApollo.Caso;
DROP TABLE IF EXISTS AgenciaApollo.Funcionarios_Telemoveis;
DROP TABLE IF EXISTS AgenciaApollo.Funcionario_Emails;
DROP TABLE IF EXISTS AgenciaApollo.Funcionario;
DROP TABLE IF EXISTS AgenciaApollo.Envolvidos_Telefone;
DROP TABLE IF EXISTS AgenciaApollo.Envolvidos_Email;
DROP TABLE IF EXISTS AgenciaApollo.Envolvido;
DROP TABLE IF EXISTS AgenciaApollo.Vitima_Telefone;
DROP TABLE IF EXISTS AgenciaApollo.Vitima_Email;
DROP TABLE IF EXISTS AgenciaApollo.Vitima;
DROP TABLE IF EXISTS AgenciaApollo.Fatura;
DROP TABLE IF EXISTS AgenciaApollo.Cliente_Telefone;
DROP TABLE IF EXISTS AgenciaApollo.Cliente_Email;
DROP TABLE IF EXISTS AgenciaApollo.Cliente;

-- Limpeza das Views
DROP VIEW IF EXISTS Contactos;
DROP VIEW IF EXISTS FuncionariosView;
DROP VIEW IF EXISTS EnvolvidosView;
DROP VIEW IF EXISTS infoCaso;

-- Limpeza das Queries
DEALLOCATE PREPARE  FichaEnvolvido; -- Q1
DEALLOCATE PREPARE Duracao_Caso; -- Q2
DEALLOCATE PREPARE ProvaInfo; -- Q3
DROP PROCEDURE IF EXISTS AddProva; -- Q4
DROP PROCEDURE IF EXISTS RemoveProva; -- Q4
DEALLOCATE PREPARE CasosEncerrados; -- Q6
DEALLOCATE PREPARE Casos_por_Prioridade; -- Q7
DEALLOCATE PREPARE CasosDoDetetive; -- Q8
DEALLOCATE PREPARE DocumentosCaso; -- Q9
DROP PROCEDURE IF EXISTS InserirDocumento; -- Q10
DROP PROCEDURE IF EXISTS AddEnvolvido; -- Q11

-- Limpeza das Funções
DROP FUNCTION IF EXISTS calculaPrecoCaso;

-- Limpeza dos Procedures
DROP PROCEDURE IF EXISTS RemoverFuncionario;
DROP PROCEDURE IF EXISTS RemoverEnvolvido;
DROP PROCEDURE IF EXISTS RemoverCaso;
DROP PROCEDURE IF EXISTS RemoverVitima;
DROP PROCEDURE IF EXISTS RemoverCliente;
DROP PROCEDURE IF EXISTS RemoverFatura;
DROP PROCEDURE IF EXISTS RemoverDocumento;

-- Limpeza da Base de Dados
DROP DATABASE IF EXISTS AgenciaApollo;

-- Limpeza dos utilizadores
DROP USER IF EXISTS 'admin'@'localhost', 'detetive'@'localhost', 'administrador'@'localhost';

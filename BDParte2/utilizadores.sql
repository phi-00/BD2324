-- Utilizadores: Criação, alteração e remoção de utilizadores e as suas permissões.

-- Usar a base de dados de trabalho
USE AgenciaApollo;

-- Remover os utilizadores se já existirem
DROP USER IF EXISTS 'admin'@'localhost';
DROP USER IF EXISTS 'detetive'@'localhost';
DROP USER IF EXISTS 'administrador'@'localhost';

-- Criação do utilizador: administrador da base de dados
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'Admin00'; -- senha

-- Criação do utilizador: detetive da agência
CREATE USER 'detetive'@'localhost' IDENTIFIED BY 'Detetive01'; -- senha

-- Criação do utilizador: administrador da agência
CREATE USER 'administrador'@'localhost' IDENTIFIED BY 'Administrador01'; -- senha

-- Atribuição de privilégios aos utilizadores

-- Administrador da base de dados
GRANT ALL ON *.* TO 'admin'@'localhost'; 

-- Administrador da agência

GRANT SELECT, INSERT, UPDATE, DELETE ON AgenciaApollo.Funcionario TO 'administrador'@'localhost';

GRANT INSERT ON AgenciaApollo.Fatura TO 'administrador'@'localhost';

GRANT SELECT, INSERT, UPDATE, DELETE ON AgenciaApollo.Documento TO 'administrador'@'localhost';

-- Detetive
GRANT SELECT, INSERT, UPDATE ON AgenciaApollo.Caso TO 'detetive'@'localhost';

GRANT SELECT, INSERT, UPDATE, DELETE ON AgenciaApollo.Prova TO 'detetive'@'localhost';

-- Verificar os utilizadores
-- SELECT User, Host FROM mysql.User WHERE Host = 'localhost';

-- Recarregar os privilégios
FLUSH PRIVILEGES;

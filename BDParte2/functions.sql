-- Functions

-- Função que calcula o preço de um caso ############################################################################################################################################################################
DELIMITER $$
CREATE FUNCTION calculaPrecoCaso(id_caso INT)
RETURNS INT
BEGIN
DECLARE preco INT;

IF NOT EXISTS (SELECT * FROM AgenciaApollo.Caso WHERE id = id_caso) THEN
RETURN 0;
END IF;

IF NOT EXISTS (SELECT data_encerramento FROM AgenciaApollo.Caso WHERE id = id_caso) THEN
RETURN 0;
END IF;

SELECT TIMESTAMPDIFF(DAY,data_inic,data_encerramento)*preco_por_dia INTO preco FROM agenciaapollo.caso WHERE id = id_caso;

RETURN preco;
END $$
DELIMITER ;

-- SET @preco = calculaPrecoCaso(19);
-- SELECT @preco;

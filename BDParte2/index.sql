CREATE INDEX idx_prioridade 
ON AgenciaApollo.Caso (prioridade);

CREATE INDEX idx_dataInicio
ON AgenciaApollo.Caso (data_inic);

CREATE INDEX idx_pagamento
ON AgenciaApollo.Fatura (metodo_pagamento);

-- SHOW INDEX FROM AgenciaApollo.Caso;
-- SHOW INDEX FROM AgenciaApollo.Fatura;

-- SELECT * FROM AgenciaApollo.Caso WHERE prioridade = 'Urgente';
-- SELECT * FROM AgenciaApollo.Caso WHERE data_inic = '2024-05-01';
-- SELECT * FROM AgenciaApollo.Caso ORDER BY data_inic;
-- SELECT * FROM AgenciaApollo.Caso WHERE data_inic BETWEEN '2020-01-01' AND '2022-01-01';
-- SELECT * FROM AgenciaApollo.Fatura WHERE metodo_pagamento = 'Dinheiro';

-- DROP INDEX idx_prioridade ON AgenciaApollo.Caso
-- DROP INDEX idx_dataInicio ON AgenciaApollo.Caso
-- DROP INDEX idx_pagamento ON AgenciaApollo.Fatura




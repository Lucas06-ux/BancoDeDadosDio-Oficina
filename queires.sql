USE oficina_dio;

-- 1) Quais clientes estão cadastrados?
SELECT idCLIENTE, NOME, CPF, DATA_NASCIMENTO
FROM CLIENTE;

-- 2) Quais ordens de serviço ainda não foram concluídas?
SELECT idORDEM_SERVICO, DATA_EMISSAO, STATUS, VALOR
FROM ORDEM_SERVICO
WHERE STATUS <> 'CONCLUIDA';

-- 3) Qual é a idade aproximada dos clientes?
SELECT
    NOME,
    DATA_NASCIMENTO,
    TIMESTAMPDIFF(YEAR, DATA_NASCIMENTO, CURDATE()) AS idade
FROM CLIENTE;

-- 4) Quais ordens de serviço possuem maior valor?
SELECT idORDEM_SERVICO, STATUS, DATA_EMISSAO, VALOR
FROM ORDEM_SERVICO
ORDER BY VALOR DESC;

-- 5) Quais veículos pertencem a cada cliente?
SELECT
    c.NOME AS cliente,
    v.PLACA,
    v.MARCA,
    v.MODELO,
    v.ANO
FROM CLIENTE c
INNER JOIN VEICULO v ON c.idCLIENTE = v.CLIENTE_idCLIENTE
ORDER BY c.NOME;

-- 6) Quantas ordens de serviço foram abertas por cliente?
SELECT
    c.NOME AS cliente,
    COUNT(os.idORDEM_SERVICO) AS total_ordens
FROM CLIENTE c
INNER JOIN VEICULO v ON c.idCLIENTE = v.CLIENTE_idCLIENTE
INNER JOIN ORDEM_SERVICO os ON v.idVEICULO = os.VEICULO_idVEICULO
GROUP BY c.idCLIENTE, c.NOME
ORDER BY total_ordens DESC;

-- 7) Quais clientes possuem mais de uma ordem de serviço?
SELECT
    c.NOME AS cliente,
    COUNT(os.idORDEM_SERVICO) AS total_ordens
FROM CLIENTE c
INNER JOIN VEICULO v ON c.idCLIENTE = v.CLIENTE_idCLIENTE
INNER JOIN ORDEM_SERVICO os ON v.idVEICULO = os.VEICULO_idVEICULO
GROUP BY c.idCLIENTE, c.NOME
HAVING COUNT(os.idORDEM_SERVICO) > 1;

-- 8) Qual equipe está responsável por cada ordem de serviço?
SELECT
    os.idORDEM_SERVICO,
    c.NOME AS cliente,
    v.PLACA,
    CONCAT(v.MARCA, ' ', v.MODELO) AS veiculo,
    e.NOME_EQUIPE,
    os.STATUS,
    os.VALOR
FROM ORDEM_SERVICO os
INNER JOIN VEICULO v ON os.VEICULO_idVEICULO = v.idVEICULO
INNER JOIN CLIENTE c ON v.CLIENTE_idCLIENTE = c.idCLIENTE
INNER JOIN EQUIPE e ON os.EQUIPE_idEQUIPE = e.idEQUIPE
ORDER BY os.idORDEM_SERVICO;

-- 9) Quais mecânicos fazem parte de cada equipe?
SELECT
    e.NOME_EQUIPE,
    m.NOME AS mecanico,
    m.ESPECIALIDADE
FROM EQUIPE e
INNER JOIN MECANICO m ON e.idEQUIPE = m.EQUIPE_idEQUIPE
ORDER BY e.NOME_EQUIPE, m.NOME;

-- 10) Peças utilizadas em cada ordem de serviço
SELECT
    os.idORDEM_SERVICO,
    p.DESCRICAO AS peca,
    osp.QUANTIDADE,
    p.VALOR_UNITARIO,
    (osp.QUANTIDADE * p.VALOR_UNITARIO) AS subtotal_pecas
FROM ORDEM_SERVICO os
INNER JOIN ORDEM_SERVICO_has_PECA osp
    ON os.idORDEM_SERVICO = osp.ORDEM_SERVICO_idORDEM_SERVICO
INNER JOIN PECA p ON p.idPECA = osp.PECA_idPECA
ORDER BY os.idORDEM_SERVICO;

-- 11) Serviços executados em cada ordem de serviço
SELECT
    os.idORDEM_SERVICO,
    s.DESCRICAO AS servico,
    s.VALOR
FROM ORDEM_SERVICO os
INNER JOIN ORDEM_SERVICO_has_SERVICO oss
    ON os.idORDEM_SERVICO = oss.ORDEM_SERVICO_idORDEM_SERVICO
INNER JOIN SERVICO s ON s.idSERVICO = oss.SERVICO_idSERVICO
ORDER BY os.idORDEM_SERVICO;

-- 12) Valor total detalhado de cada ordem de serviço
SELECT
    os.idORDEM_SERVICO,
    c.NOME AS cliente,
    v.PLACA,
    os.STATUS,
    COALESCE(SUM(DISTINCT s.VALOR), 0) AS total_servicos,
    COALESCE((
        SELECT SUM(p2.VALOR_UNITARIO * osp2.QUANTIDADE)
        FROM ORDEM_SERVICO_has_PECA osp2
        INNER JOIN PECA p2 ON p2.idPECA = osp2.PECA_idPECA
        WHERE osp2.ORDEM_SERVICO_idORDEM_SERVICO = os.idORDEM_SERVICO
    ), 0) AS total_pecas,
    (
        COALESCE(SUM(DISTINCT s.VALOR), 0)
        +
        COALESCE((
            SELECT SUM(p3.VALOR_UNITARIO * osp3.QUANTIDADE)
            FROM ORDEM_SERVICO_has_PECA osp3
            INNER JOIN PECA p3 ON p3.idPECA = osp3.PECA_idPECA
            WHERE osp3.ORDEM_SERVICO_idORDEM_SERVICO = os.idORDEM_SERVICO
        ), 0)
    ) AS total_calculado
FROM ORDEM_SERVICO os
INNER JOIN VEICULO v ON os.VEICULO_idVEICULO = v.idVEICULO
INNER JOIN CLIENTE c ON v.CLIENTE_idCLIENTE = c.idCLIENTE
LEFT JOIN ORDEM_SERVICO_has_SERVICO oss
    ON os.idORDEM_SERVICO = oss.ORDEM_SERVICO_idORDEM_SERVICO
LEFT JOIN SERVICO s ON s.idSERVICO = oss.SERVICO_idSERVICO
GROUP BY os.idORDEM_SERVICO, c.NOME, v.PLACA, os.STATUS
ORDER BY total_calculado DESC;

-- 13) Quais equipes possuem mais de uma OS atribuída?
SELECT
    e.NOME_EQUIPE,
    COUNT(os.idORDEM_SERVICO) AS total_ordens
FROM EQUIPE e
INNER JOIN ORDEM_SERVICO os ON e.idEQUIPE = os.EQUIPE_idEQUIPE
GROUP BY e.idEQUIPE, e.NOME_EQUIPE
HAVING COUNT(os.idORDEM_SERVICO) > 1;

-- 14) Quais peças geraram maior faturamento?
SELECT
    p.DESCRICAO,
    SUM(osp.QUANTIDADE) AS quantidade_total_usada,
    p.VALOR_UNITARIO,
    SUM(osp.QUANTIDADE * p.VALOR_UNITARIO) AS faturamento_peca
FROM PECA p
INNER JOIN ORDEM_SERVICO_has_PECA osp ON p.idPECA = osp.PECA_idPECA
GROUP BY p.idPECA, p.DESCRICAO, p.VALOR_UNITARIO
ORDER BY faturamento_peca DESC;

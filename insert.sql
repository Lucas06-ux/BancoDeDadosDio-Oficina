USE oficina_dio;

INSERT INTO CLIENTE (NOME, CPF, DATA_NASCIMENTO) VALUES
('Lucas Giannini', '123.456.789-10', '2005-08-15'),
('Maria Souza', '987.654.321-00', '1998-03-20'),
('João Oliveira', '111.222.333-44', '1990-11-05'),
('Ana Pereira', '555.666.777-88', '1985-07-12');

INSERT INTO VEICULO (PLACA, MODELO, MARCA, ANO, CLIENTE_idCLIENTE) VALUES
('ABC1D23', 'Civic', 'Honda', 2020, 1),
('XYZ9A87', 'Corolla', 'Toyota', 2019, 2),
('BRA2E45', 'Onix', 'Chevrolet', 2022, 3),
('CAR8F99', 'Fiesta', 'Ford', 2015, 4),
('LUC5G10', 'HB20', 'Hyundai', 2021, 1);

INSERT INTO EQUIPE (NOME_EQUIPE) VALUES
('Equipe Motor'),
('Equipe Elétrica'),
('Equipe Revisão Geral');

INSERT INTO MECANICO (NOME, ENDERECO, ESPECIALIDADE, EQUIPE_idEQUIPE) VALUES
('Carlos Silva', 'Rua A, 100', 'Motor', 1),
('Pedro Santos', 'Rua B, 200', 'Motor', 1),
('Fernanda Lima', 'Rua C, 300', 'Elétrica', 2),
('Ricardo Alves', 'Rua D, 400', 'Suspensão', 3),
('Mariana Costa', 'Rua E, 500', 'Revisão', 3);

INSERT INTO PECA (DESCRICAO, VALOR_UNITARIO) VALUES
('Filtro de óleo', 45.00),
('Pastilha de freio', 180.00),
('Bateria 60Ah', 420.00),
('Vela de ignição', 35.00),
('Correia dentada', 250.00),
('Óleo motor 5W30', 55.00);

INSERT INTO SERVICO (DESCRICAO, VALOR) VALUES
('Troca de óleo', 80.00),
('Revisão completa', 350.00),
('Troca de bateria', 120.00),
('Alinhamento e balanceamento', 150.00),
('Troca de correia dentada', 300.00),
('Diagnóstico elétrico', 200.00);

INSERT INTO ORDEM_SERVICO 
(DATA_EMISSAO, VALOR, STATUS, DATA_CONCLUSAO, VEICULO_idVEICULO, EQUIPE_idEQUIPE) VALUES
('2026-05-01', 0, 'CONCLUIDA', '2026-05-03', 1, 3),
('2026-05-02', 0, 'EM_ANDAMENTO', NULL, 2, 1),
('2026-05-04', 0, 'AGUARDANDO_PECA', NULL, 3, 2),
('2026-05-05', 0, 'CONCLUIDA', '2026-05-06', 4, 3),
('2026-05-07', 0, 'ABERTA', NULL, 5, 1);

INSERT INTO ORDEM_SERVICO_has_PECA VALUES
(1, 1, 1), (1, 6, 4), (2, 5, 1), (2, 4, 4),
(3, 3, 1), (4, 2, 1), (5, 4, 4);

INSERT INTO ORDEM_SERVICO_has_SERVICO VALUES
(1, 1), (1, 2), (2, 5), (3, 3), (3, 6), (4, 4), (5, 5);

UPDATE ORDEM_SERVICO os
SET VALOR = (
    COALESCE((
        SELECT SUM(p.VALOR_UNITARIO * osp.QUANTIDADE)
        FROM ORDEM_SERVICO_has_PECA osp
        INNER JOIN PECA p ON p.idPECA = osp.PECA_idPECA
        WHERE osp.ORDEM_SERVICO_idORDEM_SERVICO = os.idORDEM_SERVICO
    ), 0)
    +
    COALESCE((
        SELECT SUM(s.VALOR)
        FROM ORDEM_SERVICO_has_SERVICO oss
        INNER JOIN SERVICO s ON s.idSERVICO = oss.SERVICO_idSERVICO
        WHERE oss.ORDEM_SERVICO_idORDEM_SERVICO = os.idORDEM_SERVICO
    ), 0)
);

# Projeto Lógico de Banco de Dados — Oficina

Este projeto representa o esquema lógico de banco de dados para o contexto de uma oficina mecânica. O modelo contempla clientes, veículos, equipes, mecânicos, ordens de serviço, peças e serviços executados.

## Contexto do modelo

Um cliente pode possuir um ou mais veículos. Cada veículo pode gerar ordens de serviço. Uma ordem de serviço é atribuída a uma equipe e pode conter vários serviços e várias peças. Uma equipe possui vários mecânicos, e cada mecânico pertence a uma equipe.

## Principais entidades

- **CLIENTE:** dados dos clientes da oficina.
- **VEICULO:** veículos vinculados aos clientes.
- **EQUIPE:** grupos responsáveis pelas ordens de serviço.
- **MECANICO:** mecânicos e suas especialidades.
- **ORDEM_SERVICO:** ordens abertas para manutenção dos veículos.
- **PECA:** peças usadas nos reparos.
- **SERVICO:** serviços prestados pela oficina.
- **ORDEM_SERVICO_has_PECA:** tabela associativa entre ordens de serviço e peças.
- **ORDEM_SERVICO_has_SERVICO:** tabela associativa entre ordens de serviço e serviços.

## Arquivos

- `01_create.sql`: criação do banco, tabelas, chaves primárias, chaves estrangeiras e constraints.
- `02_insert.sql`: dados fictícios para testes.
- `03_queries.sql`: consultas com SELECT, WHERE, atributos derivados, ORDER BY, GROUP BY, HAVING e JOINs.

## Como executar

Execute no MySQL Workbench nesta ordem:

1. `01_create.sql`
2. `02_insert.sql`
3. `03_queries.sql`

# Olist Analytics API

Projeto criado com intuito de aprender SQL e construção de APIs a partir de uma pergunta que veio da minha experiência com e-commerce: quais estados concentram mais vendas em unidades e qual categoria lidera em cada um? Usei PostgreSQL para analisar os dados públicos da Olist e uma API em Node.js com Express para disponibilizar os resultados. O painel em React e TypeScript usa componentes do Material UI apenas para visualizar a resposta dessa consulta.

## O que o projeto faz

- Consulta os dados de vendas por estado no PostgreSQL.
- Identifica a categoria mais vendida em cada estado.
- Disponibiliza os resultados por meio de uma API REST.
- Apresenta o total de unidades, os cinco estados com mais vendas e uma tabela com as 27 UFs.

## Tecnologias utilizadas

- PostgreSQL e SQL
- Node.js e Express
- React e TypeScript
- Material UI

## Estrutura do projeto

```text
olist-analytics-api/
├── sql/        # Estrutura do banco e consultas SQL
├── api/        # API REST
└── frontend/   # Painel de visualização
```

## Como executar localmente

Clone o repositório:

```bash
git clone https://github.com/gustavosgm/olist-analytics-api.git
cd olist-analytics-api
```

Com o PostgreSQL instalado, crie o banco utilizando os scripts da pasta `sql/` e importe os dados da Olist. Configure a conexão da API com o banco de dados conforme o código da pasta `api/`.

Instale as dependências da API:

```bash
cd api
npm install
npm run
```

O comando `npm run` lista os scripts disponíveis no projeto. Utilize o script de inicialização da API.

Em outro terminal, na raiz do repositório, instale as dependências do front-end:

```bash
cd frontend
npm install
npm run
```

Execute o script de desenvolvimento listado e acesse o endereço informado no terminal. No ambiente local de desenvolvimento, o painel está disponível em `http://localhost:5173`.

## Resultados da análise

O painel apresenta 112.650 unidades contabilizadas na consulta, distribuídas pelas 27 unidades federativas. São Paulo lidera com 47.449 unidades, seguido pelo Rio de Janeiro e por Minas Gerais. A categoria mais vendida nesses três estados é cama, mesa e banho.

## Base de dados

O projeto utiliza o [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce), disponibilizado publicamente no Kaggle, com aproximadamente 100 mil pedidos reais de e-commerce realizados entre 2016 e 2018.

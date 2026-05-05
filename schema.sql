-- ══════════════════════════════════════════
-- A. TABELA BASE — Pessoa
-- ══════════════════════════════════════════

CREATE TABLE pessoa (
    id   SERIAL PRIMARY KEY,
    cpf  VARCHAR(14)  NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    sexo CHAR(1)      NOT NULL CHECK (sexo IN ('M', 'F', 'O')),
    data_nascimento DATE NOT NULL
);


-- ══════════════════════════════════════════
-- B. ENDEREÇO SUBATÔMICO — 1 pessoa : N endereços
-- ══════════════════════════════════════════

CREATE TABLE endereco (
    id           SERIAL PRIMARY KEY,
    pessoa_id    INTEGER NOT NULL,
    logradouro   VARCHAR(150) NOT NULL,
    numero       VARCHAR(10)  NOT NULL,
    complemento  VARCHAR(100),
    bairro       VARCHAR(100) NOT NULL,
    cidade       VARCHAR(100) NOT NULL,
    estado       CHAR(2)      NOT NULL,
    cep          VARCHAR(9)   NOT NULL,
    tipo         VARCHAR(20)  NOT NULL CHECK (tipo IN ('residencial', 'comercial', 'outro')),
    CONSTRAINT fk_endereco_pessoa
        FOREIGN KEY (pessoa_id)
        REFERENCES pessoa(id)
        ON DELETE CASCADE
);


-- ══════════════════════════════════════════
-- C. TELEFONE — 1 pessoa : N telefones
-- ══════════════════════════════════════════

CREATE TABLE telefone (
    id        SERIAL PRIMARY KEY,
    pessoa_id INTEGER NOT NULL,
    numero    VARCHAR(15) NOT NULL,
    tipo      VARCHAR(20) NOT NULL CHECK (tipo IN ('celular', 'residencial', 'comercial')),
    CONSTRAINT fk_telefone_pessoa
        FOREIGN KEY (pessoa_id)
        REFERENCES pessoa(id)
        ON DELETE CASCADE
);


-- ══════════════════════════════════════════
-- D. FUNCIONARIO — herda pessoa
--    autorelacionamento 1: supervisor
--    autorelacionamento 2: dependente
-- ══════════════════════════════════════════

CREATE TABLE funcionario (
    id            SERIAL PRIMARY KEY,
    pessoa_id     INTEGER NOT NULL UNIQUE,
    supervisor_id INTEGER,
    dependente_id INTEGER,
    CONSTRAINT fk_funcionario_pessoa
        FOREIGN KEY (pessoa_id)
        REFERENCES pessoa(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_supervisor
        FOREIGN KEY (supervisor_id)
        REFERENCES funcionario(id)
        ON DELETE SET NULL,
    CONSTRAINT fk_dependente
        FOREIGN KEY (dependente_id)
        REFERENCES funcionario(id)
        ON DELETE SET NULL
);


-- ══════════════════════════════════════════
-- E. PROJETO
-- ══════════════════════════════════════════

CREATE TABLE projeto (
    id           SERIAL PRIMARY KEY,
    nome_projeto VARCHAR(100) NOT NULL
);


-- ══════════════════════════════════════════
-- F. AGREGAÇÃO — Alocacao (Funcionario + Projeto)
-- ══════════════════════════════════════════

CREATE TABLE alocacao (
    funcionario_id INTEGER NOT NULL,
    projeto_id     INTEGER NOT NULL,
    funcao         VARCHAR(100),
    data_inicio    DATE,
    CONSTRAINT pk_alocacao
        PRIMARY KEY (funcionario_id, projeto_id),
    CONSTRAINT fk_alocacao_funcionario
        FOREIGN KEY (funcionario_id)
        REFERENCES funcionario(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_alocacao_projeto
        FOREIGN KEY (projeto_id)
        REFERENCES projeto(id)
        ON DELETE CASCADE
);


-- ══════════════════════════════════════════
-- G. AGREGAÇÃO — Equipamento vinculado a Alocacao
-- ══════════════════════════════════════════

CREATE TABLE equipamento (
    id               SERIAL PRIMARY KEY,
    nome_equipamento VARCHAR(100) NOT NULL,
    funcionario_id   INTEGER NOT NULL,
    projeto_id       INTEGER NOT NULL,
    CONSTRAINT fk_equipamento_alocacao
        FOREIGN KEY (funcionario_id, projeto_id)
        REFERENCES alocacao(funcionario_id, projeto_id)
        ON DELETE CASCADE
);

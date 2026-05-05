-- ══════════════════════════════════════════
-- A. AUTORELACIONAMENTO — Hierarquia
-- ══════════════════════════════════════════

CREATE TABLE funcionario (
    id            SERIAL PRIMARY KEY,
    nome          VARCHAR(100) NOT NULL,
    supervisor_id INTEGER REFERENCES funcionario(id) ON DELETE SET NULL
);


-- ══════════════════════════════════════════
-- B. ENTIDADE FRACA — Dependência de Existência
-- ══════════════════════════════════════════

CREATE TABLE dependente (
    id             SERIAL PRIMARY KEY,
    nome           VARCHAR(100) NOT NULL,
    funcionario_id INTEGER NOT NULL,
    CONSTRAINT fk_dependente_funcionario
        FOREIGN KEY (funcionario_id)
        REFERENCES funcionario(id)
        ON DELETE CASCADE
);


-- ══════════════════════════════════════════
-- C. ENTIDADES INDEPENDENTES
-- ══════════════════════════════════════════

CREATE TABLE projeto (
    id           SERIAL PRIMARY KEY,
    nome_projeto VARCHAR(100) NOT NULL
);


-- ══════════════════════════════════════════
-- D. AGREGAÇÃO — Relacionamento Funcionario + Projeto
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
-- E. AGREGAÇÃO — Equipamento vinculado a Alocacao
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

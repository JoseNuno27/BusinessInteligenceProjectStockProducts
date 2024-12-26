-- Remover a base de dados se já existir
DROP DATABASE IF EXISTS Grupo09;
GO

-- Criar a base de dados
CREATE DATABASE Grupo09;
GO
USE Grupo09;
GO

-- Criação e Estruturação da Base de Dados:

CREATE TABLE CategoriaProduto (
    CategoriaID INT PRIMARY KEY IDENTITY,
    NomeCategoria VARCHAR(100) NOT NULL
);
GO

CREATE TABLE Produto (
    ProdutoID INT PRIMARY KEY IDENTITY,
    NomeProduto VARCHAR(100) NOT NULL,
    Descricao VARCHAR(300),
    Preco DECIMAL(10, 2) NOT NULL,
    CategoriaID INT NOT NULL,
    FOREIGN KEY (CategoriaID) REFERENCES CategoriaProduto(CategoriaID)
);
GO
ALTER TABLE Produto
ADD QualidadeProduto DECIMAL(5, 2);
GO

CREATE TABLE Cliente (
    ClienteID INT PRIMARY KEY IDENTITY,
    Nome VARCHAR(100) NOT NULL,
    DataNascimento DATE NOT NULL,
    Endereco VARCHAR(255) NOT NULL,
    CartaoCliente BIT DEFAULT 0,
    Desconto DECIMAL(5, 2) DEFAULT 0,
    CONSTRAINT CK_Cliente_MaiorDe18 CHECK (DATEDIFF(YEAR, DataNascimento, GETDATE()) >= 18),
    CONSTRAINT CK_Cliente_Desconto_Validacao CHECK ((CartaoCliente = 0 AND Desconto = 0) OR (CartaoCliente = 1 AND Desconto >= 0))
);
GO
ALTER TABLE Cliente
ADD Pontos INT DEFAULT 0;
GO

CREATE TABLE Funcionario (
    FuncionarioID INT PRIMARY KEY IDENTITY,
    NomeFuncionario VARCHAR(100) NOT NULL,
    DataContratacao DATE NOT NULL,
    DataFinalContrato DATE DEFAULT NULL,
    Endereco VARCHAR(255) NOT NULL,
    Cargo VARCHAR(100) NOT NULL,
    Salario DECIMAL(10, 2) NOT NULL
);
GO

CREATE TABLE RegiaoVenda (
    RegiaoID INT PRIMARY KEY IDENTITY,
    NomeRegiao VARCHAR(100) NOT NULL,
    Endereco VARCHAR(300)
);
GO

CREATE TABLE CanalVenda (
    CanalID INT PRIMARY KEY IDENTITY,
    NomeCanal VARCHAR(100) NOT NULL,
    Descricao VARCHAR(300)
);
GO

CREATE TABLE Fornecedor (
    FornecedorID INT PRIMARY KEY IDENTITY,
    NomeFornecedor VARCHAR(100) NOT NULL,
    Endereco VARCHAR(255),
    Telefone VARCHAR(15)
);
GO
ALTER TABLE Fornecedor
ADD PrazoEntrega INT;
GO


CREATE TABLE ProdutosFornecedores (
    ProdutoFornecedorID INT PRIMARY KEY IDENTITY,
    ProdutoID INT NOT NULL,
    FornecedorID INT NOT NULL,
    FOREIGN KEY (ProdutoID) REFERENCES Produto(ProdutoID),
    FOREIGN KEY (FornecedorID) REFERENCES Fornecedor(FornecedorID)
);
GO

CREATE TABLE Venda (
    VendaID INT PRIMARY KEY IDENTITY,
    ClienteID INT NOT NULL,
    FuncionarioID INT NOT NULL,
    RegiaoID INT NOT NULL,
    CanalID INT NOT NULL,
    DataVenda DATE NOT NULL,
    TotalVenda DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (ClienteID) REFERENCES Cliente(ClienteID),
    FOREIGN KEY (FuncionarioID) REFERENCES Funcionario(FuncionarioID),
    FOREIGN KEY (RegiaoID) REFERENCES RegiaoVenda(RegiaoID),
    FOREIGN KEY (CanalID) REFERENCES CanalVenda(CanalID)
);
GO

CREATE TABLE DetalheVenda (
    DetalheVendaID INT PRIMARY KEY IDENTITY,
    VendaID INT NOT NULL,
    ProdutoID INT NOT NULL,
    Quantidade INT NOT NULL,
    PrecoUnitario DECIMAL(10, 2) NOT NULL,
    DescontoAplicado DECIMAL(5, 2) DEFAULT 0,
    FOREIGN KEY (VendaID) REFERENCES Venda(VendaID),
    FOREIGN KEY (ProdutoID) REFERENCES Produto(ProdutoID)
);
GO

CREATE TABLE Stock (
    StockID INT PRIMARY KEY IDENTITY,
    ProdutoID INT NOT NULL UNIQUE,
    QuantidadeDisponivel INT NOT NULL,
    NivelCritico INT NOT NULL,
    FOREIGN KEY (ProdutoID) REFERENCES Produto(ProdutoID)
);
GO

CREATE TABLE Logs (
    LogID INT PRIMARY KEY IDENTITY,
    TipoLog VARCHAR(50) NOT NULL,
    DataLog DATETIME NOT NULL,
    Descricao VARCHAR(300)
);
GO

-- Índices 
CREATE INDEX idx_Cliente_Nome ON Cliente(Nome);
CREATE INDEX idx_Cliente_DataNascimento ON Cliente(DataNascimento);

CREATE INDEX idx_Produto_NomeProduto ON Produto(NomeProduto);
CREATE INDEX idx_Produto_CategoriaID ON Produto(CategoriaID);

CREATE INDEX idx_CategoriaProduto_NomeCategoria ON CategoriaProduto(NomeCategoria);

CREATE INDEX idx_Fornecedor_NomeFornecedor ON Fornecedor(NomeFornecedor);

CREATE INDEX idx_ProdutosFornecedores_ProdutoID ON ProdutosFornecedores(ProdutoID);
CREATE INDEX idx_ProdutosFornecedores_FornecedorID ON ProdutosFornecedores(FornecedorID);

CREATE INDEX idx_Venda_ClienteID ON Venda(ClienteID);
CREATE INDEX idx_Venda_FuncionarioID ON Venda(FuncionarioID);
CREATE INDEX idx_Venda_RegiaoID ON Venda(RegiaoID);
CREATE INDEX idx_Venda_CanalID ON Venda(CanalID);
CREATE INDEX idx_Venda_DataVenda ON Venda(DataVenda);

CREATE INDEX idx_DetalheVenda_VendaID ON DetalheVenda(VendaID);
CREATE INDEX idx_DetalheVenda_ProdutoID ON DetalheVenda(ProdutoID);

CREATE INDEX idx_RegiaoVenda_NomeRegiao ON RegiaoVenda(NomeRegiao);

CREATE INDEX idx_CanalVenda_NomeCanal ON CanalVenda(NomeCanal);

CREATE INDEX idx_Stock_ProdutoID ON Stock(ProdutoID);

CREATE INDEX idx_Log_TipoLog ON Logs(TipoLog);
CREATE INDEX idx_Log_DataLog ON Logs(DataLog);

CREATE INDEX idx_Funcionario_NomeFuncionario ON Funcionario(NomeFuncionario);
CREATE INDEX idx_Funcionario_DataContratacao ON Funcionario(DataContratacao);
CREATE INDEX idx_Funcionario_Cargo ON Funcionario(Cargo);
GO

-- Povoamento inicial das tabelas
--INSERT INTO CategoriaProduto (NomeCategoria) VALUES
--('Eletrônicos'),
--('Móveis'),
--('Roupas'),
--('Alimentos'),
--('Livros');

--INSERT INTO Produto (NomeProduto, Descricao, Preco, CategoriaID) VALUES
--('Smartphone', 'Um smartphone moderno', 999.99, 1),
--('Sofá', 'Sofá confortável de 3 lugares', 499.99, 2),
--('Camiseta', 'Camiseta de algodão', 19.99, 3),
--('Pizza', 'Pizza de calabresa', 15.99, 4),
--('Livro de SQL', 'Livro sobre SQL avançado', 39.99, 5);

--INSERT INTO Cliente (Nome, DataNascimento, Endereco, CartaoCliente, Desconto) VALUES
--('João Silva', '1980-05-15', 'Rua A, 123', 1, 10.00),
--('Maria Oliveira', '1992-08-20', 'Rua B, 456', 1, 5.00),
--('Carlos Souza', '1985-12-10', 'Rua C, 789', 0, 0.00),
--('Ana Costa', '1990-03-05', 'Rua D, 321', 1, 7.50),
--('Pedro Lima', '1975-07-22', 'Rua E, 654', 0, 0.00);

---- Esta inserção deve falhar devido à idade inferior a 18 anos
--INSERT INTO Cliente (Nome, DataNascimento, Endereco, CartaoCliente, Desconto) 
--VALUES ('Teste Invalido 1', '2010-05-20', 'Rua Teste 2', 0, 0.00);

---- Esta inserção deve falhar devido a Desconto > 0 enquanto CartaoCliente = 0
--INSERT INTO Cliente (Nome, DataNascimento, Endereco, CartaoCliente, Desconto) 
--VALUES ('Teste Invalido 2', '1985-07-10', 'Rua Teste 3', 0, 5.00);


--INSERT INTO Funcionario (NomeFuncionario, DataContratacao, DataFinalContrato, Endereco, Cargo, Salario) VALUES
--('José Santos', '2020-01-15', NULL, 'Rua F, 987', 'Gerente', 3500.00),
--('Carla Mendes', '2019-03-12', NULL, 'Rua G, 654', 'Vendedor', 2200.00),
--('Ricardo Pereira', '2021-07-20', NULL, 'Rua H, 321', 'Analista', 3000.00),
--('Sônia Nunes', '2018-09-01', NULL, 'Rua I, 567', 'Técnico', 2500.00),
--('Roberto Alves', '2022-02-05', NULL, 'Rua J, 432', 'Assistente', 1800.00);

--INSERT INTO RegiaoVenda (NomeRegiao, Endereco) VALUES
--('Centro', 'Rua Central, 1000'),
--('Sul', 'Rua do Sul, 2000'),
--('Norte', 'Rua do Norte, 3000'),
--('Leste', 'Rua Leste, 4000'),
--('Oeste', 'Rua Oeste, 5000');

--INSERT INTO CanalVenda (NomeCanal, Descricao) VALUES
--('Loja Física', 'Vendas realizadas na loja física'),
--('Online', 'Vendas online'),
--('Telemarketing', 'Vendas por telefone'),
--('Parcerias', 'Vendas através de parceiros'),
--('Distribuição', 'Vendas por distribuição direta');

--INSERT INTO Fornecedor (NomeFornecedor, Endereco, Telefone) VALUES
--('Fornecedor A', 'Rua 1, 100', '123456789'),
--('Fornecedor B', 'Rua 2, 200', '987654321'),
--('Fornecedor C', 'Rua 3, 300', '111222333'),
--('Fornecedor D', 'Rua 4, 400', '444555666'),
--('Fornecedor E', 'Rua 5, 500', '777888999');

--INSERT INTO ProdutosFornecedores (ProdutoID, FornecedorID) VALUES
--(1, 1),
--(2, 2),
--(3, 3),
--(4, 4),
--(5, 5);

--INSERT INTO Venda (ClienteID, FuncionarioID, RegiaoID, CanalID, DataVenda, TotalVenda) VALUES
--(1, 1, 1, 1, '2024-11-01', 200.00),
--(2, 2, 2, 2, '2024-11-02', 150.00),
--(3, 3, 3, 3, '2024-11-03', 300.00),
--(4, 4, 4, 4, '2024-11-04', 50.00),
--(5, 5, 5, 5, '2024-11-05', 400.00);

--INSERT INTO DetalheVenda (VendaID, ProdutoID, Quantidade, PrecoUnitario, DescontoAplicado) VALUES
--(1, 1, 2, 999.99, 10.00),
--(2, 2, 1, 499.99, 5.00),
--(3, 3, 5, 19.99, 0.00),
--(4, 4, 3, 15.99, 0.00),
--(5, 5, 2, 39.99, 7.50);

--INSERT INTO Stock (ProdutoID, QuantidadeDisponivel, NivelCritico) VALUES
--(1, 100, 10),
--(2, 50, 5),
--(3, 200, 20),
--(4, 30, 3),
--(5, 75, 7);

--INSERT INTO Logs (TipoLog, DataLog, Descricao) VALUES
--('INFO', '2024-11-01 10:00:00', 'Sistema inicializado'),
--('ERROR', '2024-11-02 12:00:00', 'Falha de conexão'),
--('WARN', '2024-11-03 14:30:00', 'Limite de vendas atingido'),
--('INFO', '2024-11-04 16:45:00', 'Novo cliente registrado'),
--('DEBUG', '2024-11-05 18:00:00', 'Depuração de vendas');

--SELECT * FROM CategoriaProduto;
--SELECT * FROM Produto;
--SELECT * FROM Cliente;
--SELECT * FROM Funcionario;
--SELECT * FROM RegiaoVenda;
--SELECT * FROM CanalVenda;
--SELECT * FROM Fornecedor;
--SELECT * FROM ProdutosFornecedores;
--SELECT * FROM Venda;
--SELECT * FROM DetalheVenda;
--SELECT * FROM Stock;
--SELECT * FROM Logs;

-- Implementação de Triggers:-- o Atualizem o inventário em tempo real e registem logs de alterações.
CREATE TRIGGER trg_UpdateStockOnVenda
ON DetalheVenda
AFTER INSERT, UPDATE
AS
BEGIN

    -- Para inserções, ajustar diretamente a quantidade disponível
    IF EXISTS (SELECT 1 FROM inserted LEFT JOIN deleted ON inserted.DetalheVendaID = deleted.DetalheVendaID WHERE deleted.DetalheVendaID IS NULL)
    BEGIN
        UPDATE Stock
        SET QuantidadeDisponivel = QuantidadeDisponivel - inserted.Quantidade
        FROM Stock
        JOIN inserted ON Stock.ProdutoID = inserted.ProdutoID;
    END
    ELSE
    BEGIN
        -- Para atualizações, ajustar com base na diferença de quantidades
        UPDATE Stock
        SET QuantidadeDisponivel = QuantidadeDisponivel - (inserted.Quantidade - deleted.Quantidade)
        FROM Stock
        JOIN inserted ON Stock.ProdutoID = inserted.ProdutoID
        JOIN deleted ON deleted.DetalheVendaID = inserted.DetalheVendaID;
    END;

    -- Gerar um erro se a quantidade ficar negativa
    IF EXISTS (
        SELECT 1
        FROM Stock
        WHERE QuantidadeDisponivel < 0
    )
    BEGIN
        RAISERROR ('Quantidade disponível insuficiente no inventário.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

CREATE TRIGGER trg_LogStockChanges
ON Stock
AFTER INSERT, UPDATE
AS
BEGIN

    -- Registo de inserções
    IF EXISTS (SELECT 1 FROM inserted LEFT JOIN deleted ON inserted.ProdutoID = deleted.ProdutoID WHERE deleted.ProdutoID IS NULL)
    BEGIN
        INSERT INTO Logs (TipoLog, DataLog, Descricao)
        SELECT 
            'Inserção de Stock',
            GETDATE(),
            'ProdutoID: ' + CAST(inserted.ProdutoID AS VARCHAR) + 
            ', Quantidade Disponível: ' + CAST(inserted.QuantidadeDisponivel AS VARCHAR) + 
            ', Nível Crítico: ' + CAST(inserted.NivelCritico AS VARCHAR)
        FROM inserted
        LEFT JOIN deleted ON inserted.ProdutoID = deleted.ProdutoID
        WHERE deleted.ProdutoID IS NULL;
    END

    -- Registo de atualizações
    IF EXISTS (SELECT 1 FROM inserted INNER JOIN deleted ON inserted.ProdutoID = deleted.ProdutoID)
    BEGIN
        INSERT INTO Logs (TipoLog, DataLog, Descricao)
        SELECT 
            'Atualização de Stock',
            GETDATE(),
            'ProdutoID: ' + CAST(inserted.ProdutoID AS VARCHAR) + 
            ', Quantidade Anterior: ' + CAST(deleted.QuantidadeDisponivel AS VARCHAR) + 
            ', Quantidade Atual: ' + CAST(inserted.QuantidadeDisponivel AS VARCHAR)
        FROM inserted
        JOIN deleted ON inserted.ProdutoID = deleted.ProdutoID;
    END
END;
GO

---- Teste de inserção no stock
--INSERT INTO CategoriaProduto (NomeCategoria) VALUES ('Eletrónicos');
--INSERT INTO Produto (NomeProduto, Descricao, Preco, CategoriaID) VALUES ('Telemóvel', 'Telemóvel de última geração', 1500.00, 1);
--INSERT INTO Stock (ProdutoID, QuantidadeDisponivel, NivelCritico) VALUES (1, 100, 10);
--SELECT * FROM Logs WHERE TipoLog = 'Inserção de Stock';

---- Teste de inserção em detalhevenda e update no stock
--INSERT INTO Cliente (Nome, DataNascimento, Endereco, CartaoCliente, Desconto) 
--VALUES ('João Silva', '1990-01-01', 'Rua Exemplo, 123', 1, 5.00);
--INSERT INTO Funcionario (NomeFuncionario, DataContratacao, Endereco, Cargo, Salario) 
--VALUES ('Maria Sousa', '2020-05-15', 'Avenida Principal, 456', 'Vendedor', 3000.00);
--INSERT INTO RegiaoVenda (NomeRegiao, Endereco) 
--VALUES ('Região Norte', 'Rua A, 123');
--INSERT INTO CanalVenda (NomeCanal, Descricao) 
--VALUES ('Online', 'Vendas pela internet');
--INSERT INTO Venda (ClienteID, FuncionarioID, RegiaoID, CanalID, DataVenda, TotalVenda)
--VALUES (1, 1, 1, 1, GETDATE(), 1000.00);
--INSERT INTO DetalheVenda (VendaID, ProdutoID, Quantidade, PrecoUnitario, DescontoAplicado)
--VALUES (1, 1, 10, 20.00, 0);

--SELECT * FROM DetalheVenda;
--SELECT * FROM Stock;
--SELECT * FROM Logs;

--  Notifiquem automaticamente quando os níveis de stock estiverem abaixo de um valor crítico, registando esses eventos numa tabela de alertas.

CREATE TRIGGER trg_NotifyStockBelowCritical
ON Stock
AFTER UPDATE
AS
BEGIN
    -- Inserir log quando a quantidade disponível estiver abaixo do nível crítico
    INSERT INTO Logs (TipoLog, DataLog, Descricao)
    SELECT 
        'ALERTA: Stock Crítico',
        GETDATE(),
        'ProdutoID: ' + CAST(inserted.ProdutoID AS VARCHAR) + 
        ', Quantidade Disponível: ' + CAST(inserted.QuantidadeDisponivel AS VARCHAR) + 
        ' está abaixo do Nível Crítico: ' + CAST(inserted.NivelCritico AS VARCHAR)
    FROM inserted
    WHERE inserted.QuantidadeDisponivel < inserted.NivelCritico;
END;
GO

--UPDATE Stock SET QuantidadeDisponivel = 5 WHERE ProdutoID = 1;
--SELECT * FROM Logs WHERE TipoLog = 'ALERTA: Stock Crítico';
--UPDATE Stock SET QuantidadeDisponivel = 15 WHERE ProdutoID = 1;
--SELECT * FROM Logs;

-- Verifiquem e registem alterações nas tabelas de clientes e fornecedores numa tabela de auditoria.
CREATE TRIGGER trg_AuditClienteChanges
ON Cliente
AFTER UPDATE
AS
BEGIN
    DECLARE @Descricao NVARCHAR(MAX);

    -- Selecionar as mudanças do cliente
    SELECT 
        @Descricao = STRING_AGG(
            CASE 
                WHEN inserted.Nome <> deleted.Nome THEN 'Nome alterado de "' + deleted.Nome + '" para "' + inserted.Nome + '"'
                WHEN inserted.DataNascimento <> deleted.DataNascimento THEN 'DataNascimento alterado de "' + CONVERT(VARCHAR, deleted.DataNascimento, 120) + '" para "' + CONVERT(VARCHAR, inserted.DataNascimento, 120) + '"'
                WHEN inserted.Endereco <> deleted.Endereco THEN 'Endereco alterado de "' + deleted.Endereco + '" para "' + inserted.Endereco + '"'
                WHEN inserted.CartaoCliente <> deleted.CartaoCliente THEN 'CartaoCliente alterado de "' + CAST(deleted.CartaoCliente AS VARCHAR) + '" para "' + CAST(inserted.CartaoCliente AS VARCHAR) + '"'
                WHEN inserted.Desconto <> deleted.Desconto THEN 'Desconto alterado de "' + CAST(deleted.Desconto AS VARCHAR) + '" para "' + CAST(inserted.Desconto AS VARCHAR) + '"'
            END, '; ')
    FROM inserted
    JOIN deleted ON inserted.ClienteID = deleted.ClienteID
    WHERE inserted.Nome <> deleted.Nome
       OR inserted.DataNascimento <> deleted.DataNascimento
       OR inserted.Endereco <> deleted.Endereco
       OR inserted.CartaoCliente <> deleted.CartaoCliente
       OR inserted.Desconto <> deleted.Desconto
    GROUP BY inserted.ClienteID;

    -- Inserting log entry only if there is a description of changes
    IF @Descricao IS NOT NULL
    BEGIN
        INSERT INTO Logs (TipoLog, DataLog, Descricao)
        SELECT 
            'AUDITORIA: Atualização de Cliente',
            GETDATE(),
            'ClienteID: ' + CAST(inserted.ClienteID AS VARCHAR) + '; ' + @Descricao
        FROM inserted;
    END
END;
GO

CREATE TRIGGER trg_AuditFornecedorChanges
ON Fornecedor
AFTER UPDATE
AS
BEGIN
    DECLARE @Descricao NVARCHAR(MAX);

    -- Selecionar as mudanças do fornecedor
    SELECT 
        @Descricao = STRING_AGG(
            CASE 
                WHEN inserted.NomeFornecedor <> deleted.NomeFornecedor THEN 'NomeFornecedor alterado de "' + deleted.NomeFornecedor + '" para "' + inserted.NomeFornecedor + '"'
                WHEN inserted.Endereco <> deleted.Endereco THEN 'Endereco alterado de "' + deleted.Endereco + '" para "' + inserted.Endereco + '"'
                WHEN inserted.Telefone <> deleted.Telefone THEN 'Telefone alterado de "' + deleted.Telefone + '" para "' + inserted.Telefone + '"'
            END, '; ')
    FROM inserted
    JOIN deleted ON inserted.FornecedorID = deleted.FornecedorID
    WHERE inserted.NomeFornecedor <> deleted.NomeFornecedor
       OR inserted.Endereco <> deleted.Endereco
       OR inserted.Telefone <> deleted.Telefone
    GROUP BY inserted.FornecedorID;

    -- Inserting log entry only if there is a description of changes
    IF @Descricao IS NOT NULL
    BEGIN
        INSERT INTO Logs (TipoLog, DataLog, Descricao)
        SELECT 
            'AUDITORIA: Atualização de Fornecedor',
            GETDATE(),
            'FornecedorID: ' + CAST(inserted.FornecedorID AS VARCHAR) + '; ' + @Descricao
        FROM inserted;
    END
END;
GO

-- Teste para o updtade do cliente
--SELECT * FROM Cliente;
--UPDATE Cliente
--SET Nome = 'João Modificado', Endereco = 'Rua Nova, 321', Desconto = 15.00
--WHERE ClienteID = 1;
--SELECT * FROM Logs WHERE TipoLog = 'AUDITORIA: Atualização de Cliente';

---- Teste para o updtade do fornecedor
--SELECT * FROM Fornecedor; 
--INSERT INTO Fornecedor (NomeFornecedor, Endereco, Telefone) VALUES
--('Fornecedor A', 'Rua 1, 100', '123456789');
--UPDATE Fornecedor
--SET NomeFornecedor = 'Fornecedor A Modificado', Endereco = 'Rua Nova, 200', Telefone = '123123123'
--WHERE FornecedorID = 1;
--SELECT * FROM Logs WHERE TipoLog = 'AUDITORIA: Atualização de Fornecedor';

-- Analise as vendas e possa atribuir pontos aos clientes que apresentem o cartão de cliente.
CREATE TRIGGER trg_AtribuirPontosCliente
ON Venda
AFTER INSERT
AS
BEGIN
    -- Atribuir pontos aos clientes com CartaoCliente = 1, convertendo TotalVenda para INT, ou seja, 1 euro = 1 ponto
    UPDATE Cliente
    SET Pontos = Pontos + (inserted.TotalVenda)
    FROM Cliente
    JOIN inserted ON Cliente.ClienteID = inserted.ClienteID
    WHERE Cliente.CartaoCliente = 1;
END;
GO

-- Teste
--SELECT * FROM Cliente;
--INSERT INTO Cliente (Nome, DataNascimento, Endereco, CartaoCliente, Desconto)
--VALUES ('Nuno Mendes', '1992-10-15', 'Rua Direita, 700', 1, 00.00);
--INSERT INTO Venda (ClienteID, FuncionarioID, RegiaoID, CanalID, DataVenda, TotalVenda)
--VALUES (3, 1, 1, 1, GETDATE(), 100.00);
--SELECT * FROM Cliente WHERE ClienteID = 3;
--SELECT * FROM Venda;

-- Views

-- Forneçam relatórios de vendas detalhados, agrupados por região e categoria de produto.
CREATE VIEW vw_RelatorioVendasPorRegiaoECategoria AS
SELECT 
    rv.NomeRegiao,
    cp.NomeCategoria,
    SUM(dv.Quantidade * dv.PrecoUnitario - dv.DescontoAplicado) AS TotalVendas,
    COUNT(DISTINCT v.VendaID) AS NumeroVendas,
    SUM(dv.Quantidade) AS QuantidadeTotalVendida
FROM Venda v
JOIN DetalheVenda dv ON v.VendaID = dv.VendaID
JOIN Produto p ON dv.ProdutoID = p.ProdutoID
JOIN CategoriaProduto cp ON p.CategoriaID = cp.CategoriaID
JOIN RegiaoVenda rv ON v.RegiaoID = rv.RegiaoID
GROUP BY rv.NomeRegiao, cp.NomeCategoria;
GO

-- Teste
--SELECT * FROM vw_RelatorioVendasPorRegiaoECategoria;

-- Mostrem a evolução histórica das vendas com cálculos de crescimento percentual e médias móveis.
CREATE VIEW vw_EvolucaoHistoricaVendas AS
SELECT 
    -- Data da venda utilizada para agrupar os resultados
    v.DataVenda,
    
    -- Calcular o total de vendas para cada data: quantidade vendida multiplicada pelo preço unitário, menos os descontos aplicados
    SUM(dv.Quantidade * dv.PrecoUnitario - dv.DescontoAplicado) AS TotalVendas,
    
    -- Usar LAG para obter o valor de vendas do período anterior (para calcular crescimento percentual)
    LAG(SUM(dv.Quantidade * dv.PrecoUnitario - dv.DescontoAplicado)) 
        OVER (ORDER BY v.DataVenda) AS VendaAnterior,
    
    -- Cálculo do crescimento percentual em relação ao período anterior
    CASE 
        WHEN LAG(SUM(dv.Quantidade * dv.PrecoUnitario - dv.DescontoAplicado)) 
             OVER (ORDER BY v.DataVenda) IS NULL THEN 0  -- Se não houver período anterior, crescimento é 0
        ELSE 
            (SUM(dv.Quantidade * dv.PrecoUnitario - dv.DescontoAplicado) - 
             LAG(SUM(dv.Quantidade * dv.PrecoUnitario - dv.DescontoAplicado)) 
             OVER (ORDER BY v.DataVenda)) * 100.0 / 
             LAG(SUM(dv.Quantidade * dv.PrecoUnitario - dv.DescontoAplicado)) 
             OVER (ORDER BY v.DataVenda)  -- Calcular a diferença percentual
    END AS CrescimentoPercentual,
    
    -- Cálculo da média móvel dos últimos 3 períodos
    AVG(SUM(dv.Quantidade * dv.PrecoUnitario - dv.DescontoAplicado)) 
        OVER (ORDER BY v.DataVenda 
              ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MediaMovel
FROM Venda v
JOIN DetalheVenda dv ON v.VendaID = dv.VendaID  -- Join com a tabela de detalhes de vendas
GROUP BY v.DataVenda;  -- Agrupar por data de venda para calcular os totais diários
GO

-- Teste
--SELECT * FROM vw_EvolucaoHistoricaVendas;

-- Consolidem o desempenho dos fornecedores com base em prazos de entrega e qualidade do produto.
CREATE VIEW vw_DesempenhoFornecedores AS
SELECT 
    f.NomeFornecedor,
    AVG(f.PrazoEntrega) AS MediaPrazoEntrega,  -- Média dos prazos de entrega dos fornecedores
    AVG(p.QualidadeProduto) AS MediaQualidade,  -- Média da qualidade dos produtos fornecidos
    COUNT(pf.ProdutoID) AS NumeroProdutosFornecidos  -- Número de produtos fornecidos
FROM Fornecedor f
JOIN ProdutosFornecedores pf ON f.FornecedorID = pf.FornecedorID
JOIN Produto p ON pf.ProdutoID = p.ProdutoID
GROUP BY f.NomeFornecedor;
GO

--SELECT * FROM vw_DesempenhoFornecedores;

-- Mostre os logs mais críticos, como por exemplo baixa critica de stock.
CREATE VIEW vw_LogsCriticos AS
SELECT 
    LogID,
    TipoLog,
    DataLog,
    -- Extraindo a parte após os dois pontos (:) do TipoLog
    LTRIM(SUBSTRING(TipoLog, CHARINDEX(':', TipoLog) + 1, LEN(TipoLog))) AS MensagemCritica,
    Descricao
FROM Logs
WHERE TipoLog LIKE 'ALERTA:%';  -- Filtra os logs que começam com "ALERTA:"
GO

--SELECT * FROM vw_LogsCriticos;

-- Desenvolvimento de Stored Procedures:

-- Realizem inserções de dados de vendas com verificações de stock e registo de alertas.
CREATE PROCEDURE sp_InserirVendaSimplificada
    @ClienteID INT,
    @FuncionarioID INT,
    @RegiaoID INT,
    @CanalID INT,
    @DataVenda DATE,
    @ProdutoID INT,
    @Quantidade INT,
    @PrecoUnitario DECIMAL(10, 2),
    @DescontoAplicado DECIMAL(5, 2)
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        DECLARE @VendaID INT, @TotalVenda DECIMAL(10, 2), @QuantidadeDisponivel INT, @NivelCritico INT;

        -- Verificar quantidade disponível em estoque
        SELECT @QuantidadeDisponivel = QuantidadeDisponivel, @NivelCritico = NivelCritico
        FROM Stock
        WHERE ProdutoID = @ProdutoID;

        IF @QuantidadeDisponivel < @Quantidade
        BEGIN
            THROW 50001, 'Quantidade em estoque insuficiente.', 1;
        END

        -- Inserir a venda
        SET @TotalVenda = @Quantidade * @PrecoUnitario - @DescontoAplicado;
        INSERT INTO Venda (ClienteID, FuncionarioID, RegiaoID, CanalID, DataVenda, TotalVenda)
        VALUES (@ClienteID, @FuncionarioID, @RegiaoID, @CanalID, @DataVenda, @TotalVenda);

        SET @VendaID = SCOPE_IDENTITY();

        -- Inserir detalhe da venda
        INSERT INTO DetalheVenda (VendaID, ProdutoID, Quantidade, PrecoUnitario, DescontoAplicado)
        VALUES (@VendaID, @ProdutoID, @Quantidade, @PrecoUnitario, @DescontoAplicado);

        -- Atualizar o estoque
        UPDATE Stock
        SET QuantidadeDisponivel = QuantidadeDisponivel - @Quantidade
        WHERE ProdutoID = @ProdutoID;

        -- Registrar alerta se o estoque atingir ou for inferior ao nível crítico
        IF @QuantidadeDisponivel - @Quantidade <= @NivelCritico
        BEGIN
            INSERT INTO Logs (TipoLog, DataLog, Descricao)
            VALUES ('ALERTA: Stock Crítico', GETDATE(), 'ProdutoID: ' + CAST(@ProdutoID AS VARCHAR) + 
                    ', Quantidade Disponível: ' + CAST(@QuantidadeDisponivel - @Quantidade AS VARCHAR) + 
                    ' está abaixo ou no nível crítico: ' + CAST(@NivelCritico AS VARCHAR));
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        -- Re-raise the error
        THROW;
    END CATCH
END;
GO

-- Teste
--DECLARE @DataVendaAux DATE = GETDATE();
--EXEC sp_InserirVendaSimplificada
--    @ClienteID = 1,
--    @FuncionarioID = 1,
--    @RegiaoID = 1,
--    @CanalID = 1,
--    @DataVenda = @DataVendaAux,
--    @ProdutoID = 1,
--    @Quantidade = 5,
--    @PrecoUnitario = 20.00,
--    @DescontoAplicado = 0
--;

-- Verificar registros inseridos na tabela de vendas
--SELECT * FROM Venda
--ORDER BY VendaID DESC;  -- Mostra as vendas mais recentes primeiro

---- Verificar registros inseridos na tabela de detalhes de vendas
--SELECT * FROM DetalheVenda
--ORDER BY DetalheVendaID DESC;  -- Mostra os detalhes de venda mais recentes primeiro

---- Verificar atualização na tabela de estoque
--SELECT * FROM Stock
--ORDER BY ProdutoID;  -- Mostra todos os produtos e suas quantidades disponíveis

---- Verificar registros de alertas na tabela de logs (caso tenham sido gerados)
--SELECT * FROM Logs
--WHERE TipoLog LIKE 'ALERTA:%'
--ORDER BY DataLog DESC;  -- Mostra os alertas mais recentes

-- Atualizem automaticamente preços de produtos num aumento de 1% .
CREATE PROCEDURE sp_AumentarPrecosProdutos
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Atualizar todos os preços dos produtos com um aumento de 1%
        UPDATE Produto
        SET Preco = Preco * 1.01;

        -- Registrar a operação nos logs para monitoramento
        INSERT INTO Logs (TipoLog, DataLog, Descricao)
        VALUES ('INFO', GETDATE(), 'Aumento de 1% aplicado aos preços dos produtos.');

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        -- Registar erro nos logs para análise
        INSERT INTO Logs (TipoLog, DataLog, Descricao)
        VALUES ('ERRO na Procedure: sp_AumentarPrecosProdutos', GETDATE(), ERROR_MESSAGE());

        -- Re-raise o erro para que possa ser tratado externamente, se necessário
        THROW;
    END CATCH
END;
GO

-- Teste
--INSERT INTO CategoriaProduto (NomeCategoria)
--VALUES
--('Informática'),
--('Decoração'),
--('Calçados'),
--('Doces');
--INSERT INTO Produto (NomeProduto, Descricao, Preco, CategoriaID, QualidadeProduto)
--VALUES
--('Notebook', 'Notebook de alta performance', 2000.00, 1, 4.7),
--('Mesa de Escritório', 'Mesa de madeira com acabamento fino', 300.00, 2, 4.0),
--('Calça Jeans', 'Calça jeans confortável', 49.99, 3, 4.2),
--('Chocolate', 'Chocolate ao leite', 5.99, 4, 4.8);
--SELECT * FROM Produto;

--EXEC sp_AumentarPrecosProdutos;

--  Gerem relatórios personalizados com filtros dinâmicos de tempo, (data inicio e data fim), região e categoria de produto.
CREATE PROCEDURE sp_RelatorioPersonalizado
    @DataInicio DATE,
    @DataFim DATE,
    @RegiaoID INT = NULL,  -- Parâmetro opcional, pode ser NULL para incluir todas as regiões
    @CategoriaID INT = NULL  -- Parâmetro opcional, pode ser NULL para incluir todas as categorias
AS
BEGIN
    -- Selecionar vendas com filtros aplicados
    SELECT 
        v.DataVenda,
        rv.NomeRegiao,
        cp.NomeCategoria,
        p.NomeProduto,
        dv.Quantidade,
        dv.PrecoUnitario,
        dv.DescontoAplicado,
        (dv.Quantidade * dv.PrecoUnitario - dv.DescontoAplicado) AS TotalVenda
    FROM Venda v
    JOIN DetalheVenda dv ON v.VendaID = dv.VendaID
    JOIN Produto p ON dv.ProdutoID = p.ProdutoID
    JOIN CategoriaProduto cp ON p.CategoriaID = cp.CategoriaID
    JOIN RegiaoVenda rv ON v.RegiaoID = rv.RegiaoID
    WHERE v.DataVenda BETWEEN @DataInicio AND @DataFim
    AND (@RegiaoID IS NULL OR v.RegiaoID = @RegiaoID)
    AND (@CategoriaID IS NULL OR p.CategoriaID = @CategoriaID)
    ORDER BY v.DataVenda;
END;
GO

--EXEC sp_RelatorioPersonalizado
--    @DataInicio = '2024-11-01',
--    @DataFim = '2024-11-30',
--    @RegiaoID = 1,
--    @CategoriaID = 2;

--EXEC sp_RelatorioPersonalizado
--    @DataInicio = '2024-11-01',
--    @DataFim = '2024-11-30',
--    @RegiaoID = NULL,
--    @CategoriaID = NULL;

-- Povoamento Final

-- CategoriaProduto
INSERT INTO CategoriaProduto (NomeCategoria)
VALUES 
    ('Alimentação'),
    ('Bebidas'),
    ('Eletrónica'),
    ('Roupas e Acessórios'),
    ('Saúde e Bem-estar'),
    ('Casa e Decoração'),
    ('Desporto e Lazer'),
    ('Brinquedos e Jogos'),
    ('Livros e Mídia'),
    ('Ferramentas e Materiais');
GO

-- Produto
INSERT INTO Produto (NomeProduto, Descricao, Preco, CategoriaID, QualidadeProduto) VALUES
('Espumante', 'Produto sem aditivos artificiais.', 165.48, 6, 4.77),
('Torta de Laranja', 'Produto tradicional português.', 125.39, 10, 2.08),
('Cúrcuma', 'Produto gourmet, perfeito para ocasiões especiais.', 54.97, 7, 4.54),
('Café Expresso', 'Produto sem aditivos artificiais.', 159.11, 6, 1.83),
('Café Moka', 'Produto fresco e de qualidade superior.', 127.48, 9, 3.72),
('Vinho Tinto', 'Produto tradicional português.', 67.87, 8, 3.01),
('Toalhetes Humedecidos', 'Produto gourmet, perfeito para ocasiões especiais.', 70.33, 6, 3.01),
('Manteiga', 'Produto gourmet, perfeito para ocasiões especiais.', 191.89, 8, 2.64),
('Salada de Quinoa', 'Produto tradicional português.', 155.21, 1, 2.81),
('Bacalhau à Brás', 'Produto tradicional português.', 97.17, 9, 2.37),
('Shampoo', 'Produto importado de alta qualidade.', 176.25, 1, 4.78),
('Croquetes', 'Produto de origem biológica.', 106.33, 1, 3.37),
('Alho', 'Produto de origem biológica.', 100.36, 3, 4.38),
('Croquetes', 'Sabor autêntico que remete para as tradições de Portugal.', 64.73, 7, 2.03),
('Detergente de Louça', 'Produto de origem biológica.', 101.57, 8, 4.31),
('Ervas de Provence', 'Produto tradicional português.', 140.14, 10, 4.56),
('Gelado de Morango', 'Produto fresco e de qualidade superior.', 123.36, 10, 2.3),
('Sangria', 'Perfeito para petiscos e jantares com amigos.', 183.26, 2, 1.88),
('Pêssegos', 'Produto artesanal de produção local.', 170.91, 7, 4.23),
('Batatas Fritas', 'Produto sem aditivos artificiais.', 118.44, 1, 4.1),
('Peixe Fresco', 'Produto importado de alta qualidade.', 181.03, 1, 2.42),
('Salada Grega', 'Produto de origem biológica.', 133.39, 1, 2.2),
('Robalo', 'Perfeito para petiscos e jantares com amigos.', 46.96, 6, 1.54),
('Filetes de Pescada', 'Produto gourmet, perfeito para ocasiões especiais.', 131.02, 9, 4.73),
('Brócolos Congelados', 'Produto de origem biológica.', 2.27, 4, 1.79),
('Chá Preto', 'Ideal para receitas rápidas e saborosas.', 131.15, 4, 4.69),
('Detergente de Louça', 'Produto artesanal de produção local.', 50.83, 10, 2.88),
('Salmão', 'Produto sem aditivos artificiais.', 58.46, 4, 2.53),
('Refrigerante Coca-Cola', 'Produto sem aditivos artificiais.', 97.05, 1, 3.99),
('Pizzas Congeladas', 'Produto fresco e de qualidade superior.', 37.15, 1, 3.98),
('Manjericão', 'Produto sem aditivos artificiais.', 152.64, 8, 1.18),
('Frango Congelado Inteiro', 'Perfeito para petiscos e jantares com amigos.', 10.79, 2, 3.06),
('Cajus', 'Produto de origem biológica.', 187.55, 4, 2.49),
('Chourição', 'Produto de origem biológica.', 194.28, 6, 3.43),
('Chili', 'Produto gourmet, perfeito para ocasiões especiais.', 46.4, 3, 3.44),
('Frango Congelado Inteiro', 'Ideal para receitas rápidas e saborosas.', 103.01, 7, 2.04),
('Sumo de Laranja', 'Produto fresco e de qualidade superior.', 128.2, 4, 3.44),
('Brócolos Congelados', 'Delicioso e rico em vitaminas.', 76.5, 4, 2.2),
('Peixe Fresco', 'Ideal para receitas rápidas e saborosas.', 79.38, 1, 2.46),
('Carne de Frango', 'Produto de origem biológica.', 96.62, 6, 3.29),
('Bifes de Frango', 'Produto gourmet, perfeito para ocasiões especiais.', 54.48, 7, 2.09),
('Ketchup', 'Produto gourmet, perfeito para ocasiões especiais.', 22.33, 9, 2.5),
('Frango Grelhado', 'Produto de origem biológica.', 171.23, 5, 1.41),
('Sardinhas em Lata', 'Produto gourmet, perfeito para ocasiões especiais.', 160.9, 3, 2.85),
('Purê de Batata', 'Produto gourmet, perfeito para ocasiões especiais.', 175.43, 4, 4.66),
('Laranja de Sumo', 'Sabor autêntico que remete para as tradições de Portugal.', 179.82, 6, 2.72),
('Alho em pó', 'Ideal para receitas rápidas e saborosas.', 119.02, 6, 2.21),
('Vodka', 'Sabor autêntico que remete para as tradições de Portugal.', 98.26, 2, 4.83),
('Ração para Gatos', 'Produto sem aditivos artificiais.', 43.19, 3, 4.37),
('Gelado de Morango', 'Produto sem aditivos artificiais.', 50.23, 1, 3.42),
('Brócolos Congelados', 'Produto fresco e de qualidade superior.', 130.01, 7, 1.67),
('Pepino', 'Produto gourmet, perfeito para ocasiões especiais.', 90.23, 7, 1.78),
('Manjericão', 'Produto fresco e de qualidade superior.', 107.37, 9, 3.46),
('Almôndegas', 'Sabor autêntico que remete para as tradições de Portugal.', 93.13, 5, 1.94),
('Creme Hidratante', 'Produto importado de alta qualidade.', 78.04, 5, 2.73),
('Salada de Bacalhau', 'Produto artesanal de produção local.', 100.57, 10, 1.87),
('Tâmaras', 'Delicioso e rico em vitaminas.', 113.9, 6, 2.74),
('Creme Hidratante', 'Sabor autêntico que remete para as tradições de Portugal.', 168.16, 2, 1.34),
('Purê de Batata', 'Produto gourmet, perfeito para ocasiões especiais.', 90.19, 6, 4.8),
('Rúcula', 'Perfeito para petiscos e jantares com amigos.', 60.7, 1, 1.05),
('Fideuá', 'Sabor autêntico que remete para as tradições de Portugal.', 188.42, 4, 2.51),
('Gel de Banho', 'Sabor autêntico que remete para as tradições de Portugal.', 106.27, 10, 1.45),
('Batatas Fritas', 'Produto sem aditivos artificiais.', 47.7, 5, 2.53),
('Creme de Leite', 'Produto tradicional português.', 50.74, 5, 2.17),
('Bananas', 'Produto de origem biológica.', 125.07, 8, 1.64),
('Farinha de Arroz', 'Delicioso e rico em vitaminas.', 19.73, 7, 3.55),
('Lulas', 'Produto fresco e de qualidade superior.', 90.45, 9, 1.79),
('Cerveja de Trigo', 'Ideal para receitas rápidas e saborosas.', 39.72, 4, 1.33),
('Sopa de Peixe', 'Produto gourmet, perfeito para ocasiões especiais.', 126.43, 10, 1.44),
('Bife à Portuguesa', 'Sabor autêntico que remete para as tradições de Portugal.', 171.4, 4, 1.13),
('Avelãs', 'Produto importado de alta qualidade.', 56.14, 10, 2.28),
('Salsichas', 'Perfeito para petiscos e jantares com amigos.', 125.08, 3, 4.85),
('Nozes', 'Produto sem aditivos artificiais.', 25.08, 8, 4.45),
('Molho Bechamel', 'Produto de origem biológica.', 139.65, 7, 2.06),
('Leite de Amêndoa', 'Delicioso e rico em vitaminas.', 69.56, 9, 3.67),
('Arroz Basmatia', 'Produto artesanal de produção local.', 125.66, 8, 3.74),
('Minestrone', 'Delicioso e rico em vitaminas.', 150.51, 2, 1.37),
('Nozes', 'Produto tradicional português.', 184.11, 1, 1.87),
('Laranja de Sumo', 'Delicioso e rico em vitaminas.', 185.45, 9, 2.51),
('Condicionador', 'Produto tradicional português.', 30.72, 3, 2.69),
('Desodorizante', 'Produto fresco e de qualidade superior.', 2.81, 3, 4.4),
('Carne de Porco', 'Delicioso e rico em vitaminas.', 41.62, 9, 1.24),
('Espumante', 'Produto tradicional português.', 157.08, 5, 3.55),
('Uvas de Mesa', 'Produto fresco e de qualidade superior.', 98.94, 10, 1.99),
('Vinho do Porto', 'Sabor autêntico que remete para as tradições de Portugal.', 38.43, 3, 3.22),
('Orégãos', 'Produto artesanal de produção local.', 83.22, 10, 4.39),
('Uvas de Mesa', 'Produto de origem biológica.', 65.85, 9, 2.13),
('Chocolates Lindt', 'Produto importado de alta qualidade.', 134.09, 7, 1.65),
('Cenouras Congeladas', 'Produto fresco e de qualidade superior.', 26.16, 9, 4.4),
('Atum em Lata', 'Produto artesanal de produção local.', 134.37, 2, 1.87),
('Leite UHT', 'Perfeito para petiscos e jantares com amigos.', 122.54, 8, 2.29),
('Molho Bechamel', 'Perfeito para petiscos e jantares com amigos.', 97.93, 1, 1.01),
('Refrigerante Diet', 'Delicioso e rico em vitaminas.', 30.44, 2, 1.27),
('Páprica', 'Perfeito para petiscos e jantares com amigos.', 2.05, 8, 3.39),
('Bacalhau à Gomes de Sá', 'Produto fresco e de qualidade superior.', 56.07, 5, 4.35),
('Tábua de Queijos', 'Delicioso e rico em vitaminas.', 7.18, 5, 2.74),
('Batatas Congeladas', 'Produto artesanal de produção local.', 63.12, 5, 3.84),
('Ervas de Provence', 'Produto de origem biológica.', 32.13, 10, 4.24),
('Bolo de Arroz', 'Ideal para receitas rápidas e saborosas.', 79.77, 2, 3.89),
('Bifes de Vaca', 'Produto sem aditivos artificiais.', 84.53, 10, 3.64),
('Massa de Pizza', 'Produto importado de alta qualidade.', 73.52, 6, 1.2),
('Brócolos Congelados', 'Sabor autêntico que remete para as tradições de Portugal.', 172.3, 2, 2.71),
('Leite de Amêndoa', 'Delicioso e rico em vitaminas.', 152.38, 10, 1.1),
('Carne de Porco à Alentejana', 'Produto tradicional português.', 162.49, 3, 4.91),
('Gelado de Morango', 'Sabor autêntico que remete para as tradições de Portugal.', 132.19, 1, 1.8),
('Torta de Laranja', 'Sabor autêntico que remete para as tradições de Portugal.', 48.45, 4, 2.31),
('Pastéis de Nata', 'Produto fresco e de qualidade superior.', 115.04, 7, 2.57),
('Salada de Bacalhau', 'Ideal para receitas rápidas e saborosas.', 36.56, 6, 2.55),
('Carne de Porco', 'Produto tradicional português.', 146.54, 8, 2.57),
('Leite de Soja', 'Produto gourmet, perfeito para ocasiões especiais.', 146.32, 9, 4.89),
('Tâmaras', 'Ideal para receitas rápidas e saborosas.', 152.97, 1, 1.52),
('Passas', 'Ideal para receitas rápidas e saborosas.', 25.44, 1, 3.8),
('Chá Preto', 'Delicioso e rico em vitaminas.', 109.88, 7, 4.23),
('Champanhe', 'Produto fresco e de qualidade superior.', 94.63, 7, 1.99),
('Frango à Brás', 'Produto gourmet, perfeito para ocasiões especiais.', 76.86, 5, 4.42),
('Chá Preto', 'Produto fresco e de qualidade superior.', 70.28, 1, 2.2),
('Pão de Mafra', 'Produto artesanal de produção local.', 47.84, 1, 4.63),
('Mariscos', 'Sabor autêntico que remete para as tradições de Portugal.', 23.75, 7, 1.79),
('Fermento em Pó', 'Perfeito para petiscos e jantares com amigos.', 175.88, 2, 4.82),
('Hamburgueres Congelados', 'Produto importado de alta qualidade.', 164.83, 4, 1.25),
('Café Expresso', 'Sabor autêntico que remete para as tradições de Portugal.', 166.77, 5, 4.32),
('Gel de Banho', 'Produto gourmet, perfeito para ocasiões especiais.', 5.68, 10, 4.16),
('Rum', 'Produto tradicional português.', 158.55, 8, 2.16),
('Ovos mexidos', 'Perfeito para petiscos e jantares com amigos.', 180.74, 7, 3.82),
('Atum em Lata', 'Perfeito para petiscos e jantares com amigos.', 141.03, 5, 1.04),
('Gelo em Cubos', 'Perfeito para petiscos e jantares com amigos.', 66.14, 4, 3.16),
('Couve-flor', 'Sabor autêntico que remete para as tradições de Portugal.', 196.73, 2, 1.02),
('Manteiga', 'Delicioso e rico em vitaminas.', 151.57, 4, 3.29),
('Frango Grelhado', 'Produto de origem biológica.', 62.11, 2, 4.71),
('Cajus', 'Produto sem aditivos artificiais.', 2.95, 4, 3.37),
('Tarte de Limão', 'Sabor autêntico que remete para as tradições de Portugal.', 38.35, 6, 1.57),
('Macarrão', 'Perfeito para petiscos e jantares com amigos.', 14.95, 8, 4.31),
('Cachorros', 'Produto de origem biológica.', 30.42, 9, 4.35),
('Fideuá', 'Produto fresco e de qualidade superior.', 162.43, 5, 1.9),
('Chá Preto', 'Produto tradicional português.', 81.49, 6, 4.25),
('Rúcula', 'Produto importado de alta qualidade.', 5.15, 9, 4.1),
('Avelãs', 'Sabor autêntico que remete para as tradições de Portugal.', 159.56, 6, 4.4),
('Chocolates Lindt', 'Sabor autêntico que remete para as tradições de Portugal.', 20.08, 9, 3.7),
('Vinho do Porto', 'Produto gourmet, perfeito para ocasiões especiais.', 9.23, 7, 4.0),
('Gin', 'Sabor autêntico que remete para as tradições de Portugal.', 57.82, 6, 3.11),
('Fermento em Pó', 'Perfeito para petiscos e jantares com amigos.', 128.96, 4, 2.07),
('Vinho Branco', 'Produto fresco e de qualidade superior.', 7.58, 2, 2.42),
('Pastéis de Nata', 'Delicioso e rico em vitaminas.', 31.22, 10, 1.87),
('Robalo Congelado', 'Produto de origem biológica.', 98.47, 9, 3.95),
('Cebolinhas', 'Sabor autêntico que remete para as tradições de Portugal.', 54.69, 6, 2.49),
('Tâmaras', 'Produto gourmet, perfeito para ocasiões especiais.', 138.12, 3, 4.87),
('Hamburgueres', 'Produto artesanal de produção local.', 5.97, 2, 4.06),
('Pasta de Dente', 'Perfeito para petiscos e jantares com amigos.', 60.5, 4, 4.37),
('Biscoitos de Chocolate', 'Sabor autêntico que remete para as tradições de Portugal.', 148.68, 3, 2.58),
('Sabão em Barra', 'Produto fresco e de qualidade superior.', 179.24, 5, 3.6),
('Vinho do Porto', 'Produto sem aditivos artificiais.', 68.12, 8, 1.3),
('Costeletas de Porco', 'Sabor autêntico que remete para as tradições de Portugal.', 63.65, 10, 4.26),
('Tequila', 'Delicioso e rico em vitaminas.', 29.56, 6, 2.76),
('Fermento em Pó', 'Produto importado de alta qualidade.', 195.79, 10, 4.6),
('Risotto', 'Produto de origem biológica.', 13.81, 7, 4.06),
('Chá de Ervas', 'Produto fresco e de qualidade superior.', 145.6, 3, 1.04),
('Cominhos', 'Ideal para receitas rápidas e saborosas.', 102.54, 10, 4.4),
('Robalo no Forno', 'Perfeito para petiscos e jantares com amigos.', 89.58, 10, 1.62),
('Amêndoas', 'Produto sem aditivos artificiais.', 123.5, 5, 5.0),
('Alimentos para Cães', 'Delicioso e rico em vitaminas.', 155.42, 7, 1.31),
('Páprica', 'Produto sem aditivos artificiais.', 177.36, 6, 4.26),
('Sabão em Barra', 'Produto tradicional português.', 106.39, 8, 2.52),
('Cenouras Congeladas', 'Sabor autêntico que remete para as tradições de Portugal.', 86.86, 6, 2.18),
('Bananas', 'Produto importado de alta qualidade.', 114.96, 10, 1.04),
('Bifes de Frango', 'Perfeito para petiscos e jantares com amigos.', 152.64, 4, 1.04),
('Pimento', 'Delicioso e rico em vitaminas.', 151.62, 5, 3.69),
('Ração para Gatos', 'Produto artesanal de produção local.', 47.18, 1, 4.02),
('Creme Hidratante', 'Produto importado de alta qualidade.', 80.21, 8, 4.07),
('Costeletas de Porco', 'Produto importado de alta qualidade.', 152.08, 7, 2.06),
('Cachorros', 'Produto gourmet, perfeito para ocasiões especiais.', 122.14, 4, 3.8),
('Frango à Brás', 'Produto tradicional português.', 186.38, 3, 2.58),
('Vinho Branco', 'Produto tradicional português.', 176.73, 6, 4.81),
('Hamburgueres', 'Produto fresco e de qualidade superior.', 36.29, 9, 3.2),
('Burritos', 'Produto gourmet, perfeito para ocasiões especiais.', 155.42, 3, 4.92),
('Detergente de Louça', 'Produto sem aditivos artificiais.', 146.41, 8, 3.05),
('Fiambre', 'Produto sem aditivos artificiais.', 198.01, 9, 2.91),
('Robalo', 'Produto gourmet, perfeito para ocasiões especiais.', 114.72, 10, 4.86),
('Risotto', 'Sabor autêntico que remete para as tradições de Portugal.', 148.77, 9, 1.29),
('Alface', 'Sabor autêntico que remete para as tradições de Portugal.', 122.77, 1, 1.9),
('Vinho Tinto', 'Produto tradicional português.', 48.39, 7, 3.05),
('Pizzas Congeladas', 'Produto importado de alta qualidade.', 127.18, 10, 3.58),
('Bolo de Aniversário', 'Delicioso e rico em vitaminas.', 59.99, 3, 2.59),
('Farinha de Trigo', 'Produto gourmet, perfeito para ocasiões especiais.', 111.4, 8, 3.54),
('Ovos mexidos', 'Sabor autêntico que remete para as tradições de Portugal.', 45.89, 7, 2.22),
('Pimenta', 'Produto de origem biológica.', 84.96, 3, 4.69),
('Alho Francês', 'Ideal para receitas rápidas e saborosas.', 95.65, 6, 1.32),
('Hamburgueres Congelados', 'Ideal para receitas rápidas e saborosas.', 59.75, 3, 1.43),
('Água Mineral', 'Produto fresco e de qualidade superior.', 43.79, 3, 1.84),
('Croquetes', 'Produto gourmet, perfeito para ocasiões especiais.', 84.25, 9, 4.3),
('Salada de Atum', 'Produto importado de alta qualidade.', 139.64, 5, 2.25),
('Tâmaras', 'Produto artesanal de produção local.', 18.56, 4, 4.06),
('Pão de Mafra', 'Produto gourmet, perfeito para ocasiões especiais.', 47.81, 8, 4.53),
('Bife de Frango Grelhado', 'Produto de origem biológica.', 38.06, 6, 2.38),
('Espumante', 'Produto sem aditivos artificiais.', 89.63, 9, 2.36),
('Café Torrado', 'Produto de origem biológica.', 11.58, 5, 2.26),
('Presunto', 'Sabor autêntico que remete para as tradições de Portugal.', 144.53, 6, 2.19),
('Páprica', 'Produto gourmet, perfeito para ocasiões especiais.', 50.05, 3, 3.66),
('Batatas Congeladas', 'Produto gourmet, perfeito para ocasiões especiais.', 105.12, 4, 4.79),
('Pêssegos', 'Produto artesanal de produção local.', 151.28, 9, 2.6),
('Gelo em Cubos', 'Ideal para receitas rápidas e saborosas.', 128.99, 8, 4.89);
GO

-- Cliente
INSERT INTO Cliente (Nome, DataNascimento, Endereco, CartaoCliente, Desconto, Pontos) VALUES
('Cláudia Almeida', '1995-11-27', 'Avenida Central, 120, Funchal', 1, 22.54, 818),
('Paula Pinto', '1964-12-04', 'Rua da Boavista, 130, Porto', 1, 4.43, 576),
('Patrícia Sousa', '2000-11-25', 'Avenida das Américas, 51, Coimbra', 0, 0, 603),
('Jorge Pinto', '2003-11-25', 'Rua de São Bento, 43, Coimbra', 1, 13.12, 369),
('Inês Moreira', '1997-11-26', 'Avenida da República, 102, Funchal', 0, 0, 429),
('Cláudia Almeida', '1946-12-09', 'Rua das Palmeiras, 20, Aveiro', 1, 9.09, 361),
('Pedro Costa', '1957-12-06', 'Rua das Laranjeiras, 200, Lisboa', 1, 6.6, 616),
('Catarina Lima', '1993-11-27', 'Avenida das Américas, 51, Coimbra', 0, 0, 738),
('Sérgio Lima', '1954-12-07', 'Rua de São Bento, 43, Coimbra', 0, 0, 246),
('Sandra Silva', '1994-11-27', 'Rua das Flores, 101, Lisboa', 1, 2.38, 418),
('Carlos Oliveira', '1997-11-26', 'Rua do Porto, 155, Braga', 1, 24.69, 195),
('Ana Martins', '1996-11-26', 'Rua da Vitória, 123, Santarém', 0, 0, 488),
('Luís Santos', '2004-11-24', 'Rua do Sol, 15, Aveiro', 1, 14.44, 534),
('Vítor Alves', '1950-12-08', 'Rua das Laranjeiras, 200, Lisboa', 1, 1.74, 838),
('Ricardo Pinto', '1952-12-07', 'Avenida 25 de Abril, 250, Faro', 1, 6.25, 159),
('Raul Ferreira', '1969-12-03', 'Rua do Porto, 155, Braga', 1, 0.65, 19),
('Margarida Lima', '1947-12-09', 'Avenida da Liberdade, 200, Porto', 1, 20.16, 760),
('Ricardo Rocha', '1988-11-28', 'Rua da Liberdade, 101, Setúbal', 1, 21.58, 362),
('Luís Santos', '1967-12-04', 'Rua José Falcão, 12, Coimbra', 1, 6.46, 19),
('Carla Silva', '1994-11-27', 'Rua da Vitória, 123, Santarém', 1, 4.65, 183),
('Raul Ferreira', '1945-12-09', 'Rua do Sol, 15, Aveiro', 1, 18.71, 127),
('Pedro Costa', '1995-11-27', 'Rua do Carmo, 12, Braga', 0, 0, 862),
('Inês Moreira', '1949-12-08', 'Rua do Sol, 15, Aveiro', 0, 0, 321),
('Bruno Pereira', '1976-12-01', 'Avenida Central, 120, Funchal', 0, 0, 882),
('Francisco Martins', '1969-12-03', 'Rua da Liberdade, 101, Setúbal', 0, 0, 906),
('David Ferreira', '1973-12-02', 'Rua das Flores, 101, Lisboa', 0, 0, 170),
('Sandra Silva', '1957-12-06', 'Avenida Central, 120, Funchal', 0, 0, 941),
('Catarina Lima', '1956-12-06', 'Rua do Príncipe Real, 45, Lisboa', 0, 0, 883),
('Margarida Lima', '1954-12-07', 'Rua das Laranjeiras, 200, Lisboa', 1, 28.42, 452),
('Nelson Martins', '1972-12-02', 'Rua do Porto, 155, Braga', 1, 2.93, 540),
('Helena Carvalho', '2002-11-25', 'Avenida da República, 102, Funchal', 1, 27.08, 245),
('Liliana Pinto', '1978-12-01', 'Rua D. João IV, 55, Évora', 0, 0, 722),
('Beatriz Sousa', '1969-12-03', 'Avenida da Liberdade, 200, Porto', 0, 0, 954),
('Sandra Silva', '1991-11-28', 'Rua das Laranjeiras, 200, Lisboa', 1, 20.21, 820),
('Patrícia Sousa', '1944-12-09', 'Rua de Santa Catarina, 76, Porto', 1, 27.34, 354),
('Paula Pinto', '1985-11-29', 'Avenida da República, 102, Funchal', 1, 2.68, 484),
('Helena Carvalho', '1976-12-01', 'Rua das Laranjeiras, 200, Lisboa', 1, 13.92, 312),
('Bruno Pereira', '1996-11-26', 'Rua da Trindade, 9, Porto', 1, 18.41, 187),
('Ricardo Rocha', '1997-11-26', 'Rua do Porto, 155, Braga', 0, 0, 763),
('Fernando Santos', '1944-12-09', 'Rua do Príncipe Real, 45, Lisboa', 1, 7.28, 615),
('André Santos', '1944-12-09', 'Rua da República, 83, Almada', 0, 0, 112),
('Inês Moreira', '1986-11-29', 'Avenida da Liberdade, 200, Porto', 1, 6.97, 58),
('Tiago Costa', '1985-11-29', 'Rua das Palmeiras, 20, Aveiro', 0, 0, 356),
('Pedro Costa', '1985-11-29', 'Rua da Vitória, 123, Santarém', 0, 0, 57),
('Carlos Oliveira', '1990-11-28', 'Avenida das Américas, 51, Coimbra', 0, 0, 200),
('Diogo Almeida', '1995-11-27', 'Rua D. João IV, 55, Évora', 1, 21.75, 552),
('Margarida Lima', '2005-11-24', 'Avenida 25 de Abril, 250, Faro', 0, 0, 852),
('José Almeida', '1990-11-28', 'Avenida 25 de Abril, 250, Faro', 1, 25.37, 395),
('Raul Ferreira', '1979-12-01', 'Rua das Acácias, 67, Oeiras', 0, 0, 514),
('Carlos Oliveira', '1995-11-27', 'Avenida da República, 102, Funchal', 0, 0, 537),
('Sofia Dias', '2001-11-25', 'Rua do Príncipe Real, 45, Lisboa', 1, 29.06, 539),
('Beatriz Sousa', '1999-11-26', 'Avenida das Nações Unidas, 45, Beja', 1, 25.25, 6),
('Ricardo Rocha', '2001-11-25', 'Rua do Castelo, 301, Sintra', 1, 14.13, 262),
('Daniel Costa', '1977-12-01', 'Avenida das Américas, 51, Coimbra', 1, 6.16, 477),
('Ana Martins', '1961-12-05', 'Rua José Falcão, 12, Coimbra', 0, 0, 352),
('Sandra Silva', '1944-12-09', 'Rua do Porto, 155, Braga', 1, 3.99, 49),
('Catarina Lima', '1972-12-02', 'Rua do Sol, 15, Aveiro', 0, 0, 796),
('David Ferreira', '1966-12-04', 'Rua do Príncipe Real, 45, Lisboa', 0, 0, 729),
('Francisco Martins', '1983-11-30', 'Avenida das Américas, 51, Coimbra', 1, 26.04, 428),
('Luís Santos', '1990-11-28', 'Rua da Trindade, 9, Porto', 1, 19.18, 260),
('Helena Carvalho', '1968-12-03', 'Rua das Palmeiras, 20, Aveiro', 1, 29.2, 782),
('Margarida Lima', '1972-12-02', 'Rua da Trindade, 9, Porto', 1, 0.76, 1000),
('Vítor Alves', '1961-12-05', 'Rua das Laranjeiras, 200, Lisboa', 1, 0.2, 349),
('Marta Ferreira', '2005-11-24', 'Rua da Páscoa, 27, Setúbal', 0, 0, 56),
('Rita Rocha', '1957-12-06', 'Avenida da República, 102, Funchal', 1, 7.63, 864),
('Raul Ferreira', '1954-12-07', 'Avenida da Liberdade, 200, Porto', 1, 4.01, 604),
('Bruno Pereira', '1971-12-03', 'Rua da Boavista, 130, Porto', 0, 0, 155),
('David Ferreira', '1979-12-01', 'Rua José Falcão, 12, Coimbra', 0, 0, 403),
('Bruno Pereira', '1956-12-06', 'Rua das Flores, 101, Lisboa', 1, 18.93, 764),
('Sandra Silva', '1983-11-30', 'Rua do Norte, 23, Guimarães', 0, 0, 872),
('Tiago Barbosa', '1960-12-05', 'Rua José Falcão, 12, Coimbra', 0, 0, 462),
('Carla Silva', '1982-11-30', 'Avenida da República, 102, Funchal', 0, 0, 787),
('André Santos', '2000-11-25', 'Rua das Acácias, 67, Oeiras', 0, 0, 493),
('Sérgio Lima', '1978-12-01', 'Avenida Central, 120, Funchal', 1, 18.11, 391),
('Carlos Oliveira', '2003-11-25', 'Avenida das Nações Unidas, 45, Beja', 0, 0, 603),
('Catarina Lima', '1968-12-03', 'Rua das Flores, 101, Lisboa', 1, 28.92, 676),
('Daniel Costa', '1944-12-09', 'Rua D. João IV, 55, Évora', 0, 0, 324),
('Raul Ferreira', '1999-11-26', 'Rua do Príncipe Real, 45, Lisboa', 0, 0, 20),
('Bruno Pereira', '1984-11-29', 'Rua do Porto, 155, Braga', 0, 0, 732),
('Beatriz Sousa', '1974-12-02', 'Rua das Acácias, 67, Oeiras', 0, 0, 247),
('Inês Moreira', '1973-12-02', 'Rua D. João IV, 55, Évora', 1, 18.45, 340),
('Fernando Santos', '2004-11-24', 'Rua do Sol, 15, Aveiro', 0, 0, 42),
('Jorge Pinto', '1951-12-08', 'Avenida da Liberdade, 200, Porto', 0, 0, 461),
('Margarida Lima', '1947-12-09', 'Rua José Falcão, 12, Coimbra', 1, 0.81, 565),
('Joana Ramos', '2006-11-24', 'Rua de São Bento, 43, Coimbra', 0, 0, 513),
('Cláudia Almeida', '1981-11-30', 'Avenida das Américas, 51, Coimbra', 0, 0, 24),
('Carlos Oliveira', '1982-11-30', 'Rua das Palmeiras, 20, Aveiro', 0, 0, 24),
('Sofia Dias', '1958-12-06', 'Rua da Páscoa, 27, Setúbal', 0, 0, 582),
('André Santos', '1953-12-07', 'Rua das Acácias, 67, Oeiras', 1, 20.81, 612),
('Beatriz Sousa', '1987-11-29', 'Rua de Santa Catarina, 76, Porto', 1, 18.87, 47),
('Catarina Lima', '1948-12-08', 'Rua da República, 83, Almada', 1, 28.17, 377),
('Paula Pinto', '1992-11-27', 'Rua D. João IV, 55, Évora', 1, 22.82, 357),
('Vítor Alves', '1962-12-05', 'Rua de Santa Catarina, 76, Porto', 0, 0, 202),
('Catarina Lima', '2003-11-25', 'Rua José Falcão, 12, Coimbra', 0, 0, 104),
('Nelson Martins', '2000-11-25', 'Rua da Vitória, 123, Santarém', 1, 7.63, 902),
('Tiago Costa', '1953-12-07', 'Rua do Sol, 15, Aveiro', 1, 9.76, 934),
('Miguel Barbosa', '1986-11-29', 'Rua de São Bento, 43, Coimbra', 1, 28.75, 422),
('Marta Ferreira', '1991-11-28', 'Avenida Central, 120, Funchal', 1, 27.92, 694),
('José Almeida', '1987-11-29', 'Rua José Falcão, 12, Coimbra', 0, 0, 645),
('Marta Ferreira', '1971-12-03', 'Rua de São Bento, 43, Coimbra', 0, 0, 814),
('João Silva', '1999-11-26', 'Rua das Laranjeiras, 200, Lisboa', 1, 24.23, 525),
('Inês Moreira', '1997-11-26', 'Rua da Liberdade, 101, Setúbal', 1, 22.19, 194),
('Pedro Costa', '1962-12-05', 'Rua das Laranjeiras, 200, Lisboa', 0, 0, 375),
('Nelson Martins', '1980-11-30', 'Avenida Central, 120, Funchal', 1, 22.55, 608),
('Pedro Costa', '1970-12-03', 'Rua José Falcão, 12, Coimbra', 1, 4.11, 637),
('Fernando Costa', '1960-12-05', 'Rua do Carmo, 12, Braga', 1, 24.29, 589),
('Paula Pinto', '1976-12-01', 'Rua do Carmo, 12, Braga', 0, 0, 439),
('Fernando Santos', '1965-12-04', 'Rua de Santa Catarina, 76, Porto', 0, 0, 363),
('Rita Rocha', '2006-11-24', 'Rua de Santa Catarina, 76, Porto', 0, 0, 216),
('Margarida Lima', '1980-11-30', 'Rua de Santa Catarina, 76, Porto', 0, 0, 425),
('André Santos', '1948-12-08', 'Avenida Central, 120, Funchal', 1, 5.33, 284),
('Francisco Martins', '2003-11-25', 'Rua da Vitória, 123, Santarém', 0, 0, 853),
('Jorge Pinto', '1996-11-26', 'Avenida das Nações Unidas, 45, Beja', 0, 0, 152),
('Nelson Martins', '1963-12-05', 'Avenida das Américas, 51, Coimbra', 0, 0, 704),
('Carlos Oliveira', '1967-12-04', 'Rua da Páscoa, 27, Setúbal', 1, 23.66, 360),
('Beatriz Sousa', '1959-12-06', 'Rua do Castelo, 301, Sintra', 0, 0, 962),
('Diogo Almeida', '1959-12-06', 'Rua do Castelo, 301, Sintra', 1, 16.67, 844),
('Cláudia Almeida', '1956-12-06', 'Avenida Central, 120, Funchal', 1, 23.29, 687),
('Fernando Costa', '1960-12-05', 'Rua da Liberdade, 101, Setúbal', 0, 0, 842),
('Carla Silva', '1945-12-09', 'Avenida das Nações Unidas, 45, Beja', 1, 22.01, 274),
('Diogo Almeida', '1976-12-01', 'Rua de São Bento, 43, Coimbra', 1, 18.65, 24),
('Sofia Dias', '1972-12-02', 'Avenida 25 de Abril, 250, Faro', 0, 0, 184),
('Nuno Gomes', '1944-12-09', 'Avenida 25 de Abril, 250, Faro', 0, 0, 995),
('Sofia Dias', '1969-12-03', 'Rua das Flores, 101, Lisboa', 0, 0, 371),
('Sandra Silva', '1977-12-01', 'Rua das Laranjeiras, 200, Lisboa', 1, 14.19, 818),
('Paula Mendes', '1966-12-04', 'Avenida da Liberdade, 200, Porto', 0, 0, 251),
('Paula Mendes', '1948-12-08', 'Rua da Liberdade, 101, Setúbal', 0, 0, 741),
('João Mendes', '1977-12-01', 'Rua de São Bento, 43, Coimbra', 1, 19.19, 728),
('André Santos', '1987-11-29', 'Rua da Liberdade, 101, Setúbal', 1, 12.61, 779),
('Ricardo Pinto', '1948-12-08', 'Avenida 25 de Abril, 250, Faro', 0, 0, 342),
('Helena Carvalho', '1957-12-06', 'Avenida da Liberdade, 200, Porto', 0, 0, 809),
('Raul Ferreira', '1991-11-28', 'Rua da República, 83, Almada', 0, 0, 168),
('Fátima Rocha', '1999-11-26', 'Rua das Palmeiras, 20, Aveiro', 0, 0, 394),
('Tiago Barbosa', '1999-11-26', 'Rua das Flores, 101, Lisboa', 1, 3.09, 550),
('Patrícia Sousa', '2004-11-24', 'Rua das Flores, 101, Lisboa', 0, 0, 391),
('Carla Silva', '1997-11-26', 'Rua da Páscoa, 27, Setúbal', 0, 0, 681),
('Tiago Costa', '1995-11-27', 'Avenida 25 de Abril, 250, Faro', 0, 0, 610),
('Miguel Barbosa', '1995-11-27', 'Rua do Sol, 15, Aveiro', 0, 0, 821),
('Ricardo Rocha', '1949-12-08', 'Rua da Liberdade, 101, Setúbal', 1, 19.48, 759),
('David Ferreira', '1950-12-08', 'Rua do Norte, 23, Guimarães', 0, 0, 368),
('Maria Pereira', '1971-12-03', 'Avenida 25 de Abril, 250, Faro', 1, 20.76, 916),
('Jorge Pinto', '1995-11-27', 'Avenida 25 de Abril, 250, Faro', 0, 0, 537),
('Carla Silva', '2004-11-24', 'Rua das Laranjeiras, 200, Lisboa', 0, 0, 592),
('Carla Silva', '2001-11-25', 'Avenida da Liberdade, 200, Porto', 1, 9.26, 792),
('Sandra Silva', '1991-11-28', 'Rua do Porto, 155, Braga', 0, 0, 178),
('Fátima Rocha', '1996-11-26', 'Rua da Páscoa, 27, Setúbal', 0, 0, 704),
('Rita Rocha', '1946-12-09', 'Rua das Laranjeiras, 200, Lisboa', 1, 7.68, 14),
('Paula Mendes', '1976-12-01', 'Rua das Laranjeiras, 200, Lisboa', 1, 7.6, 22),
('Sofia Dias', '1983-11-30', 'Rua da Páscoa, 27, Setúbal', 0, 0, 216),
('Liliana Pinto', '1949-12-08', 'Rua de Santa Catarina, 76, Porto', 0, 0, 956),
('Francisco Martins', '1951-12-08', 'Avenida das Américas, 51, Coimbra', 0, 0, 945),
('Marta Ferreira', '1991-11-28', 'Avenida das Américas, 51, Coimbra', 1, 1.11, 609),
('Cláudia Almeida', '2004-11-24', 'Avenida da República, 102, Funchal', 1, 9.86, 124),
('Ricardo Rocha', '2003-11-25', 'Avenida Central, 120, Funchal', 0, 0, 862),
('Luís Santos', '1979-12-01', 'Rua de Santa Catarina, 76, Porto', 1, 20.95, 427),
('Nuno Gomes', '1949-12-08', 'Rua de Santa Catarina, 76, Porto', 0, 0, 811),
('Patrícia Sousa', '1998-11-26', 'Rua D. João IV, 55, Évora', 0, 0, 857),
('Sandra Silva', '1990-11-28', 'Avenida das Américas, 51, Coimbra', 0, 0, 583),
('Raul Ferreira', '1980-11-30', 'Avenida 25 de Abril, 250, Faro', 1, 16.78, 471),
('Paula Mendes', '1999-11-26', 'Rua do Porto, 155, Braga', 1, 11.87, 180),
('Carlos Oliveira', '2002-11-25', 'Rua do Norte, 23, Guimarães', 0, 0, 942),
('Carlos Oliveira', '1985-11-29', 'Rua da República, 83, Almada', 1, 12.61, 637),
('Margarida Lima', '1968-12-03', 'Rua de São Bento, 43, Coimbra', 1, 9.85, 613),
('Maria Pereira', '1962-12-05', 'Avenida Central, 120, Funchal', 1, 0.87, 445),
('Joana Ramos', '1977-12-01', 'Rua da República, 83, Almada', 1, 7.76, 696),
('Maria Pereira', '1960-12-05', 'Rua da Trindade, 9, Porto', 0, 0, 148),
('Maria Pereira', '1980-11-30', 'Rua da Boavista, 130, Porto', 1, 12.42, 259),
('Miguel Barbosa', '1971-12-03', 'Rua do Carmo, 12, Braga', 0, 0, 773),
('Carla Silva', '1966-12-04', 'Rua do Sol, 15, Aveiro', 0, 0, 320),
('Paula Mendes', '1956-12-06', 'Rua das Acácias, 67, Oeiras', 1, 14.39, 746),
('Paula Pinto', '1992-11-27', 'Avenida das Nações Unidas, 45, Beja', 0, 0, 740),
('Jorge Pinto', '1998-11-26', 'Rua de Santa Catarina, 76, Porto', 0, 0, 106),
('Tiago Barbosa', '1967-12-04', 'Avenida 25 de Abril, 250, Faro', 1, 8.3, 521),
('Francisco Martins', '1969-12-03', 'Rua do Sol, 15, Aveiro', 0, 0, 862),
('Sérgio Lima', '1986-11-29', 'Rua da Vitória, 123, Santarém', 0, 0, 454),
('Diogo Almeida', '1958-12-06', 'Avenida da Liberdade, 200, Porto', 1, 23.6, 700),
('Paula Pinto', '1974-12-02', 'Rua da Páscoa, 27, Setúbal', 1, 21.87, 450),
('Liliana Pinto', '1945-12-09', 'Rua da Boavista, 130, Porto', 1, 23.11, 456),
('Vítor Alves', '1957-12-06', 'Rua do Norte, 23, Guimarães', 0, 0, 771),
('Liliana Pinto', '1961-12-05', 'Avenida 25 de Abril, 250, Faro', 0, 0, 823),
('Marta Ferreira', '1951-12-08', 'Rua da Liberdade, 101, Setúbal', 0, 0, 149),
('Margarida Lima', '1952-12-07', 'Rua das Acácias, 67, Oeiras', 1, 4.09, 48),
('Ricardo Pinto', '1946-12-09', 'Avenida das Américas, 51, Coimbra', 0, 0, 915),
('Fernando Santos', '1981-11-30', 'Rua das Palmeiras, 20, Aveiro', 0, 0, 961),
('Pedro Costa', '1999-11-26', 'Rua de São Bento, 43, Coimbra', 0, 0, 632),
('Tiago Costa', '1958-12-06', 'Rua D. João IV, 55, Évora', 0, 0, 424),
('Vítor Alves', '1944-12-09', 'Rua D. João IV, 55, Évora', 0, 0, 834),
('Fátima Rocha', '1987-11-29', 'Rua da Trindade, 9, Porto', 1, 25.53, 55),
('Fernando Costa', '1947-12-09', 'Rua do Porto, 155, Braga', 0, 0, 6),
('Sérgio Lima', '1989-11-28', 'Avenida das Américas, 51, Coimbra', 0, 0, 834),
('Ricardo Rocha', '1981-11-30', 'Rua das Acácias, 67, Oeiras', 0, 0, 688),
('Bruno Pereira', '1975-12-02', 'Rua do Norte, 23, Guimarães', 0, 0, 973),
('Margarida Lima', '1956-12-06', 'Rua das Laranjeiras, 200, Lisboa', 1, 6.36, 814),
('João Silva', '1996-11-26', 'Rua do Norte, 23, Guimarães', 1, 17.32, 84),
('Tiago Barbosa', '1994-11-27', 'Avenida da República, 102, Funchal', 1, 5.39, 704),
('Sérgio Lima', '1980-11-30', 'Rua do Carmo, 12, Braga', 0, 0, 537),
('Sofia Dias', '1991-11-28', 'Rua de São Bento, 43, Coimbra', 1, 18.56, 528),
('Bruno Pereira', '2002-11-25', 'Rua do Sol, 15, Aveiro', 1, 7.86, 897),
('Sérgio Lima', '1979-12-01', 'Avenida das Nações Unidas, 45, Beja', 0, 0, 992),
('Tiago Barbosa', '1999-11-26', 'Rua José Falcão, 12, Coimbra', 1, 20.63, 797);
GO

-- Funcionario
INSERT INTO Funcionario (NomeFuncionario, DataContratacao, DataFinalContrato, Endereco, Cargo, Salario) VALUES
('Carlos Oliveira', '2019-11-21', NULL, 'Rua da Trindade, 9, Porto', 'Supervisor de Produção', 2075.39),
('Inês Moreira', '2018-11-21', NULL, 'Rua do Porto, 155, Braga', 'Consultor de TI', 1139.25),
('Ana Martins', '2022-11-20', '2020-11-20', 'Rua do Porto, 155, Braga', 'Designer Gráfico', 3764.11),
('Fernando Costa', '2016-11-21', '2023-11-20', 'Rua do Castelo, 301, Sintra', 'Engenheiro de Software', 2393.92),
('Maria Pereira', '2017-11-21', NULL, 'Avenida das Américas, 51, Coimbra', 'Consultor de Vendas', 3973.62),
('Nelson Martins', '2022-11-20', '2018-11-21', 'Rua da Páscoa, 27, Setúbal', 'Gestor de Recursos Humanos', 2101.36),
('Sérgio Lima', '2015-11-22', NULL, 'Rua do Castelo, 301, Sintra', 'Assistente Administrativo', 4339.62),
('Francisco Martins', '2016-11-21', '2018-11-21', 'Avenida Central, 120, Funchal', 'Especialista em SEO', 1657.22),
('Tiago Costa', '2021-11-20', NULL, 'Avenida Central, 120, Funchal', 'Consultor de Gestão', 1533.05),
('José Almeida', '2014-11-22', NULL, 'Avenida das Américas, 51, Coimbra', 'Técnico de Suporte', 4114.57),
('Tiago Barbosa', '2021-11-20', NULL, 'Rua das Acácias, 67, Oeiras', 'Supervisor de Produção', 4485.67),
('Catarina Lima', '2014-11-22', '2016-11-21', 'Rua do Príncipe Real, 45, Lisboa', 'Analista de Qualidade', 3138.44),
('Ricardo Pinto', '2015-11-22', NULL, 'Rua da Boavista, 130, Porto', 'Especialista em Atendimento ao Cliente', 2844.33),
('Fernando Costa', '2020-11-20', '2018-11-21', 'Rua de São Bento, 43, Coimbra', 'Diretor Financeiro', 2973.97),
('Ricardo Rocha', '2017-11-21', NULL, 'Rua das Flores, 101, Lisboa', 'Engenheiro de Software', 4240.26),
('Rita Rocha', '2016-11-21', NULL, 'Rua do Príncipe Real, 45, Lisboa', 'Consultor Jurídico', 2749.31),
('Tiago Costa', '2015-11-22', NULL, 'Avenida das Américas, 51, Coimbra', 'Encarregado de Logística', 4273.4),
('Cristina Rocha', '2015-11-22', NULL, 'Rua das Palmeiras, 20, Aveiro', 'Assistente de Recursos Humanos', 1211.09),
('Cláudia Almeida', '2019-11-21', NULL, 'Rua do Norte, 23, Guimarães', 'Consultor de Vendas', 3458.66),
('Sérgio Lima', '2014-11-22', '2018-11-21', 'Rua da Boavista, 130, Porto', 'Especialista em SEO', 4677.09),
('Fátima Rocha', '2015-11-22', NULL, 'Rua de Santa Catarina, 76, Porto', 'Gerente', 1130.59),
('Maria Pereira', '2016-11-21', NULL, 'Avenida Central, 120, Funchal', 'Assistente Comercial', 3725.78),
('Nuno Gomes', '2019-11-21', NULL, 'Rua da Liberdade, 101, Setúbal', 'Encarregado de Logística', 4640.95),
('Carlos Oliveira', '2017-11-21', NULL, 'Avenida da República, 102, Funchal', 'Analista de Dados', 2871.28),
('Sérgio Lima', '2016-11-21', '2014-11-22', 'Avenida das Nações Unidas, 45, Beja', 'Consultor de Gestão', 2729.72),
('Patrícia Sousa', '2018-11-21', NULL, 'Avenida das Nações Unidas, 45, Beja', 'Designer Gráfico', 3889.13),
('Liliana Pinto', '2014-11-22', NULL, 'Rua do Príncipe Real, 45, Lisboa', 'Engenheiro de Software', 4227.79),
('Tiago Barbosa', '2018-11-21', NULL, 'Avenida das Nações Unidas, 45, Beja', 'Assistente de Recursos Humanos', 4783.33),
('Jorge Pinto', '2016-11-21', NULL, 'Avenida da República, 102, Funchal', 'Coordenador de Marketing', 3233.88),
('Carlos Oliveira', '2020-11-20', NULL, 'Rua do Porto, 155, Braga', 'Diretor de Operações', 2434.76),
('Nuno Gomes', '2014-11-22', NULL, 'Rua do Porto, 155, Braga', 'Designer Gráfico', 1226.12),
('João Mendes', '2017-11-21', NULL, 'Rua de Santa Catarina, 76, Porto', 'Desenvolvedor Full Stack', 4562.54),
('Maria Pereira', '2022-11-20', NULL, 'Avenida 25 de Abril, 250, Faro', 'Designer Gráfico', 3068.71),
('Lúcia Ferreira', '2014-11-22', '2023-11-20', 'Rua das Laranjeiras, 200, Lisboa', 'Gestor de Comunicação', 3919.29),
('Joana Ramos', '2023-11-20', NULL, 'Rua do Carmo, 12, Braga', 'Especialista em Atendimento ao Cliente', 4773.69),
('Tiago Barbosa', '2021-11-20', NULL, 'Rua do Porto, 155, Braga', 'Especialista em SEO', 3964.44),
('Cristina Rocha', '2016-11-21', '2017-11-21', 'Rua da Liberdade, 101, Setúbal', 'Consultor de Gestão', 2894.8),
('Bruno Pereira', '2020-11-20', NULL, 'Rua das Palmeiras, 20, Aveiro', 'Assistente de Recursos Humanos', 4340.33),
('Daniel Costa', '2022-11-20', NULL, 'Rua da Vitória, 123, Santarém', 'Consultor de Marketing Digital', 3314.08),
('Diogo Almeida', '2015-11-22', '2016-11-21', 'Rua da Liberdade, 101, Setúbal', 'Diretor Financeiro', 3344.71),
('Jorge Pinto', '2022-11-20', NULL, 'Avenida 25 de Abril, 250, Faro', 'Consultor de Gestão', 2941.57),
('Sofia Dias', '2023-11-20', '2019-11-21', 'Avenida Central, 120, Funchal', 'Especialista em Atendimento ao Cliente', 3315.87),
('Joana Ramos', '2020-11-20', NULL, 'Rua do Carmo, 12, Braga', 'Desenvolvedor Full Stack', 2492.15),
('Diogo Almeida', '2015-11-22', NULL, 'Avenida Central, 120, Funchal', 'Desenvolvedor Full Stack', 3114.23),
('Daniel Costa', '2023-11-20', NULL, 'Avenida da Liberdade, 200, Porto', 'Assistente Comercial', 3248.86),
('André Santos', '2014-11-22', NULL, 'Rua José Falcão, 12, Coimbra', 'Encarregado de Logística', 4605.34),
('João Mendes', '2017-11-21', NULL, 'Rua do Norte, 23, Guimarães', 'Encarregado de Logística', 4274.79),
('Pedro Costa', '2014-11-22', NULL, 'Avenida da República, 102, Funchal', 'Consultor de Vendas', 2525.91),
('Inês Moreira', '2015-11-22', NULL, 'Rua da Vitória, 123, Santarém', 'Técnico de Segurança do Trabalho', 3374.56),
('Inês Moreira', '2020-11-20', NULL, 'Rua das Laranjeiras, 200, Lisboa', 'Engenheiro de Software', 1379.17);
GO

-- RegiaoVenda
INSERT INTO RegiaoVenda (NomeRegiao, Endereco) VALUES
('Lisboa e Vale do Tejo', 'Avenida da Liberdade, 200, Lisboa'),
('Porto e Norte', 'Rua da Alegria, 130, Porto'),
('Algarve', 'Avenida 25 de Abril, 120, Faro'),
('Centro de Portugal', 'Rua do Castelo, 45, Coimbra'),
('Madeira', 'Rua do Funchal, 77, Funchal');
GO

-- CanalVenda
INSERT INTO CanalVenda (NomeCanal, Descricao) VALUES
('Lojas Físicas', 'Canais de venda em lojas físicas espalhadas por diversas regiões do país.'),
('E-commerce', 'Venda online através de plataformas de comércio eletrônico como websites e apps.'),
('Vendas Diretas', 'Venda realizada diretamente com o consumidor final, muitas vezes porta a porta.'),
('Redes Sociais', 'Vendas realizadas através de plataformas de redes sociais como Instagram e Facebook.'),
('Revendedores', 'Venda através de revendedores independentes que comercializam produtos de diversas marcas.');
GO

-- Fornecedor
INSERT INTO Fornecedor (NomeFornecedor, Endereco, Telefone, PrazoEntrega) VALUES
('Distribuidora Norte', 'Rua do Norte, 45, Porto', '222 333 444', 5),
('Alimentar Lda', 'Avenida da Liberdade, 100, Lisboa', '213 456 789', 3),
('Vendas e Importações', 'Rua da Trindade, 30, Coimbra', '239 112 233', 7),
('Fazenda Agrícola', 'Avenida 25 de Abril, 25, Faro', '289 222 334', 4),
('Tecno Distribuição', 'Rua José Falcão, 15, Coimbra', '239 444 555', 10),
('Máquinas e Ferramentas', 'Rua das Laranjeiras, 20, Aveiro', '234 567 890', 14),
('Produtos Naturais', 'Rua das Palmeiras, 101, Setúbal', '265 667 788', 6),
('Conexões Elétricas', 'Rua do Sol, 11, Funchal', '291 233 445', 5),
('Cervejeira Portuguesa', 'Rua do Porto, 50, Braga', '253 334 556', 3),
('Roupas & Acessórios', 'Avenida República, 85, Beja', '284 111 222', 7);
GO

-- ProdutosFornecedores
INSERT INTO ProdutosFornecedores (ProdutoID, FornecedorID) VALUES
(128, 8),
(89, 8),
(102, 6),
(50, 6),
(101, 6),
(168, 6),
(187, 5),
(60, 1),
(177, 8),
(84, 2),
(165, 2),
(41, 9),
(51, 8),
(60, 3),
(28, 3),
(181, 6),
(191, 4),
(2, 5),
(131, 1),
(162, 1),
(87, 10),
(154, 5),
(135, 7),
(170, 10),
(196, 5),
(95, 9),
(176, 10),
(167, 7),
(91, 4),
(75, 8),
(65, 4),
(171, 1),
(66, 7),
(154, 10),
(137, 6),
(127, 9),
(16, 6),
(21, 10),
(116, 2),
(87, 3),
(177, 10),
(26, 6),
(30, 1),
(63, 2),
(118, 1),
(22, 3),
(148, 3),
(113, 6),
(103, 3),
(31, 2),
(120, 3),
(184, 1),
(193, 6),
(20, 9),
(132, 6),
(198, 4),
(30, 6),
(112, 5),
(193, 2),
(59, 2),
(138, 1),
(114, 9),
(199, 5),
(155, 3),
(199, 1),
(12, 1),
(17, 7),
(34, 8),
(42, 6),
(146, 10),
(60, 10),
(187, 2),
(66, 1),
(182, 7),
(188, 10),
(144, 7),
(138, 8),
(155, 7),
(92, 2),
(11, 5),
(142, 4),
(154, 7),
(94, 5),
(8, 4),
(58, 3),
(172, 3),
(100, 9),
(46, 4),
(181, 4),
(53, 4),
(195, 8),
(1, 8),
(27, 6),
(184, 9),
(96, 9),
(78, 3),
(45, 4),
(104, 5),
(167, 6),
(43, 3),
(102, 10),
(62, 9),
(13, 7),
(180, 6),
(96, 3),
(3, 6),
(127, 3),
(18, 6),
(118, 4),
(153, 6),
(80, 10),
(78, 6),
(80, 8),
(118, 7),
(143, 3),
(137, 6),
(150, 1),
(35, 3),
(7, 2),
(86, 1),
(169, 2),
(164, 10),
(50, 3),
(94, 1),
(93, 3),
(95, 8),
(177, 6),
(59, 4),
(74, 7),
(196, 3),
(159, 8),
(170, 7),
(191, 2),
(24, 5),
(115, 4),
(46, 9),
(94, 5),
(107, 5),
(30, 1),
(187, 4),
(74, 6),
(172, 6),
(77, 10),
(124, 6),
(8, 5),
(52, 10),
(112, 10),
(65, 1),
(191, 4),
(185, 6),
(127, 7),
(19, 9),
(81, 5),
(42, 2),
(191, 10),
(23, 5),
(169, 5),
(60, 5),
(61, 4),
(160, 5),
(115, 1),
(21, 8),
(57, 4),
(22, 2),
(178, 2),
(159, 1),
(191, 9),
(29, 6),
(98, 8),
(100, 3),
(20, 8),
(143, 7),
(60, 7),
(177, 1),
(130, 1),
(125, 4),
(47, 7),
(66, 7),
(75, 5),
(161, 7),
(123, 6),
(57, 7),
(161, 10),
(40, 10),
(34, 4),
(38, 6),
(164, 5),
(90, 9),
(156, 6),
(12, 7),
(62, 4),
(109, 5),
(39, 10),
(75, 9),
(28, 7),
(132, 9),
(41, 9),
(142, 9),
(100, 8),
(150, 6);
GO

-- Venda
INSERT INTO Venda (ClienteID, FuncionarioID, RegiaoID, CanalID, DataVenda, TotalVenda) VALUES
(200, 23, 2, 5, '2024-02-29', 771.53),
(60, 47, 1, 4, '2023-12-14', 457.96),
(184, 48, 3, 1, '2024-03-07', 701.29),
(114, 9, 1, 1, '2024-01-18', 323.41),
(128, 25, 2, 2, '2024-09-06', 826.89),
(42, 10, 3, 3, '2024-05-08', 426.69),
(80, 25, 5, 1, '2024-03-22', 492.99),
(100, 15, 3, 5, '2024-01-07', 518.74),
(77, 10, 5, 1, '2024-08-16', 350.92),
(24, 22, 3, 5, '2024-07-14', 352.77),
(140, 44, 4, 5, '2024-01-18', 730.73),
(172, 49, 3, 5, '2023-12-02', 942.42),
(94, 10, 2, 5, '2024-05-27', 822.73),
(32, 25, 4, 5, '2024-02-28', 596.07),
(7, 18, 4, 5, '2024-04-19', 596.56),
(148, 31, 5, 3, '2024-04-23', 158.16),
(54, 2, 4, 1, '2024-05-18', 548.49),
(61, 38, 5, 5, '2024-04-07', 228.91),
(174, 46, 5, 4, '2024-02-27', 369.22),
(129, 42, 5, 4, '2024-04-07', 394.48),
(17, 20, 4, 2, '2024-10-09', 946.58),
(190, 47, 4, 3, '2024-05-29', 550.11),
(54, 35, 3, 3, '2023-12-24', 649.11),
(89, 36, 3, 4, '2024-07-14', 621.34),
(115, 6, 1, 2, '2023-11-24', 816.44),
(161, 38, 3, 5, '2024-01-31', 727.13),
(27, 25, 5, 5, '2024-07-11', 988.97),
(167, 3, 1, 2, '2024-07-07', 600.2),
(184, 2, 3, 1, '2024-01-18', 998.34),
(182, 5, 2, 5, '2023-12-24', 518.68),
(165, 14, 3, 1, '2024-05-24', 500.34),
(96, 18, 2, 2, '2024-06-29', 645.33),
(151, 22, 3, 2, '2024-10-04', 972.7),
(146, 14, 3, 1, '2024-06-23', 357.87),
(195, 29, 3, 2, '2023-12-20', 359.88),
(199, 37, 3, 4, '2024-04-17', 443.04),
(15, 10, 4, 4, '2023-11-22', 383.26),
(40, 22, 1, 4, '2024-07-10', 207.89),
(17, 48, 4, 2, '2024-06-17', 241.2),
(94, 2, 3, 4, '2024-08-02', 993.8),
(56, 38, 4, 5, '2024-04-02', 860.16),
(160, 5, 2, 2, '2024-03-17', 947.87),
(181, 32, 3, 2, '2024-01-19', 159.79),
(19, 21, 1, 4, '2024-02-28', 199.05),
(47, 28, 3, 3, '2024-08-05', 240.04),
(113, 23, 1, 5, '2024-04-21', 55.18),
(56, 34, 1, 1, '2024-09-25', 945.93),
(63, 37, 5, 4, '2023-12-13', 722.09),
(105, 20, 5, 3, '2024-05-14', 265.66),
(108, 31, 4, 3, '2024-03-27', 235.48),
(162, 42, 1, 4, '2023-12-19', 436.5),
(182, 29, 3, 1, '2024-09-21', 186.81),
(165, 8, 3, 5, '2024-02-18', 225.18),
(173, 22, 1, 2, '2024-11-13', 30.39),
(16, 7, 2, 1, '2024-02-02', 801.76),
(167, 2, 2, 1, '2024-06-29', 536.65),
(87, 15, 2, 2, '2024-02-17', 537.54),
(137, 44, 3, 4, '2024-02-22', 793.58),
(77, 46, 1, 4, '2024-02-02', 454.02),
(183, 35, 1, 3, '2024-08-29', 935.33),
(128, 5, 5, 2, '2024-03-05', 250.7),
(192, 2, 4, 4, '2024-01-16', 426.01),
(189, 23, 5, 4, '2024-06-14', 458.14),
(34, 22, 5, 5, '2024-11-01', 966.0),
(22, 14, 3, 3, '2024-01-01', 291.87),
(52, 12, 5, 5, '2024-04-03', 534.94),
(73, 9, 3, 1, '2024-07-06', 608.94),
(78, 25, 1, 1, '2024-04-11', 443.86),
(81, 10, 4, 2, '2024-04-03', 550.0),
(147, 19, 5, 4, '2024-08-20', 997.08),
(165, 22, 1, 2, '2024-03-14', 778.75),
(185, 28, 5, 3, '2024-01-17', 58.29),
(23, 48, 5, 4, '2024-05-31', 530.83),
(30, 37, 3, 4, '2024-03-22', 638.98),
(179, 48, 1, 2, '2024-08-24', 673.99),
(111, 7, 1, 1, '2024-03-10', 218.64),
(113, 24, 5, 3, '2024-07-11', 868.63),
(116, 42, 4, 1, '2024-01-25', 235.78),
(87, 12, 4, 5, '2024-03-22', 831.87),
(11, 28, 3, 4, '2024-04-12', 91.02),
(130, 31, 1, 1, '2024-04-17', 274.31),
(80, 43, 5, 5, '2024-06-18', 576.92),
(145, 45, 1, 3, '2024-03-02', 770.1),
(90, 44, 2, 2, '2024-09-22', 206.6),
(154, 6, 5, 1, '2024-08-20', 77.44),
(58, 45, 3, 3, '2023-12-12', 120.38),
(93, 24, 5, 4, '2024-04-19', 787.09),
(196, 3, 5, 3, '2024-09-19', 171.85),
(108, 14, 4, 1, '2024-06-05', 842.96),
(52, 18, 3, 1, '2024-07-05', 783.52),
(142, 47, 3, 2, '2023-12-18', 114.15),
(50, 33, 1, 5, '2023-12-14', 873.02),
(149, 49, 2, 3, '2024-04-21', 189.41),
(130, 38, 1, 4, '2024-07-07', 915.56),
(173, 32, 3, 5, '2024-08-13', 443.16),
(93, 10, 4, 2, '2024-07-31', 832.41),
(5, 17, 3, 3, '2024-07-30', 910.44),
(62, 40, 5, 2, '2023-12-18', 376.36),
(17, 3, 5, 3, '2024-08-01', 118.25),
(91, 18, 2, 1, '2024-08-08', 129.52),
(95, 16, 3, 4, '2024-03-25', 95.66),
(101, 22, 2, 3, '2024-06-15', 37.75),
(199, 23, 5, 4, '2024-01-03', 629.35),
(124, 8, 4, 5, '2024-05-21', 987.66),
(35, 35, 5, 3, '2024-07-29', 509.63),
(34, 33, 5, 5, '2024-02-10', 673.27),
(53, 30, 2, 1, '2024-02-26', 709.63),
(170, 34, 3, 3, '2024-04-18', 991.73),
(44, 46, 2, 2, '2024-02-14', 773.4),
(15, 31, 3, 2, '2024-01-18', 946.97),
(154, 40, 5, 2, '2024-05-23', 854.37),
(168, 32, 3, 2, '2024-09-26', 523.58),
(66, 50, 4, 2, '2024-02-12', 297.68),
(60, 46, 4, 1, '2024-09-16', 970.11),
(78, 24, 1, 1, '2024-04-12', 929.31),
(75, 19, 2, 5, '2024-09-14', 623.49),
(152, 18, 1, 1, '2024-03-18', 158.84),
(154, 25, 1, 2, '2024-10-07', 429.16),
(152, 49, 4, 5, '2024-10-02', 94.67),
(40, 25, 3, 4, '2023-12-04', 458.92),
(46, 23, 1, 2, '2024-05-26', 387.19),
(27, 33, 3, 2, '2024-01-27', 215.25),
(3, 9, 5, 4, '2023-11-22', 289.38),
(46, 19, 2, 2, '2024-08-02', 256.53),
(150, 41, 4, 4, '2024-02-10', 513.13),
(66, 5, 4, 2, '2024-02-06', 101.09),
(48, 35, 3, 4, '2024-10-19', 506.35),
(103, 16, 2, 1, '2024-08-04', 917.76),
(197, 19, 4, 3, '2024-08-07', 913.03),
(18, 10, 3, 2, '2024-01-25', 815.83),
(161, 12, 1, 5, '2024-04-04', 707.21),
(170, 46, 2, 4, '2024-09-05', 485.9),
(93, 24, 4, 3, '2024-08-06', 343.72),
(114, 26, 3, 4, '2024-07-14', 586.31),
(21, 19, 2, 3, '2024-02-26', 97.72),
(2, 39, 4, 1, '2024-06-20', 387.63),
(128, 50, 3, 1, '2024-06-08', 507.68),
(129, 25, 3, 1, '2024-05-28', 954.91),
(51, 26, 2, 3, '2024-06-06', 180.86),
(117, 6, 4, 5, '2024-11-12', 410.72),
(116, 32, 3, 2, '2024-01-23', 936.88),
(2, 43, 4, 1, '2024-11-06', 961.13),
(162, 7, 1, 4, '2024-10-04', 296.73),
(169, 1, 5, 5, '2024-01-26', 676.32),
(50, 27, 4, 1, '2024-04-07', 661.62),
(103, 33, 3, 5, '2024-11-05', 302.56),
(78, 6, 3, 5, '2024-05-26', 805.11),
(148, 4, 3, 4, '2024-08-30', 699.8),
(31, 12, 1, 1, '2024-03-06', 490.22),
(130, 28, 5, 4, '2024-07-31', 422.56),
(150, 25, 4, 2, '2024-03-16', 836.18),
(102, 8, 3, 5, '2023-12-25', 233.29),
(145, 26, 1, 3, '2024-07-15', 490.23),
(19, 8, 3, 2, '2024-02-16', 622.02),
(113, 18, 4, 3, '2024-07-09', 59.26),
(84, 17, 5, 5, '2024-04-09', 822.58),
(20, 21, 4, 5, '2024-02-06', 403.43),
(46, 43, 2, 2, '2024-06-19', 43.76),
(117, 49, 2, 2, '2024-09-08', 177.61),
(155, 44, 2, 1, '2024-11-10', 579.3),
(1, 30, 4, 5, '2024-02-14', 169.01),
(41, 26, 4, 2, '2024-05-17', 327.05),
(13, 13, 1, 1, '2024-04-02', 846.38),
(139, 20, 2, 5, '2024-10-18', 411.38),
(182, 20, 4, 4, '2024-05-24', 796.96),
(33, 12, 3, 2, '2024-02-08', 908.52),
(165, 18, 2, 3, '2024-08-29', 352.21),
(111, 6, 5, 4, '2024-08-08', 367.69),
(95, 20, 4, 1, '2024-01-12', 979.53),
(32, 34, 5, 2, '2024-06-13', 688.54),
(123, 16, 3, 5, '2024-09-16', 553.34),
(192, 10, 4, 5, '2024-01-06', 592.43),
(94, 35, 4, 5, '2024-09-04', 20.79),
(170, 34, 4, 4, '2024-07-28', 488.47),
(29, 18, 1, 2, '2023-11-30', 268.22),
(125, 30, 5, 3, '2024-04-02', 426.41),
(110, 4, 2, 2, '2024-11-12', 845.59),
(107, 13, 4, 4, '2024-05-26', 112.6),
(151, 24, 3, 4, '2024-11-09', 448.86),
(152, 35, 2, 3, '2023-11-25', 271.1),
(51, 3, 5, 2, '2024-10-11', 942.58),
(94, 9, 5, 3, '2024-01-29', 34.66),
(132, 13, 2, 5, '2023-11-25', 492.82),
(163, 26, 2, 3, '2024-02-26', 846.76),
(132, 9, 3, 5, '2024-08-06', 811.59),
(148, 47, 1, 5, '2024-07-31', 497.07),
(107, 30, 5, 4, '2024-07-28', 357.95),
(186, 30, 5, 5, '2024-08-29', 464.27),
(169, 14, 5, 2, '2023-12-18', 863.66),
(4, 42, 5, 1, '2024-03-06', 305.5),
(84, 2, 3, 5, '2024-01-18', 945.4),
(139, 25, 5, 3, '2024-08-20', 96.13),
(7, 13, 2, 2, '2024-10-04', 591.98),
(16, 12, 1, 4, '2024-03-18', 604.86),
(138, 8, 2, 1, '2024-04-04', 678.22),
(65, 31, 4, 2, '2024-06-14', 738.2),
(114, 49, 4, 1, '2024-06-12', 320.72),
(82, 32, 4, 1, '2024-01-21', 892.1),
(130, 42, 1, 3, '2024-03-05', 955.27),
(20, 30, 2, 5, '2024-05-03', 601.57);
GO

-- DetalheVenda
INSERT INTO DetalheVenda (VendaID, ProdutoID, Quantidade, PrecoUnitario, DescontoAplicado) VALUES
(122, 55, 7, 164.67, 39.76),
(48, 74, 10, 473.49, 16.48),
(87, 77, 2, 115.83, 27.61),
(114, 187, 2, 195.9, 18.58),
(98, 33, 10, 339.92, 1.68),
(166, 169, 9, 194.61, 11.74),
(7, 67, 6, 62.5, 27.16),
(166, 6, 7, 267.52, 31.6),
(172, 135, 3, 365.99, 15.47),
(29, 63, 5, 344.1, 13.48),
(84, 70, 4, 35.1, 48.7),
(121, 175, 7, 393.39, 5.37),
(65, 4, 9, 417.84, 0.47),
(140, 138, 4, 124.4, 0.26),
(52, 22, 1, 283.07, 41.34),
(136, 62, 2, 8.9, 43.03),
(165, 111, 3, 229.59, 13.98),
(37, 183, 8, 14.07, 25.4),
(32, 153, 6, 68.74, 25.78),
(36, 200, 10, 16.66, 30.75),
(91, 164, 4, 293.35, 22.68),
(38, 48, 1, 403.35, 24.52),
(165, 144, 8, 315.57, 5.51),
(16, 173, 2, 134.39, 14.79),
(82, 186, 5, 54.31, 31.36),
(22, 107, 3, 162.0, 37.22),
(56, 80, 9, 183.99, 1.92),
(130, 104, 3, 271.09, 44.46),
(154, 61, 4, 1.75, 37.3),
(3, 98, 6, 46.85, 49.26),
(171, 95, 1, 159.45, 5.76),
(189, 33, 4, 464.82, 22.57),
(59, 102, 4, 497.85, 10.72),
(2, 49, 3, 354.13, 0.72),
(58, 1, 7, 80.16, 43.92),
(8, 146, 9, 361.84, 21.49),
(89, 162, 3, 215.42, 34.7),
(148, 116, 7, 432.18, 14.4),
(5, 183, 8, 207.34, 46.55),
(66, 98, 6, 8.77, 38.58),
(153, 61, 10, 101.13, 38.83),
(36, 153, 5, 115.37, 38.8),
(90, 66, 6, 25.96, 29.05),
(52, 199, 5, 120.49, 38.12),
(14, 23, 6, 158.33, 27.89),
(197, 140, 3, 150.85, 28.81),
(142, 170, 8, 56.72, 15.46),
(48, 17, 10, 64.11, 6.13),
(125, 158, 6, 219.52, 12.6),
(160, 87, 10, 188.26, 20.58),
(107, 75, 9, 388.82, 36.26),
(59, 97, 6, 61.53, 3.29),
(110, 123, 9, 407.41, 19.1),
(195, 81, 4, 271.3, 2.28),
(102, 35, 3, 377.48, 20.57),
(55, 3, 1, 489.37, 24.23),
(197, 55, 9, 256.09, 45.03),
(116, 141, 3, 295.93, 14.18),
(123, 145, 1, 448.64, 10.09),
(62, 6, 4, 283.89, 11.08),
(182, 51, 6, 298.86, 15.53),
(117, 95, 7, 91.6, 12.55),
(178, 93, 1, 394.97, 27.46),
(87, 34, 3, 415.19, 0.27),
(189, 130, 8, 405.67, 34.93),
(196, 92, 5, 489.84, 14.68),
(192, 70, 4, 31.29, 35.19),
(189, 129, 7, 383.8, 49.47),
(15, 82, 2, 183.51, 19.96),
(81, 136, 8, 359.8, 32.78),
(167, 52, 5, 82.42, 8.88),
(132, 137, 10, 25.4, 34.02),
(182, 28, 5, 232.74, 29.38),
(109, 181, 4, 225.66, 0.65),
(85, 146, 6, 278.43, 47.58),
(44, 183, 8, 12.1, 20.79),
(12, 109, 3, 186.53, 45.67),
(49, 106, 8, 84.15, 35.24),
(97, 18, 4, 176.49, 44.86),
(16, 176, 4, 45.39, 28.0),
(88, 28, 4, 305.82, 15.65),
(134, 123, 5, 282.62, 31.75),
(72, 115, 2, 448.08, 16.34),
(36, 149, 1, 430.34, 1.28),
(177, 186, 8, 174.62, 6.28),
(33, 105, 10, 241.52, 18.92),
(75, 56, 9, 306.76, 19.73),
(3, 37, 2, 41.54, 15.41),
(26, 48, 9, 152.44, 19.6),
(61, 187, 8, 365.04, 0.24),
(71, 24, 8, 438.59, 20.31),
(110, 94, 3, 340.82, 40.41),
(19, 112, 7, 272.38, 34.54),
(13, 175, 7, 22.44, 12.97),
(180, 11, 2, 71.27, 37.76),
(67, 62, 3, 16.2, 41.05),
(83, 10, 1, 326.66, 18.77),
(115, 44, 8, 123.86, 11.18),
(30, 74, 9, 360.39, 31.98),
(150, 87, 7, 217.47, 3.36),
(163, 106, 6, 422.89, 20.86),
(99, 184, 4, 8.56, 26.39),
(56, 177, 4, 400.34, 20.49),
(74, 36, 6, 257.63, 1.66),
(162, 130, 9, 265.85, 11.82),
(76, 176, 7, 240.71, 32.6),
(129, 129, 3, 366.12, 10.17),
(63, 79, 8, 443.74, 44.88),
(111, 40, 5, 77.73, 40.34),
(192, 37, 6, 79.22, 7.43),
(147, 5, 3, 276.46, 31.14),
(120, 65, 7, 440.32, 6.08),
(97, 149, 8, 368.02, 8.33),
(56, 63, 9, 489.24, 48.81),
(77, 6, 5, 15.77, 38.48),
(109, 192, 10, 418.87, 13.74),
(144, 49, 9, 89.46, 33.53),
(123, 78, 2, 357.76, 27.67),
(61, 171, 6, 485.57, 29.95),
(184, 33, 10, 271.9, 35.54),
(42, 159, 2, 277.04, 35.82),
(97, 46, 10, 474.64, 32.57),
(99, 67, 4, 132.32, 6.19),
(84, 182, 7, 160.02, 2.83),
(59, 110, 3, 315.81, 8.19),
(25, 75, 3, 17.04, 27.6),
(97, 137, 3, 177.64, 13.36),
(103, 48, 5, 145.62, 2.26),
(80, 54, 2, 128.45, 49.72),
(188, 116, 7, 427.76, 43.03),
(180, 90, 2, 101.12, 48.82),
(198, 121, 10, 434.13, 21.83),
(130, 108, 4, 177.63, 33.25),
(121, 158, 5, 229.26, 16.2),
(33, 73, 3, 291.19, 14.88),
(185, 146, 10, 98.9, 45.79),
(133, 80, 7, 323.92, 41.0),
(20, 139, 8, 316.48, 32.71),
(173, 113, 8, 87.07, 41.82),
(82, 111, 2, 193.87, 0.76),
(40, 157, 3, 448.33, 13.63),
(101, 14, 4, 469.5, 23.78),
(85, 191, 9, 41.69, 12.71),
(53, 26, 3, 217.15, 6.3),
(23, 51, 7, 42.83, 10.47),
(108, 76, 4, 372.5, 4.52),
(40, 40, 1, 316.76, 5.12),
(101, 157, 9, 117.48, 34.0),
(4, 148, 8, 122.58, 20.01),
(54, 107, 10, 346.26, 49.48),
(87, 126, 1, 217.29, 42.57),
(65, 118, 10, 498.9, 3.69),
(177, 158, 7, 120.49, 17.69),
(5, 171, 6, 147.82, 47.58),
(144, 87, 7, 452.43, 4.76),
(10, 52, 7, 393.12, 4.34),
(182, 160, 8, 28.28, 29.35),
(90, 176, 9, 317.61, 20.98),
(113, 153, 8, 41.22, 48.79),
(46, 39, 1, 97.91, 19.72),
(177, 141, 1, 260.68, 10.69),
(88, 168, 6, 408.06, 21.24),
(177, 119, 3, 142.38, 42.37),
(168, 7, 4, 199.43, 38.27),
(156, 118, 2, 433.99, 28.75),
(76, 107, 9, 196.53, 19.0),
(183, 147, 4, 204.46, 2.9),
(165, 12, 10, 411.01, 42.3),
(1, 192, 3, 456.04, 40.26),
(58, 86, 3, 73.4, 12.3),
(82, 136, 8, 68.74, 15.51),
(142, 6, 7, 54.27, 9.35),
(91, 157, 3, 438.37, 28.63),
(34, 149, 8, 186.05, 4.54),
(4, 40, 9, 383.7, 4.01),
(75, 31, 10, 232.56, 4.75),
(9, 39, 4, 206.54, 14.44),
(121, 89, 1, 181.86, 25.74),
(93, 64, 7, 174.54, 0.61),
(168, 96, 5, 492.99, 38.84),
(101, 91, 3, 227.88, 3.79),
(29, 181, 10, 95.34, 7.65),
(160, 162, 4, 204.38, 25.49),
(127, 11, 3, 151.31, 12.85),
(50, 133, 8, 38.79, 48.81),
(147, 156, 9, 351.69, 18.95),
(36, 135, 3, 300.82, 13.48),
(28, 55, 8, 174.67, 46.32),
(84, 45, 7, 180.63, 10.54),
(183, 78, 8, 43.46, 29.15),
(120, 76, 4, 124.47, 30.02),
(131, 92, 1, 63.33, 42.16),
(97, 44, 6, 40.35, 30.1),
(167, 196, 4, 225.46, 43.54),
(143, 7, 9, 306.02, 10.9),
(28, 119, 7, 305.3, 36.93),
(24, 185, 10, 60.47, 9.77),
(184, 78, 1, 360.39, 7.08),
(36, 138, 5, 236.12, 19.19),
(97, 35, 2, 70.15, 17.4),
(55, 181, 8, 446.26, 38.51),
(40, 36, 3, 488.9, 46.38),
(12, 188, 3, 209.26, 41.72),
(127, 93, 5, 334.97, 29.57),
(159, 143, 9, 113.7, 27.41),
(83, 157, 1, 437.78, 0.15),
(170, 192, 2, 446.83, 2.41),
(80, 172, 6, 381.89, 27.52),
(134, 79, 8, 122.95, 49.52),
(150, 89, 10, 445.35, 42.74),
(102, 151, 5, 17.65, 9.26),
(81, 83, 2, 340.26, 46.42),
(50, 82, 3, 297.15, 39.49),
(80, 97, 6, 243.91, 34.02),
(108, 143, 2, 9.84, 41.45),
(49, 107, 9, 195.68, 29.57),
(23, 69, 10, 326.86, 18.62),
(139, 24, 10, 364.5, 17.57),
(183, 125, 4, 336.39, 6.19),
(148, 124, 1, 352.19, 12.59),
(8, 33, 3, 317.45, 3.89),
(42, 110, 2, 169.35, 20.3),
(58, 51, 6, 108.88, 1.29),
(83, 91, 2, 167.88, 1.95),
(104, 200, 3, 102.98, 14.53),
(168, 176, 3, 111.96, 19.82),
(119, 120, 10, 431.33, 27.77),
(24, 135, 3, 47.17, 43.16),
(136, 81, 1, 388.39, 15.84),
(96, 163, 4, 127.75, 36.91),
(145, 192, 3, 150.13, 45.49),
(155, 4, 1, 475.74, 40.4),
(49, 68, 1, 443.14, 39.73),
(191, 32, 9, 175.5, 0.99),
(30, 161, 4, 183.27, 33.67),
(121, 198, 2, 416.2, 9.75),
(48, 32, 6, 406.8, 40.46),
(191, 153, 6, 466.75, 38.19),
(114, 29, 7, 157.17, 29.27),
(159, 129, 4, 471.92, 2.44),
(115, 131, 5, 2.03, 6.97),
(8, 32, 9, 378.27, 37.09),
(88, 178, 4, 442.14, 13.18),
(150, 159, 1, 124.4, 35.84),
(117, 124, 6, 228.37, 12.91),
(190, 122, 3, 226.71, 24.14),
(85, 79, 2, 47.63, 45.49),
(20, 151, 4, 106.47, 31.22),
(135, 80, 2, 452.21, 23.34),
(44, 9, 1, 370.14, 24.21),
(194, 133, 5, 120.71, 37.41),
(49, 185, 2, 207.26, 37.07),
(113, 110, 6, 350.74, 10.51),
(178, 47, 3, 405.86, 41.96),
(188, 86, 3, 77.43, 18.79),
(80, 166, 10, 310.07, 46.74),
(94, 7, 9, 166.26, 21.83),
(101, 25, 10, 494.78, 39.56),
(31, 139, 4, 54.16, 16.42),
(194, 194, 5, 12.82, 49.75),
(8, 109, 3, 297.9, 1.31),
(30, 32, 3, 54.38, 23.1),
(63, 76, 4, 387.24, 43.92),
(156, 95, 10, 294.18, 3.87),
(96, 170, 4, 32.47, 21.75),
(51, 43, 3, 271.94, 10.92),
(85, 191, 9, 144.16, 24.88),
(83, 122, 6, 443.02, 48.55),
(29, 130, 4, 260.85, 49.56),
(29, 37, 2, 186.42, 43.16),
(185, 177, 1, 268.3, 35.78),
(54, 124, 3, 236.42, 5.32),
(126, 157, 6, 210.71, 1.79),
(172, 183, 8, 483.9, 18.04),
(156, 112, 10, 150.24, 21.78),
(150, 164, 9, 283.54, 28.76),
(132, 110, 10, 231.17, 21.73),
(183, 112, 7, 306.14, 2.17),
(64, 71, 6, 324.52, 27.95),
(84, 155, 8, 428.11, 5.94),
(73, 93, 1, 442.36, 30.76),
(192, 115, 10, 105.56, 48.24),
(197, 143, 8, 84.31, 30.0),
(107, 185, 8, 347.45, 23.47),
(197, 88, 6, 494.76, 8.75),
(182, 178, 9, 34.3, 47.68),
(132, 34, 6, 35.79, 27.31),
(128, 164, 3, 235.55, 21.51),
(106, 134, 9, 121.4, 16.03),
(38, 92, 7, 79.71, 23.33),
(143, 86, 6, 168.68, 14.32),
(145, 156, 3, 311.68, 33.47),
(149, 43, 2, 281.15, 1.33),
(16, 111, 3, 67.64, 34.57),
(191, 72, 7, 319.04, 18.97),
(148, 70, 3, 306.07, 9.78),
(198, 44, 6, 35.12, 44.71),
(113, 38, 2, 414.73, 37.93),
(189, 126, 1, 1.13, 44.75),
(16, 125, 9, 9.69, 12.27),
(95, 1, 1, 120.64, 19.57),
(64, 12, 8, 148.92, 18.02),
(45, 86, 8, 167.35, 27.14),
(186, 17, 9, 400.32, 49.33),
(141, 118, 8, 134.25, 36.54),
(61, 62, 3, 149.54, 9.57),
(58, 164, 6, 394.28, 3.57),
(5, 6, 10, 25.63, 5.09),
(29, 186, 4, 47.54, 32.2),
(189, 47, 7, 448.82, 27.26),
(12, 92, 5, 293.23, 22.8),
(63, 113, 10, 26.31, 49.5),
(121, 72, 6, 280.01, 30.55),
(163, 127, 9, 477.92, 12.75),
(149, 113, 4, 389.45, 37.35),
(186, 86, 3, 306.83, 19.67),
(67, 110, 8, 53.51, 43.29),
(75, 74, 4, 258.12, 31.99),
(98, 25, 4, 121.19, 47.85),
(129, 145, 3, 67.33, 32.67),
(166, 14, 9, 315.8, 29.83),
(71, 15, 7, 152.68, 8.57),
(121, 200, 8, 385.49, 6.04),
(185, 139, 9, 49.98, 19.89),
(45, 31, 4, 50.69, 45.84),
(77, 87, 8, 483.5, 15.93),
(79, 91, 8, 362.64, 38.38),
(48, 68, 3, 439.33, 26.93),
(57, 18, 3, 350.78, 49.99),
(165, 184, 7, 195.96, 35.74),
(123, 60, 2, 442.04, 13.96),
(123, 53, 10, 359.8, 26.62),
(80, 148, 4, 347.83, 32.54),
(172, 149, 6, 232.07, 31.95),
(102, 44, 1, 322.35, 25.33),
(47, 188, 10, 7.67, 48.73),
(176, 175, 9, 106.21, 5.56),
(188, 26, 3, 193.9, 25.33),
(159, 76, 9, 25.03, 43.56),
(117, 60, 3, 428.71, 6.26),
(154, 128, 6, 283.13, 20.67),
(46, 89, 9, 302.05, 37.39),
(87, 162, 6, 17.13, 38.34),
(2, 156, 3, 214.33, 0.15),
(29, 91, 2, 356.7, 35.91),
(180, 185, 5, 197.93, 11.0),
(157, 167, 2, 294.3, 41.72),
(55, 89, 10, 93.92, 11.25),
(91, 137, 8, 59.76, 10.92),
(122, 12, 7, 367.52, 27.36),
(77, 177, 6, 1.74, 29.76),
(25, 88, 3, 328.72, 30.1),
(175, 82, 4, 266.83, 3.82),
(84, 132, 5, 493.46, 6.49),
(20, 199, 9, 234.81, 12.54),
(52, 115, 3, 325.2, 14.68),
(110, 71, 6, 151.28, 3.56),
(65, 115, 8, 80.93, 32.17),
(26, 189, 6, 44.97, 0.1),
(137, 62, 10, 266.49, 20.54),
(36, 95, 9, 322.37, 24.09),
(176, 9, 2, 188.76, 29.39),
(25, 58, 1, 124.04, 7.94),
(114, 161, 8, 96.39, 49.12),
(40, 104, 4, 346.09, 45.77),
(101, 115, 9, 470.69, 45.98),
(192, 180, 8, 218.52, 31.27),
(106, 25, 8, 63.76, 8.17),
(167, 73, 1, 434.05, 37.73),
(85, 71, 10, 359.92, 32.04),
(82, 165, 8, 2.08, 17.65),
(49, 162, 4, 211.04, 30.06),
(26, 67, 5, 151.68, 29.7),
(130, 196, 6, 464.82, 40.83),
(163, 153, 10, 352.33, 21.07),
(166, 196, 4, 331.16, 34.45),
(103, 6, 3, 450.87, 49.68),
(128, 183, 6, 181.67, 41.81),
(120, 165, 10, 168.46, 24.9),
(103, 147, 8, 407.4, 4.84),
(186, 182, 5, 482.99, 6.09),
(190, 151, 3, 91.59, 17.34),
(124, 97, 3, 206.34, 35.23),
(4, 129, 4, 138.1, 46.4),
(97, 160, 4, 401.51, 38.1),
(164, 116, 8, 397.06, 41.78),
(20, 37, 5, 35.02, 40.3),
(135, 169, 2, 268.33, 29.53),
(135, 105, 10, 30.58, 11.9),
(128, 79, 1, 148.55, 19.5),
(97, 80, 2, 5.52, 16.38),
(26, 16, 5, 186.4, 3.87),
(83, 40, 7, 13.54, 45.38),
(197, 45, 6, 9.61, 16.84),
(108, 81, 10, 17.61, 7.2),
(43, 86, 10, 85.52, 24.5),
(73, 138, 8, 117.87, 48.28),
(196, 119, 9, 312.87, 24.51),
(67, 30, 6, 491.36, 14.79),
(47, 84, 4, 499.32, 43.37),
(28, 173, 8, 388.84, 4.96),
(154, 117, 10, 8.15, 32.55),
(54, 47, 2, 376.38, 9.81),
(72, 56, 5, 317.54, 1.77),
(18, 136, 9, 269.99, 36.87),
(130, 190, 3, 161.96, 33.01),
(53, 24, 3, 495.93, 45.0),
(1, 118, 10, 140.88, 1.64),
(40, 126, 9, 350.56, 13.66),
(49, 134, 3, 370.12, 41.62),
(170, 94, 1, 67.05, 19.21),
(78, 23, 4, 441.38, 14.43),
(198, 122, 1, 258.61, 8.67),
(120, 141, 5, 145.41, 47.25),
(53, 2, 4, 365.23, 42.8),
(63, 114, 3, 116.96, 22.79),
(76, 154, 6, 189.18, 33.35),
(155, 124, 7, 489.02, 13.3),
(87, 68, 8, 385.95, 14.7),
(156, 102, 5, 370.27, 37.56),
(179, 187, 2, 113.05, 29.79),
(124, 183, 8, 445.48, 12.93),
(127, 99, 9, 282.51, 49.69),
(54, 172, 3, 319.2, 15.59),
(149, 11, 5, 379.82, 21.34),
(38, 76, 4, 358.46, 15.34),
(24, 39, 3, 174.5, 24.98),
(113, 153, 2, 158.19, 43.02),
(150, 187, 3, 245.52, 1.44),
(70, 104, 3, 4.41, 12.83),
(81, 80, 7, 123.13, 32.86),
(87, 20, 5, 221.78, 1.25),
(108, 182, 10, 375.82, 30.36),
(102, 198, 3, 357.19, 15.4),
(134, 78, 1, 204.58, 20.74),
(101, 128, 3, 359.98, 35.62),
(126, 77, 1, 357.74, 20.58),
(29, 154, 1, 452.33, 6.76),
(147, 159, 10, 467.83, 49.75),
(6, 13, 3, 419.45, 4.16),
(160, 146, 6, 345.58, 9.91),
(62, 33, 3, 110.01, 3.28),
(63, 7, 7, 65.96, 27.35),
(105, 160, 7, 404.55, 26.65),
(195, 71, 8, 223.44, 36.99),
(190, 7, 6, 108.31, 31.28),
(63, 199, 5, 320.03, 35.38),
(146, 35, 10, 95.91, 11.48),
(192, 132, 1, 113.69, 38.82),
(56, 149, 9, 409.3, 2.57),
(93, 51, 2, 447.21, 25.36),
(3, 160, 7, 202.58, 4.09),
(100, 146, 5, 445.92, 32.73),
(182, 98, 7, 142.07, 24.46),
(178, 113, 9, 433.51, 31.06),
(198, 119, 8, 462.85, 6.0),
(73, 14, 10, 360.21, 30.93),
(129, 68, 9, 194.23, 41.54),
(80, 26, 5, 361.79, 18.32),
(110, 7, 6, 381.75, 19.78),
(31, 127, 5, 262.55, 9.26),
(91, 185, 2, 200.72, 34.22),
(99, 161, 3, 377.82, 22.54),
(11, 5, 10, 391.54, 47.76),
(65, 56, 8, 22.92, 48.81),
(16, 27, 7, 303.62, 40.54),
(82, 61, 7, 107.54, 14.36),
(64, 2, 2, 43.71, 23.18),
(89, 180, 4, 44.52, 17.26),
(2, 21, 3, 130.75, 2.58),
(185, 48, 1, 6.83, 25.16),
(10, 29, 2, 297.66, 35.56),
(114, 70, 4, 202.15, 47.94),
(62, 4, 7, 220.73, 17.38),
(36, 129, 4, 307.43, 26.19),
(197, 27, 1, 454.48, 37.41),
(32, 89, 1, 26.92, 19.22),
(33, 116, 8, 15.59, 11.36),
(114, 136, 1, 388.31, 12.68),
(11, 26, 8, 242.31, 14.48),
(184, 55, 2, 26.98, 49.73),
(144, 170, 10, 226.73, 41.58),
(194, 75, 6, 470.99, 10.48),
(198, 176, 5, 32.26, 13.42),
(68, 140, 4, 81.98, 29.69),
(6, 111, 3, 356.92, 11.1),
(158, 195, 7, 149.26, 35.07),
(119, 160, 10, 420.99, 9.24),
(163, 177, 5, 419.14, 42.04),
(129, 124, 2, 188.87, 25.54),
(177, 141, 5, 397.43, 20.34),
(82, 130, 4, 339.2, 1.06),
(172, 194, 3, 308.51, 47.97),
(37, 121, 1, 155.99, 47.43),
(184, 180, 6, 43.16, 4.26),
(114, 106, 3, 431.27, 4.92),
(115, 137, 9, 374.6, 5.96),
(103, 182, 7, 254.58, 1.14),
(137, 172, 8, 106.08, 26.54),
(106, 102, 5, 393.35, 29.11);
GO

-- Stock
INSERT INTO Stock (ProdutoID, QuantidadeDisponivel, NivelCritico) VALUES
(1, 191, 35),
(2, 353, 25),
(3, 292, 44),
(4, 459, 17),
(5, 328, 23),
(6, 429, 43),
(7, 162, 26),
(8, 359, 23),
(9, 224, 31),
(10, 389, 44),
(11, 260, 16),
(12, 102, 44),
(13, 444, 33),
(14, 158, 49),
(15, 127, 47),
(16, 292, 12),
(17, 194, 41),
(18, 421, 18),
(19, 119, 20),
(20, 472, 16),
(21, 197, 48),
(22, 355, 22),
(23, 92, 14),
(24, 105, 20),
(25, 494, 33),
(26, 205, 17),
(27, 93, 42),
(28, 483, 14),
(29, 56, 19),
(30, 167, 18),
(31, 467, 14),
(32, 68, 30),
(33, 399, 44),
(34, 268, 32),
(35, 220, 28),
(36, 283, 23),
(37, 340, 50),
(38, 472, 16),
(39, 64, 12),
(40, 286, 34),
(41, 415, 16),
(42, 98, 26),
(43, 139, 13),
(44, 309, 46),
(45, 322, 45),
(46, 66, 20),
(47, 326, 33),
(48, 144, 20),
(49, 312, 19),
(50, 450, 23),
(51, 485, 44),
(52, 257, 26),
(53, 455, 40),
(54, 266, 27),
(55, 105, 39),
(56, 407, 43),
(57, 335, 48),
(58, 319, 16),
(59, 297, 42),
(60, 398, 11),
(61, 440, 12),
(62, 84, 35),
(63, 474, 36),
(64, 244, 36),
(65, 463, 20),
(66, 349, 50),
(67, 216, 33),
(68, 405, 45),
(69, 266, 46),
(70, 148, 44),
(71, 229, 30),
(72, 267, 31),
(73, 185, 48),
(74, 363, 37),
(75, 155, 17),
(76, 282, 34),
(77, 471, 44),
(78, 266, 50),
(79, 201, 34),
(80, 76, 14),
(81, 107, 50),
(82, 66, 42),
(83, 447, 12),
(84, 233, 13),
(85, 158, 28),
(86, 172, 49),
(87, 290, 31),
(88, 235, 15),
(89, 195, 49),
(90, 191, 31),
(91, 234, 47),
(92, 476, 15),
(93, 332, 48),
(94, 373, 35),
(95, 272, 32),
(96, 328, 17),
(97, 193, 40),
(98, 427, 41),
(99, 387, 36),
(100, 247, 23),
(101, 291, 34),
(102, 59, 31),
(103, 192, 23),
(104, 446, 33),
(105, 388, 49),
(106, 390, 38),
(107, 402, 19),
(108, 345, 30),
(109, 158, 48),
(110, 237, 45),
(111, 90, 25),
(112, 135, 44),
(113, 387, 15),
(114, 279, 27),
(115, 460, 31),
(116, 207, 48),
(117, 67, 39),
(118, 197, 15),
(119, 368, 21),
(120, 270, 35),
(121, 304, 14),
(122, 77, 24),
(123, 489, 40),
(124, 425, 43),
(125, 383, 31),
(126, 327, 18),
(127, 385, 15),
(128, 253, 33),
(129, 176, 22),
(130, 366, 40),
(131, 485, 30),
(132, 478, 16),
(133, 386, 50),
(134, 113, 18),
(135, 115, 31),
(136, 301, 17),
(137, 417, 36),
(138, 295, 49),
(139, 474, 34),
(140, 142, 28),
(141, 120, 25),
(142, 427, 42),
(143, 351, 22),
(144, 197, 17),
(145, 155, 23),
(146, 423, 44),
(147, 363, 21),
(148, 433, 10),
(149, 93, 10),
(150, 345, 32),
(151, 247, 15),
(152, 328, 43),
(153, 112, 33),
(154, 478, 16),
(155, 336, 25),
(156, 276, 16),
(157, 406, 22),
(158, 227, 27),
(159, 322, 31),
(160, 471, 42),
(161, 147, 18),
(162, 89, 44),
(163, 488, 48),
(164, 391, 41),
(165, 74, 23),
(166, 330, 30),
(167, 268, 33),
(168, 85, 24),
(169, 481, 46),
(170, 412, 33),
(171, 306, 50),
(172, 97, 14),
(173, 51, 47),
(174, 326, 48),
(175, 291, 10),
(176, 353, 17),
(177, 66, 18),
(178, 95, 26),
(179, 73, 30),
(180, 444, 40),
(181, 440, 20),
(182, 471, 32),
(183, 428, 29),
(184, 357, 12),
(185, 300, 37),
(186, 77, 13),
(187, 69, 41),
(188, 196, 21),
(189, 415, 34),
(190, 64, 25),
(191, 341, 36),
(192, 274, 30),
(193, 476, 21),
(194, 107, 47),
(195, 64, 33),
(196, 346, 44),
(197, 367, 38),
(198, 264, 16),
(199, 119, 20),
(200, 385, 26);
GO

INSERT INTO Logs (TipoLog, DataLog, Descricao) VALUES
('ALERTA: Stock Crítico', 2024-06-26, 'ProdutoID: 1, Quantidade Disponível: 4 está abaixo do Nível Crítico: 10,'),
('ALERTA: Stock Crítico', 2024-07-12, 'ProdutoID: 2, Quantidade Disponível: 8 está abaixo do Nível Crítico: 10,'),
('Inserção de Stock', 2024-06-30, 'ProdutoID: 3, Quantidade Disponível: 50, Nível Crítico: 5,'),
('Atualização de Stock', 2024-07-10, 'ProdutoID: 4, Quantidade Anterior: 30, Quantidade Atual: 25,'),
('AUDITORIA: Atualização de Cliente', 2024-08-01, 'ClienteID: 10, Nome alterado de Maria Silva para Maria Costa, Endereco alterado de Rua A para Rua B'),
('AUDITORIA: Atualização de Fornecedor', 2024-08-05, 'FornecedorID: 5, NomeFornecedor alterado de Fornecedor X para Fornecedor Y, Endereco alterado de Rua do Porto, 50 para Avenida da Liberdade, 100'),
('Inserção de Stock', 2024-08-10, 'ProdutoID: 6, Quantidade Disponível: 100, Nível Crítico: 20'),
('ALERTA: Stock Crítico', 2024-08-15, 'ProdutoID: 7, Quantidade Disponível: 5 está abaixo do Nível Crítico: 10'),
('AUDITORIA: Atualização de Cliente', 2024-09-01, 'ClienteID: 15, DataNascimento alterado de 1990-05-25 para 1992-10-1'),
('ALERTA: Stock Crítico', 2024-09-03, 'ProdutoID: 8, Quantidade Disponível: 3 está abaixo do Nível Crítico: 10,'),
('AUDITORIA: Atualização de Fornecedor', 2024-09-05, 'FornecedorID: 8, Telefone alterado de 123456789 para 987654321'),
('Inserção de Stock', 2024-09-10, 'ProdutoID: 9, Quantidade Disponível: 60, Nível Crítico: 15,'),
('Atualização de Stock', 2024-09-12, 'ProdutoID: 10, Quantidade Anterior: 40, Quantidade Atual: 50,'),
('AUDITORIA: Atualização de Cliente', 2024-09-15, 'ClienteID: 20, CartaoCliente alterado de 0 para 1'),
('ALERTA: Stock Crítico', 2024-09-18, 'ProdutoID: 11, Quantidade Disponível: 2 está abaixo do Nível Crítico: 10'),
('AUDITORIA: Atualização de Fornecedor', 2024-09-20, 'FornecedorID: 12, Endereco alterado de Rua das Palmeiras, 10 para Rua Nova, 20'),
('Inserção de Stock', 2024-09-22, 'ProdutoID: 13, Quantidade Disponível: 200, Nível Crítico: 50'),
('ALERTA: Stock Crítico', 2024-09-25, 'ProdutoID: 14, Quantidade Disponível: 8 está abaixo do Nível Crítico: 10'),
('AUDITORIA: Atualização de Cliente', 2024-09-28, 'ClienteID: 30, Nome alterado de Carlos Pereira para Carlos Santos'),
('Atualização de Stock', 2024-09-30, 'ProdutoID: 15, Quantidade Anterior: 60, Quantidade Atual: 55'),
('ALERTA: Stock Crítico', 2024-10-01, 'ProdutoID: 16, Quantidade Disponível: 7 está abaixo do Nível Crítico: 10'),
('Inserção de Stock', 2024-10-02, 'ProdutoID: 17, Quantidade Disponível: 150, Nível Crítico: 50'),
('AUDITORIA: Atualização de Fornecedor', 2024-10-05, 'FornecedorID: 18, Endereco alterado de Rua 1, 100 para Rua Central, 200'),
('ALERTA: Stock Crítico', 2024-10-10, 'ProdutoID: 18, Quantidade Disponível: 6 está abaixo do Nível Crítico: 10'),
('AUDITORIA: Atualização de Cliente', 2024-10-15, 'ClienteID: 35, Desconto alterado de 10 para 5'),
('Inserção de Stock', 2024-10-18, 'ProdutoID: 19, Quantidade Disponível: 90, Nível Crítico: 20'),
('ALERTA: Stock Crítico', 2024-10-20, 'ProdutoID: 20, Quantidade Disponível: 4 está abaixo do Nível Crítico: 10'),
('Atualização de Stock', 2024-10-25, 'ProdutoID: 21, Quantidade Anterior: 50, Quantidade Atual: 45'),
('Inserção de Stock', 2024-10-30, 'ProdutoID: 22, Quantidade Disponível: 80, Nível Crítico: 25'),
('AUDITORIA: Atualização de Fornecedor', 2024-11-02, 'FornecedorID: 25, NomeFornecedor alterado de Fornecedor Z para Fornecedor A'),
('ALERTA: Stock Crítico', 2024-11-05, 'ProdutoID: 23, Quantidade Disponível: 3 está abaixo do Nível Crítico: 10'),
('Inserção de Stock', 2024-11-08, 'ProdutoID: 24, Quantidade Disponível: 120, Nível Crítico: 40'),
('AUDITORIA: Atualização de Cliente', 2024-11-10, 'ClienteID: 40, Endereco alterado de Rua B, 200 para Rua C, 250'),
('ALERTA: Stock Crítico', 2024-11-15, 'ProdutoID: 25, Quantidade Disponível: 6 está abaixo do Nível Crítico: 15'),
('AUDITORIA: Atualização de Fornecedor', 2024-11-18, 'FornecedorID: 30, Telefone alterado de 987654321 para 112233445'),
('Inserção de Stock', 2024-11-20, 'ProdutoID: 26, Quantidade Disponível: 200, Nível Crítico: 75'),
('ALERTA: Stock Crítico', 2024-11-25, 'ProdutoID: 27, Quantidade Disponível: 2 está abaixo do Nível Crítico: 10'),
('AUDITORIA: Atualização de Cliente', 2024-11-28, 'ClienteID: 50, CartaoCliente alterado de 1 para 0'),
('Inserção de Stock', 2024-11-30, 'ProdutoID: 28, Quantidade Disponível: 150, Nível Crítico: 50');
GO

SELECT * FROM CategoriaProduto;
SELECT * FROM Produto;
SELECT * FROM Cliente;
SELECT * FROM Funcionario;
SELECT * FROM RegiaoVenda;
SELECT * FROM CanalVenda;
SELECT * FROM Fornecedor;
SELECT * FROM ProdutosFornecedores;
SELECT * FROM Venda;
SELECT * FROM Logs;
GO

SELECT COUNT(*) AS TotalCategoriaProduto FROM CategoriaProduto;
SELECT COUNT(*) AS TotalProduto FROM Produto;
SELECT COUNT(*) AS TotalCliente FROM Cliente;
SELECT COUNT(*) AS TotalFuncionario FROM Funcionario;
SELECT COUNT(*) AS TotalRegiaoVenda FROM RegiaoVenda;
SELECT COUNT(*) AS TotalCanalVenda FROM CanalVenda;
SELECT COUNT(*) AS TotalFornecedor FROM Fornecedor;
SELECT COUNT(*) AS TotalProdutosFornecedores FROM ProdutosFornecedores;
SELECT COUNT(*) AS TotalVenda FROM Venda;
SELECT COUNT(*) AS TotalLogs FROM Logs;
GO

SELECT 
    (SELECT COUNT(*) FROM CategoriaProduto) +
    (SELECT COUNT(*) FROM Produto) +
    (SELECT COUNT(*) FROM Cliente) +
    (SELECT COUNT(*) FROM Funcionario) +
    (SELECT COUNT(*) FROM RegiaoVenda) +
    (SELECT COUNT(*) FROM CanalVenda) +
    (SELECT COUNT(*) FROM Fornecedor) +
    (SELECT COUNT(*) FROM ProdutosFornecedores) +
    (SELECT COUNT(*) FROM Venda) +
    (SELECT COUNT(*) FROM Logs) AS TotalRegistros;
GO


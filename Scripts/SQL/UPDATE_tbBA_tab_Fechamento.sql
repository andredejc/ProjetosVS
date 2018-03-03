USE dbBA_Cartoes
GO

-- Quando a Rosana informar da data correta do fechamento, atualizar com as iformações passadas:
UPDATE tbBA_tab_Fechamento SET dt_FechEnvioEmail = '2016-03-08',dt_FechProcArquivo = '2016-03-08'
WHERE id_AnoMesFech = 201602;
GO

-- Após o disparo dos emails, rodar essa linha de fechamento alterando apenas os meses:
INSERT INTO tbBA_tab_Fechamento VALUES(201604,'2016-05-11','2016-05-11',7);
GO



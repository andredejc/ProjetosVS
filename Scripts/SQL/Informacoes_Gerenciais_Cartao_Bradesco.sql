Andre, todo m�s preciso que seja carregado na tabela abaixo as informa��es gerencias do cart�o BS que Bradesco Cart�es envia, 
informa��o esta que e utilizando no dash que voc� envia toda ter�a-feira.
Segue abaixo as informa��es de abril-16, ap�s o insert sempre verificar se a soma bate com o total do relat�rio.

Segue exemplo do insert que fiz no m�s passado.
Adicionar no seu controle para sempre no final do m�s receber as informa��es do m�s anterior, caso n�o receba me informe que aciono a Rosana.



INSERT INTO [tbBA_tab_InformacoesGerenciais](aa_Ano,mm_Mes,cs_Bandeira,ds_Tipo,qt_BaseTotal,qt_CartoesAtivos,qt_CartoesDesbloqueados,qt_CartoesEmitidos,vl_Faturamento) 
VALUES(2016,4,'Visa e Elo','Elo Nacional',256448,70407,98683,15440,14819560) -- OK

INSERT INTO [tbBA_tab_InformacoesGerenciais](aa_Ano,mm_Mes,cs_Bandeira,ds_Tipo,qt_BaseTotal,qt_CartoesAtivos,qt_CartoesDesbloqueados,qt_CartoesEmitidos,vl_Faturamento) 
VALUES(2016,4,'Visa e Elo','Internacional',435397,205965,235749,6499,98062844) -- OK

INSERT INTO [tbBA_tab_InformacoesGerenciais](aa_Ano,mm_Mes,cs_Bandeira,ds_Tipo,qt_BaseTotal,qt_CartoesAtivos,qt_CartoesDesbloqueados,qt_CartoesEmitidos,vl_Faturamento) 
VALUES(2016,4,'Visa e Elo','Internacional Funcion�rio',19308,6306,9370,1632,2971791) -- OK

INSERT INTO [tbBA_tab_InformacoesGerenciais](aa_Ano,mm_Mes,cs_Bandeira,ds_Tipo,qt_BaseTotal,qt_CartoesAtivos,qt_CartoesDesbloqueados,qt_CartoesEmitidos,vl_Faturamento) 
VALUES(2016,4,'Visa e Elo','Gold',137538,81756,89326,1606,74225850) -- OK

INSERT INTO [tbBA_tab_InformacoesGerenciais](aa_Ano,mm_Mes,cs_Bandeira,ds_Tipo,qt_BaseTotal,qt_CartoesAtivos,qt_CartoesDesbloqueados,qt_CartoesEmitidos,vl_Faturamento) 
VALUES(2016,4,'Visa e Elo','Gold Funcion�rio',16802,6983,10317,658,4654898) --ok

INSERT INTO [tbBA_tab_InformacoesGerenciais](aa_Ano,mm_Mes,cs_Bandeira,ds_Tipo,qt_BaseTotal,qt_CartoesAtivos,qt_CartoesDesbloqueados,qt_CartoesEmitidos,vl_Faturamento) 
VALUES(2016,4,'Visa e Elo','Platinum',24855,15802,18129,359,26427689) -- ok

SELECT 
	sum(qt_BaseTotal) as qt_BaseTotal,
	sum(qt_CartoesAtivos) as qt_CartoesAtivos,
	sum(qt_CartoesDesbloqueados) as qt_CartoesDesbloqueados,
	sum(qt_CartoesEmitidos) as qt_CartoesEmitidos,		
	sum(vl_Faturamento)  as vl_Faturamento
FROM [tbBA_tab_InformacoesGerenciais] where aa_ano = 2016 and mm_mes = 4
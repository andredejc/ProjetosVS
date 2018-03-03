
1.	Reestruturar o processo:
Proc: sp_ncl_AtualizaRaioXOutbound
Tab: tbPC_tab_RaioXOutbound

2.	Rever o tipo de base de hot list, cross e regular para base A e base B.

3.	Incluir a informação de quem comprou a partir do ano de 2015.

4.	Criar o indicar de qual telefone foi feita a venda (fixo ou celular).


USE dbBR_PainelControle

-- DADOS DE CAMPANHA
SELECT *
FROM dbBR_PainelControle..tbPC_tab_Arquivo A    
INNER JOIN dbBR_PainelControle..tbPC_tab_Produto P ON P.id_Produto = A.id_Produto    
INNER JOIN dbBR_PainelControle..tbPC_tab_EPS E ON E.id_EPS = A.id_EPS    
INNER JOIN dbBR_PainelControle..tbPC_tab_Operacao O ON O.id_Operacao = A.id_Operacao    
INNER JOIN dbBR_PainelControle..tbPC_tab_Campanha C ON C.id_Arquivo = A.id_Arquivo   
WHERE C.nr_Cartao = 5480469953380198 AND C.nr_CPF = 22501504860 AND A.cd_Campanha = '15011213'


-- DADOS DE RETORNO DE TELEFONE
SELECT * FROM tbPC_log_Acionamento A
INNER JOIN tbPC_tab_Arquivo B ON B.id_Arquivo = A.id_Arquivo
WHERE LEFT(B.cd_Campanha,2) IN (15,16)
AND nr_Cartao = 5480469953380198 AND nr_CPF = 22501504860 AND B.cd_Campanha = '15011213'


-- QV
OUTBOUND RAIO X.qvw

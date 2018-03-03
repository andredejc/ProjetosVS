string arquivo = @"\\D5668m001e035\operacoes\Andre\CANAIS_COMPLEMENTARES\OPORTUNIDADES_AUTO_CC_BRADESCOR_201611.txt";

using(StreamReader streamReader = new StreamReader(arquivo, Encoding.GetEncoding(1252)))
{
	streamReader.ReadLine();

	using(DataTable dataTable = new DataTable())
	{
		var colunas = dataTable.Columns;
		colunas.Add("TIPO_DE_OPORTUNIDADE", typeof(string));
		colunas.Add("CANAL", typeof(string));
		colunas.Add("SEGURADORA", typeof(string));
		colunas.Add("PRODUTO", typeof(string));
		colunas.Add("TIPO_DE_SEGURO", typeof(string));
		colunas.Add("FAMILIA_DE_PRODUTO", typeof(string));
		colunas.Add("ANO", typeof(string));
		colunas.Add("MES", typeof(string));
		colunas.Add("SUCURSAL_INDICACAO", typeof(string));
		colunas.Add("APOLICE", typeof(string));
		colunas.Add("AGENCIA_INDICACAO", typeof(string));
		colunas.Add("AGENCIA_PRODUCAO", typeof(string));
		colunas.Add("CORRETOR_INDICACAO", typeof(string));
		colunas.Add("ASSESSORIA", typeof(string));
		colunas.Add("PEL", typeof(string));
		colunas.Add("RECEITA_ESTIMADA", typeof(string));
		colunas.Add("CD_FIPE", typeof(string));
		colunas.Add("MARCA_MODELO_ANO", typeof(string));
		colunas.Add("DS_PLACA", typeof(string));
		colunas.Add("ANO_FABRICACAO", typeof(string));
		colunas.Add("CAMPANHA_ORIGEM", typeof(string));
		colunas.Add("TOPICO", typeof(string));
		colunas.Add("SUPEX_MATRIZ", typeof(string));
		colunas.Add("SUPEX_REGIONAL", typeof(string));
		colunas.Add("FASE_DO_PIPELINE", typeof(string));
		colunas.Add("ESTAGIO_DA_VENDA", typeof(string));
		colunas.Add("DATA_INICIO", typeof(string));
		colunas.Add("DATA_FIM", typeof(string));
		colunas.Add("MATRICULA", typeof(string));
		colunas.Add("DATA_FIM_VIGENCIA", typeof(string));
		colunas.Add("RAZAO_SOCIAL", typeof(string));
		colunas.Add("CNPJ_CPF", typeof(string));
		colunas.Add("SEXO", typeof(string));
		colunas.Add("TELEFONE_PRINCIPAL", typeof(string));
		colunas.Add("TELEFONE2", typeof(string));
		colunas.Add("TELEFONE3", typeof(string));
		colunas.Add("TELEFONE4", typeof(string));
		colunas.Add("MUNICIPIO", typeof(string));
		colunas.Add("ESTADO", typeof(string));
		colunas.Add("EMAIL", typeof(string));
		colunas.Add("TIPO_PESSOA", typeof(string));
		colunas.Add("FL_CARTAO", typeof(string));
		colunas.Add("FL_DESSASSITIDAS", typeof(string));
		colunas.Add("FL_AUTO_RE", typeof(string));
		colunas.Add("NR_CONTRATO", typeof(string));
		colunas.Add("FROTA", typeof(string));
		colunas.Add("NM_GERENTE_COMERCIAL", typeof(string));
		colunas.Add("NM_SUPERINTENDENTE", typeof(string));
		colunas.Add("NM_SUPEX_MATRIZ", typeof(string));
		colunas.Add("QTD_ITENS", typeof(string));
		colunas.Add("CD_ORIGEM", typeof(string));
		colunas.Add("DS_SEGMENTO_CLIENTE", typeof(string));
		colunas.Add("CD_AGENCIA_DEBITO", typeof(string));
		colunas.Add("NR_CONTA_COR", typeof(string));
		colunas.Add("NR_MATRICULA", typeof(string));
		colunas.Add("CD_CONTROLE_ESPECIAL", typeof(string));
		colunas.Add("GRUPO_ACAO", typeof(string));
		colunas.Add("NOME_ACAO", typeof(string));
		string[] linhas;

		while (!streamReader.EndOfStream)
		{
			linhas = streamReader.ReadLine().Split('\t');
			dataTable.Rows.Add(linhas);
		}

		var dados01 = from p in dataTable.AsEnumerable()
					where p.Field<string>("CANAL") == "CORPORATE"
					&& Convert.ToDouble(p.Field<string>("PEL")) > 1000.00                                
					orderby p.Field<string>("MARCA_MODELO_ANO")
					select p;

		foreach (DataRow d in dados01)
		{
			Console.WriteLine(d.Field<string>("CANAL") + " - " + d.Field<string>("PEL"));
		}

		var dados02 = from p in dataTable.AsEnumerable()
					  where p.Field<string>("CANAL") == "CORPORATE"
					  && Convert.ToDouble(p.Field<string>("PEL")) > 1000.00
					  group p by p.Field<string>("CANAL") into pGroup
					  select new
					  {
						  a = pGroup.Key,
						  b = pGroup.Sum(x => Convert.ToDouble(x.Field<string>("PEL"))),
						  c = pGroup.Count()
					  };

		foreach (var dado in dados02)
		{
			Console.WriteLine("Tipo - " + dado.a + "\n" + "Valor Total - " + dado.b + "\n" + "Quantidade - " + dado.c);
		}                    
	}
}            

Console.ReadKey();
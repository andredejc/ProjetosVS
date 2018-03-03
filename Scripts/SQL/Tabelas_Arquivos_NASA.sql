-- Tabelas dos arquivos do NASA

CREATE TABLE tbBR_tab_NASA_MovRenoTelePropo2015 --2016
(
	 id_BaseCarga INT IDENTITY(1,1) PRIMARY KEY
	,id_Arquivo INT
	-- MOVIMENTO			
	,ds_Modalidade VARCHAR(15) -- DICIO
	,cd_CIA	INT
	,nm_CIA	VARCHAR(35)
	,cd_Sucursal INT
	,nr_Proposta BIGINT
	,nr_Item	INT
	,ds_tpSistema VARCHAR(15) -- DICIO
	,ds_Origem VARCHAR(15) -- DICIO
	,cd_Usuario	INT				
	--RENOVACAO			
	,cd_CiaRenova INT
	,cd_SucursalRenova INT
	,nr_ApoliceRenova BIGINT
	,nr_ItemRenova INT				
	--TELEEMPRESA			
	,cd_Empresa INT
	,cd_Depto INT
	,nr_Matricula BIGINT
	,ds_Parentesco VARCHAR(30) -- REMOVER ******				
	--PROPONENTE			
	,nm_Segurado VARCHAR(100)
	,ds_Pessoa VARCHAR(15)
	,nm_Endereco VARCHAR(80)
	,nm_Bairro VARCHAR(30)
	,nm_Municipio VARCHAR(20)
	,cd_Estado CHAR(2)
	,nr_CEP BIGINT
	,ds_FillerVago	VARCHAR(50)
	,nr_CPF_CGC BIGINT
	,nm_PorContaDe VARCHAR(40)
	,dt_InicioVigencia DATE
	,dt_FinalVigencia DATE
	-- LOCAL_RISCO			
	,nm_EnderecoRisco VARCHAR(40)
	,nm_ComplementoRisco VARCHAR(15)
	,nm_BairroRisco VARCHAR(30)
	,nm_MunicipioRisco VARCHAR(30)
	,cd_EstadoRisco	CHAR(2)
	,nr_CepRisco INT
)
-------------------------------------------------------------------------------------------
CREATE TABLE tbBR_tab_NASA_ObjSeg_Opci_Cobert_LMI2016
(
 id_BaseCarga INT PRIMARY KEY -- recebe id da primeira tabela
--OBJETO_SEGURO			
,cd_Veiculo INT
,ds_Veiculo VARCHAR(50)
,ds_Fabricante VARCHAR(50)
,nr_Placa VARCHAR(7)
,nr_Chassi VARCHAR(23)
,nr_AnoFabricacao INT
,nr_AnoModelo INT
,ds_Combustivel VARCHAR(15)
,nr_Portas INT
,nr_Eixos INT
,ds_UsoVeiculo VARCHAR(20)
,cd_RegiaoFenaseg INT			
	-- OPCIONAIS		
,in_SemOpcionais CHAR(1)
,in_AR CHAR(1)
,in_Direcao CHAR(1)
,in_CambioAutomatico CHAR(1)
,in_BancoCouro CHAR(1)
,in_FreioABS CHAR(1)
,in_AirBag CHAR(1)
,in_CambioSemi CHAR(1)			
	-- COBERTURAS		
,ds_Compreensiva CHAR(1)
,ds_INCENDIO_ROUBO CHAR(1)
,ds_RCF char(1)
,ds_APP	char(1)
,ds_CarroReserva char(1)
,ds_DiaNoite char(1)
,ds_Vidro char(1)
,cd_CategoriaAuto INT
,cd_CategoriaRCF int			
	-- LMI		
,in_Bonus char(1)
,ds_FtAjusteVMR	int
,vl_isCasco MONEY
,vl_DespExtr MONEY
,vl_isCarroceria MONEY
,vl_isEquipamento MONEY
,vl_isAcessorio MONEY
,vl_DiariaParaliz MONEY
,cd_FIPE int
,vl_isDM money
,vl_isDP money
,vl_isDMO money
,vl_isGU money
,vl_isMorte money
,vl_isInvalidez money
,nr_Passageiros	int
)
-------------------------------------------------------------------------------------------
CREATE TABLE tbBR_tab_NASA_Franq_Prem_Clau_Desc_CBB_Leasing2016
(
 id_BaseCarga INT PRIMARY KEY -- recebe id da primeira tabela
	--FRANQUIAS		
,vl_PremioAuto money -- Tratar sinal de positivo negativo
,vl_FranquiaVidro money
,vl_FranquiaCarroc money
,vl_FranquiaEquip money -- Tratar sinal de positivo negativo			
	--PREMIOS		
,vl_Premio_Liquido money -- Tratar sinal de positivo negativo
,vl_Custo money
,vl_AdicionalFRAC money
,vl_IOF money
,vl_PremioTotal money -- Tratar sinal de positivo negativo
,pc_TaxaJuros int
,vl_1a_Prestacao money
,qt_PrestacaoRestante int
,vl_DemaisPrest money			
	--CLAUSULAS		
,nr_Clausula varchar(120)			
	-- FORMA_COBRANCA		
,in_Carne char(1)
,in_Debito char(1)
,nr_Banco int
,nr_Agencia varchar(10) -- pode ter letras
,nr_Conta bigint -- tratar zeros à esquerda			
	-- DESCONTOS		
,pc_DescAuto int 
,pc_DescRCF int
,pc_DescAPP	int			
	-- CCB		
,nr_CCB	int
,dt_Emissao	date
,dt_Pagamento date
,vl_Pago money			
	-- LEASING		
,nr_Contrato int
,dv_Contrato char(1)
,dt_Fim date			
)

--------------------------------------------------------


CREATE TABLE tbBR_tab_NASA_Corr_Anali_Perf_Sup2016
(
 id_BaseCarga INT PRIMARY KEY -- recebe id da primeira tabela
	--CORRETOR		
,nm_Corretor varchar(80)
,cd_Susep int
,cd_CPD int
,cd_Angariador int
,cd_AgencProd int
,nr_Inspetoria int				
	-- ANALISE		
,cd_Evento int
,dt_UltimoEvento date
,ds_UltimoEvento varchar(40)
,dt_Primeiro_Evento date
,dt_UltimaPendencia	date
,ds_UltimaPendencia varchar(70)
,dt_UltimaRejeicao date
,ds_UltimaRejeicao varchar(70)			
	-- PERFIL		
,dt_Nascimento date
,ds_EstadoCivil	int
,ds_Filhos int
,ds_FxEtariaFilhos char(1)
,in_Garagem char(1)
,in_OutrosVeiculos char(1)
,ds_Sexo char(1)
,ds_TipoPessoa char(1)			
	-- SUPERVISORES		
,cd_Supervisor	varchar(20)			
	-- TRANSMISSOES		
,qt_TransProp int			
	-- ALERTAS_PROPOSTA		
,cd_Alerta1 int
,ds_UserLiber1 varchar(10)
,ds_LibrcContr1	char(1)
,dt_DataLiber1 date
,cd_NivelAlcada1 int
,cd_Alerta2 int
,ds_UserLiber2 varchar(10)
,ds_LibrcContr2	char(1)
,dt_DataLiber2 date
,cd_NivelAlcada2 int
,cd_Alerta3 int
,ds_UserLiber3 varchar(10)
,ds_LibrcContr3	char(1)
,dt_DataLiber3 date
,cd_NivelAlcada3 int
,cd_Alerta4 int
,ds_UserLiber4 varchar(10)
,ds_LibrcContr4	char(1)
,dt_DataLiber4 date
,cd_NivelAlcada4 int
,cd_Alerta5 int
,ds_UserLiber5 varchar(10)
,ds_LibrcContr5	char(1)
,dt_DataLiber5 date
,cd_NivelAlcada5 int
,cd_Alerta6 int
,ds_UserLiber6 varchar(10)
,ds_LibrcContr6	char(1)
,dt_DataLiber6 date
,cd_NivelAlcada6 int
,cd_Alerta7 int
,ds_UserLiber7 varchar(10)
,ds_LibrcContr7	char(1)
,dt_DataLiber7 date
,cd_NivelAlcada7 int
,cd_Alerta8 int
,ds_UserLiber8 varchar(10)
,ds_LibrcContr8	char(1)
,dt_DataLiber8 date
,cd_NivelAlcada8 int
,cd_Alerta9 int
,ds_UserLiber9 varchar(10)
,ds_LibrcContr9	char(1)
,dt_DataLiber9 date
,cd_NivelAlcada9 int
,cd_Alerta10 int
,ds_UserLiber10 varchar(10)
,ds_LibrcContr10	char(1)
,dt_DataLiber10 date
,cd_NivelAlcada10 int
,cd_Alerta11 int
,ds_UserLiber11 varchar(10)
,ds_LibrcContr11	char(1)
,dt_DataLiber11 date
,cd_NivelAlcada11 int
,cd_Alerta12 int
,ds_UserLiber12 varchar(10)
,ds_LibrcContr12	char(1)
,dt_DataLiber12 date
,cd_NivelAlcada12 int
,cd_Alerta13 int
,ds_UserLiber13 varchar(10)
,ds_LibrcContr13	char(1)
,dt_DataLiber13 date
,cd_NivelAlcada13 int
,cd_Alerta14 int
,ds_UserLiber14 varchar(10)
,ds_LibrcContr14	char(1)
,dt_DataLiber14 date
,cd_NivelAlcada14 int
,cd_Alerta15 int
,ds_UserLiber15 varchar(10)
,ds_LibrcContr15	char(1)
,dt_DataLiber15 date
,cd_NivelAlcada15 int
,cd_Alerta16 int
,ds_UserLiber16 varchar(10)
,ds_LibrcContr16	char(1)
,dt_DataLiber16 date
,cd_NivelAlcada16 int
,cd_Alerta17 int
,ds_UserLiber17 varchar(10)
,ds_LibrcContr17	char(1)
,dt_DataLiber17 date
,cd_NivelAlcada17 int
,cd_Alerta18 int
,ds_UserLiber18 varchar(10)
,ds_LibrcContr18	char(1)
,dt_DataLiber18 date
,cd_NivelAlcada18 int
,cd_Alerta19 int
,ds_UserLiber19 varchar(10)
,ds_LibrcContr19	char(1)
,dt_DataLiber19 date
,cd_NivelAlcada19 int
,cd_Alerta20 int
,ds_UserLiber20 varchar(10)
,ds_LibrcContr20	char(1)
,dt_DataLiber20 date
,cd_NivelAlcada20 int														
	-- FORMA_COBR_NASA		
,in_CCB char(1)
,in_Avista	char(1)			
	-- MOTIVOS_ENDOSSO		
,cd_Motivo1 int
,ds_Motivo1 varchar(50)
,cd_Motivo2 int
,ds_Motivo2 varchar(50)
,cd_Motivo3 int
,ds_Motivo3 varchar(50)
,cd_Motivo4 int
,ds_Motivo4 varchar(50)
,cd_Motivo5 int
,ds_Motivo5 varchar(50)
,cd_Motivo6 int
,ds_Motivo6 varchar(50)
,cd_Motivo7 int
,ds_Motivo7 varchar(50)
,cd_Motivo8 int
,ds_Motivo8 varchar(50)
,cd_Motivo9 int
,ds_Motivo9 varchar(50)
,cd_Motivo10 int
,ds_Motivo10 varchar(50)
,ds_ClasseBonus	int
,ds_CindSegurResid char(1)
,ds_PdescEspclConcd	int
,cd_AntiFurto int
,ds_Carroceria	varchar(30)		
)

------------------------------------------------
CREATE TABLE tbBR_tab_NASA_EquipaVeic_AcessoVeic2016
(
 id_BaseCarga INT PRIMARY KEY -- recebe id da primeira tabela
	--EQUIPAMENTOS_VEIC		
,cd_Equipamento1 int
,cd_Equipamento2 int
,cd_Equipamento3 int
,cd_Equipamento4 int
,cd_Equipamento5 int
,cd_Equipamento6 int
,cd_Equipamento7 int
,cd_Equipamento8 int
,cd_Equipamento9 int
,cd_Equipamento10 int			
	-- ACESSORIOS_VEIC		
,cd_Acessorio1 int
,cd_Acessorio2 int
,cd_Acessorio3 int
,cd_Acessorio4 int
,cd_Acessorio5 int
,cd_Acessorio6 int
,cd_Acessorio7 int
,cd_Acessorio8 int
,cd_Acessorio9 int
,cd_Acessorio10 int
,dt_SaidaConc date	
,in_ChassiREM char(1)
,in_VeicTransf char(1)
,in_SuperAuto char(1)
,ds_ClasseBonusAnt int
,nr_Sinistro int
,cd_ProcedVeic varchar(15) -- 1 - PROCED-NAC | 2 - PROCED-EST | 3 - PROCED-NAC-EST
,nr_PropostaOrig int
,dt_EfetPropOrig date
,cd_UsuarioSOL varchar(9)
,nr_ItensFrota int
,ds_CindNovaTarifa char(1)
,cd_RegiaoTarifaria int
,nr_VersaoTarifa float
,nr_Apolice int
)

------------------------------------------------------------------------
CREATE TABLE tbBR_tab_NASA_PremRCFAPP_CRIVO_QAR_NOVO2016
(
 id_BaseCarga INT PRIMARY KEY -- recebe id da primeira tabela
	--PREMIOS_RCF_APP		
,vl_PremioRCFDM	money -- tratar sinais
,vl_PremioRCFDC	money
,vl_PremioRCFDMO money
,vl_PremioRCFGU money
,vl_PremioAPPMO	money
,vl_PremioAPPINV money			
,ds_TipoVeiculo	int
,vl_Premio_Casco money
,vl_PremioDespEXT money
,vl_PremioCarroceria money
,vl_PremioEquip	money
,vl_PremioAccess money
,vl_PremioDiarias money
,vl_PremioKitGAS money
,vl_ServicoDiaNoite money
,vl_ServicoCarroRES	money
,vl_ServicoVidros money
,ds_TipoCliente int
,cd_Franquia int
,flg_Renova_Propria	char(1)
,cd_RelacaoSegProp int
,ds_TpCancelamento varchar(25) -- P - FALTA DE PAGAMENTO | M - FALTA DE MOVIMENTACAO | O - OUTROS
,in_Comodato char(1)
,cd_SemiReboque int
,vl_LMIBlindagem money
,vl_PremioBlindagem money
,vl_LMIKitGAS money
,vl_FranquiaCasco money
,vl_FranquiaKitGAS money
	-- CRIVO		
,ds_PdescCrivo int
,ds_NoperCrivo varchar(9)
,nr_Cretor_Crivo int
,ds_CindRcusa_Cotac	char(1)
,ds_CindSbcaoCrivo char(1)
,ds_PdescLimCrivo int
,ds_QptoOperCrivo int
,nr_CclasfSerasaOper int			
,ds_CobrViaCCBS	char(1)
,ds_CindLiberCCB char(1)
,cd_UsoVeic int
,cd_Combust int
,nr_CcontxOperCrivo int
,pc_ComissAuto float
,pc_ComissRCF float
,pc_ComissAPP float
,in_Revenda char(1)
,nr_CgrpRevdaVeic int
,dt_DinicVgciaGRP datetime
,nr_CseqRevdaVeic int
,in_Cartao char(1)
,nr_CartaoCredito bigint
,nr_CoperCatao int
,nr_CvalddCataoCredt int
,ds_Aplicativo varchar(30) -- tratar acentuação
,nr_CcnpjCrrtr bigint
,nr_CnroLoteFrota int
,cd_CodigoCI varchar(20)
,ds_CsexoPprieVeic char(1)
,dt_DnascPprieVeic date
,ds_CestCvilPprie varchar(17) -- 1 - SOLTEIRO-OUTROS | 2 - CASADO
,nr_CcontrEspcl	int
,ds_CindMesaNegoc char(1)
,nr_PropostaAnt int
,nr_CtpoFuncPblic int
,ds_CindLibrMotvo char(1)
,ds_CindAceitRestr char(1)
,ds_CindSeguroCorretor char(1)
,nr_CopcaoSegurResid int
,cd_CodPrestadora int
,in_PPV char(1)
,ds_TipoConta varchar(20) --  1 - CONTA-CORRENTE | 2 - CONTA-POUPANCA
,nr_BancoCred int
,nr_AgenciaCred int
,nr_ContaCred bigint
,dv_Conta_Cred char(2)
,nr_VfatorAgrvoLnear int
,cd_Susep14	bigint
,ds_UsuarioCotacao varchar(10)
,nr_CpfCnpjCotacao bigint
,ds_PessoaCotacao char(1)
,ds_EmailSegurado varchar(70)
,ds_TpUtilFoneRes varchar(12)
,nr_DDDRes int
,nr_FoneRes int
,ds_TpUtilFoneCom varchar(12)
,nr_DDDCom int
,nr_FoneCom int
,ds_TpUtilFoneCEL varchar(12)
,nr_DDDCEL int
,nr_FoneCEL int
,ds_TpUtilFoneConl int
,nr_DDDCon int
,nr_FoneCon int
,nm_FoneCon varchar(30)
,nr_DescDCE int
,nr_CnegocDCE int
,nr_CtpoCenDec int
,nr_PremLiqResid int
	-- QAR_NOVO		
,nr_CtpoPrfilPropn int
,ds_CindPprieVeic char(1)
,ds_CindCndorPrinc char(1)
,ds_Icndor varchar(60)
,nr_CcpfPssoaCndor int
,dt_DnascCndor date
,ds_CsexoCndor char(1)
,nr_CestCvilCndor char(1)
,nr_CtpoOutroCndor int
,nr_CtpoGaragPnoit int
,nr_CatvddPrincCndor int
,nr_CramoAtvPrincCndor int
,nr_CutilzVeicTrab int
,nr_ClocFixoTrab int
,nr_NcepLocTrab int
,nr_CtpoGaragLocTrab int
,nr_CutilzVeicStudo int
,nr_ClocFixoStudo int
,nr_NcepLocStudo int
,nr_CtpoGaragLocStudo int
,nr_CfaixaKM int			
,vl_PremioRCF money -- tratar sinal
,vl_PremioAPP money
,cd_VeiculoNovo int
,cd_Molicar int
,in_EletroHidraulica char(1)
,in_Eletrica char(1)
,in_OpcOutros char(1)
,ds_CindCataoBdsco char(1)
,nr_Endosso int
,vl_PremTarCasco money
,vl_PremTarAcess money
,vl_PremTarCarroc money
,vl_PremTarEquip money
,vl_PremTarBlind money
,vl_PremTarCarroRes money
,vl_PremTarDespExt money
,vl_PremTarKitGAS money
,vl_PremTarDiarias money
,vl_PremTarAdn money
,vl_PremTarVidros money	
,vl_PremTarAuto money
,vl_PremTarDM money
,vl_PremTarDC money
,vl_PremTarDMO money
,vl_PremTarGU money
,vl_PremTarRCF money
,vl_PremTarMorte money
,vl_PremTarInval money
,vl_PremTarAPP money
,vl_PremTarTotal money
,dt_ConcilVP date
,dt_TransmVP money
,nr_Vistoria int
,cd_SituacaoVP varchar(30)
,cd_EmprVist int
,ind_VPGeradaCalc char(1)
,ds_IndVPRealiz varchar(40)
,cd_OcupPrinc int
,ind_CertfDigital varchar(3)
,vl_PremioDCE money
,vl_DescDCE money
,vl_PremioCapitRES money
,vl_PremioAdnRES money
,nr_Lograd int
,nr_LogradRisco int
,nr_CmodTrfio int
,nr_CnovaRgiaoRisco int
,vl_VPrmioPerdaPCIAL money
,vl_VprmioPerdaTot money
,vl_VprmioROuboFurto money
,vl_VservcADN money
,vl_VservcVidro money
,vl_VservcCarRes money
,nr_CclassBonusPP int
,nr_CclassBonusPT int
,nr_CclassBonusRF int
,nr_CclassBonusDM int
,nr_CsitCCB int

)
----------------------------------------------------------
-- Tabela 05
----------------------------------------------------------
[Coluna473] [varchar]            (100) NULL,
	[Coluna474] [varchar]            (100) NULL,
	[Coluna475] [varchar]            (100) NULL,
	[Coluna476] [varchar]            (100) NULL,
	[Coluna477] [varchar]            (100) NULL,
	[Coluna478] [varchar]            (100) NULL,
	[Coluna479] [varchar]            (100) NULL,
	[Coluna480] [varchar]            (100) NULL,
	[Coluna481] [varchar]            (100) NULL,
	[Coluna482] [varchar]            (100) NULL,
	[Coluna483] [varchar]            (100) NULL,
	[Coluna484] [varchar]            (100) NULL,
	[Coluna485] [varchar]            (100) NULL,
	[Coluna486] [varchar]            (100) NULL,
	[Coluna487] [varchar]            (100) NULL,
	[Coluna488] [varchar]            (100) NULL,
	[Coluna489] [varchar]            (100) NULL,
	[Coluna490] [varchar]            (100) NULL,
	[Coluna491] [varchar]            (100) NULL,
	[Coluna492] [varchar]            (100) NULL,
	[Coluna493] [varchar]            (100) NULL,
	[Coluna494] [varchar]            (100) NULL,
	[Coluna495] [varchar]            (100) NULL,
	[Coluna496] [varchar]            (100) NULL,
	[Coluna497] [varchar]            (100) NULL,
	[Coluna498] [varchar]            (100) NULL,
	[Coluna499] [varchar]            (100) NULL,
	[Coluna500] [varchar]            (100) NULL,
	[Coluna501] [varchar]            (100) NULL,
	[Coluna502] [varchar]            (100) NULL,
	[Coluna503] [varchar]            (100) NULL,
	[Coluna504] [varchar]            (100) NULL,
	[Coluna505] [varchar]            (100) NULL,
	[Coluna506] [varchar]            (100) NULL,
	[Coluna507] [varchar]            (100) NULL,
	[Coluna508] [varchar]            (100) NULL,
	[Coluna509] [varchar]            (100) NULL,
	[Coluna510] [varchar]            (100) NULL,
	[Coluna511] [varchar]            (100) NULL,
	[Coluna512] [varchar]            (100) NULL,
	[Coluna513] [varchar]            (100) NULL,
	[Coluna514] [varchar]            (100) NULL
	
	
	
	
	
	
	
	
	
	
	
	------------------------------------
	--- QAR-NOVO
	[nr_CtpoPrfilPropn] [int] NULL,
	[ds_CindPprieVeic] [char](1) NULL,
	[ds_CindCndorPrinc] [char](1) NULL,
	[ds_Icndor] [varchar](60) NULL,
	[nr_CcpfPssoaCndor] [bigint] NULL,
	[dt_DnascCndor] [date] NULL,
	[ds_CsexoCndor] [char](1) NULL,
	[nr_CestCvilCndor] [varchar](20) NULL,
	[nr_CtpoOutroCndor] [int] NULL,
	[nr_CtpoGaragPnoit] [int] NULL,
	[nr_CatvddPrincCndor] [int] NULL,
	[nr_CramoAtvPrincCndor] [int] NULL,
	[nr_CutilzVeicTrab] [int] NULL,
	[nr_ClocFixoTrab] [int] NULL,
	[nr_NcepLocTrab] [int] NULL,
	[nr_CtpoGaragLocTrab] [int] NULL,
	[nr_CutilzVeicStudo] [int] NULL,
	[nr_ClocFixoStudo] [int] NULL,
	[nr_NcepLocStudo] [int] NULL,
	[nr_CtpoGaragLocStudo] [int] NULL,
	[nr_CfaixaKM] [int] NULL,
	[vl_PremioRCF] [money] NULL,
	[vl_PremioAPP] [money] NULL,
	[cd_VeiculoNovo] [int] NULL,
	[cd_Molicar] [int] NULL,
	[in_EletroHidraulica] [char](1) NULL,
	[in_Eletrica] [char](1) NULL,
	[in_OpcOutros] [char](1) NULL,
	[ds_CindCataoBdsco] [char](1) NULL,
	[nr_Endosso] [int] NULL,
	[vl_PremTarCasco] [money] NULL,
	[vl_PremTarAcess] [money] NULL,
	[vl_PremTarCarroc] [money] NULL,
	[vl_PremTarEquip] [money] NULL,
	[vl_PremTarBlind] [money] NULL,
	[vl_PremTarCarroRes] [money] NULL,
	[vl_PremTarDespExt] [money] NULL,
	[vl_PremTarKitGAS] [money] NULL,
	[vl_PremTarDiarias] [money] NULL,
	[vl_PremTarAdn] [money] NULL,
	[vl_PremTarVidros] [money] NULL,
	[vl_PremTarAuto] [money] NULL,
	[vl_PremTarDM] [money] NULL,
	[vl_PremTarDC] [money] NULL,
	[vl_PremTarDMO] [money] NULL,
	[vl_PremTarGU] [money] NULL,
	[vl_PremTarRCF] [money] NULL,
	[vl_PremTarMorte] [money] NULL,
	[vl_PremTarInval] [money] NULL,
	[vl_PremTarAPP] [money] NULL,
	[vl_PremTarTotal] [money] NULL,
	[dt_ConcilVP] [date] NULL,
	[dt_TransmVP] [money] NULL,
	[nr_Vistoria] [int] NULL,
	[cd_SituacaoVP] [varchar](30) NULL,
	[cd_EmprVist] [int] NULL,
	[ind_VPGeradaCalc] [char](1) NULL,
	[ds_IndVPRealiz] [varchar](40) NULL,
	[cd_OcupPrinc] [int] NULL,
	[ind_CertfDigital] [varchar](3) NULL,
	[vl_PremioDCE] [money] NULL,
	[vl_DescDCE] [money] NULL,
	[vl_PremioCapitRES] [money] NULL,
	[vl_PremioAdnRES] [money] NULL,
	[nr_Lograd] [int] NULL,
	[nr_LogradRisco] [int] NULL,
	[nr_CmodTrfio] [int] NULL,
	[nr_CnovaRgiaoRisco] [int] NULL,
	[vl_VPrmioPerdaPCIAL] [money] NULL,
	[vl_VprmioPerdaTot] [money] NULL,
	[vl_VprmioROuboFurto] [money] NULL,
	[vl_VservcADN] [money] NULL,
	[vl_VservcVidro] [money] NULL,
	[vl_VservcCarRes] [money] NULL,
	[nr_CclassBonusPP] [int] NULL,
	[nr_CclassBonusPT] [int] NULL,
	[nr_CclassBonusRF] [int] NULL,
	[nr_CsitCCB] [int] NULL,
	[nr_CclassBonusDM] [int] NULL,














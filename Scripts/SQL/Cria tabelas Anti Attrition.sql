SELECT * FROM dbo.tmp_Att1		-- tbGS_tmp_Attrition01
SELECT * FROM dbo.tmp_Att2		-- tbGS_tmp_Attrition02
SELECT * FROM dbo.hst_Anttrition -- tbGS_hst_Anttrition
SELECT * FROM dbo.tbGS_TipoMotivos_Attrition -- tbGS_hst_TipoMotivos_Attrition

-- PROCS


tbGS_tmp_Attrition01
tbGS_tmp_Attrition02
tbGS_hst_Anttrition
tbGS_hst_TipoMotivos_Attrition

sp_ins_TipoMotivos_Attrition
sp_ins_ArquivoAttrition
sp_ins_tbGS_hst_Anttrition
sp_ins_tbGS_tmp_Attrition02



SELECT * FROM dbo.tbBR_tab_Arquivo


USE TESTANDO123
GO

CREATE TABLE [dbo].[tbGS_tmp_Attrition01](
	[Coluna1] [varchar](255) NULL,
	[Coluna2] [varchar](255) NULL,
	[Coluna3] [varchar](255) NULL,
	[Coluna4] [varchar](255) NULL,
	[Coluna5] [varchar](255) NULL,
	[Coluna6] [varchar](255) NULL,
	[Coluna7] [varchar](255) NULL,
	[Coluna8] [varchar](255) NULL,
	[Coluna9] [varchar](255) NULL,
	[Coluna10] [varchar](255) NULL,
	[Coluna11] [varchar](255) NULL,
	[Coluna12] [varchar](255) NULL,
	[Coluna13] [varchar](255) NULL,
	[Coluna14] [varchar](255) NULL,
	[Coluna15] [varchar](255) NULL,
	[Coluna16] [varchar](255) NULL,
	[Coluna17] [varchar](255) NULL,
	[Coluna18] [varchar](255) NULL,
	[Coluna19] [varchar](255) NULL,
	[Coluna20] [varchar](255) NULL,
	[Coluna21] [varchar](255) NULL,
	[Coluna22] [varchar](255) NULL,
	[Coluna23] [varchar](255) NULL,
	[Coluna24] [varchar](255) NULL,
	[Coluna25] [varchar](255) NULL,
	[Coluna26] [varchar](255) NULL,
	[Coluna27] [varchar](255) NULL,
	[Coluna28] [varchar](255) NULL,
	[Coluna29] [varchar](255) NULL,
	[Coluna30] [varchar](255) NULL,
	[Coluna31] [varchar](255) NULL,
	[Coluna32] [varchar](255) NULL,
	[Coluna33] [varchar](255) NULL,
	[Coluna34] [varchar](255) NULL,
	[Coluna35] [varchar](255) NULL,
	[Coluna36] [varchar](255) NULL,
	[Coluna37] [varchar](255) NULL,
	[Coluna38] [varchar](255) NULL,
	[Coluna39] [varchar](255) NULL,
	[Coluna40] [varchar](255) NULL,
	[Coluna41] [varchar](255) NULL,
	[Coluna42] [varchar](255) NULL,
	[Coluna43] [varchar](255) NULL,
	[Coluna44] [varchar](255) NULL,
	[Coluna45] [varchar](255) NULL,
	[Coluna46] [varchar](255) NULL,
	[Coluna47] [varchar](255) NULL,
	[Coluna48] [varchar](255) NULL,
	[Coluna49] [varchar](255) NULL,
	[Coluna50] [varchar](255) NULL,
	[Coluna51] [varchar](255) NULL,
	[Coluna52] [varchar](255) NULL,
	[Coluna53] [varchar](255) NULL,
	[Coluna54] [varchar](255) NULL,
	[Coluna55] [varchar](255) NULL,
	[Coluna56] [varchar](255) NULL,
	[Coluna57] [varchar](255) NULL,
	[Coluna58] [varchar](255) NULL,
	[Coluna59] [varchar](255) NULL,
	[Coluna60] [varchar](255) NULL,
	[Coluna61] [varchar](255) NULL,
	[Coluna62] [varchar](255) NULL,
	[Coluna63] [varchar](255) NULL,
	[Coluna64] [varchar](255) NULL,
	[Coluna65] [varchar](255) NULL,
	[Coluna66] [varchar](255) NULL,
	[Coluna67] [varchar](255) NULL,
	[Coluna68] [varchar](255) NULL,
	[Coluna69] [varchar](255) NULL,
	[Coluna70] [varchar](255) NULL,
	[Coluna71] [varchar](255) NULL,
	[Coluna72] [varchar](255) NULL,
	[Coluna73] [varchar](255) NULL,
	[Coluna74] [varchar](255) NULL,
	[Coluna75] [varchar](255) NULL,
	[Coluna76] [varchar](255) NULL,
	[Coluna77] [varchar](255) NULL,
	[Coluna78] [varchar](255) NULL,
	[Coluna79] [varchar](255) NULL,
	[Coluna80] [varchar](255) NULL,
	[Coluna81] [varchar](255) NULL,
	[Coluna82] [varchar](255) NULL,
	[Coluna83] [varchar](255) NULL,
	[Coluna84] [varchar](255) NULL,
	[Coluna85] [varchar](255) NULL,
	[Coluna86] [varchar](255) NULL,
	[Coluna87] [varchar](255) NULL,
	[Coluna88] [varchar](255) NULL,
	[Coluna89] [varchar](255) NULL,
	[Coluna90] [varchar](255) NULL,
	[Coluna91] [varchar](255) NULL,
	[Coluna92] [varchar](255) NULL,
	[Coluna93] [varchar](255) NULL,
	[Coluna94] [varchar](255) NULL,
	[Coluna95] [varchar](255) NULL,
	[Coluna96] [varchar](255) NULL,
	[Coluna97] [varchar](255) NULL,
	[Coluna98] [varchar](255) NULL,
	[Coluna99] [varchar](255) NULL,
	[Coluna100] [varchar](255) NULL,
	[Coluna101] [varchar](255) NULL,
	[Coluna102] [varchar](255) NULL,
	[Coluna103] [varchar](255) NULL,
	[Coluna104] [varchar](255) NULL,
	[Coluna105] [varchar](255) NULL,
	[Coluna106] [varchar](255) NULL,
	[Coluna107] [varchar](255) NULL,
	[Coluna108] [varchar](255) NULL,
	[Coluna109] [varchar](255) NULL,
	[Coluna110] [varchar](255) NULL,
	[Coluna111] [varchar](255) NULL,
	[Coluna112] [varchar](255) NULL,
	[Coluna113] [varchar](255) NULL,
	[Coluna114] [varchar](255) NULL,
	[Coluna115] [varchar](255) NULL,
	[Coluna116] [varchar](255) NULL,
	[Coluna117] [varchar](255) NULL,
	[Coluna118] [varchar](255) NULL,
	[Coluna119] [varchar](255) NULL,
	[Coluna120] [varchar](255) NULL,
	[Coluna121] [varchar](255) NULL,
	[Coluna122] [varchar](255) NULL,
	[Coluna123] [varchar](255) NULL,
	[Coluna124] [varchar](255) NULL,
	[Coluna125] [varchar](255) NULL,
	[Coluna126] [varchar](255) NULL,
	[Coluna127] [varchar](255) NULL,
	[Coluna128] [varchar](255) NULL,
	[Coluna129] [varchar](255) NULL
) ON [PRIMARY]

GO


CREATE TABLE [dbo].[tbGS_tmp_Attrition02](
	[Coluna1] [varchar](255) NULL,
	[Coluna2] [varchar](255) NULL,
	[Coluna3] [varchar](255) NULL,
	[Coluna4] [varchar](255) NULL,
	[Coluna5] [varchar](255) NULL,
	[Coluna6] [varchar](255) NULL,
	[Coluna7] [varchar](255) NULL,
	[Coluna8] [varchar](255) NULL,
	[Coluna9] [varchar](255) NULL,
	[Coluna10] [varchar](255) NULL,
	[Coluna11] [varchar](255) NULL,
	[Coluna12] [varchar](255) NULL,
	[Coluna13] [varchar](255) NULL,
	[Coluna14] [varchar](255) NULL,
	[Coluna15] [varchar](255) NULL,
	[Coluna16] [varchar](255) NULL,
	[Coluna17] [varchar](255) NULL,
	[Coluna18] [varchar](255) NULL,
	[Coluna19] [varchar](255) NULL,
	[Coluna20] [varchar](255) NULL,
	[Coluna21] [varchar](255) NULL,
	[Coluna22] [varchar](255) NULL,
	[Coluna23] [varchar](255) NULL,
	[Coluna24] [varchar](255) NULL,
	[Coluna25] [varchar](255) NULL,
	[Coluna26] [varchar](255) NULL,
	[Coluna27] [varchar](255) NULL,
	[Coluna28] [varchar](255) NULL,
	[Coluna29] [varchar](255) NULL,
	[Coluna30] [varchar](255) NULL,
	[Coluna31] [varchar](255) NULL,
	[Coluna32] [varchar](255) NULL,
	[Coluna33] [varchar](255) NULL,
	[Coluna34] [varchar](255) NULL,
	[Coluna35] [varchar](255) NULL,
	[Coluna36] [varchar](255) NULL,
	[Coluna37] [varchar](255) NULL,
	[Coluna38] [varchar](255) NULL,
	[Coluna39] [varchar](255) NULL,
	[Coluna40] [varchar](255) NULL,
	[Coluna41] [varchar](255) NULL,
	[Coluna42] [varchar](255) NULL,
	[Coluna43] [varchar](255) NULL,
	[Coluna44] [varchar](255) NULL,
	[Coluna45] [varchar](255) NULL,
	[Coluna46] [varchar](255) NULL,
	[Coluna47] [varchar](255) NULL,
	[Coluna48] [varchar](255) NULL,
	[Coluna49] [varchar](255) NULL,
	[Coluna50] [varchar](255) NULL,
	[Coluna51] [varchar](255) NULL,
	[Coluna52] [varchar](255) NULL,
	[Coluna53] [varchar](255) NULL,
	[Coluna54] [varchar](255) NULL,
	[Coluna55] [varchar](255) NULL,
	[Coluna56] [varchar](255) NULL,
	[Coluna57] [varchar](255) NULL,
	[Coluna58] [varchar](255) NULL,
	[Coluna59] [varchar](255) NULL,
	[Coluna60] [varchar](255) NULL,
	[Coluna61] [varchar](255) NULL,
	[Coluna62] [varchar](255) NULL,
	[Coluna63] [varchar](255) NULL,
	[Coluna64] [varchar](255) NULL,
	[Coluna65] [varchar](255) NULL,
	[Coluna66] [varchar](255) NULL,
	[Coluna67] [varchar](255) NULL,
	[Coluna68] [varchar](255) NULL,
	[Coluna69] [varchar](255) NULL,
	[Coluna70] [varchar](255) NULL,
	[Coluna71] [varchar](255) NULL,
	[Coluna72] [varchar](255) NULL,
	[Coluna73] [varchar](255) NULL,
	[Coluna74] [varchar](255) NULL,
	[Coluna75] [varchar](255) NULL,
	[Coluna76] [varchar](255) NULL,
	[Coluna77] [varchar](255) NULL,
	[Coluna78] [varchar](255) NULL,
	[Coluna79] [varchar](255) NULL,
	[Coluna80] [varchar](255) NULL,
	[Coluna81] [varchar](255) NULL,
	[Coluna82] [varchar](255) NULL,
	[Coluna83] [varchar](255) NULL,
	[Coluna84] [varchar](255) NULL,
	[Coluna85] [varchar](255) NULL,
	[Coluna86] [varchar](255) NULL,
	[Coluna87] [varchar](255) NULL,
	[Coluna88] [varchar](255) NULL,
	[Coluna89] [varchar](255) NULL,
	[Coluna90] [varchar](255) NULL,
	[Coluna91] [varchar](255) NULL,
	[Coluna92] [varchar](255) NULL,
	[Coluna93] [varchar](255) NULL,
	[Coluna94] [varchar](255) NULL,
	[Coluna95] [varchar](255) NULL,
	[Coluna96] [varchar](255) NULL,
	[Coluna97] [varchar](255) NULL,
	[Coluna98] [varchar](255) NULL,
	[Coluna99] [varchar](255) NULL,
	[Coluna100] [varchar](255) NULL,
	[Coluna101] [varchar](255) NULL,
	[Coluna102] [varchar](255) NULL,
	[Coluna103] [varchar](255) NULL,
	[Coluna104] [varchar](255) NULL,
	[Coluna105] [varchar](255) NULL,
	[Coluna106] [varchar](255) NULL,
	[Coluna107] [varchar](255) NULL,
	[Coluna108] [varchar](255) NULL,
	[Coluna109] [varchar](255) NULL,
	[Coluna110] [varchar](255) NULL,
	[Coluna111] [varchar](255) NULL,
	[Coluna112] [varchar](255) NULL,
	[Coluna113] [varchar](255) NULL,
	[Coluna114] [varchar](255) NULL,
	[Coluna115] [varchar](255) NULL,
	[Coluna116] [varchar](255) NULL,
	[Coluna117] [varchar](255) NULL,
	[Coluna118] [varchar](255) NULL,
	[Coluna119] [varchar](255) NULL,
	[Coluna120] [varchar](255) NULL,
	[Coluna121] [varchar](255) NULL,
	[Coluna122] [varchar](255) NULL,
	[Coluna123] [varchar](255) NULL,
	[Coluna124] [varchar](255) NULL,
	[Coluna125] [varchar](255) NULL,
	[Coluna126] [varchar](255) NULL,
	[Coluna127] [varchar](255) NULL,
	[Coluna128] [varchar](255) NULL,
	[Coluna129] [varchar](255) NULL
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[tbGS_hst_Anttrition](
	[id_Base] [bigint] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[id_Arquivo] [bigint] NOT NULL,
	[ds_Periodo] [varchar](150) NOT NULL,
	[ds_TipoArq] [varchar](150) NOT NULL,
	[ds_TipoSeg] [varchar](150) NOT NULL,
	[qt_QtdeTotalSolicitacaoCancel] [int] NULL,
	[qt_TotalPremio_1] [money] NULL,
	[qt_QtdeTotalCancel] [int] NULL,
	[qt_TotalPremio_2] [money] NULL,
	[qt_TotalRecuperados] [int] NULL,
	[qt_TotalPremio_3] [money] NULL,
	[qt_Qtde_A] [int] NULL,
	[qt_TotalPremio_A] [money] NULL,
	[qt_Qtde_B] [int] NULL,
	[qt_TotalPremio_B] [money] NULL,
	[qt_Qtde_C] [int] NULL,
	[qt_TotalPremio_C] [money] NULL,
	[qt_Qtde_D] [int] NULL,
	[qt_TotalPremio_D] [money] NULL,
	[qt_Qtde_E] [int] NULL,
	[qt_TotalPremio_E] [money] NULL,
	[qt_Qtde_F] [int] NULL,
	[qt_TotalPremio_F] [money] NULL,
	[qt_Qtde_G] [int] NULL,
	[qt_TotalPremio_G] [money] NULL,
	[qt_Qtde_H] [int] NULL,
	[qt_TotalPremio_H] [money] NULL,
	[qt_Qtde_I] [int] NULL,
	[qt_TotalPremio_I] [money] NULL,
	[qt_Qtde_J] [int] NULL,
	[qt_TotalPremio_J] [money] NULL,
	[qt_Qtde_K] [int] NULL,
	[qt_TotalPremio_K] [money] NULL,
	[qt_Qtde_L] [int] NULL,
	[qt_TotalPremio_L] [money] NULL,
	[qt_Qtde_M] [int] NULL,
	[qt_TotalPremio_M] [money] NULL,
	[qt_Qtde_N] [int] NULL,
	[qt_TotalPremio_N] [money] NULL,
	[qt_Qtde_O] [int] NULL,
	[qt_TotalPremio_O] [money] NULL,
	[qt_Qtde_P] [int] NULL,
	[qt_TotalPremio_P] [money] NULL,
	[qt_Qtde_Q] [int] NULL,
	[qt_TotalPremio_Q] [money] NULL,
	[qt_Qtde_R] [int] NULL,
	[qt_TotalPremio_R] [money] NULL,
	[qt_Qtde_S] [int] NULL,
	[qt_TotalPremio_S] [money] NULL,
	[qt_Qtde_T] [int] NULL,
	[qt_TotalPremio_T] [money] NULL,
	[qt_Qtde_U] [int] NULL,
	[qt_TotalPremio_U] [money] NULL,
	[qt_Qtde_V] [int] NULL,
	[qt_TotalPremio_V] [money] NULL,
	[qt_Qtde_W] [int] NULL,
	[qt_TotalPremio_W] [money] NULL,
	[qt_Qtde_X] [int] NULL,
	[qt_TotalPremio_X] [money] NULL,
	[qt_Qtde_Y] [int] NULL,
	[qt_TotalPremio_Y] [money] NULL,
	[qt_Qtde_Z] [int] NULL,
	[qt_TotalPremio_Z] [money] NULL,
	[qt_Qtde_AA] [int] NULL,
	[qt_TotalPremio_AA] [money] NULL,
	[qt_Qtde_AB] [int] NULL,
	[qt_TotalPremio_AB] [money] NULL,
	[qt_Qtde_AC] [int] NULL,
	[qt_TotalPremio_AC] [money] NULL,
	[qt_Qtde_AD] [int] NULL,
	[qt_TotalPremio_AD] [money] NULL,
	[qt_Qtde_AE] [int] NULL,
	[qt_TotalPremio_AE] [money] NULL,
	[qt_Qtde_AF] [int] NULL,
	[qt_TotalPremio_AF] [money] NULL,
	[qt_Qtde_AG] [int] NULL,
	[qt_TotalPremio_AG] [money] NULL,
	[qt_Qtde_AH] [int] NULL,
	[qt_TotalPremio_AH] [money] NULL,
	[qt_Qtde_AI] [int] NULL,
	[qt_TotalPremio_AI] [money] NULL,
	[qt_Qtde_AJ] [int] NULL,
	[qt_TotalPremio_AJ] [money] NULL,
	[qt_Qtde_AK] [int] NULL,
	[qt_TotalPremio_AK] [money] NULL,
	[qt_Qtde_AL] [int] NULL,
	[qt_TotalPremio_AL] [money] NULL,
	[qt_Qtde_AM] [int] NULL,
	[qt_TotalPremio_AM] [money] NULL,
	[qt_Qtde_AN] [int] NULL,
	[qt_TotalPremio_AN] [money] NULL,
	[qt_Qtde_AO] [int] NULL,
	[qt_TotalPremio_AO] [money] NULL,
	[qt_Qtde_AP] [int] NULL,
	[qt_TotalPremio_AP] [money] NULL,
	[qt_Qtde_AQ] [int] NULL,
	[qt_TotalPremio_AQ] [money] NULL,
	[qt_Qtde_AR] [int] NULL,
	[qt_TotalPremio_AR] [money] NULL,
	[qt_Qtde_AS] [int] NULL,
	[qt_TotalPremio_AS] [money] NULL,
	[qt_Qtde_AT] [int] NULL,
	[qt_TotalPremio_AT] [money] NULL,
	[qt_Qtde_AU] [int] NULL,
	[qt_TotalPremio_AU] [money] NULL,
	[qt_Qtde_AV] [int] NULL,
	[qt_TotalPremio_AV] [money] NULL,
	[qt_Qtde_AW] [int] NULL,
	[qt_TotalPremio_AW] [money] NULL,
	[qt_Qtde_AX] [int] NULL,
	[qt_TotalPremio_AX] [money] NULL,
	[qt_Qtde_AY] [int] NULL,
	[qt_TotalPremio_AY] [money] NULL,
	[qt_Qtde_AZ] [int] NULL,
	[qt_TotalPremio_AZ] [money] NULL,
	[qt_Qtde_BA] [int] NULL,
	[qt_TotalPremio_BA] [money] NULL,
	[qt_Qtde_BB] [int] NULL,
	[qt_TotalPremio_BB] [money] NULL,
	[qt_Qtde_BC] [int] NULL,
	[qt_TotalPremio_BC] [money] NULL,
	[qt_Qtde_BD] [int] NULL,
	[qt_TotalPremio_BD] [money] NULL,
	[qt_Qtde_BE] [int] NULL,
	[qt_TotalPremio_BE] [money] NULL,
	[qt_Qtde_BF] [int] NULL,
	[qt_TotalPremio_BF] [money] NULL,
	[qt_Qtde_BG] [int] NULL,
	[qt_TotalPremio_BG] [money] NULL,
	[qt_Qtde_BH] [int] NULL,
	[qt_TotalPremio_BH] [money] NULL,
	[qt_Qtde_BI] [int] NULL,
	[qt_TotalPremio_BI] [varchar](100) NULL
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[tbGS_hst_TipoMotivos_Attrition](
	[id_Base] [bigint] IDENTITY(1,1) NOT NULL,
	[id_Arquivo] [bigint] NULL,
	[ds_Periodo] [varchar](30) NULL,
	[ds_TipoArquivo] [varchar](100) NULL,
	[ds_Motivo] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_Base] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

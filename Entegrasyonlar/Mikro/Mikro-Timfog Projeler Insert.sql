    USE [XPODA]
GO
/****** Object:  StoredProcedure [dbo].[sp_XP_MCM_ProjelerInsert]    Script Date: 10/1/2020 3:46:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_XP_MCM_ProjelerInsert]
(
@UserTableID INT
)
AS
BEGIN


DECLARE @Guid uniqueidentifier,
@CreateUser INT,
@ProjeCreateDate DATETIME,
@ProjeKodu NVARCHAR(25),
@ProjeAdi NVARCHAR(40),
@MusteriKodu NVARCHAR(25),
@SorumlulukMerkezi NVARCHAR(25),
@Bolge NVARCHAR(25),
@Sektor NVARCHAR(25),
@Grup NVARCHAR(25),
@Durum INT,
@Aciklama NVARCHAR(50),
@PlanlananSure INT,
@PlanlananBaslangicTarihi DATETIME,
@PlanlananBitisTarihi DATETIME,
@GerceklesenBalangicTarihi DATETIME='1899-12-31 00:00:00.000',
@GerceklesenBitisTarihi DATETIME='1899-12-31 00:00:00.000',
@BaslangicGecikmeSebep NVARCHAR(50),
@BitisGecikmeSebep NVARCHAR(50),
@TeminatSekli INT,
@TeminatDovizCinsi INT,
@Teminat FLOAT,
@IsAvansiSekli INT,
@IsAvansiDovizCinsi INT,
@IsAvansi FLOAT


SELECT
	@CreateUser=CreateUser,
	@ProjeAdi=ProjeAdi,
	@MusteriKodu=MusteriKodu,
	@SorumlulukMerkezi=SorumlulukMerkeziKodu,
	@Bolge=YurtIciYurtDisi,
	@Sektor=SektorKodu,
	@Grup=GrupKodu,
	@Durum=CONVERT(INT,Durumu),
	@PlanlananBaslangicTarihi=BaslamaTarihi,
	@PlanlananBitisTarihi=BitisTarifi,
	@TeminatSekli=CONVERT(INT,TeminatSekli),
	@TeminatDovizCinsi=CONVERT(INT,TeminatDovizCinsi),
	@Teminat=TeminatFiyati,
	@IsAvansiSekli=CONVERT(INT,AvansSekli),
	@IsAvansiDovizCinsi=CONVERT(INT,AvansDovizCinsi),
	@IsAvansi=AvansFiyati

FROM MCM_PROJE_TANITIM_KARTI WITH (NOLOCK)
WHERE UserTableID=@UserTableID

SET @Guid=NEWID()
SET @ProjeCreateDate=GETDATE()
SET @ProjeKodu=(SELECT dbo.fn_XP_MikroProjeKoduOlusturma())

INSERT INTO MikroDB_V16_MCM.dbo.PROJELER
           ([pro_Guid]
           ,[pro_DBCno]
           ,[pro_SpecRECno]
           ,[pro_iptal]
           ,[pro_fileid]
           ,[pro_hidden]
           ,[pro_kilitli]
           ,[pro_degisti]
           ,[pro_checksum]
           ,[pro_create_user]
           ,[pro_create_date]
           ,[pro_lastup_user]
           ,[pro_lastup_date]
           ,[pro_special1]
           ,[pro_special2]
           ,[pro_special3]
           ,[pro_kodu]
           ,[pro_adi]
           ,[pro_musterikodu]
           ,[pro_sormerkodu]
           ,[pro_bolgekodu]
           ,[pro_sektorkodu]
           ,[pro_grupkodu]
           ,[pro_muh_kod_artikeli]
           ,[pro_durumu]
           ,[pro_aciklama]
           ,[pro_ana_projekodu]
           ,[pro_planlanan_sure]
           ,[pro_planlanan_bastarih]
           ,[pro_planlanan_bittarih]
           ,[pro_gerceklesen_bastarih]
           ,[pro_gerceklesen_bittarih]
           ,[pro_baslangic_gecikmesebep]
           ,[pro_bitis_gecikmesebep]
           ,[pro_performans_orani]
           ,[pro_teminat_sekli]
           ,[pro_teminat_doviz_cinsi]
           ,[pro_teminat]
           ,[pro_isavansi_sekli]
           ,[pro_isavansi_doviz_cinsi]
           ,[pro_isavansi])
     VALUES
           (
		   @Guid ---<pro_Guid, uniqueidentifier,>
           ,0 ---<pro_DBCno, smallint,>
           ,0 ---<pro_SpecRECno, int,>
           ,0 ---<pro_iptal, bit,>
           ,176 ---<pro_fileid, smallint,>
           ,0 ---<pro_hidden, bit,>
           ,0 ---<pro_kilitli, bit,>
           ,0 ---<pro_degisti, bit,>
           ,0 ---<pro_checksum, int,>
           ,@CreateUser ---<pro_create_user, smallint,>
           ,@ProjeCreateDate ---<pro_create_date, datetime,>
           ,@CreateUser ---<pro_lastup_user, smallint,>
           ,@ProjeCreateDate ---<pro_lastup_date, datetime,>
           ,'XPD' ---<pro_special1, nvarchar(4),>
           ,'' ---<pro_special2, nvarchar(4),>
           ,'' ---<pro_special3, nvarchar(4),>
           ,@ProjeKodu ---<pro_kodu, nvarchar(25),>
           ,@ProjeAdi ---<pro_adi, nvarchar(40),>
           ,@MusteriKodu ---<pro_musterikodu, nvarchar(25),>
           ,@SorumlulukMerkezi ---<pro_sormerkodu, nvarchar(25),>
           ,CASE WHEN CONVERT(NVARCHAR(5),@Bolge)='2' THEN '01'  ELSE '02' END---<pro_bolgekodu, nvarchar(25),>
           ,@Sektor ---<pro_sektorkodu, nvarchar(25),>
           ,@Grup ---<pro_grupkodu, nvarchar(25),>
           ,'' ---<pro_muh_kod_artikeli, nvarchar(10),>
           ,@Durum ---<pro_durumu, tinyint,>
           ,'' ---<pro_aciklama, nvarchar(50),>
           ,'' ---<pro_ana_projekodu, nvarchar(25),>
           ,0 ---<pro_planlanan_sure, int,>
           ,@PlanlananBaslangicTarihi ---<pro_planlanan_bastarih, datetime,>
           ,@PlanlananBitisTarihi ---<pro_planlanan_bittarih, datetime,>
           ,@GerceklesenBalangicTarihi ---<pro_gerceklesen_bastarih, datetime,>
           ,@GerceklesenBitisTarihi ---<pro_gerceklesen_bittarih, datetime,>
           ,'' ---<pro_baslangic_gecikmesebep, nvarchar(50),>
           ,'' ---<pro_bitis_gecikmesebep, nvarchar(50),>
           ,0 ---<pro_performans_orani, float,>
           ,@TeminatSekli ---<pro_teminat_sekli, tinyint,>
           ,@TeminatDovizCinsi ---<pro_teminat_doviz_cinsi, tinyint,>
           ,@Teminat ---<pro_teminat, float,>
           ,@IsAvansiSekli ---<pro_isavansi_sekli, tinyint,>
           ,@IsAvansiDovizCinsi ---<pro_isavansi_doviz_cinsi, tinyint,>
           ,@IsAvansi ---<pro_isavansi, float,>
		   
		   )

		   UPDATE MCM_PROJE_TANITIM_KARTI SET IntegrationID=@Guid,ProjeKodu=@ProjeKodu WHERE UserTableID=@UserTableID
		--- UPDATE MCM_PROJE_TANITIM_KARTI SET Guid=@Guid,ProjeKodu=@ProjeKodu WHERE UserTableID=@UserTableID
		
END


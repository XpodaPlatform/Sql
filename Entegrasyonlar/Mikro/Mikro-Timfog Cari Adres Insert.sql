USE [XPODA]
GO

/****** Object:  StoredProcedure [dbo].[sp_XP_MCM_AdreslerMikroInsert]    Script Date: 10/1/2020 3:44:07 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_XP_MCM_AdreslerMikroInsert]
(
@CariKodu NVARCHAR(50)
)
AS
BEGIN

DECLARE @Guid uniqueidentifier, @CreateDate DATETIME,@AdresNo INT

DECLARE @UserTableID INT,
@CreateUser INT,
@CariKod NVARCHAR(25),
@Cadde NVARCHAR(50), 
@Mahalle NVARCHAR(50), 
@Sokak NVARCHAR(50), 
@Semt NVARCHAR(25), 
@ApartmanNo NVARCHAR(10), 
@DaireNo NVARCHAR(10), 
@PostaKodu NVARCHAR(8), 
@Il NVARCHAR(50),
@Ilce NVARCHAR(50),
@Ulke NVARCHAR(50),
@AdresKodu NVARCHAR(10),
@TelUlkeKodu NVARCHAR(5),
@TelBolgeKodu NVARCHAR(5),
@TelNo1 NVARCHAR(10),
@TelNo2 NVARCHAR(10),
@FaxNo NVARCHAR(10),
@OzelNot NVARCHAR(50)

  
	DECLARE Adresler CURSOR FOR
	
	SELECT A.UserTableID, A.CreateUser, C.MikroCariKodu, Cadde, Mahalle, Sokak, Semt, ApartmanNo, DaireNo, PostaKodu, Il, Ilce, Ulke, AdresKodu, TelUlkeKodu, TelBolgeKodu, TelNo1,TelNo2, FaxNo, OzelNot FROM MCM_ADRES_TANITIM_KARTI A WITH (NOLOCK)
	LEFT OUTER JOIN MCM_CARI_TANITIM_KARTI C WITH (NOLOCK) ON C.CariKodu=A.CariKodu
	WHERE  A.CariKodu=@CariKodu AND A.IntegrationID IN ('','0')

	OPEN Adresler 
 
	FETCH NEXT FROM Adresler INTO @UserTableID,@CreateUser,@CariKod,@Cadde,@Mahalle,@Sokak,@Semt,@ApartmanNo,@DaireNo,@PostaKodu,@Il,@Ilce,@Ulke,@AdresKodu,@TelUlkeKodu,@TelBolgeKodu,@TelNo1,@TelNo2,@FaxNo,@OzelNot
 
	WHILE @@FETCH_STATUS =0
		BEGIN
			
			SET @AdresNo=0
			SET @Guid=NEWID()
			SET @CreateDate=GETDATE()

			IF EXISTS (SELECT * FROM MikroDB_V16_MCM.dbo.CARI_HESAP_ADRESLERI WITH (NOLOCK) WHERE adr_cari_kod=@CariKod )
			SET @AdresNo=(SELECT ISNULL(MAX(adr_adres_no),0)+1 FROM MikroDB_V16_MCM.dbo.CARI_HESAP_ADRESLERI WITH (NOLOCK) WHERE adr_cari_kod=@CariKod)
			ELSE 
			SET @AdresNo=1

			INSERT INTO MikroDB_V16_MCM.dbo.CARI_HESAP_ADRESLERI
           ([adr_Guid]
           ,[adr_DBCno]
           ,[adr_SpecRECno]
           ,[adr_iptal]
           ,[adr_fileid]
           ,[adr_hidden]
           ,[adr_kilitli]
           ,[adr_degisti]
           ,[adr_checksum]
           ,[adr_create_user]
           ,[adr_create_date]
           ,[adr_lastup_user]
           ,[adr_lastup_date]
           ,[adr_special1]
           ,[adr_special2]
           ,[adr_special3]
           ,[adr_cari_kod]
           ,[adr_adres_no]
           ,[adr_aprint_fl]
           ,[adr_cadde]
           ,[adr_mahalle]
           ,[adr_sokak]
           ,[adr_Semt]
           ,[adr_Apt_No]
           ,[adr_Daire_No]
           ,[adr_posta_kodu]
           ,[adr_ilce]
           ,[adr_il]
           ,[adr_ulke]
           ,[adr_Adres_kodu]
           ,[adr_tel_ulke_kodu]
           ,[adr_tel_bolge_kodu]
           ,[adr_tel_no1]
           ,[adr_tel_no2]
           ,[adr_tel_faxno]
           ,[adr_tel_modem]
           ,[adr_yon_kodu]
           ,[adr_uzaklik_kodu]
           ,[adr_temsilci_kodu]
           ,[adr_ozel_not]
           ,[adr_ziyaretperyodu]
           ,[adr_ziyaretgunu]
           ,[adr_gps_enlem]
           ,[adr_gps_boylam]
           ,[adr_ziyarethaftasi]
           ,[adr_ziygunu2_1]
           ,[adr_ziygunu2_2]
           ,[adr_ziygunu2_3]
           ,[adr_ziygunu2_4]
           ,[adr_ziygunu2_5]
           ,[adr_ziygunu2_6]
           ,[adr_ziygunu2_7]
           ,[adr_efatura_alias]
           ,[adr_eirsaliye_alias])
     VALUES
           (
		    @Guid ---<adr_Guid, uniqueidentifier,>
           ,0 ---<adr_DBCno, smallint,>
           ,0 ---<adr_SpecRECno, int,>
           ,0 ---<adr_iptal, bit,>
           ,32 ---<adr_fileid, smallint,>
           ,0 ---<adr_hidden, bit,>
           ,0 ---<adr_kilitli, bit,>
           ,0 ---<adr_degisti, bit,>
           ,0 ---<adr_checksum, int,>
           ,@CreateUser ---<adr_create_user, smallint,>
           ,@CreateDate ---<adr_create_date, datetime,>
           ,@CreateUser ---<adr_lastup_user, smallint,>
           ,@CreateDate ---<adr_lastup_date, datetime,>
           ,'XPD' ---<adr_special1, nvarchar(4),>
           ,'' ---<adr_special2, nvarchar(4),>
           ,'' ---<adr_special3, nvarchar(4),>
           ,@CariKod ---<adr_cari_kod, nvarchar(25),>
           ,@AdresNo ---<adr_adres_no, int,>								
           ,0 ---<adr_aprint_fl, bit,>
           ,@Cadde ---<adr_cadde, nvarchar(50),>
           ,@Mahalle ---<adr_mahalle, nvarchar(50),>
           ,@Sokak ---<adr_sokak, nvarchar(50),>
           ,@Semt ---<adr_Semt, nvarchar(25),>
           ,@ApartmanNo ---<adr_Apt_No, nvarchar(10),>
           ,@DaireNo ---<adr_Daire_No, nvarchar(10),>
           ,@PostaKodu ---<adr_posta_kodu, nvarchar(8),>
           ,@Ilce ---<adr_ilce, nvarchar(50),>
           ,@Il ---<adr_il, nvarchar(50),>
           ,@Ulke ---<adr_ulke, nvarchar(50),>
           ,@AdresKodu ---<adr_Adres_kodu, nvarchar(10),>
           ,@TelUlkeKodu ---<adr_tel_ulke_kodu, nvarchar(5),>
           ,ISNULL(@TelBolgeKodu,'') ---<adr_tel_bolge_kodu, nvarchar(5),>
           ,@TelNo1 ---<adr_tel_no1, nvarchar(10),>
           ,@TelNo2 ---<adr_tel_no2, nvarchar(10),>
           ,@FaxNo ---<adr_tel_faxno, nvarchar(10),>
           ,'' ---<adr_tel_modem, nvarchar(10),>
           ,'' ---<adr_yon_kodu, nvarchar(4),>
           ,0 ---<adr_uzaklik_kodu, smallint,>
           ,'' ---<adr_temsilci_kodu, nvarchar(25),>
           ,@OzelNot ---<adr_ozel_not, nvarchar(50),>
           ,0 ---<adr_ziyaretperyodu, tinyint,>
           ,0 ---<adr_ziyaretgunu, float,>
           ,0 ---<adr_gps_enlem, float,>
           ,0 ---<adr_gps_boylam, float,>
           ,0 ---<adr_ziyarethaftasi, tinyint,>
           ,0 ---<adr_ziygunu2_1, bit,>
           ,0 ---<adr_ziygunu2_2, bit,>
           ,0 ---<adr_ziygunu2_3, bit,>
           ,0 ---<adr_ziygunu2_4, bit,>
           ,0 ---<adr_ziygunu2_5, bit,>
           ,0 ---<adr_ziygunu2_6, bit,>
           ,0 ---<adr_ziygunu2_7, bit,>
           ,'' ---<adr_efatura_alias, nvarchar(120),>
           ,'' ---<adr_eirsaliye_alias, nvarchar(120),>
		   )

			UPDATE MCM_ADRES_TANITIM_KARTI SET IntegrationID=@Guid WHERE UserTableID=@UserTableID
 
			FETCH NEXT FROM Adresler INTO @UserTableID,@CreateUser,@CariKod,@Cadde,@Mahalle,@Sokak,@Semt,@ApartmanNo,@DaireNo,@PostaKodu,@Il,@Ilce,@Ulke,@AdresKodu,@TelUlkeKodu,@TelBolgeKodu,@TelNo1,@TelNo2,@FaxNo,@OzelNot
 
		END
 
	CLOSE Adresler 
 
	DEALLOCATE Adresler 


END
GO


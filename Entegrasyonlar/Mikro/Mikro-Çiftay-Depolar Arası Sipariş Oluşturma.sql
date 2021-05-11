USE [EMS_OCTOPOD]
GO
/****** Object:  StoredProcedure [dbo].[sp_Oct_Siparis_Depolar_Arasi_Siparis_Olusturma_1]    Script Date: 1.10.2020 11:35:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_Oct_Siparis_Depolar_Arasi_Siparis_Olusturma_1]
@UserTableID INT
     
AS 
BEGIN  
DECLARE
        

         @MalzemeKodu NVARCHAR(25),
		 @MalzemeTipi INT,
         @Miktar FLOAT,
		 @BirimFiyat FLOAT,
		 @TalepDetayID INT,
	     @DovizCinsi INT,
		 @GonderiTarihi  DATETIME,

		 @GirisDepo INT, 
		 @CikisDepo INT ,
		 @SorumlulukMerkezi NVARCHAR(25),
		 @TalepNo NVARCHAR(50),
		 @Aciklama NVARCHAR(50),
		 @ToplamTutar FLOAT = dbo.fn_Cy_SiparisToplam(@UserTableID),
		 @Tarih DATETIME = GETDATE(),
		 @MikroGuid UNIQUEIDENTIFIER,
		 @OldCari NVARCHAR(25)='',
		 @Tedarikci NVARCHAR(25),
         @CreateUser INT = 1,
         @EvrakSira INT,
         @SatirNo INT=0,
		 @UniqueBosAlan UNIQUEIDENTIFIER,
		 @DakikasizTarih DATETIME = (SELECT CONVERT(NVARCHAR,CAST(ROUND(CAST(GETDATE() AS FLOAT),0,1) AS DATETIME),120)),
		 @SiparisDetayID INT,
		 @OldDepo1 INT=0,
         @OldDepo2 INT=0,
		 @MerkezmiFL NVARCHAR(100),
		 @OldMerkezmiFL NVARCHAR(100)=''
	

		 SET @CikisDepo = (SELECT TOP 1  SevkDepo FROM CY_SANTIYE_PARAMETRELERI WITH(NOLOCK) WHERE Santiye=10)

SET @UniqueBosAlan=(SELECT  CAST(CAST(0 AS BINARY) AS UNIQUEIDENTIFIER))
         
BEGIN TRY
BEGIN TRANSACTION 


DECLARE Siparis CURSOR LOCAL READ_ONLY FAST_FORWARD FOR


SELECT  
DISTINCT 
TD.UserTableID,
CASE WHEN CONVERT(NVARCHAR,TD.Islem)='1' THEN CONVERT(NVARCHAR,DT.Merkezemi_fl) WHEN CONVERT(NVARCHAR,TD.Islem)='2' THEN CONVERT(NVARCHAR,THD.Merkezemi_fl)
 WHEN CONVERT(NVARCHAR,TD.Islem)='3' THEN CONVERT(NVARCHAR,DT.Merkezemi_fl) END AS MerkezMiFl,
TD.MalzemeKodu,
TD.MalzemeTipi,
TD.Miktar,
TD.BirimFiyat,
TD.UserTableID,
TD.DovizCinsi,
TD.GonderiTarihi,
D.Santiye AS GirisDepo,
@CikisDepo AS CikisDepo,
dbo.fn_CY_DepoyaGoreSrmMerkezi(EMS_OCTOPOD.dbo.[fn_CY_TeklifDegerlendirmeDepoBulma](TD.TalepDetayID)) AS SorumlulukMerkezi,
SUBSTRING(dbo.[fn_CY_TeklifDegerlendirmeTalepNoBulma](TD.UserTableID)+' ' + 
MikroDB_V16_ÇİFTAY.dbo.fn_DepoIsmi(D.Santiye),1,50) AS TalepNo,
TD.Aciklama,
TD.Tedarikci
FROM
dbo.CY_SIPARIS T WITH(NOLOCK)
LEFT OUTER JOIN dbo.CY_SIPARIS_DETAYLARI  TD WITH(NOLOCK) ON TD.SiparisID=T.UserTableID
LEFT OUTER JOIN CY_TALEP_DETAYLARI DT WITH(NOLOCK) ON DT.UserTableID=TD.TalepDetayID
LEFT OUTER JOIN CY_TALEP_FORMU D WITH(NOLOCK) ON DT.TalepID=D.UserTableID

left outer join CY_TEKLIF_DETAYLARI SS WITH(NOLOCK) ON SS.TalepDetayID=DT.UserTableID

LEFT OUTER JOIN CY_TEKLIF_HAZIRLAMA_DETAIL THD WITH(NOLOCK) ON THD.UserDetailTableID=SS.TeklifHazirlamaDetailID
WHERE 
TD.UserTableID IS NOT NULL 
AND
T.UserTableID=@UserTableID
AND
 0 = (CASE WHEN TD.Islem=1 THEN DT.Merkezemi_fl WHEN TD.Islem=2 THEN THD.Merkezemi_fl
 WHEN TD.Islem=3 THEN DT.Merkezemi_fl END) /*MERKEZMI FL =0 OLANLAR. */
 AND  
 D.Santiye<>10  /* OSTİM OLMAYANLAR  */ 
 AND 
 TD.SiparisDetayOnayDurumu=0 --ONAYLI

ORDER BY TD.Tedarikci



OPEN Siparis
FETCH NEXT FROM Siparis INTO 
@SiparisDetayID,
@MerkezmiFL,

@MalzemeKodu,@MalzemeTipi,@Miktar,@BirimFiyat,@TalepDetayID,@DovizCinsi,@GonderiTarihi,@GirisDepo,@CikisDepo,@SorumlulukMerkezi,
@TalepNo,@Aciklama,@Tedarikci
WHILE @@FETCH_STATUS = 0
BEGIN


IF /*@OldCari<>@Tedarikci OR*/ @GirisDepo<>@OldDepo1 OR @CikisDepo<>@OldDepo2
BEGIN

SET  @OldCari = @Tedarikci
SET  @OldMerkezmiFL = @MerkezmiFL
SET  @OldDepo1 = @GirisDepo
SET  @OldDepo2 = @CikisDepo
		 SET @EvrakSira=(SELECT ISNULL(MAX(ssip_evrakno_sira),0) + 1  FROM MikroDB_V16_ÇİFTAY.dbo.DEPOLAR_ARASI_SIPARISLER WITH(NOLOCK) WHERE ssip_evrakno_seri='OCT')
		 SET @SatirNo=0

		
END



SET @MikroGuid=NEWID()



INSERT INTO MikroDB_V16_ÇİFTAY.[dbo].[DEPOLAR_ARASI_SIPARISLER]
           ([ssip_Guid]
           ,[ssip_DBCno]
           ,[ssip_SpecRECno]
           ,[ssip_iptal]
           ,[ssip_fileid]
           ,[ssip_hidden]
           ,[ssip_kilitli]
           ,[ssip_degisti]
           ,[ssip_checksum]
           ,[ssip_create_user]
           ,[ssip_create_date]
           ,[ssip_lastup_user]
           ,[ssip_lastup_date]
           ,[ssip_special1]
           ,[ssip_special2]
           ,[ssip_special3]
           ,[ssip_firmano]
           ,[ssip_subeno]
           ,[ssip_tarih]
           ,[ssip_teslim_tarih]
           ,[ssip_evrakno_seri]
           ,[ssip_evrakno_sira]
           ,[ssip_satirno]
           ,[ssip_belgeno]
           ,[ssip_belge_tarih]
           ,[ssip_stok_kod]
           ,[ssip_miktar]
           ,[ssip_b_fiyat]
           ,[ssip_tutar]
           ,[ssip_teslim_miktar]
           ,[ssip_aciklama]
           ,[ssip_girdepo]
           ,[ssip_cikdepo]
           ,[ssip_kapat_fl]
           ,[ssip_birim_pntr]
           ,[ssip_fiyat_liste_no]
           ,[ssip_stal_uid]
           ,[ssip_paket_kod]
           ,[ssip_kapatmanedenkod]
           ,[ssip_projekodu]
           ,[ssip_sormerkezi]
           ,[ssip_gecerlilik_tarihi]
           ,[ssip_rezervasyon_miktari]
           ,[ssip_rezerveden_teslim_edilen])
     VALUES
           (@MikroGuid,
            0,--,<ssip_DBCno, smallint,>
            0,--<ssip_SpecRECno, int,>
            0,--,<ssip_iptal, bit,>
            86,--<ssip_fileid, smallint,>
            0,--,<ssip_hidden, bit,>
            0,--,<ssip_kilitli, bit,>
            0,--,<ssip_degisti, bit,>
            0,--,<ssip_checksum, int,>
            @CreateUser, --,<ssip_create_user, smallint,>
            @Tarih,--,<ssip_create_date, datetime,>
            @CreateUser,--,<ssip_lastup_user, smallint,>
            @Tarih,--<ssip_lastup_date, datetime,>
            'OCT',--<ssip_special1, nvarchar(4),>
            '',--<ssip_special2, nvarchar(4),>
            '',--,<ssip_special3, nvarchar(4),>
            0,--,<ssip_firmano, int,>
            0,--<ssip_subeno, int,>
            @DakikasizTarih,--,<ssip_tarih, datetime,>
            @GonderiTarihi,--<ssip_teslim_tarih, datetime,>
            'OCT',--<ssip_evrakno_seri, [dbo].[evrakseri_str],>
            @EvrakSira,----,<ssip_evrakno_sira, int,>
            @SatirNo,--,<ssip_satirno, int,>
            '',--,<ssip_belgeno, [dbo].[belgeno_str],>
            @DakikasizTarih,--,<ssip_belge_tarih, datetime,>
            @MalzemeKodu,--<ssip_stok_kod, nvarchar(25),>
            @Miktar,--<ssip_miktar, float,>
            @BirimFiyat,--<ssip_b_fiyat, float,>
            @ToplamTutar,--<ssip_tutar, float,>
            0,--<ssip_teslim_miktar, float,>
            @TalepNo,--,<ssip_aciklama, nvarchar(50),>
            @GirisDepo,--<ssip_girdepo, int,>
            @CikisDepo,--<ssip_cikdepo, int,>
            0,--,<ssip_kapat_fl, bit,>
            0,---,<ssip_birim_pntr, tinyint,>
            0,--,<ssip_fiyat_liste_no, int,>
            @UniqueBosAlan,----,<ssip_stal_uid, uniqueidentifier,>
            '',--,<ssip_paket_kod, nvarchar(25),>
            '',--,<ssip_kapatmanedenkod, nvarchar(25),>
            '',--,<ssip_projekodu, nvarchar(25),>
            ISNULL(@SorumlulukMerkezi,''),--,<ssip_sormerkezi, nvarchar(25),>
            @DakikasizTarih,--- ,<ssip_gecerlilik_tarihi, datetime,>
            0,---,<ssip_rezervasyon_miktari, float,>
            0---<ssip_rezerveden_teslim_edilen, float,>)
			)

			
	
	SET @SatirNo=@SatirNo+1
	
FETCH NEXT FROM Siparis INTO @SiparisDetayID,
@MerkezmiFL,
@MalzemeKodu,@MalzemeTipi,@Miktar,@BirimFiyat,@TalepDetayID,@DovizCinsi,@GonderiTarihi,@GirisDepo,@CikisDepo,@SorumlulukMerkezi,
@TalepNo,@Aciklama,@Tedarikci
END
CLOSE Siparis
DEALLOCATE Siparis

COMMIT TRANSACTION
END TRY
BEGIN CATCH
ROLLBACK TRAN
SELECT ERROR_MESSAGE()
END CATCH



END


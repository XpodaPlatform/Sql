USE [EMS_OCTOPOD]
GO
/****** Object:  StoredProcedure [dbo].[sp_Oct_Depolar_Arasi_Sevk_Olusturma]    Script Date: 1.10.2020 11:10:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[sp_Oct_Depolar_Arasi_Sevk_Olusturma]
@UserTableID INT
     
AS 
BEGIN  
DECLARE
         @StokKodu NVARCHAR(25),
         @Miktar FLOAT,
		 @Aciklama NVARCHAR(50),
		 @KaynakDepo INT, 
		 @PaketlemeDepo INT ,
		 @TedarikTarihi DATETIME,

		 @Tarih DATETIME = GETDATE(),
		 @MikroGuid UNIQUEIDENTIFIER,
         @CreateUser INT = 1,
         @EvrakSira INT,
         @SatirNo INT = 0,
		 @UniqueBosAlan UNIQUEIDENTIFIER,
		 @SorumlulukMerkezi NVARCHAR(25),
		 @DetailID INT,
		 @DakikasizTarih DATETIME = (SELECT CONVERT(NVARCHAR,CAST(ROUND(CAST(GETDATE() AS FLOAT),0,1) AS DATETIME),120))

SET @PaketlemeDepo = (SELECT TOP 1 PaketlemeDepo FROM dbo.CY_SANTIYE_PARAMETRELERI WITH(NOLOCK) 
WHERE Santiye=(SELECT KaynakDepo FROM dbo.CY_IC_TEDARIK WITH(NOLOCK) WHERE UserTableID=@UserTableID))
	

SET @KaynakDepo=( SELECT TOP 1 KaynakDepo FROM dbo.CY_IC_TEDARIK  WITH(NOLOCK) WHERE UserTableID=@UserTableID)

  SET @SorumlulukMerkezi= ( SELECT TOP 1 SorumlulukMerkeziKodu FROM dbo.CY_SANTIYE_PARAMETRELERI WITH(NOLOCK) WHERE Santiye = (SELECT TOP 1 KaynakDepo FROM dbo.CY_IC_TEDARIK WITH(NOLOCK) WHERE UserTableID=@UserTableID ))

         SET @EvrakSira=(SELECT ISNULL(MAX(sth_evrakno_sira),0) + 1  FROM  MikroDB_V16_��FTAY.dbo.STOK_HAREKETLERI WITH(NOLOCK) WHERE sth_evrakno_seri='OCT')
  
SET @UniqueBosAlan=(SELECT  CAST(CAST(0 AS BINARY) AS UNIQUEIDENTIFIER))       
BEGIN TRY
BEGIN TRANSACTION 


DECLARE SevkCursor CURSOR LOCAL READ_ONLY FAST_FORWARD FOR

SELECT
 
TD.StokKodu,
IH.IcTedarikMiktari,
IH.Aciklama,
CONVERT(NVARCHAR,CAST(ROUND(CAST(I.IcTedarikTarihi AS FLOAT),0,1) AS DATETIME),120),
 IH.UserTableID
 FROM  dbo.CY_IC_TEDARIK I WITH(NOLOCK)
LEFT OUTER JOIN dbo.CY_IC_TEDARIK_HAREKETLERI IH WITH(NOLOCK) ON IH.IcTedarikID=I.UserTableID
LEFT OUTER JOIN dbo.CY_TALEP_DETAYLARI TD WITH(NOLOCK) ON TD.UserTableID=IH.TalepDetayID
LEFT OUTER JOIN dbo.CY_TALEP_FORMU T WITH(NOLOCK) ON T.UserTableID=TD.TalepID
WHERE I.UserTableID=@UserTableID


OPEN SevkCursor
FETCH NEXT FROM SevkCursor INTO @StokKodu,@Miktar,@Aciklama,@TedarikTarihi,@DetailID
WHILE @@FETCH_STATUS = 0
BEGIN

SET @MikroGuid=NEWID()
INSERT INTO MikroDB_V16_CIFTAY.[dbo].[STOK_HAREKETLERI]
           ([sth_Guid]
           ,[sth_DBCno]
           ,[sth_SpecRECno]
           ,[sth_iptal]
           ,[sth_fileid]
           ,[sth_hidden]
           ,[sth_kilitli]
           ,[sth_degisti]
           ,[sth_checksum]
           ,[sth_create_user]
           ,[sth_create_date]
           ,[sth_lastup_user]
           ,[sth_lastup_date]
           ,[sth_special1]
           ,[sth_special2]
           ,[sth_special3]
           ,[sth_firmano]
           ,[sth_subeno]
           ,[sth_tarih]
           ,[sth_tip]
           ,[sth_cins]
           ,[sth_normal_iade]
           ,[sth_evraktip]
           ,[sth_evrakno_seri]
           ,[sth_evrakno_sira]
           ,[sth_satirno]
           ,[sth_belge_no]
           ,[sth_belge_tarih]
           ,[sth_stok_kod]
           ,[sth_isk_mas1]
           ,[sth_isk_mas2]
           ,[sth_isk_mas3]
           ,[sth_isk_mas4]
           ,[sth_isk_mas5]
           ,[sth_isk_mas6]
           ,[sth_isk_mas7]
           ,[sth_isk_mas8]
           ,[sth_isk_mas9]
           ,[sth_isk_mas10]
           ,[sth_sat_iskmas1]
           ,[sth_sat_iskmas2]
           ,[sth_sat_iskmas3]
           ,[sth_sat_iskmas4]
           ,[sth_sat_iskmas5]
           ,[sth_sat_iskmas6]
           ,[sth_sat_iskmas7]
           ,[sth_sat_iskmas8]
           ,[sth_sat_iskmas9]
           ,[sth_sat_iskmas10]
           ,[sth_pos_satis]
           ,[sth_promosyon_fl]
           ,[sth_cari_cinsi]
           ,[sth_cari_kodu]
           ,[sth_cari_grup_no]
           ,[sth_isemri_gider_kodu]
           ,[sth_plasiyer_kodu]
           ,[sth_har_doviz_cinsi]
           ,[sth_har_doviz_kuru]
           ,[sth_alt_doviz_kuru]
           ,[sth_stok_doviz_cinsi]
           ,[sth_stok_doviz_kuru]
           ,[sth_miktar]
           ,[sth_miktar2]
           ,[sth_birim_pntr]
           ,[sth_tutar]
           ,[sth_iskonto1]
           ,[sth_iskonto2]
           ,[sth_iskonto3]
           ,[sth_iskonto4]
           ,[sth_iskonto5]
           ,[sth_iskonto6]
           ,[sth_masraf1]
           ,[sth_masraf2]
           ,[sth_masraf3]
           ,[sth_masraf4]
           ,[sth_vergi_pntr]
           ,[sth_vergi]
           ,[sth_masraf_vergi_pntr]
           ,[sth_masraf_vergi]
           ,[sth_netagirlik]
           ,[sth_odeme_op]
           ,[sth_aciklama]
           ,[sth_sip_uid]
           ,[sth_fat_uid]
           ,[sth_giris_depo_no]
           ,[sth_cikis_depo_no]
           ,[sth_malkbl_sevk_tarihi]
           ,[sth_cari_srm_merkezi]
           ,[sth_stok_srm_merkezi]
           ,[sth_fis_tarihi]
           ,[sth_fis_sirano]
           ,[sth_vergisiz_fl]
           ,[sth_maliyet_ana]
           ,[sth_maliyet_alternatif]
           ,[sth_maliyet_orjinal]
           ,[sth_adres_no]
           ,[sth_parti_kodu]
           ,[sth_lot_no]
           ,[sth_kons_uid]
           ,[sth_proje_kodu]
           ,[sth_exim_kodu]
           ,[sth_otv_pntr]
           ,[sth_otv_vergi]
           ,[sth_brutagirlik]
           ,[sth_disticaret_turu]
           ,[sth_otvtutari]
           ,[sth_otvvergisiz_fl]
           ,[sth_oiv_pntr]
           ,[sth_oiv_vergi]
           ,[sth_oivvergisiz_fl]
           ,[sth_fiyat_liste_no]
           ,[sth_oivtutari]
           ,[sth_Tevkifat_turu]
           ,[sth_nakliyedeposu]
           ,[sth_nakliyedurumu]
           ,[sth_yetkili_uid]
           ,[sth_taxfree_fl]
           ,[sth_ilave_edilecek_kdv]
           ,[sth_ismerkezi_kodu]
           ,[sth_HareketGrupKodu1]
           ,[sth_HareketGrupKodu2]
           ,[sth_HareketGrupKodu3]
           ,[sth_Olcu1]
           ,[sth_Olcu2]
           ,[sth_Olcu3]
           ,[sth_Olcu4]
           ,[sth_Olcu5]
           ,[sth_FormulMiktarNo]
           ,[sth_FormulMiktar])
     VALUES
           ( @MikroGuid,--<sth_Guid, uniqueidentifier,>
             0,--,<sth_DBCno, smallint,>
             0,--<sth_SpecRECno, int,>
             0,--,<sth_iptal, bit,>
             16,--,<sth_fileid, smallint,>
             0,-- ,<sth_hidden, bit,>
             0,--,<sth_kilitli, bit,>
             0,--,<sth_degisti, bit,>
             0,--,<sth_checksum, int,>
             @CreateUser,--,<sth_create_user, smallint,>
             @Tarih,--<sth_create_date, datetime,>
             @CreateUser,--,<sth_lastup_user, smallint,>
             @Tarih,--<sth_lastup_date, datetime,>
             'OCT',--,<sth_special1, nvarchar(4),>
             '',--,<sth_special2, nvarchar(4),>
             '',--,<sth_special3, nvarchar(4),>
             0,--,<sth_firmano, int,>
             0,--,<sth_subeno, int,>
             @DakikasizTarih,--<sth_tarih, datetime,>
             2,--,<sth_tip, tinyint,>
             6 ,-- serkan beye sor ... <sth_cins, tinyint,>
             0,--,<sth_normal_iade, tinyint,>
             2 ,-- SERKAN BEYE SOR.,<sth_evraktip, tinyint,>
             'OCT',--<sth_evrakno_seri, [dbo].[evrakseri_str],>
             @EvrakSira,--<sth_evrakno_sira, int,>
             @SatirNo,--<sth_satirno, int,>
             '',--,<sth_belge_no, [dbo].[belgeno_str],>
             @DakikasizTarih,--,<sth_belge_tarih, datetime,>
             @StokKodu,--<sth_stok_kod, nvarchar(25),>
             0,--,<sth_isk_mas1, tinyint,>
             0,--,<sth_isk_mas2, tinyint,>
             0,--,<sth_isk_mas3, tinyint,>
             0,--,<sth_isk_mas4, tinyint,>
             0,--,<sth_isk_mas5, tinyint,>
             0,--,<sth_isk_mas6, tinyint,>
             0,--,<sth_isk_mas7, tinyint,>
             0,--,<sth_isk_mas8, tinyint,>
             0,--,<sth_isk_mas9, tinyint,>
             0,--,<sth_isk_mas10, tinyint,>
             0,--,<sth_sat_iskmas1, bit,>
             0,--,<sth_sat_iskmas2, bit,>
             0,--,<sth_sat_iskmas3, bit,>
             0,--,<sth_sat_iskmas4, bit,>
             0,--,<sth_sat_iskmas5, bit,>
             0,--,<sth_sat_iskmas6, bit,>
             0,--,<sth_sat_iskmas7, bit,>
             0,--,<sth_sat_iskmas8, bit,>
             0,--,<sth_sat_iskmas9, bit,>
             0,--,<sth_sat_iskmas10, bit,>
             0,--,<sth_pos_satis, bit,>
             0,--,<sth_promosyon_fl, bit,>
             0,--,<sth_cari_cinsi, tinyint,>
             '',--,<sth_cari_kodu, nvarchar(25),>
             0,--,<sth_cari_grup_no, tinyint,>
             0,--,<sth_isemri_gider_kodu, nvarchar(25),>
             0,--,<sth_plasiyer_kodu, nvarchar(25),>
             0,--,<sth_har_doviz_cinsi, tinyint,>
             0,--,<sth_har_doviz_kuru, float,>
             0,--,<sth_alt_doviz_kuru, float,>
             0,--,<sth_stok_doviz_cinsi, tinyint,>
            MikroDB_V16_��FTAY.dbo.fn_KurBul(@Tarih,0,1),--<sth_stok_doviz_kuru, float,>
             @Miktar,--,<sth_miktar, float,>
             0,--,<sth_miktar2, float,>
             0,--,<sth_birim_pntr, tinyint,>
             0,--<sth_tutar, float,>
             0,--,<sth_iskonto1, float,>
             0,--, <sth_iskonto2, float,>
             0,--,<sth_iskonto3, float,>
             0,--,<sth_iskonto4, float,>
             0,--,<sth_iskonto5, float,>
             0,--,<sth_iskonto6, float,>
             0,--,<sth_masraf1, float,>
             0,--,<sth_masraf2, float,>
             0,--,<sth_masraf3, float,>
             0,--,<sth_masraf4, float,>
           0,--<sth_vergi_pntr, tinyint,>
           0,--,<sth_vergi, float,>
           0,--,<sth_masraf_vergi_pntr, tinyint,>
           0,--,<sth_masraf_vergi, float,>
           0,--,<sth_netagirlik, float,>
           0,--,<sth_odeme_op, int,>
           @Aciklama,--<sth_aciklama, nvarchar(50),>
           @UniqueBosAlan,--,<sth_sip_uid, uniqueidentifier,>
           @UniqueBosAlan,--,<sth_fat_uid, uniqueidentifier,>
           @PaketlemeDepo,---,<sth_giris_depo_no, int,>
           @KaynakDepo,--,<sth_cikis_depo_no, int,>
           @DakikasizTarih,--,<sth_malkbl_sevk_tarihi, datetime,>
           '',--,<sth_cari_srm_merkezi, nvarchar(25),>
           ISNULL(@SorumlulukMerkezi,''),--,<sth_stok_srm_merkezi, nvarchar(25),>
           @DakikasizTarih,--<sth_fis_tarihi, datetime,>
           0,--,<sth_fis_sirano, int,>
           0,--,<sth_vergisiz_fl, bit,>
           0,--,<sth_maliyet_ana, float,>
           0,--,<sth_maliyet_alternatif, float,>
           0,--,<sth_maliyet_orjinal, float,>
           0,--,<sth_adres_no, int,>
           '',--,<sth_parti_kodu, nvarchar(25),>
           0,--,<sth_lot_no, int,>
           @UniqueBosAlan,--,<sth_kons_uid, uniqueidentifier,>
           '',--,<sth_proje_kodu, nvarchar(25),>
           '',--<sth_exim_kodu, nvarchar(25),>
           0,--,<sth_otv_pntr, tinyint,>
           0,--,<sth_otv_vergi, float,>
           0,--,<sth_brutagirlik, float,>
           0,--,<sth_disticaret_turu, tinyint,>
           0,--,<sth_otvtutari, float,>
           0,--,<sth_otvvergisiz_fl, bit,>
           0,--,<sth_oiv_pntr, tinyint,>
           0,--,<sth_oiv_vergi, float,>
           0,--,<sth_oivvergisiz_fl, bit,>
           0,--<sth_fiyat_liste_no, int,>
           0,--,<sth_oivtutari, float,>
           0,--,<sth_Tevkifat_turu, tinyint,>
           0,--,<sth_nakliyedeposu, int,>
           0,--,<sth_nakliyedurumu, tinyint,>
           @UniqueBosAlan,--,<sth_yetkili_uid, uniqueidentifier,>
           0,--,<sth_taxfree_fl, bit,>
           0,--,<sth_ilave_edilecek_kdv, float,>
           0,--,<sth_ismerkezi_kodu, nvarchar(25),>
           '',--,<sth_HareketGrupKodu1, nvarchar(25),>
           '',--,<sth_HareketGrupKodu2, nvarchar(25),>
           '',--,<sth_HareketGrupKodu3, nvarchar(25),>
           0,--,<sth_Olcu1, float,>
           0,--,<sth_Olcu2, float,>
           0,--,<sth_Olcu3, float,>
           0,--,<sth_Olcu4, float,>
           0,--,<sth_Olcu5, float,>
           0,--,<sth_FormulMiktarNo, tinyint,>
           0-- ,<sth_FormulMiktar, float,>
		   )
		   
  
	
UPDATE dbo.CY_IC_TEDARIK_HAREKETLERI SET IntegrationID = @MikroGuid WHERE UserTableID = @DetailID

	
	SET @SatirNo = @SatirNo + 1

FETCH NEXT FROM SevkCursor INTO @StokKodu,@Miktar,@Aciklama,@TedarikTarihi,@DetailID
END
CLOSE SevkCursor
DEALLOCATE SevkCursor

COMMIT TRANSACTION
END TRY
BEGIN CATCH
ROLLBACK TRAN
SELECT ERROR_MESSAGE()
END CATCH



END


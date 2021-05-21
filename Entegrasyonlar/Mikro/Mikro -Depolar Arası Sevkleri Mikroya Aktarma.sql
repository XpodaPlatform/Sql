CREATE PROCEDURE [dbo].[sp_NK_DEPOLAR_ARASI_SEVKLERI_MIKROYA_AKTARMA]			
@ActiveUser INT

AS


DECLARE 
		@Tarih DATETIME,
		@Special1 NVARCHAR(4),		
		@ErrMsg NVARCHAR(4000),
		@ErrSeverity INT,
		@StokKodu NVARCHAR(25),
		@MusteriKodu NVARCHAR(25),
		@BelgeNo NVARCHAR(25),
		@Miktar INT,
		@sth_Guid NVARCHAR(36),
		@LotNo INT,
		@PartiKodu NVARCHAR(25),
		@Barkod NVARCHAR(25),
		@EvrakTipi int,
		@EvrakNo INT,
		@SatirNo INT=0,
		@UserTableID int,
		@KaynakDepo NVARCHAR(25),
		@HedefDepo NVARCHAR(25),
		@EvrPartNumber INT=0,
		@OldEvrPartNumber INT=0,
		@AltDovizKuru FLOAT,
		@Seri NVARCHAR(10),
		@BosGuid uniqueidentifier
		
		
		
SET @Tarih=MikroDB_V16_2020_NIKEL.dbo.fn_DatePart(GETDATE())
SET @AltDovizKuru=MikroDB_V16_2020_NIKEL.dbo.fn_FirmaAlternatifDovizKuru()
SET @BosGuid='00000000-0000-0000-0000-000000000000'

SET @Special1='DS'
SET @Seri='DS'

BEGIN TRY
BEGIN TRANSACTION
BEGIN


DECLARE DEPOLAR_ARASI_SEVK CURSOR LOCAL READ_ONLY FAST_FORWARD FOR

SELECT TOP 100 PERCENT
	bar_stokkodu AS StokKodu,
	M.Miktar,
	dbo.[fn_NK_CARI_KODU](P.RecNo,P.EvrakTipi) AS CariKodu,
	P.BelgeNo,
	P.EvrakTipi,
	bar_partikodu,
	bar_lotno,
	M.UserTableID,
	M.KaynakDepo,
	M.HedefDepo,
	M.Barkod,
	DENSE_RANK() OVER(ORDER BY KaynakDepo,HedefDepo ASC)
FROM NK_DEPOLAR_ARASI_SEVKLER M WITH (NOLOCK)
LEFT OUTER JOIN NK_PARTI_LOT_DETAYLARI P WITH (NOLOCK) ON M.Barkod=P.Barkod
LEFT OUTER JOIN MikroDB_V16_2020_NIKEL.dbo.BARKOD_TANIMLARI WITH(NOLOCK) ON M.Barkod=bar_kodu COLLATE DATABASE_DEFAULT
WHERE M.IntegrationID IN ('','0') AND   M.CreateUser=@ActiveUser
ORDER BY KaynakDepo,HedefDepo

OPEN DEPOLAR_ARASI_SEVK
FETCH NEXT FROM DEPOLAR_ARASI_SEVK INTO @StokKodu,@Miktar,@MusteriKodu,@BelgeNo,@EvrakTipi,@PartiKodu,@LotNo,@UserTableID,@KaynakDepo,@HedefDepo,@Barkod,@EvrPartNumber
WHILE @@FETCH_STATUS = 0 
BEGIN


IF @OldEvrPartNumber<>@EvrPartNumber
BEGIN

SELECT TOP 1 @EvrakNo=MAX(sth_evrakno_sira) FROM  [MikroDB_V16_2020_NIKEL].[dbo].[STOK_HAREKETLERI] WITH (NOLOCK) WHERE sth_evraktip=2 AND sth_evrakno_seri=@Seri
SET @EvrakNo=ISNULL(@EvrakNo,0)+1

SET @SatirNo=0
SET @OldEvrPartNumber=@EvrPartNumber
END

SET @sth_Guid=newid() 

INSERT INTO [MikroDB_V16_2020_NIKEL].[dbo].[STOK_HAREKETLERI]
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
           (@sth_Guid--<sth_Guid, uniqueidentifier,>
           ,0--<sth_DBCno, smallint,>
           ,0--<sth_SpecRECno, int,>
           ,0--<sth_iptal, bit,>									
           ,16--<sth_fileid, smallint,>								
           ,0--<sth_hidden, bit,>									
           ,0--<sth_kilitli, bit,>									
           ,0--<sth_degisti, bit,>									
           ,0--<sth_checksum, int,>									
           ,1--<sth_create_user, smallint,>							
           ,GETDATE()--<sth_create_date, datetime,>					
           ,1--<sth_lastup_user, smallint,>							
           ,GETDATE()--<sth_lastup_date, datetime,>					
           ,@Special1--<sth_special1, nvarchar(4),>					
           ,''--<sth_special2, nvarchar(4),>						
           ,''--<sth_special3, nvarchar(4),>						
           ,0--<sth_firmano, int,>									
           ,0--<sth_subeno, int,>									
           ,@Tarih--<sth_tarih, datetime,>							
           ,2--<sth_tip, tinyint,>									
           ,6--<sth_cins, tinyint,>									
           ,0--<sth_normal_iade, tinyint,>							
           ,2--<sth_evraktip, tinyint,>								
           ,@Seri--<sth_evrakno_seri, nvarchar_evrakseri,>			
           ,@EvrakNo--<sth_evrakno_sira, int,>						
           ,@SatirNo--<sth_satirno, int,>							
           ,@BelgeNo--<sth_belge_no, nvarchar_belgeno,>				
           ,@Tarih--<sth_belge_tarih, datetime,>					
           ,@StokKodu--<sth_stok_kod, nvarchar(25),>				
           ,0--<sth_isk_mas1, tinyint,>								
           ,1--<sth_isk_mas2, tinyint,>								
           ,1--<sth_isk_mas3, tinyint,>								
           ,1--<sth_isk_mas4, tinyint,>								
           ,1--<sth_isk_mas5, tinyint,>								
           ,1--<sth_isk_mas6, tinyint,>								
           ,1--<sth_isk_mas7, tinyint,>								
           ,1--<sth_isk_mas8, tinyint,>								
           ,1--<sth_isk_mas9, tinyint,>								
           ,1--<sth_isk_mas10, tinyint,>							
           ,0--<sth_sat_iskmas1, bit,>								
           ,0--<sth_sat_iskmas2, bit,>								
           ,0--<sth_sat_iskmas3, bit,>								
           ,0--<sth_sat_iskmas4, bit,>								
           ,0--<sth_sat_iskmas5, bit,>								
           ,0--<sth_sat_iskmas6, bit,>								
           ,0--<sth_sat_iskmas7, bit,>								
           ,0--<sth_sat_iskmas8, bit,>								
           ,0--<sth_sat_iskmas9, bit,>								
           ,0--<sth_sat_iskmas10, bit,>								
           ,0--<sth_pos_satis, bit,>								
           ,0--<sth_promosyon_fl, bit,>								
           ,0--<sth_cari_cinsi, tinyint,>							
           ,@MusteriKodu--<sth_cari_kodu, nvarchar(25),>			
           ,0--<sth_cari_grup_no, tinyint,>							
           ,''--<sth_isemri_gider_kodu, nvarchar(25),>				
           ,''--<sth_plasiyer_kodu, nvarchar(25),>						
           ,0--<sth_har_doviz_cinsi, tinyint,>		
           ,1.0--<sth_har_doviz_kuru, float,>							
           ,@AltDovizKuru--<sth_alt_doviz_kuru, float,>					
           ,0--<sth_stok_doviz_cinsi, tinyint,>							
           ,1.0--<sth_stok_doviz_kuru, float,>							
           ,@Miktar--<sth_miktar, float,>								
           ,@Miktar--<sth_miktar2, float,>								
           ,0--<sth_birim_pntr, tinyint,>								
           ,0--<sth_tutar, float,>										
           ,0--<sth_iskonto1, float,>									
           ,0--<sth_iskonto2, float,>									
           ,0--<sth_iskonto3, float,>									
           ,0--<sth_iskonto4, float,>									
           ,0--<sth_iskonto5, float,>									
           ,0--<sth_iskonto6, float,>									
           ,0--<sth_masraf1, float,>									
           ,0--<sth_masraf2, float,>									
           ,0--<sth_masraf3, float,>									
           ,0--<sth_masraf4, float,>									
           ,4--<sth_vergi_pntr, tinyint,>								
           ,0--<sth_vergi, float,>										
           ,0--<sth_masraf_vergi_pntr, tinyint,>						
           ,0--<sth_masraf_vergi, float,>								
           ,0--<sth_netagirlik, float,>									
           ,0--<sth_odeme_op, int,>										
           ,''--<sth_aciklama, nvarchar(50),>							
           ,@BosGuid--,<sth_sip_uid, uniqueidentifier,>
		   ,@BosGuid--,<sth_fat_uid, uniqueidentifier,>
           ,@HedefDepo--<sth_giris_depo_no, int,>	
           ,@KaynakDepo--<sth_cikis_depo_no, int,>	
           ,@Tarih--<sth_malkbl_sevk_tarihi, datetime,>					
           ,''--<sth_cari_srm_merkezi, nvarchar(25),>					
           ,''--<sth_stok_srm_merkezi, nvarchar(25),>					
           ,'18991230'--<sth_fis_tarihi, datetime,>						
           ,0--<sth_fis_sirano, int,>									
           ,0--<sth_vergisiz_fl, bit,>									
           ,0--<sth_maliyet_ana, float,>								
           ,0--<sth_maliyet_alternatif, float,>							
           ,0--<sth_maliyet_orjinal, float,>							
           ,1--<sth_adres_no, int,>										
           ,@PartiKodu--<sth_parti_kodu, nvarchar(25),>					
           ,@LotNo--<sth_lot_no, int,>									
           ,@BosGuid--,<sth_kons_uid, uniqueidentifier,>						
           ,''--<sth_proje_kodu, nvarchar(25),>							
           ,''--<sth_exim_kodu, nvarchar(25),>							
           ,0--<sth_otv_pntr, tinyint,>									
           ,0--<sth_otv_vergi, float,>									
           ,0--<sth_brutagirlik, float,>								
           ,0--<sth_disticaret_turu, tinyint,>							
           ,0--<sth_otvtutari, float,>									
           ,0--<sth_otvvergisiz_fl, bit,>								
           ,0--<sth_oiv_pntr, tinyint,>									
           ,0--<sth_oiv_vergi, float,>									
           ,0--<sth_oivvergisiz_fl, bit,>								
           ,0--<sth_fiyat_liste_no, int,>								
           ,0--<sth_oivtutari, float,>									
           ,0--<sth_Tevkifat_turu, tinyint,>							
           ,0--<sth_nakliyedeposu, int,>								
           ,0--<sth_nakliyedurumu, tinyint,>							
           ,@BosGuid--,<sth_yetkili_uid, uniqueidentifier,>
           ,0--<sth_taxfree_fl, bit,>					
           ,0--<sth_ilave_edilecek_kdv, float,>					
           ,''--<sth_ismerkezi_kodu, nvarchar(25),>					
		   ,''--<sth_HareketGrupKodu1, nvarchar(25),>				
			,N''--,<sth_HareketGrupKodu2, nvarchar(25),>				
			,N''--<sth_HareketGrupKodu3, nvarchar(25),>				
			,0--<sth_Olcu1, float,>				
			,0--<sth_Olcu2, float,>				
			,0--<sth_Olcu3, float,>				
			,0--<sth_Olcu4, float,>				
			,0--<sth_Olcu5, float,>				
			,0--<sth_FormulMiktarNo, tinyint,>
			,0--<sth_FormulMiktar, float,>
			)

 SET @SatirNo=@SatirNo+1

UPDATE NK_DEPOLAR_ARASI_SEVKLER SET IntegrationID=@sth_Guid WHERE UserTableID=@UserTableID


FETCH NEXT FROM DEPOLAR_ARASI_SEVK INTO @StokKodu,@Miktar,@MusteriKodu,@BelgeNo,@EvrakTipi,@PartiKodu,@LotNo,@UserTableID,@KaynakDepo,@HedefDepo,@Barkod,@EvrPartNumber
END
CLOSE DEPOLAR_ARASI_SEVK
DEALLOCATE DEPOLAR_ARASI_SEVK

COMMIT TRANSACTION	
END
END TRY
BEGIN CATCH 
ROLLBACK TRAN
	IF Cursor_Status('local', 'DEPOLAR_ARASI_SEVK') > -1 CLOSE DEPOLAR_ARASI_SEVK
    IF Cursor_Status('local', 'DEPOLAR_ARASI_SEVK') = -1 DEALLOCATE DEPOLAR_ARASI_SEVK
	
	SELECT ERROR_MESSAGE(),ERROR_SEVERITY()


END CATCH


USE [XPODA]
GO

/****** Object:  StoredProcedure [dbo].[sp_XP_MCM_CariHesaplarInsert]    Script Date: 10/1/2020 3:45:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_XP_MCM_CariHesaplarInsert]
(
@UserTableID INT,
@CariTuru NVARCHAR(5) --- eklendi
)
AS
BEGIN
DECLARE @Guid uniqueidentifier,
@CariCreateDate DATETIME,
@CreateUser INT,
@CariUnvan NVARCHAR(127),
@VergiDairesiAdi NVARCHAR(50),
@VergiNo NVARCHAR(15),
@WebAdresi NVARCHAR(30),
@CariEmail NVARCHAR(127),
@CariTelefon NVARCHAR(20),
@CariKodu NVARCHAR(25),
@DovizCinsi1 INT,
@DovizCinsi2 INT,
@DovizCinsi3 INT

SELECT
	@CreateUser=CreateUser,
	@CariUnvan=CariUnvan,
	---@VergiDairesiAdi=Vgd_adi,
	@VergiDairesiAdi=VergiDairesi,
	@VergiNo=VergiNo,
	@WebAdresi=Web,
	@CariEmail=Mail,
	@CariTelefon=Telefon,
	@DovizCinsi1=CONVERT(INT,DovizCinsi1),
	@DovizCinsi2=CONVERT(INT,DovizCinsi2),
	@DovizCinsi3=CONVERT(INT,DovizCinsi3)

FROM MCM_CARI_TANITIM_KARTI WITH (NOLOCK)
---LEFT OUTER JOIN MikroDB_V16.dbo.VERGI_DAIRELERI WITH (NOLOCK) ON VergiDairesi=CONVERT(NVARCHAR(100),Vgd_Guid) COLLATE Turkish_CI_AS
WHERE UserTableID=@UserTableID


SET @Guid=NEWID()
SET @CariCreateDate=GETDATE()
SET @CariKodu=(SELECT CASE WHEN @CariTuru='1' THEN dbo.fn_XP_MikroCariKoduOlusturma_YurtIci() ELSE dbo.fn_XP_MikroCariKoduOlusturma_YurtDisi() END)
---SET @CariKodu=(SELECT dbo.fn_XP_MikroCariKoduOlusturma())


INSERT INTO MikroDB_V16_MCM.[dbo].[CARI_HESAPLAR]
           ([cari_Guid]
           ,[cari_DBCno]
           ,[cari_SpecRECno]
           ,[cari_iptal]
           ,[cari_fileid]
           ,[cari_hidden]
           ,[cari_kilitli]
           ,[cari_degisti]
           ,[cari_checksum]
           ,[cari_create_user]
           ,[cari_create_date]
           ,[cari_lastup_user]
           ,[cari_lastup_date]
           ,[cari_special1]
           ,[cari_special2]
           ,[cari_special3]
           ,[cari_kod]
           ,[cari_unvan1]
           ,[cari_unvan2]
           ,[cari_hareket_tipi]
           ,[cari_baglanti_tipi]
           ,[cari_stok_alim_cinsi]
           ,[cari_stok_satim_cinsi]
           ,[cari_muh_kod]
           ,[cari_muh_kod1]
           ,[cari_muh_kod2]
           ,[cari_doviz_cinsi]
           ,[cari_doviz_cinsi1]
           ,[cari_doviz_cinsi2]
           ,[cari_vade_fark_yuz]
           ,[cari_vade_fark_yuz1]
           ,[cari_vade_fark_yuz2]
           ,[cari_KurHesapSekli]
           ,[cari_vdaire_adi]
           ,[cari_vdaire_no]
           ,[cari_sicil_no]
           ,[cari_VergiKimlikNo]
           ,[cari_satis_fk]
           ,[cari_odeme_cinsi]
           ,[cari_odeme_gunu]
           ,[cari_odemeplan_no]
           ,[cari_opsiyon_gun]
           ,[cari_cariodemetercihi]
           ,[cari_fatura_adres_no]
           ,[cari_sevk_adres_no]
           ,[cari_banka_tcmb_kod1]
           ,[cari_banka_tcmb_subekod1]
           ,[cari_banka_tcmb_ilkod1]
           ,[cari_banka_hesapno1]
           ,[cari_banka_swiftkodu1]
           ,[cari_banka_tcmb_kod2]
           ,[cari_banka_tcmb_subekod2]
           ,[cari_banka_tcmb_ilkod2]
           ,[cari_banka_hesapno2]
           ,[cari_banka_swiftkodu2]
           ,[cari_banka_tcmb_kod3]
           ,[cari_banka_tcmb_subekod3]
           ,[cari_banka_tcmb_ilkod3]
           ,[cari_banka_hesapno3]
           ,[cari_banka_swiftkodu3]
           ,[cari_banka_tcmb_kod4]
           ,[cari_banka_tcmb_subekod4]
           ,[cari_banka_tcmb_ilkod4]
           ,[cari_banka_hesapno4]
           ,[cari_banka_swiftkodu4]
           ,[cari_banka_tcmb_kod5]
           ,[cari_banka_tcmb_subekod5]
           ,[cari_banka_tcmb_ilkod5]
           ,[cari_banka_hesapno5]
           ,[cari_banka_swiftkodu5]
           ,[cari_banka_tcmb_kod6]
           ,[cari_banka_tcmb_subekod6]
           ,[cari_banka_tcmb_ilkod6]
           ,[cari_banka_hesapno6]
           ,[cari_banka_swiftkodu6]
           ,[cari_banka_tcmb_kod7]
           ,[cari_banka_tcmb_subekod7]
           ,[cari_banka_tcmb_ilkod7]
           ,[cari_banka_hesapno7]
           ,[cari_banka_swiftkodu7]
           ,[cari_banka_tcmb_kod8]
           ,[cari_banka_tcmb_subekod8]
           ,[cari_banka_tcmb_ilkod8]
           ,[cari_banka_hesapno8]
           ,[cari_banka_swiftkodu8]
           ,[cari_banka_tcmb_kod9]
           ,[cari_banka_tcmb_subekod9]
           ,[cari_banka_tcmb_ilkod9]
           ,[cari_banka_hesapno9]
           ,[cari_banka_swiftkodu9]
           ,[cari_banka_tcmb_kod10]
           ,[cari_banka_tcmb_subekod10]
           ,[cari_banka_tcmb_ilkod10]
           ,[cari_banka_hesapno10]
           ,[cari_banka_swiftkodu10]
           ,[cari_EftHesapNum]
           ,[cari_Ana_cari_kodu]
           ,[cari_satis_isk_kod]
           ,[cari_sektor_kodu]
           ,[cari_bolge_kodu]
           ,[cari_grup_kodu]
           ,[cari_temsilci_kodu]
           ,[cari_muhartikeli]
           ,[cari_firma_acik_kapal]
           ,[cari_BUV_tabi_fl]
           ,[cari_cari_kilitli_flg]
           ,[cari_etiket_bas_fl]
           ,[cari_Detay_incele_flg]
           ,[cari_efatura_fl]
           ,[cari_POS_ongpesyuzde]
           ,[cari_POS_ongtaksayi]
           ,[cari_POS_ongIskOran]
           ,[cari_kaydagiristarihi]
           ,[cari_KabEdFCekTutar]
           ,[cari_hal_caritip]
           ,[cari_HalKomYuzdesi]
           ,[cari_TeslimSuresi]
           ,[cari_wwwadresi]
           ,[cari_EMail]
           ,[cari_CepTel]
           ,[cari_VarsayilanGirisDepo]
           ,[cari_VarsayilanCikisDepo]
           ,[cari_Portal_Enabled]
           ,[cari_Portal_PW]
           ,[cari_BagliOrtaklisa_Firma]
           ,[cari_kampanyakodu]
           ,[cari_b_bakiye_degerlendirilmesin_fl]
           ,[cari_a_bakiye_degerlendirilmesin_fl]
           ,[cari_b_irsbakiye_degerlendirilmesin_fl]
           ,[cari_a_irsbakiye_degerlendirilmesin_fl]
           ,[cari_b_sipbakiye_degerlendirilmesin_fl]
           ,[cari_a_sipbakiye_degerlendirilmesin_fl]
           ,[cari_AvmBilgileri1KiraKodu]
           ,[cari_AvmBilgileri1TebligatSekli]
           ,[cari_AvmBilgileri2KiraKodu]
           ,[cari_AvmBilgileri2TebligatSekli]
           ,[cari_AvmBilgileri3KiraKodu]
           ,[cari_AvmBilgileri3TebligatSekli]
           ,[cari_AvmBilgileri4KiraKodu]
           ,[cari_AvmBilgileri4TebligatSekli]
           ,[cari_AvmBilgileri5KiraKodu]
           ,[cari_AvmBilgileri5TebligatSekli]
           ,[cari_AvmBilgileri6KiraKodu]
           ,[cari_AvmBilgileri6TebligatSekli]
           ,[cari_AvmBilgileri7KiraKodu]
           ,[cari_AvmBilgileri7TebligatSekli]
           ,[cari_AvmBilgileri8KiraKodu]
           ,[cari_AvmBilgileri8TebligatSekli]
           ,[cari_AvmBilgileri9KiraKodu]
           ,[cari_AvmBilgileri9TebligatSekli]
           ,[cari_AvmBilgileri10KiraKodu]
           ,[cari_AvmBilgileri10TebligatSekli]
           ,[cari_KrediRiskTakibiVar_flg]
           ,[cari_ufrs_fark_muh_kod]
           ,[cari_ufrs_fark_muh_kod1]
           ,[cari_ufrs_fark_muh_kod2]
           ,[cari_odeme_sekli]
           ,[cari_TeminatMekAlacakMuhKodu]
           ,[cari_TeminatMekAlacakMuhKodu1]
           ,[cari_TeminatMekAlacakMuhKodu2]
           ,[cari_TeminatMekBorcMuhKodu]
           ,[cari_TeminatMekBorcMuhKodu1]
           ,[cari_TeminatMekBorcMuhKodu2]
           ,[cari_VerilenDepozitoTeminatMuhKodu]
           ,[cari_VerilenDepozitoTeminatMuhKodu1]
           ,[cari_VerilenDepozitoTeminatMuhKodu2]
           ,[cari_AlinanDepozitoTeminatMuhKodu]
           ,[cari_AlinanDepozitoTeminatMuhKodu1]
           ,[cari_AlinanDepozitoTeminatMuhKodu2]
           ,[cari_def_efatura_cinsi]
           ,[cari_otv_tevkifatina_tabii_fl]
           ,[cari_KEP_adresi]
           ,[cari_efatura_baslangic_tarihi]
           ,[cari_mutabakat_mail_adresi]
           ,[cari_mersis_no]
           ,[cari_istasyon_cari_kodu]
           ,[cari_gonderionayi_sms]
           ,[cari_gonderionayi_email]
           ,[cari_eirsaliye_fl]
           ,[cari_eirsaliye_baslangic_tarihi]
           ,[cari_vergidairekodu]
           ,[cari_CRM_sistemine_aktar_fl]
           ,[cari_efatura_xslt_dosya]
           ,[cari_pasaport_no]
           ,[cari_kisi_kimlik_bilgisi_aciklama_turu]
           ,[cari_kisi_kimlik_bilgisi_diger_aciklama]
           ,[cari_uts_kurum_no]
           ,[cari_kamu_kurumu_fl]
           ,[cari_earsiv_xslt_dosya]
           ,[cari_Perakende_fl])
     VALUES
           (
		    @Guid ---<cari_Guid, uniqueidentifier,>
           ,0 ---<cari_DBCno, smallint,>
           ,0 ---<cari_SpecRECno, int,>
           ,0 ---<cari_iptal, bit,>
           ,31 ---<cari_fileid, smallint,>
           ,0 ---<cari_hidden, bit,>
           ,0 ---<cari_kilitli, bit,>
           ,0 ---<cari_degisti, bit,>
           ,0 ---<cari_checksum, int,>
           ,@CreateUser ---<cari_create_user, smallint,>					
           ,@CariCreateDate ---<cari_create_date, datetime,>
           ,@CreateUser ---<cari_lastup_user, smallint,>				
           ,@CariCreateDate ---<cari_lastup_date, datetime,>
           ,'XPD' ---<cari_special1, nvarchar(4),>
           ,'' ---<cari_special2, nvarchar(4),>
           ,'' ---<cari_special3, nvarchar(4),>
           ,@CariKodu ---<cari_kod, nvarchar(25),>						
           ,@CariUnvan ---<cari_unvan1, nvarchar(127),>				
           ,'' ---<cari_unvan2, nvarchar(127),>					
           ,0 ---<cari_hareket_tipi, tinyint,>
           ,0 ---<cari_baglanti_tipi, tinyint,>
           ,0 ---<cari_stok_alim_cinsi, tinyint,>
           ,0 ---<cari_stok_satim_cinsi, tinyint,>
           ,@CariKodu ---<cari_muh_kod, nvarchar(40),>					
           ,'' ---<cari_muh_kod1, nvarchar(40),>				 	
           ,'' ---<cari_muh_kod2, nvarchar(40),>					   
           ,@DovizCinsi1 ---0  ---<cari_doviz_cinsi, tinyint,>					      
           ,@DovizCinsi2 ---0  ---<cari_doviz_cinsi1, tinyint,>							
           ,@DovizCinsi3 ---0  ---<cari_doviz_cinsi2, tinyint,>							
           ,25 ---<cari_vade_fark_yuz, float,>					        
           ,0 ---<cari_vade_fark_yuz1, float,>			
           ,0 ---<cari_vade_fark_yuz2, float,>					
           ,1 ---<cari_KurHesapSekli, tinyint,>					       
           ,@VergiDairesiAdi ---<cari_vdaire_adi, nvarchar(50),>
           ,@VergiNo ---<cari_vdaire_no, nvarchar(15),>
           ,'' ---<cari_sicil_no, nvarchar(15),>
           ,'' ---<cari_VergiKimlikNo, nvarchar(10),>
           ,1 ---<cari_satis_fk, int,>
           ,0 ---<cari_odeme_cinsi, tinyint,>
           ,0 ---<cari_odeme_gunu, tinyint,>
           ,0 ---<cari_odemeplan_no, int,>					        	
           ,0 ---<cari_opsiyon_gun, int,>
           ,0 ---<cari_cariodemetercihi, tinyint,>
           ,1 ---<cari_fatura_adres_no, int,>
           ,1 ---<cari_sevk_adres_no, int,>
           ,'' ---<cari_banka_tcmb_kod1, nvarchar(4),>
           ,'' ---<cari_banka_tcmb_subekod1, nvarchar(8),>
           ,'' ---<cari_banka_tcmb_ilkod1, nvarchar(3),>
           ,'' ---<cari_banka_hesapno1, nvarchar(30),>
           ,'' ---<cari_banka_swiftkodu1, nvarchar(25),>
           ,'' ---<cari_banka_tcmb_kod2, nvarchar(4),>
           ,'' ---<cari_banka_tcmb_subekod2, nvarchar(8),>
           ,'' ---<cari_banka_tcmb_ilkod2, nvarchar(3),>
           ,'' ---<cari_banka_hesapno2, nvarchar(30),>
           ,'' ---<cari_banka_swiftkodu2, nvarchar(25),>
           ,'' ---<cari_banka_tcmb_kod3, nvarchar(4),>
           ,'' ---<cari_banka_tcmb_subekod3, nvarchar(8),>
           ,'' ---<cari_banka_tcmb_ilkod3, nvarchar(3),>
           ,'' ---<cari_banka_hesapno3, nvarchar(30),>
           ,'' ---<cari_banka_swiftkodu3, nvarchar(25),>
           ,'' ---<cari_banka_tcmb_kod4, nvarchar(4),>
           ,'' ---<cari_banka_tcmb_subekod4, nvarchar(8),>
           ,'' ---<cari_banka_tcmb_ilkod4, nvarchar(3),>
           ,'' ---<cari_banka_hesapno4, nvarchar(30),>
           ,'' ---<cari_banka_swiftkodu4, nvarchar(25),>
           ,'' ---<cari_banka_tcmb_kod5, nvarchar(4),>
           ,'' ---<cari_banka_tcmb_subekod5, nvarchar(8),>
           ,'' ---<cari_banka_tcmb_ilkod5, nvarchar(3),>
           ,'' ---<cari_banka_hesapno5, nvarchar(30),>
           ,'' ---<cari_banka_swiftkodu5, nvarchar(25),>
           ,'' ---<cari_banka_tcmb_kod6, nvarchar(4),>
           ,'' ---<cari_banka_tcmb_subekod6, nvarchar(8),>
           ,'' ---<cari_banka_tcmb_ilkod6, nvarchar(3),>
           ,'' ---<cari_banka_hesapno6, nvarchar(30),>
           ,'' ---<cari_banka_swiftkodu6, nvarchar(25),>
           ,'' ---<cari_banka_tcmb_kod7, nvarchar(4),>
           ,'' ---<cari_banka_tcmb_subekod7, nvarchar(8),>
           ,'' ---<cari_banka_tcmb_ilkod7, nvarchar(3),>
           ,'' ---<cari_banka_hesapno7, nvarchar(30),>
           ,'' ---<cari_banka_swiftkodu7, nvarchar(25),>
           ,'' ---<cari_banka_tcmb_kod8, nvarchar(4),>
           ,'' ---<cari_banka_tcmb_subekod8, nvarchar(8),>
           ,'' ---<cari_banka_tcmb_ilkod8, nvarchar(3),>
           ,'' ---<cari_banka_hesapno8, nvarchar(30),>
           ,'' ---<cari_banka_swiftkodu8, nvarchar(25),>
           ,'' ---<cari_banka_tcmb_kod9, nvarchar(4),>
           ,'' ---<cari_banka_tcmb_subekod9, nvarchar(8),>
           ,'' ---<cari_banka_tcmb_ilkod9, nvarchar(3),>
           ,'' ---<cari_banka_hesapno9, nvarchar(30),>
           ,'' ---<cari_banka_swiftkodu9, nvarchar(25),>
           ,'' ---<cari_banka_tcmb_kod10, nvarchar(4),>
           ,'' ---<cari_banka_tcmb_subekod10, nvarchar(8),>
           ,'' ---<cari_banka_tcmb_ilkod10, nvarchar(3),>
           ,'' ---<cari_banka_hesapno10, nvarchar(30),>
           ,'' ---<cari_banka_swiftkodu10, nvarchar(25),>
           ,1  ---<cari_EftHesapNum, tinyint,>
           ,'' ---<cari_Ana_cari_kodu, nvarchar(25),>
           ,'' ---<cari_satis_isk_kod, nvarchar(4),>
           ,'' ---<cari_sektor_kodu, nvarchar(25),>
           ,'' ---<cari_bolge_kodu, nvarchar(25),>
           ,'' ---<cari_grup_kodu, nvarchar(25),>
           ,'' ---<cari_temsilci_kodu, nvarchar(25),>
           ,'' ---<cari_muhartikeli, nvarchar(10),>
           ,0  ---<cari_firma_acik_kapal, bit,>
           ,0  ---<cari_BUV_tabi_fl, bit,>
           ,0  ---<cari_cari_kilitli_flg, bit,>
           ,0  ---<cari_etiket_bas_fl, bit,>
           ,0  ---<cari_Detay_incele_flg, bit,>
           ,0  ---<cari_efatura_fl, bit,>								
           ,0  ---<cari_POS_ongpesyuzde, float,>
           ,0  ---<cari_POS_ongtaksayi, float,>
           ,0  ---<cari_POS_ongIskOran, float,>
           ,@CariCreateDate ---<cari_kaydagiristarihi, datetime,>
           ,0  ---<cari_KabEdFCekTutar, float,>
           ,0  ---<cari_hal_caritip, tinyint,>
           ,0  ---<cari_HalKomYuzdesi, float,>
           ,0  ---<cari_TeslimSuresi, smallint,>
           ,ISNULL(@WebAdresi,'')  ---<cari_wwwadresi, nvarchar(30),>
           ,@CariEmail  ---<cari_EMail, nvarchar(127),>
           ,@CariTelefon ---<cari_CepTel, nvarchar(20),>
           ,0  ---<cari_VarsayilanGirisDepo, int,>
           ,0  ---<cari_VarsayilanCikisDepo, int,>
           ,0  ---<cari_Portal_Enabled, bit,>
           ,'' ---<cari_Portal_PW, nvarchar(127),>
           ,0  ---<cari_BagliOrtaklisa_Firma, int,>
           ,'' ---<cari_kampanyakodu, nvarchar(4),>
           ,0  ---<cari_b_bakiye_degerlendirilmesin_fl, bit,>
           ,0  ---<cari_a_bakiye_degerlendirilmesin_fl, bit,>     
           ,0  ---<cari_b_irsbakiye_degerlendirilmesin_fl, bit,>
           ,0  ---<cari_a_irsbakiye_degerlendirilmesin_fl, bit,>
           ,0  ---<cari_b_sipbakiye_degerlendirilmesin_fl, bit,>  
           ,0  ---<cari_a_sipbakiye_degerlendirilmesin_fl, bit,>  
           ,'' ---<cari_AvmBilgileri1KiraKodu, nvarchar(25),>
           ,0  ---<cari_AvmBilgileri1TebligatSekli, tinyint,>
           ,'' ---<cari_AvmBilgileri2KiraKodu, nvarchar(25),>
           ,0  ---<cari_AvmBilgileri2TebligatSekli, tinyint,>
           ,'' ---<cari_AvmBilgileri3KiraKodu, nvarchar(25),>
           ,0  ---<cari_AvmBilgileri3TebligatSekli, tinyint,>
           ,'' ---<cari_AvmBilgileri4KiraKodu, nvarchar(25),>
           ,0  ---<cari_AvmBilgileri4TebligatSekli, tinyint,>
           ,'' ---<cari_AvmBilgileri5KiraKodu, nvarchar(25),>
           ,0  ---<cari_AvmBilgileri5TebligatSekli, tinyint,>
           ,'' ---<cari_AvmBilgileri6KiraKodu, nvarchar(25),>
           ,0  ---<cari_AvmBilgileri6TebligatSekli, tinyint,>
           ,'' ---<cari_AvmBilgileri7KiraKodu, nvarchar(25),>
           ,0  ---<cari_AvmBilgileri7TebligatSekli, tinyint,>
           ,'' ---<cari_AvmBilgileri8KiraKodu, nvarchar(25),>
           ,0  ---<cari_AvmBilgileri8TebligatSekli, tinyint,>
           ,'' ---<cari_AvmBilgileri9KiraKodu, nvarchar(25),>
           ,0  ---<cari_AvmBilgileri9TebligatSekli, tinyint,>
           ,'' ---<cari_AvmBilgileri10KiraKodu, nvarchar(25),>
           ,0  ---<cari_AvmBilgileri10TebligatSekli, tinyint,>
           ,0  ---<cari_KrediRiskTakibiVar_flg, bit,>
           ,'' ---<cari_ufrs_fark_muh_kod, nvarchar(40),>
           ,'' ---<cari_ufrs_fark_muh_kod1, nvarchar(40),>
           ,'' ---<cari_ufrs_fark_muh_kod2, nvarchar(40),>
           ,0  ---<cari_odeme_sekli, tinyint,>
           ,'910' ---<cari_TeminatMekAlacakMuhKodu, nvarchar(40),>
           ,'' ---<cari_TeminatMekAlacakMuhKodu1, nvarchar(40),>
           ,'' ---<cari_TeminatMekAlacakMuhKodu2, nvarchar(40),>
           ,'912' ---<cari_TeminatMekBorcMuhKodu, nvarchar(40),>
           ,'' ---<cari_TeminatMekBorcMuhKodu1, nvarchar(40),>
           ,'' ---<cari_TeminatMekBorcMuhKodu2, nvarchar(40),>
           ,'226' ---<cari_VerilenDepozitoTeminatMuhKodu, nvarchar(40),>
           ,'' ---<cari_VerilenDepozitoTeminatMuhKodu1, nvarchar(40),>
           ,'' ---<cari_VerilenDepozitoTeminatMuhKodu2, nvarchar(40),>
           ,'326' ---<cari_AlinanDepozitoTeminatMuhKodu, nvarchar(40),>
           ,'' ---<cari_AlinanDepozitoTeminatMuhKodu1, nvarchar(40),>
           ,'' ---<cari_AlinanDepozitoTeminatMuhKodu2, nvarchar(40),>
           ,0  ---<cari_def_efatura_cinsi, tinyint,>									 
           ,0  ---<cari_otv_tevkifatina_tabii_fl, bit,>
           ,'' ---<cari_KEP_adresi, nvarchar(80),>
           ,'1899-12-31 00:00:00.000' ---<cari_efatura_baslangic_tarihi, datetime,>
           ,@CariEmail ---<cari_mutabakat_mail_adresi, nvarchar(80),>
           ,'' ---<cari_mersis_no, nvarchar(25),>
           ,'' ---<cari_istasyon_cari_kodu, nvarchar(25),>
           ,0  ---<cari_gonderionayi_sms, bit,>
           ,0  ---<cari_gonderionayi_email, bit,>
           ,0  ---<cari_eirsaliye_fl, bit,>
           ,'1899-12-31 00:00:00.000' ---<cari_eirsaliye_baslangic_tarihi, datetime,>
           ,'' ---<cari_vergidairekodu, nvarchar(10),>                
           ,0  ---<cari_CRM_sistemine_aktar_fl, bit,>
           ,'' ---<cari_efatura_xslt_dosya, nvarchar(127),>
           ,'' ---<cari_pasaport_no, nvarchar(20),>
           ,0  ---<cari_kisi_kimlik_bilgisi_aciklama_turu, tinyint,>
           ,'' ---<cari_kisi_kimlik_bilgisi_diger_aciklama, nvarchar(50),>
           ,'' ---<cari_uts_kurum_no, nvarchar(15),>
           ,0  ---<cari_kamu_kurumu_fl, bit,>
           ,'' ---<cari_earsiv_xslt_dosya, nvarchar(127),>
           ,0  ---<cari_Perakende_fl, bit,>
		   )

		   UPDATE MCM_CARI_TANITIM_KARTI SET IntegrationID=@Guid, MikroCariKodu=@CariKodu WHERE UserTableID=@UserTableID

END
GO



USE [EMS_OCTOPOD]
GO
/****** Object:  StoredProcedure [dbo].[sp_M_PersonelInsert]    Script Date: 1.10.2020 11:39:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Change History:
--   23/03/2020 Furkan Camcı: meyer sicil insert eklendi. Sorgunun en altında prosedür olarak çalışacak.
--   19/08/2020 Ömer Kafaoğlu: Cari personel kodu Substring edilerek atılıyor.
-- =============================================
ALTER PROCEDURE [dbo].[sp_M_PersonelInsert]
    @ID INT
AS
BEGIN

DECLARE  @Guid uniqueidentifier = NEWID(),
		@DefaultTarih DATETIME='1899-12-31 00:00:00.000',
		@CariFl INT,
		@KimlikNo NVARCHAR(11),
		@TabiKanun INT,
		@SigortaGrubu INT,
		@Sehir NVARCHAR(50),
		@Ilce NVARCHAR(50),
		--@NufusIli NVARCHAR(20),
		--@NufusIlcesi NVARCHAR(20),
		@UpdatePerKod NVARCHAR(30),
		@BagliCariPerKod NVARCHAR(30),
		@CariPerKod INT

SET @UpdatePerKod = (SELECT TOP 1 KULLANICI_NO FROM MikroDB_V16_ÇİFTAY.dbo.KULLANICILAR_VIEW where KULLANICI_UZUN_ADI = (SELECT TOP 1 per_adi+' '+per_soyadi FROM MikroDB_V16_ÇİFTAY.dbo.PERSONELLER WITH (NOLOCK) WHERE per_caripers_kodu = (SELECT MikroKullanici FROM CY_M_KULLANICI_PARAMETRELERI WITH (NOLOCK) WHERE OctopodKullanici = (SELECT UpdateUser FROM CY_M_PERSONELLER WITH (NOLOCK) WHERE UserTableID=@ID))))


SET @Sehir = (SELECT IL_ADI FROM MikroDB_V16_ÇİFTAY.dbo.ILLER_VIEW WITH (NOLOCK)
 LEFT OUTER JOIN CY_M_PERSONELLER AS P WITH (NOLOCK) ON IL_KODU_INT=P.Sehir
 WHERE P.UserTableID = @ID)

SET @Ilce = (SELECT IlceAdi FROM dbo.vw_Ilceler WITH (NOLOCK) 
 LEFT OUTER JOIN CY_M_PERSONELLER AS P WITH (NOLOCK) ON IlceKodu=P.Ilce
 WHERE P.UserTableID = @ID)

--SET @NufusIli = (SELECT IL_ADI FROM MikroDB_V16_ÇİFTAY.dbo.ILLER_VIEW WITH (NOLOCK)
-- LEFT OUTER JOIN CY_M_PERSONELLER AS P WITH (NOLOCK) ON IL_KODU_INT=P.NufusIli
-- WHERE P.UserTableID = @ID) 

--SET @NufusIlcesi = (SELECT IlceAdi FROM dbo.vw_Ilceler WITH (NOLOCK) 
-- LEFT OUTER JOIN CY_M_PERSONELLER AS P WITH (NOLOCK) ON IlceKodu=P.NufusIlcesi
-- WHERE P.UserTableID = @ID)


SET @SigortaGrubu = (SELECT SigortaGrubu FROM CY_M_PERSONELLER WITH (NOLOCK) WHERE UserTableID=@ID)
	IF @SigortaGrubu=1
	BEGIN
		SET @TabiKanun = 17
	END
	ELSE
	BEGIN
		SET @TabiKanun = 0
	END
	SET @BagliCariPerKod = (SELECT BagliCariKodu FROM CY_M_PERSONELLER WITH (NOLOCK) WHERE UserTableID=@ID)
SET @KimlikNo = (SELECT SUBSTRING(KimlikNo,1,11) FROM CY_M_PERSONELLER WITH (NOLOCK) WHERE UserTableID=@ID)
SET @CariPerKod = (SELECT CONVERT(INT,(SUBSTRING(KimlikNo,1,3) +SUBSTRING(KimlikNo,6,1)+SUBSTRING(KimlikNo,9,3))) FROM CY_M_PERSONELLER WITH (NOLOCK) WHERE UserTableID=@ID)

SET @CariFl = (SELECT ISNULL(COUNT(cari_per_kod),0) FROM  MikroDB_V16_ÇİFTAY.[dbo].[CARI_PERSONEL_TANIMLARI] WITH (NOLOCK) WHERE cari_per_kod LIKE @BagliCariPerKod)
IF @CariFl = 0
BEGIN
	EXEC dbo.sp_M_CariPersonelInsert @ID
END
INSERT INTO [MikroDB_V16_ÇİFTAY].[dbo].[PERSONELLER]
           ([per_Guid]
           ,[per_DBCno]
           ,[per_SpecRECno]
           ,[per_iptal]
           ,[per_fileid]
           ,[per_hidden]
           ,[per_kilitli]
           ,[per_degisti]
           ,[per_checksum]
           ,[per_create_user]
           ,[per_create_date]
           ,[per_lastup_user]
           ,[per_lastup_date]
           ,[per_special1]
           ,[per_special2]
           ,[per_special3]
           ,[per_kod]
           ,[per_adi]
           ,[per_soyadi]
           ,[per_orjdildeadisoyadi]
           ,[per_sicil_no]
           ,[per_firma_no]
           ,[per_sube_no]
           ,[per_caripers_kodu]
           ,[per_tip]
           ,[per_dept_kod]
           ,[per_is_grup]
           ,[per_giris_tar]
           ,[per_cikis_tar]
           ,[per_cikis_neden]
           ,[per_muh_kod]
           ,[per_kim_tahsil]
           ,[per_kim_meslek]
           ,[per_kim_gorev]
           ,[per_kim_sakat_derece]
           ,[per_kim_gocmen]
           ,[per_kim_gorev_kod]
           ,[per_kim_SGK_kod]
           ,[per_kim_cocuk]
           ,[per_kim_okuloncesi]
           ,[per_kim_ilkokul]
           ,[per_kim_ortaokul]
           ,[per_kim_lise]
           ,[per_kim_yuksek]
           ,[per_nuf_uyruk]
           ,[per_nuf_cinsiyet]
           ,[per_nuf_medeni_hal]
           ,[per_nuf_din]
           ,[per_nuf_dogum_tarih]
           ,[per_nuf_dogum_yer]
           ,[per_nuf_kangrup]
           ,[per_nuf_seri_no]
           ,[per_nuf_il]
           ,[per_nuf_ilce]
           ,[per_nuf_mahalle]
           ,[per_nuf_koy]
           ,[per_nuf_ciltno]
           ,[per_nuf_sayfano]
           ,[per_nuf_kutukno]
           ,[per_nuf_ver_neden]
           ,[per_nuf_ver_yer]
           ,[per_nuf_ver_tarih]
           ,[per_nuf_cuz_kayitno]
           ,[per_ucr_tip]
           ,[per_ucret]
           ,[per_Brut_net]
           ,[per_ucr_send_durum]
           ,[per_ucr_send]
           ,[per_ucr_PSSK_sube]
           ,[per_ucr_hesapno]
           ,[per_ucr_sig_yuzde_gr]
           ,[per_ucr_bode_yapilma]
           ,[per_ucr_vdaire]
           ,[per_ucr_vkarneno]
           ,[per_ucr_vkarne_tarih]
           ,[per_ucr_konutfon]
           ,[per_ucr_onceod]
           ,[per_ozelavansorani]
           ,[per_yard_yol]
           ,[per_yard_yemek]
           ,[per_yard_yakacak]
           ,[per_yard_bayram]
           ,[per_yard_cocuk]
           ,[per_yard_aile]
           ,[per_yard_ozelindirim]
           ,[per_adr_cadde]
           ,[per_adr_mahalle]
           ,[per_adr_sokak]
           ,[per_adr_semt]
           ,[per_adr_apartman_no]
           ,[per_adr_daire_no]
           ,[per_adr_posta_kod]
           ,[per_adr_ilce]
           ,[per_adr_il]
           ,[per_adr_ulke]
           ,[per_adr_adres_kodu]
           ,[per_tel_ulke_kod]
           ,[per_tel_bolge_kod]
           ,[per_tel_no1]
           ,[per_tel_no2]
           ,[per_tel_faxno]
           ,[per_tel_cepno]
           ,[per_doviz_cinsi]
           ,[per_muh_grpkod]
           ,[per_muh_ozelc1]
           ,[per_muh_ozelc2]
           ,[per_muh_ozelc3]
           ,[per_muh_ozelc4]
           ,[per_muh_ozelc5]
           ,[per_muh_ozelc6]
           ,[per_muh_ozelc7]
           ,[per_muh_ozelc8]
           ,[per_muh_ozelc9]
           ,[per_muh_ozelc10]
           ,[per_muh_ozelc11]
           ,[per_muh_ozelc12]
           ,[per_muh_ozelc13]
           ,[per_muh_ozelc14]
           ,[per_muh_ozelc15]
           ,[per_muh_ozelc16]
           ,[per_muh_ozelc17]
           ,[per_muh_ozelc18]
           ,[per_muh_ozelc19]
           ,[per_muh_ozelc20]
           ,[per_muh_ozelc21]
           ,[per_muh_ozelc22]
           ,[per_muh_ozelc23]
           ,[per_muh_ozelc24]
           ,[per_old_ucret]
           ,[per_old_tarih]
           ,[per_maas_ikramiye]
           ,[per_ozel_not]
           ,[per_VkfKesOd_fl]
           ,[per_Kidem_Tarih]
           ,[per_iszlksig]
           ,[per_Calismatipi]
           ,[per_dil1]
           ,[per_dil2]
           ,[per_dil3]
           ,[per_dil4]
           ,[per_dil5]
           ,[per_dil6]
           ,[per_dil7]
           ,[per_dil8]
           ,[per_dil9]
           ,[per_dil10]
           ,[per_dil11]
           ,[per_dil12]
           ,[per_mevsim]
           ,[per_kapsam]
           ,[per_asgari_ucretli]
           ,[Per_PerCariCins1]
           ,[Per_PerCariCins2]
           ,[Per_PerCariCins3]
           ,[Per_PerCariCins4]
           ,[Per_PerCariCins5]
           ,[Per_PerCariCins6]
           ,[Per_PerCariCins7]
           ,[Per_PerCariCins8]
           ,[Per_PerCariCins9]
           ,[Per_PerCariCins10]
           ,[Per_PerCariCins11]
           ,[Per_PerCariCins12]
           ,[Per_PerCariCins13]
           ,[Per_PerCariCins14]
           ,[Per_PerCariCins15]
           ,[Per_PerCariCins16]
           ,[Per_PerCariCins17]
           ,[Per_PerCariCins18]
           ,[Per_PerCariCins19]
           ,[Per_PerCariCins20]
           ,[Per_PerCariCins21]
           ,[Per_PerCariCins22]
           ,[Per_PerCariCins23]
           ,[Per_PerCariCins24]
           ,[Per_PerCariCins_grupno1]
           ,[Per_PerCariCins_grupno2]
           ,[Per_PerCariCins_grupno3]
           ,[Per_PerCariCins_grupno4]
           ,[Per_PerCariCins_grupno5]
           ,[Per_PerCariCins_grupno6]
           ,[Per_PerCariCins_grupno7]
           ,[Per_PerCariCins_grupno8]
           ,[Per_PerCariCins_grupno9]
           ,[Per_PerCariCins_grupno10]
           ,[Per_PerCariCins_grupno11]
           ,[Per_PerCariCins_grupno12]
           ,[Per_PerCariCins_grupno13]
           ,[Per_PerCariCins_grupno14]
           ,[Per_PerCariCins_grupno15]
           ,[Per_PerCariCins_grupno16]
           ,[Per_PerCariCins_grupno17]
           ,[Per_PerCariCins_grupno18]
           ,[Per_PerCariCins_grupno19]
           ,[Per_PerCariCins_grupno20]
           ,[Per_PerCariCins_grupno21]
           ,[Per_PerCariCins_grupno22]
           ,[Per_PerCariCins_grupno23]
           ,[Per_PerCariCins_grupno24]
           ,[Per_TcKimlikNo]
           ,[Per_PersMailAddress]
           ,[Per_Aylik_calisma_saati]
           ,[Per_Muh_Grup_Kodu]
           ,[per_bolge_kodu]
           ,[per_okul_ad]
           ,[per_IdariAmirKodu]
           ,[per_TeknikAmirKodu]
           ,[per_CikisSebebiSecimli]
           ,[per_ilksoyad]
           ,[per_tabiioldugukanun]
           ,[per_semada_gosterme_fl]
           ,[per_Ehl_Bel_No]
           ,[per_Ehl_Bel_Tar]
           ,[per_Ehl_Sinif]
           ,[per_Ehl_Ver_Tar]
           ,[per_Ehl_Ver_Il]
           ,[per_Ehl_Ver_Ilce]
           ,[per_Ehl_Kart_No]
           ,[per_Pasaprot_No]
           ,[per_Pas_Alindigi_Tar]
           ,[per_Pas_Gec_Tar]
           ,[per_nuf_asker_cuzdan]
           ,[per_nuf_asker_bastarih]
           ,[per_nuf_asker_bittarih]
           ,[per_nuf_asker_durum]
           ,[per_Isy_KimlikNo]
           ,[per_calismaizni_no]
           ,[per_calismaizni_alindigi_tar]
           ,[per_calismaizni_gec_tar]
           ,[per_boyu]
           ,[per_kilo]
           ,[per_gomlek_bed]
           ,[per_pant_bed]
           ,[per_etek_bed]
           ,[per_ayak_no]
           ,[per_sapka_bed]
           ,[per_onluk_bed]
           ,[per_diger_bed1]
           ,[per_diger_bed2]
           ,[per_diger_bed3]
           ,[per_UserNo]
           ,[per_uye_dernek]
           ,[per_uye_dernek_sicil_no]
           ,[per_sinyority_uygulamasi_fl]
           ,[per_izinparasi_uygulamasi_fl]
           ,[per_YemekKarti_ID]
           ,[per_srmmrkbaglanti_tip]
           ,[per_srmmrkdaganah_kodu]
           ,[per_maas_banka]
           ,[per_calisma_kodu]
           ,[per_meslek_kodu]
           ,[per_servis_guzergahi]
           ,[per_vize_no]
           ,[per_vize_alindigi_tarih]
           ,[per_vize_tarihi]
           ,[per_sskbelge_turu]
           ,[per_agine_tabii]
           ,[per_ozur_5763_kont_dahili_fl]
           ,[per_yabanci_ulke]
           ,[per_sigortalilik_turu]
           ,[per_eski_sicil_no]
           ,[per_tabiioldugukanun2]
           ,[per_maaskiminhesabina]
           ,[per_maassistemikodu]
           ,[per_is_grup_kodu]
           ,[per_unvan_kodu]
           ,[per_raporlama_yapacagi_per_kod]
           ,[per_okul_kodu]
           ,[per_okul_bolum_kodu]
           ,[per_bolum_kodu]
           ,[per_alt_dept_kod]
           ,[per_kanun_gecerlilik_tarihi]
           ,[per_tabiioldugukanun3]
           ,[per_mezuniyetyili]
           ,[per_proje_kodu]
           ,[per_hazine_destegine_tabi_fl]
           ,[per_KEP_adresi]
           ,[per_sigara_fl]
           ,[per_otobes_fl]
           ,[per_otobes_sigorta]
           ,[per_otobes_orani]
           ,[per_otobes_hesap_no]
           ,[per_otobes_grup_sozlesme_no]
           ,[per_otobes_fon_tercihi]
           ,[per_otobes_giris]
           ,[per_otobes_ayrilis]
           ,[per_sosyal_linkedin]
           ,[per_sosyal_webadresi]
           ,[per_sosyal_youtube]
           ,[per_sosyal_twitter]
           ,[per_sosyal_facebook]
           ,[per_sosyal_google]
           ,[per_sosyal_pinterest]
           ,[per_sosyal_instagram]
           ,[per_sosyal_snapchat]
           ,[per_vergiden_muhaf_odenek1]
           ,[per_vergiden_muhaf_odenek2]
		   ,[per_engellilik_orani])
     SELECT
           @Guid--<per_Guid, uniqueidentifier,>
           ,0--<per_DBCno, smallint,>
           ,0--<per_SpecRECno, int,>
           ,0--<per_iptal, bit,>
           ,71--<per_fileid, smallint,>
           ,0--<per_hidden, bit,>
           ,0--<per_kilitli, bit,>
           ,0--<per_degisti, bit,>
           ,0--<per_checksum, int,>
           ,@UpdatePerKod--<per_create_user, smallint,>
           ,CreateDate--<per_create_date, datetime,>
           ,@UpdatePerKod--<per_lastup_user, smallint,>
           ,UpdateDate--<per_lastup_date, datetime,>
           ,'OCT'--<per_special1, nvarchar(4),>
           ,''--<per_special2, nvarchar(4),>
           ,''--<per_special3, nvarchar(4),>
           ,KimlikNo--<per_kod, nvarchar(25),>
           ,Adi--<per_adi, nvarchar(50),>
           ,Soyadi--<per_soyadi, nvarchar(50),>
           ,''--<per_orjdildeadisoyadi, nvarchar(80),>
           ,KimlikNo--<per_sicil_no, nvarchar(25),>
           ,0--<per_firma_no, int,>
           ,SubeNo--<per_sube_no, int,>
           ,@CariPerKod--<per_caripers_kodu, nvarchar(25),>
           ,0--<per_tip, tinyint,>
           ,Departman--<per_dept_kod, nvarchar(25),>
           ,CASE WHEN CalismaKodu=1 THEN 7 ELSE 1 END--<per_is_grup, tinyint,>
           ,GirisTarihi--<per_giris_tar, datetime,>
           ,CikisTarihi--<per_cikis_tar, datetime,>
           ,CikisAciklama--<per_cikis_neden, nvarchar(40),>
           ,''--<per_muh_kod, nvarchar(40),>
           ,Tahsili--<per_kim_tahsil, tinyint,>
           ,''--<per_kim_meslek, nvarchar(20),>
           ,Unvan--<per_kim_gorev, nvarchar(25),>
           ,SakatlikDerecesi--<per_kim_sakat_derece, tinyint,>
           ,0--<per_kim_gocmen, tinyint,>
           ,3--<per_kim_gorev_kod, tinyint,>
           ,0--<per_kim_SGK_kod, tinyint,>
           ,0--<per_kim_cocuk, tinyint,>
           ,0--<per_kim_okuloncesi, tinyint,>
           ,0--<per_kim_ilkokul, tinyint,>
           ,0--<per_kim_ortaokul, tinyint,>
           ,0--<per_kim_lise, tinyint,>
           ,0--<per_kim_yuksek, tinyint,>
           ,''--<per_nuf_uyruk, nvarchar(15),>
           ,Cinsiyet--<per_nuf_cinsiyet, tinyint,>
           ,MedeniHali--<per_nuf_medeni_hal, tinyint,>
           ,''--<per_nuf_din, nvarchar(15),>
           ,DogumTarihi--<per_nuf_dogum_tarih, datetime,>
           ,''--<per_nuf_dogum_yer, nvarchar(40),>
           ,KanGrubu--<per_nuf_kangrup, tinyint,>
           ,''--<per_nuf_seri_no, nvarchar(15),>
           ,''--@NufusIli--<per_nuf_il, nvarchar(20),>
           ,''--@NufusIlcesi--<per_nuf_ilce, nvarchar(20),>
           ,NufusMahallesi--<per_nuf_mahalle, nvarchar(20),>
           ,''--<per_nuf_koy, nvarchar(20),>
           ,''--<per_nuf_ciltno, nvarchar(10),>
           ,''--<per_nuf_sayfano, nvarchar(10),>
           ,''--<per_nuf_kutukno, nvarchar(10),>
           ,''--<per_nuf_ver_neden, nvarchar(20),>
           ,''--<per_nuf_ver_yer, nvarchar(20),>
           ,@DefaultTarih--<per_nuf_ver_tarih, datetime,>
           ,''--<per_nuf_cuz_kayitno, nvarchar(15),>
           ,0--UcretTipi--<per_ucr_tip, tinyint,>
           ,0--<per_ucret, float,>
           ,HesapTipi--<per_Brut_net, tinyint,>
           ,0--<per_ucr_send_durum, tinyint,>
           ,0--<per_ucr_send, tinyint,>
           ,SgkNo--<per_ucr_PSSK_sube, int,>
           ,HesapNo--<per_ucr_hesapno, nvarchar(30),>
           ,SigortaGrubu--<per_ucr_sig_yuzde_gr, tinyint,>
           ,0--<per_ucr_bode_yapilma, tinyint,>
           ,''--<per_ucr_vdaire, nvarchar(14),>
           ,''--<per_ucr_vkarneno, nvarchar(12),>
           ,@DefaultTarih--<per_ucr_vkarne_tarih, datetime,>
           ,0--<per_ucr_konutfon, tinyint,>
           ,0--<per_ucr_onceod, smallint,>
           ,0--<per_ozelavansorani, float,>
           ,0--<per_yard_yol, tinyint,>
           ,0--<per_yard_yemek, tinyint,>
           ,0--<per_yard_yakacak, tinyint,>
           ,0--<per_yard_bayram, tinyint,>
           ,0--<per_yard_cocuk, tinyint,>
           ,0--<per_yard_aile, tinyint,>
           ,1--<per_yard_ozelindirim, tinyint,>
           ,SUBSTRING(Adres,1,50)--<per_adr_cadde, nvarchar(50),>
           ,''--<per_adr_mahalle, nvarchar(50),>
           ,''--<per_adr_sokak, nvarchar(50),>
           ,''--<per_adr_semt, nvarchar(25),>
           ,''--<per_adr_apartman_no, nvarchar(10),>
           ,''--<per_adr_daire_no, nvarchar(10),>
           ,''--<per_adr_posta_kod, nvarchar(8),>
           ,@Ilce--<per_adr_ilce, nvarchar(50),>
           ,@Sehir--<per_adr_il, nvarchar(50),>
           ,''--<per_adr_ulke, nvarchar(50),>
           ,''--<per_adr_adres_kodu, nvarchar(10),>
           ,''--<per_tel_ulke_kod, nvarchar(5),>
           ,''--<per_tel_bolge_kod, nvarchar(5),>
           ,''--<per_tel_no1, nvarchar(10),>
           ,''--<per_tel_no2, nvarchar(10),>
           ,''--<per_tel_faxno, nvarchar(10),>
           ,Telefon--<per_tel_cepno, nvarchar(10),>
           ,0--<per_doviz_cinsi, tinyint,>
           ,EntegreGrubu--<per_muh_grpkod, nvarchar(25),>
           ,''--<per_muh_ozelc1, nvarchar(40),>
           ,''--<per_muh_ozelc2, nvarchar(40),>
           ,''--<per_muh_ozelc3, nvarchar(40),>
           ,''--<per_muh_ozelc4, nvarchar(40),>
           ,''--<per_muh_ozelc5, nvarchar(40),>
           ,''--<per_muh_ozelc6, nvarchar(40),>
           ,''--<per_muh_ozelc7, nvarchar(40),>
           ,''--<per_muh_ozelc8, nvarchar(40),>
           ,''--<per_muh_ozelc9, nvarchar(40),>
           ,''--<per_muh_ozelc10, nvarchar(40),>
           ,''--<per_muh_ozelc11, nvarchar(40),>
           ,''--<per_muh_ozelc12, nvarchar(40),>
           ,''--<per_muh_ozelc13, nvarchar(40),>
           ,''--<per_muh_ozelc14, nvarchar(40),>
           ,''--<per_muh_ozelc15, nvarchar(40),>
           ,''--<per_muh_ozelc16, nvarchar(40),>
           ,''--<per_muh_ozelc17, nvarchar(40),>
           ,''--<per_muh_ozelc18, nvarchar(40),>
           ,''--<per_muh_ozelc19, nvarchar(40),>
           ,''--<per_muh_ozelc20, nvarchar(40),>
           ,''--<per_muh_ozelc21, nvarchar(40),>
           ,''--<per_muh_ozelc22, nvarchar(40),>
           ,''--<per_muh_ozelc23, nvarchar(40),>
           ,''--<per_muh_ozelc24, nvarchar(40),>
           ,0--<per_old_ucret, float,>
           ,@DefaultTarih--<per_old_tarih, datetime,>
           ,0--<per_maas_ikramiye, tinyint,>
           ,Yaka--<per_ozel_not, nvarchar(12),>
           ,0--<per_VkfKesOd_fl, bit,>
           ,KidemTarihi--<per_Kidem_Tarih, datetime,>
           ,case when SigortaGrubu=0 then 1 else 0 end--<per_iszlksig, tinyint,>
           ,0--<per_Calismatipi, tinyint,>
           ,0--<per_dil1, bit,>
           ,0--<per_dil2, bit,>
           ,0--<per_dil3, bit,>
           ,0--<per_dil4, bit,>
           ,0--<per_dil5, bit,>
           ,0--<per_dil6, bit,>
           ,0--<per_dil7, bit,>
           ,0--<per_dil8, bit,>
           ,0--<per_dil9, bit,>
           ,0--<per_dil10, bit,>
           ,0--<per_dil11, bit,>
           ,0--<per_dil12, bit,>
           ,0--<per_mevsim, tinyint,>
           ,0--<per_kapsam, tinyint,>
           ,0--<per_asgari_ucretli, bit,>
           ,0--<Per_PerCariCins1, tinyint,>
           ,0--<Per_PerCariCins2, tinyint,>
           ,0--<Per_PerCariCins3, tinyint,>
           ,0--<Per_PerCariCins4, tinyint,>
           ,0--<Per_PerCariCins5, tinyint,>
           ,0--<Per_PerCariCins6, tinyint,>
           ,0--<Per_PerCariCins7, tinyint,>
           ,0--<Per_PerCariCins8, tinyint,>
           ,0--<Per_PerCariCins9, tinyint,>
           ,0--<Per_PerCariCins10, tinyint,>
           ,0--<Per_PerCariCins11, tinyint,>
           ,0--<Per_PerCariCins12, tinyint,>
           ,0--<Per_PerCariCins13, tinyint,>
           ,0--<Per_PerCariCins14, tinyint,>
           ,0--<Per_PerCariCins15, tinyint,>
           ,0--<Per_PerCariCins16, tinyint,>
           ,0--<Per_PerCariCins17, tinyint,>
           ,0--<Per_PerCariCins18, tinyint,>
           ,0--<Per_PerCariCins19, tinyint,>
           ,0--<Per_PerCariCins20, tinyint,>
           ,0--<Per_PerCariCins21, tinyint,>
           ,0--<Per_PerCariCins22, tinyint,>
           ,0--<Per_PerCariCins23, tinyint,>
           ,0--<Per_PerCariCins24, tinyint,>
           ,0--<Per_PerCariCins_grupno1, tinyint,>
           ,0--<Per_PerCariCins_grupno2, tinyint,>
           ,0--<Per_PerCariCins_grupno3, tinyint,>
           ,0--<Per_PerCariCins_grupno4, tinyint,>
           ,0--<Per_PerCariCins_grupno5, tinyint,>
           ,0--<Per_PerCariCins_grupno6, tinyint,>
           ,0--<Per_PerCariCins_grupno7, tinyint,>
           ,0--<Per_PerCariCins_grupno8, tinyint,>
           ,0--<Per_PerCariCins_grupno9, tinyint,>
           ,0--<Per_PerCariCins_grupno10, tinyint,>
           ,0--<Per_PerCariCins_grupno11, tinyint,>
           ,0--<Per_PerCariCins_grupno12, tinyint,>
           ,0--<Per_PerCariCins_grupno13, tinyint,>
           ,0--<Per_PerCariCins_grupno14, tinyint,>
           ,0--<Per_PerCariCins_grupno15, tinyint,>
           ,0--<Per_PerCariCins_grupno16, tinyint,>
           ,0--<Per_PerCariCins_grupno17, tinyint,>
           ,0--<Per_PerCariCins_grupno18, tinyint,>
           ,0--<Per_PerCariCins_grupno19, tinyint,>
           ,0--<Per_PerCariCins_grupno20, tinyint,>
           ,0--<Per_PerCariCins_grupno21, tinyint,>
           ,0--<Per_PerCariCins_grupno22, tinyint,>
           ,0--<Per_PerCariCins_grupno23, tinyint,>
           ,0--<Per_PerCariCins_grupno24, tinyint,>
           ,@KimlikNo--<Per_TcKimlikNo, nvarchar(11),>
           ,Eposta--<Per_PersMailAddress, nvarchar(50),>
           ,0--<Per_Aylik_calisma_saati, float,>
           ,'MUHSGK'--<Per_Muh_Grup_Kodu, nvarchar(25),>
           ,BolgeKodu--<per_bolge_kodu, nvarchar(25),>
           ,''--<per_okul_ad, nvarchar(40),>
           ,''--<per_IdariAmirKodu, nvarchar(25),>
           ,''--<per_TeknikAmirKodu, nvarchar(25),>
           ,CikisSebebi--<per_CikisSebebiSecimli, tinyint,>
           ,''--<per_ilksoyad, nvarchar(25),>
           ,@TabiKanun--<per_tabiioldugukanun, tinyint,>
           ,0--<per_semada_gosterme_fl, bit,>
           ,''--<per_Ehl_Bel_No, nvarchar(20),>
           ,@DefaultTarih--<per_Ehl_Bel_Tar, datetime,>
           ,''--<per_Ehl_Sinif, nvarchar(10),>
           ,@DefaultTarih--<per_Ehl_Ver_Tar, datetime,>
           ,''--<per_Ehl_Ver_Il, nvarchar(25),>
           ,''--<per_Ehl_Ver_Ilce, nvarchar(25),>
           ,''--<per_Ehl_Kart_No, nvarchar(20),>
           ,''--<per_Pasaprot_No, nvarchar(20),>
           ,@DefaultTarih--<per_Pas_Alindigi_Tar, datetime,>
           ,@DefaultTarih--<per_Pas_Gec_Tar, datetime,>
           ,''--<per_nuf_asker_cuzdan, nvarchar(20),>
           ,@DefaultTarih--<per_nuf_asker_bastarih, datetime,>
           ,@DefaultTarih--<per_nuf_asker_bittarih, datetime,>
           ,0--<per_nuf_asker_durum, tinyint,>
           ,''--<per_Isy_KimlikNo, nvarchar(20),>
           ,''--<per_calismaizni_no, nvarchar(20),>
           ,@DefaultTarih--<per_calismaizni_alindigi_tar, datetime,>
           ,@DefaultTarih--<per_calismaizni_gec_tar, datetime,>
           ,0--<per_boyu, float,>
           ,0--<per_kilo, float,>
           ,''--<per_gomlek_bed, nvarchar(10),>
           ,''--<per_pant_bed, nvarchar(10),>
           ,''--<per_etek_bed, nvarchar(10),>
           ,''--<per_ayak_no, nvarchar(10),>
           ,''--<per_sapka_bed, nvarchar(10),>
           ,''--<per_onluk_bed, nvarchar(10),>
           ,''--<per_diger_bed1, nvarchar(10),>
           ,''--<per_diger_bed2, nvarchar(10),>
           ,''--<per_diger_bed3, nvarchar(10),>
           ,0--<per_UserNo, int,>
           ,''--<per_uye_dernek, nvarchar(50),>
           ,''--<per_uye_dernek_sicil_no, nvarchar(25),>
           ,0--<per_sinyority_uygulamasi_fl, bit,>
           ,0--<per_izinparasi_uygulamasi_fl, bit,>
           ,''--<per_YemekKarti_ID, nvarchar(30),>
           ,1--<per_srmmrkbaglanti_tip, tinyint,>
           ,SrmMerkezi--<per_srmmrkdaganah_kodu, nvarchar(25),>
           ,BankaFormati--<per_maas_banka, tinyint,>
           ,CalismaKodu--<per_calisma_kodu, nvarchar(25),>
           ,MeslekKodu--<per_meslek_kodu, nvarchar(25),>
           ,''--<per_servis_guzergahi, nvarchar(60),>
           ,''--<per_vize_no, nvarchar(25),>
           ,@DefaultTarih--<per_vize_alindigi_tarih, datetime,>
           ,@DefaultTarih--<per_vize_tarihi, datetime,>
           ,BagliBelgeTuru--<per_sskbelge_turu, tinyint,>
           ,0--<per_agine_tabii, tinyint,>
           ,0--<per_ozur_5763_kont_dahili_fl, bit,>
           ,''--<per_yabanci_ulke, nvarchar(30),>
           ,0--<per_sigortalilik_turu, tinyint,>
           ,''--<per_eski_sicil_no, nvarchar(25),>
           ,0--<per_tabiioldugukanun2, tinyint,>
           ,0--<per_maaskiminhesabina, tinyint,>
           ,''--<per_maassistemikodu, nvarchar(25),>
           ,MerkezProje--<per_is_grup_kodu, nvarchar(25),>
           ,''--<per_unvan_kodu, nvarchar(25),>
           ,''--<per_raporlama_yapacagi_per_kod, nvarchar(25),>
           ,''--<per_okul_kodu, nvarchar(25),>
           ,''--<per_okul_bolum_kodu, nvarchar(25),>
           ,Direktorluk--<per_bolum_kodu, nvarchar(25),>
           ,''--<per_alt_dept_kod, nvarchar(25),>
           ,@DefaultTarih--<per_kanun_gecerlilik_tarihi, datetime,>
           ,0--<per_tabiioldugukanun3, tinyint,>
           ,0--<per_mezuniyetyili, smallint,>
           ,''--<per_proje_kodu, nvarchar(25),>
           ,0--<per_hazine_destegine_tabi_fl, bit,>
           ,''--<per_KEP_adresi, nvarchar(80),>
           ,0--<per_sigara_fl, bit,>
           ,CASE WHEN (CASE WHEN MONTH(GETDATE())-MONTH(DogumTarihi)<0 THEN YEAR(GETDATE())-YEAR(DogumTarihi)-1 ELSE YEAR(GETDATE())-YEAR(DogumTarihi) END)>=45 THEN 0 ELSE 1 END--<per_otobes_fl, bit,>
           ,4--<per_otobes_sigorta, tinyint,>
           ,0--<per_otobes_orani, float,>
           ,''--<per_otobes_hesap_no, nvarchar(30),>
           ,'2332846'--<per_otobes_grup_sozlesme_no, nvarchar(25),>
           ,0--<per_otobes_fon_tercihi, tinyint,>
           ,@DefaultTarih--<per_otobes_giris, datetime,>
           ,@DefaultTarih--<per_otobes_ayrilis, datetime,>
           ,''--<per_sosyal_linkedin, nvarchar(50),>
           ,''--<per_sosyal_webadresi, nvarchar(50),>
           ,''--<per_sosyal_youtube, nvarchar(50),>
           ,''--<per_sosyal_twitter, nvarchar(50),>
           ,''--<per_sosyal_facebook, nvarchar(50),>
           ,''--<per_sosyal_google, nvarchar(50),>
           ,''--<per_sosyal_pinterest, nvarchar(50),>
           ,''--<per_sosyal_instagram, nvarchar(50),>
           ,''--<per_sosyal_snapchat, nvarchar(50),>
           ,0--<per_vergiden_muhaf_odenek1, float,>
           ,0--<per_vergiden_muhaf_odenek2, float,>
		   ,EngellilikYuzdesi
	FROM CY_M_PERSONELLER WITH (NOLOCK) WHERE UserTableID = @ID

--personel BES tanımları
	INSERT INTO [dbo].[CY_M_BES_TANIMLARI]
           ([CreateDate]
           ,[CreateUser]
           ,[UpdateDate]
           ,[UpdateUser]
           ,[IntegrationID]
           ,[ProjectID]
           ,[FormTypeID]
           ,[LineNumber]
           ,[RecordGuid]
           ,[Personel]
           ,[OtobesGrupSozlesmeNo]
           ,[OtobesSigorta]
           ,[BESfl]
           ,[BESOrani]
           ,[TabiOlduguKanun])
     SELECT
           CreateDate--<CreateDate, datetime,>
           ,CreateUser--<CreateUser, int,>
           ,UpdateDate--<UpdateDate, datetime,>
           ,UpdateUser--<UpdateUser, int,>
           ,0--<IntegrationID, int,>
           ,30--,<ProjectID, int,>
           ,2200--,<FormTypeID, int,>
           ,0--<LineNumber, int,>
           ,NEWID()--<RecordGuid, nvarchar(100),>
           ,KimlikNo--<Personel, nvarchar(50),>
           ,'2332846'--<OtobesGrupSozlesmeNo, nvarchar(50),>
           ,4--<OtobesSigorta, float,>
           ,CASE WHEN (CASE WHEN MONTH(GETDATE())-MONTH(DogumTarihi)<0 THEN YEAR(GETDATE())-YEAR(DogumTarihi)-1 ELSE YEAR(GETDATE())-YEAR(DogumTarihi) END)>=45 THEN 0 ELSE 1 END--<BESfl, nvarchar(50),>
           ,0--<BESOrani, float,>
           ,@TabiKanun --<TabiOlduguKanun, nvarchar(50),>)
		   FROM CY_M_PERSONELLER WITH(NOLOCK) WHERE UserTableID = @ID

		   --personel ücret tanımları

		   INSERT INTO [dbo].[CY_M_UCRET_TANIMLARI]
           ([CreateDate]
           ,[CreateUser]
           ,[UpdateDate]
           ,[UpdateUser]
           ,[IntegrationID]
           ,[ProjectID]
           ,[FormTypeID]
           ,[LineNumber]
           ,[RecordGuid]
           ,[Personel]
           ,[UcretTipi]
           ,[Ucret]
           ,[YemekYardimi])
     SELECT
            CreateDate--<CreateDate, datetime,>
           ,CreateUser--<CreateUser, int,>
           ,UpdateDate--<UpdateDate, datetime,>
           ,UpdateUser--<UpdateUser, int,>
           ,0--<IntegrationID, int,>
           ,30--<ProjectID, int,>
           ,2192--<FormTypeID, int,>
           ,0--<LineNumber, int,>
           ,NEWID()--<RecordGuid, nvarchar(100),>
           ,KimlikNo--<Personel, nvarchar(50),>
           ,1--<UcretTipi, nvarchar(50),>
           ,0--<Ucret, float,>
           ,0--<YemekYardimi, nvarchar(50),>
		    FROM CY_M_PERSONELLER WITH(NOLOCK) WHERE UserTableID = @ID


--personel aile tanımları
--EXEC [dbo].[sp_M_MikroPersonelAile] @ID

--meyer insert prosedürü
--EXEC [dbo].[sp_M_MeyerSicilInsert] @ID
	
END


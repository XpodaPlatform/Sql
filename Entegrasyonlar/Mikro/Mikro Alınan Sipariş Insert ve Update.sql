ALTER PROCEDURE [dbo].[sp_XP_MCM_AlinanSiparisInsert_V2]
(
@UserTableID INT
)
AS
BEGIN


DECLARE 
@ActiveUser INT= (Select CreateUser From MCM_ALINAN_SIPARISLER_FORMU WITH (NOLOCK) WHERE UserTableID=@UserTableID),
@SozlesmeFl BIT ,
@GunSayisi INT,
@Proje NVARCHAR(50),
@DefaultTarih DATETIME =CONVERT(DATETIME,'1899-12-30 00:00:00.000'),
@DefaultGuid NVARCHAR(100)='00000000-0000-0000-0000-000000000000',
@EvrakSeri NVARCHAR(20) = 'MCM'+substring(convert(nvarchar,datepart(year,getdate())),3,2),
@XPDevrakSonSira INT,
@OdemePlanNo INT,
@OnaylayanKullanici INT = 99	--gökhan
SET @OdemePlanNo = 951--(Select top 1 MikroOdemePlanNo From MCM_VADE_TANITIM_KARTI_V2 WITH (NOLOCK) WHERE EvrakNo= (Select EvrakNo From MCM_ALINAN_SIPARISLER_FORMU WITH (NOLOCK) WHERE UserTableID = @UserTableID))


SELECT @SozlesmeFl = CASE WHEN SozlesmeGunSayisi > 0 THEN 'True' ELSE 'False' END, @GunSayisi = SozlesmeGunSayisi ,@Proje = Proje FROM MCM_ALINAN_SIPARISLER_FORMU WITH (NOLOCK) WHERE UserTableID=@UserTableID

IF @SozlesmeFl='True'
BEGIN
	IF EXISTS (SELECT * FROM MCM_PROJE_SOZLESME_SAYILARI WITH(NOLOCK) WHERE Proje = @Proje)
	BEGIN
		UPDATE MCM_PROJE_SOZLESME_SAYILARI SET UpdateDate=GETDATE(),GunSayisi=@GunSayisi WHERE Proje = @Proje
	END
	ELSE
	BEGIN
		INSERT INTO MCM_PROJE_SOZLESME_SAYILARI (CreateDate,CreateUser,UpdateDate,UpdateUser,IntegrationID,ProjectID,FormTypeID,LineNumber,RecordGuid,Proje,GunSayisi) VALUES (GETDATE(),@ActiveUser,GETDATE(),@ActiveUser,0,110,503,0,NEWID(),@Proje,@GunSayisi)
	END
END


--DAHA ÖNCE ONAYA GÖNDERİLMEMİŞSE INSERT
IF EXISTS(SELECT * FROM MCM_ALINAN_SIPARISLER_FORMU WITH (NOLOCK) WHERE UserTableID=@UserTableID and MikroSiparisNo='')
BEGIN



set @XPDevrakSonSira = (select ISNULL(MAX(sip_evrakno_sira),0)+1 from MikroDB_V16_MCM.dbo.SIPARISLER WITH (NOLOCK) where sip_evrakno_seri = @EvrakSeri )

INSERT INTO MikroDB_V16_MCM.[dbo].[SIPARISLER]
           ([sip_Guid]
           ,[sip_DBCno]
           ,[sip_SpecRECno]
           ,[sip_iptal]
           ,[sip_fileid]
           ,[sip_hidden]
           ,[sip_kilitli]
           ,[sip_degisti]
           ,[sip_checksum]
           ,[sip_create_user]
           ,[sip_create_date]
           ,[sip_lastup_user]
           ,[sip_lastup_date]
           ,[sip_special1]
           ,[sip_special2]
           ,[sip_special3]
           ,[sip_firmano]
           ,[sip_subeno]
           ,[sip_tarih]
           ,[sip_teslim_tarih]
           ,[sip_tip]
           ,[sip_cins]
           ,[sip_evrakno_seri]
           ,[sip_evrakno_sira]
           ,[sip_satirno]
           ,[sip_belgeno]
           ,[sip_belge_tarih]
           ,[sip_satici_kod]
           ,[sip_musteri_kod]
           ,[sip_stok_kod]
           ,[sip_b_fiyat]
           ,[sip_miktar]
           ,[sip_birim_pntr]
           ,[sip_teslim_miktar]
           ,[sip_tutar]
           ,[sip_iskonto_1]
           ,[sip_iskonto_2]
           ,[sip_iskonto_3]
           ,[sip_iskonto_4]
           ,[sip_iskonto_5]
           ,[sip_iskonto_6]
           ,[sip_masraf_1]
           ,[sip_masraf_2]
           ,[sip_masraf_3]
           ,[sip_masraf_4]
           ,[sip_vergi_pntr]
           ,[sip_vergi]
           ,[sip_masvergi_pntr]
           ,[sip_masvergi]
           ,[sip_opno]
           ,[sip_aciklama]
           ,[sip_aciklama2]
           ,[sip_depono]
           ,[sip_OnaylayanKulNo]
           ,[sip_vergisiz_fl]
           ,[sip_kapat_fl]
           ,[sip_promosyon_fl]
           ,[sip_cari_sormerk]
           ,[sip_stok_sormerk]
           ,[sip_cari_grupno]
           ,[sip_doviz_cinsi]
           ,[sip_doviz_kuru]
           ,[sip_alt_doviz_kuru]
           ,[sip_adresno]
           ,[sip_teslimturu]
           ,[sip_cagrilabilir_fl]
           ,[sip_prosip_uid]
           ,[sip_iskonto1]
           ,[sip_iskonto2]
           ,[sip_iskonto3]
           ,[sip_iskonto4]
           ,[sip_iskonto5]
           ,[sip_iskonto6]
           ,[sip_masraf1]
           ,[sip_masraf2]
           ,[sip_masraf3]
           ,[sip_masraf4]
           ,[sip_isk1]
           ,[sip_isk2]
           ,[sip_isk3]
           ,[sip_isk4]
           ,[sip_isk5]
           ,[sip_isk6]
           ,[sip_mas1]
           ,[sip_mas2]
           ,[sip_mas3]
           ,[sip_mas4]
           ,[sip_Exp_Imp_Kodu]
           ,[sip_kar_orani]
           ,[sip_durumu]
           ,[sip_stal_uid]
           ,[sip_planlananmiktar]
           ,[sip_teklif_uid]
           ,[sip_parti_kodu]
           ,[sip_lot_no]
           ,[sip_projekodu]
           ,[sip_fiyat_liste_no]
           ,[sip_Otv_Pntr]
           ,[sip_Otv_Vergi]
           ,[sip_otvtutari]
           ,[sip_OtvVergisiz_Fl]
           ,[sip_paket_kod]
           ,[sip_Rez_uid]
           ,[sip_harekettipi]
           ,[sip_yetkili_uid]
           ,[sip_kapatmanedenkod]
           ,[sip_gecerlilik_tarihi]
           ,[sip_onodeme_evrak_tip]
           ,[sip_onodeme_evrak_seri]
           ,[sip_onodeme_evrak_sira]
           ,[sip_rezervasyon_miktari]
           ,[sip_rezerveden_teslim_edilen]
           ,[sip_HareketGrupKodu1]
           ,[sip_HareketGrupKodu2]
           ,[sip_HareketGrupKodu3]
           ,[sip_Olcu1]
           ,[sip_Olcu2]
           ,[sip_Olcu3]
           ,[sip_Olcu4]
           ,[sip_Olcu5]
           ,[sip_FormulMiktarNo]
           ,[sip_FormulMiktar])
     SELECT
           NEWID()--(<sip_Guid, uniqueidentifier,>
           ,0--<sip_DBCno, smallint,>
           ,D.UserTableID--<sip_SpecRECno, int,>/*MCM_ALINAN_SIPARISLER_FORMU*/
           ,0--<sip_iptal, bit,>
           ,21--<sip_fileid, smallint,>
           ,0--<sip_hidden, bit,>
           ,0--<sip_kilitli, bit,>
           ,0--<sip_degisti, bit,>
           ,0--<sip_checksum, int,>
           ,@OnaylayanKullanici--P.MikroUserID-- [dbo].[MikroKullaniciNo](P.MikroPersonelKodu)--<sip_create_user, smallint,>
           ,GETDATE()--<sip_create_date, datetime,>
           ,@OnaylayanKullanici--P.MikroUserID-- [dbo].[MikroKullaniciNo](P.MikroPersonelKodu)--<sip_lastup_user, smallint,>
           ,GETDATE()--<sip_lastup_date, datetime,>
           ,'XPD'--<sip_special1, nvarchar(4),>
           ,D.CreateUser--<sip_special2, nvarchar(4),>
           ,''--<sip_special3, nvarchar(4),>
           ,SF.Firma--CASE WHEN SF.Firma=1 THEN 0 WHEN SF.Firma=2 THEN 2 WHEN SF.Firma=3 THEN 1 ELSE 0 END--<sip_firmano, int,>
           ,0--<sip_subeno, int,>
           ,Convert( DATE,GETDATE())--<sip_tarih, datetime,>
           ,D.TeslimTarihi--<sip_teslim_tarih, datetime,>
           ,0--<sip_tip, tinyint,>
           ,0--<sip_cins, tinyint,>
           ,@EvrakSeri--<sip_evrakno_seri, [dbo].[evrakseri_str],>
           ,@XPDevrakSonSira--<sip_evrakno_sira, int,>
           ,ROW_NUMBER() OVER(ORDER BY D.UserTableID)-1--<sip_satirno, int,>
           ,''--<sip_belgeno, [dbo].[belgeno_str],>
           ,GETDATE()--<sip_belge_tarih, datetime,>
           ,SF.Satici--<sip_satici_kod, nvarchar(25),>
           ,SF.Cari--<sip_musteri_kod, nvarchar(25),>
           ,D.Stok--<sip_stok_kod, nvarchar(25),>
           ,D.BirimFiyat--<sip_b_fiyat, float,>
           ,D.Miktar--<sip_miktar, float,>
           ,1--<sip_birim_pntr, tinyint,>
           ,0--<sip_teslim_miktar, float,>
		   ,D.BirimFiyat* D.Miktar --<sip_tutar, float,>
           --,D.Tutar--<sip_tutar, float,>
           --,(D.Tutar*SF.Iskonto)/100--<sip_iskonto_1, float,>
		   , CASE WHEN 
		   ((D.BirimFiyat*D.Miktar*D.Iskonto)/100) 
				+ ((((D.BirimFiyat*D.Miktar)- ((D.BirimFiyat*D.Miktar*D.Iskonto)/100))*DipIskonto)/100) 

				>  (D.BirimFiyat* D.Miktar) 
					THEN (D.BirimFiyat* D.Miktar)
					ELSE ((D.BirimFiyat*D.Miktar*D.Iskonto)/100) 
						+ ((((D.BirimFiyat*D.Miktar)- ((D.BirimFiyat*D.Miktar*D.Iskonto)/100))*DipIskonto)/100) 
						END --<sip_iskonto_1, float,>
		 --  ,((D.BirimFiyat*D.Miktar*D.Iskonto)/100 - (DipIskonto/100)--<sip_iskonto_1, float,>
           ,0--<sip_iskonto_2, float,>
           ,0--<sip_iskonto_3, float,>
           ,0--<sip_iskonto_4, float,>
           ,0--<sip_iskonto_5, float,>
           ,0--<sip_iskonto_6, float,>
           ,0--<sip_masraf_1, float,>
           ,0--<sip_masraf_2, float,>
           ,0--<sip_masraf_3, float,>
           ,0--<sip_masraf_4, float,>
           ,SF.KDV--<sip_vergi_pntr, tinyint,>

		   ,(((D.BirimFiyat*D.Miktar) - CASE WHEN 
		   ((D.BirimFiyat*D.Miktar*D.Iskonto)/100) 
				+ ((((D.BirimFiyat*D.Miktar)- ((D.BirimFiyat*D.Miktar*D.Iskonto)/100))*DipIskonto)/100) 

				>  (D.BirimFiyat* D.Miktar) 
					THEN (D.BirimFiyat* D.Miktar)
					ELSE ((D.BirimFiyat*D.Miktar*D.Iskonto)/100) 
						+ ((((D.BirimFiyat*D.Miktar)- ((D.BirimFiyat*D.Miktar*D.Iskonto)/100))*DipIskonto)/100) 
						END)*V.Tipi)/100--<sip_vergi, float,>	Tutar - iskonto * 

           --,(D.Tutar*V.Tipi)/100--<sip_vergi, float,>
           ,0--<sip_masvergi_pntr, tinyint,>
           ,0--<sip_masvergi, float,>
           ,@OdemePlanNo--<sip_opno, int,>
           ,''--<sip_aciklama, nvarchar(50),>
           ,''--<sip_aciklama2, nvarchar(50),>
           ,SF.Depo--<sip_depono, int,>
           ,@OnaylayanKullanici--<sip_OnaylayanKulNo, smallint,>
           ,0--<sip_vergisiz_fl, bit,>
           ,0--<sip_kapat_fl, bit,>
           ,0--<sip_promosyon_fl, bit,>
           ,SF.SorumlulukMerkezi--<sip_cari_sormerk, nvarchar(25),>
           ,SF.SorumlulukMerkezi--<sip_stok_sormerk, nvarchar(25),>
           ,SF.CariDovizGrup--<sip_cari_grupno, tinyint,>
           ,D.DetayDoviz--<sip_doviz_cinsi, tinyint,>
           ,MikroDB_V16_MCM.dbo.fn_KurBul(SF.CreateDate,D.DetayDoviz,1)--<sip_doviz_kuru, float,>
           ,MikroDB_V16_MCM.dbo.fn_KurBul(SF.CreateDate,1,1)--<sip_alt_doviz_kuru, float,>**USD**
           ,1--<sip_adresno, int,>
           ,''--<sip_teslimturu, nvarchar(4),>
           ,1--<sip_cagrilabilir_fl, bit,>
           ,@DefaultGuid--<sip_prosip_uid, uniqueidentifier,>
           ,0--<sip_iskonto1, tinyint,>
           ,1--<sip_iskonto2, tinyint,>
           ,1--<sip_iskonto3, tinyint,>
           ,1--<sip_iskonto4, tinyint,>
           ,1--<sip_iskonto5, tinyint,>
           ,1--<sip_iskonto6, tinyint,>
           ,1--<sip_masraf1, tinyint,>
           ,1--<sip_masraf2, tinyint,>
           ,1--<sip_masraf3, tinyint,>
           ,1--<sip_masraf4, tinyint,>
           ,0--<sip_isk1, bit,>
           ,0--<sip_isk2, bit,>
           ,0--<sip_isk3, bit,>
           ,0--<sip_isk4, bit,>
           ,0--<sip_isk5, bit,>
           ,0--<sip_isk6, bit,>
           ,0--<sip_mas1, bit,>
           ,0--<sip_mas2, bit,>
           ,0--<sip_mas3, bit,>
           ,0--<sip_mas4, bit,>
           ,''--<sip_Exp_Imp_Kodu, nvarchar(25),>
           ,0--<sip_kar_orani, float,>
           ,0--<sip_durumu, tinyint,>
           ,@DefaultGuid--<sip_stal_uid, uniqueidentifier,>
           ,0--<sip_planlananmiktar, float,>
           ,@DefaultGuid--<sip_teklif_uid, uniqueidentifier,>
           ,''--<sip_parti_kodu, nvarchar(25),>
           ,0--<sip_lot_no, int,>
           ,SF.Proje--<sip_projekodu, nvarchar(25),>
           ,0--<sip_fiyat_liste_no, int,>
           ,0--<sip_Otv_Pntr, tinyint,>
           ,0--<sip_Otv_Vergi, float,>
           ,0--<sip_otvtutari, float,>
           ,0--<sip_OtvVergisiz_Fl, tinyint,>
           ,''--<sip_paket_kod, nvarchar(25),>
           ,@DefaultGuid--<sip_Rez_uid, uniqueidentifier,>
           ,D.Cinsi--<sip_harekettipi, tinyint,>
           ,@DefaultGuid--<sip_yetkili_uid, uniqueidentifier,>
           ,''--<sip_kapatmanedenkod, nvarchar(25),>
           ,@DefaultTarih--<sip_gecerlilik_tarihi, datetime,>
           ,0--<sip_onodeme_evrak_tip, tinyint,>
           ,''--<sip_onodeme_evrak_seri, [dbo].[evrakseri_str],>
           ,0--<sip_onodeme_evrak_sira, int,>
           ,0--<sip_rezervasyon_miktari, float,>
           ,0--<sip_rezerveden_teslim_edilen, float,>
           ,SF.Marka--<sip_HareketGrupKodu1, nvarchar(25),>
           ,''--<sip_HareketGrupKodu2, nvarchar(25),>
           ,CASE WHEN SF.IhracKayitli IN ('','1') THEN 'NORMAL' ELSE 'IHRAC KAYITLI' END--<sip_HareketGrupKodu3, nvarchar(25),>
           ,0--<sip_Olcu1, float,>
           ,0--<sip_Olcu2, float,>
           ,0--<sip_Olcu3, float,>
           ,0--<sip_Olcu4, float,>
           ,0--<sip_Olcu5, float,>
           ,0--<sip_FormulMiktarNo, tinyint,>
           ,0--<sip_FormulMiktar, float,>)
		   
		FROM MCM_ALINAN_SIPARISLER_FORMU SF WITH (NOLOCK)
		LEFT JOIN MCM_ALINAN_SIPARISLER_FORMU_DETAIL D WITH (NOLOCK) ON D.MasterID = SF.UserTableID
		LEFT JOIN MCM_PERSONEL_TANITIM_KARTI P WITH (NOLOCK) ON P.XPUserID = @ActiveUser
		LEFT JOIN  [dbo].[vw_Vergi] V WITH (NOLOCK) ON V.ID = SF.KDV
		WHERE SF.UserTableID = @UserTableID

	--UPDATE EVRAK SIRA NO 
	UPDATE MCM_ALINAN_SIPARISLER_FORMU SET MikroSiparisNo = Convert(nvarchar,@XPDevrakSonSira) WHERE UserTableID = @UserTableID

	UPDATE MCM_ALINAN_SIPARISLER_FORMU_DETAIL SET IntegrationID = Convert(nvarchar(50),sip_Guid)
	
	FROM [MikroDB_V16_MCM].[dbo].[SIPARISLER] WITH (NOLOCK)
	LEFT JOIN MCM_ALINAN_SIPARISLER_FORMU_DETAIL D WITH (NOLOCK) ON sip_evrakno_seri = @EvrakSeri AND sip_evrakno_sira = @XPDevrakSonSira AND sip_SpecRECno = D.UserTableID

	where D.MasterID = @UserTableID

END
ELSE  -- DAHA ÖNCE ONAYA GÖNDERİLMİŞSE UPDATE. EĞER SİLİNEN KALEM VARSA DELETE. YENI EKLENEN KALEM VARSA INSERT
BEGIN
	
	DECLARE @MikroSiparisNo INT = (SELECT MikroSiparisNo FROM MCM_ALINAN_SIPARISLER_FORMU WITH (NOLOCK) WHERE UserTableID=@UserTableID)

	SET @EvrakSeri = (SELECT TOP 1 'MCM'+substring(convert(nvarchar,datepart(year,FlowEndDateTime)),3,2) FROM MCM_ALINAN_SIPARISLER_FORMU WITH (NOLOCK) LEFT JOIN XPODA_WORK_FLOWS WITH (NOLOCK) ON FlowDocumentID = UserTableID AND FlowProjectID = ProjectID WHERE UserTableID=@UserTableID AND FlowProses = 'a26' ORDER BY FlowID DESC)

	IF @EvrakSeri IS NULL SET @EvrakSeri='MCM'+substring(convert(nvarchar,datepart(year,GETDATE())),3,2)


	DECLARE @DetayUserTableIDs NVARCHAR(max)='',
			@SatirNo INT = 0

	SELECT @DetayUserTableIDs += CONVERT(NVARCHAR,UserTableID) + ',' FROM MCM_ALINAN_SIPARISLER_FORMU_DETAIL WITH (NOLOCK) WHERE MasterID = @UserTableID

	SET @SatirNo = (Select ISNULL(MAX(sip_satirno),0)+1 From MikroDB_V16_MCM.dbo.SIPARISLER WITH (NOLOCK) WHERE sip_evrakno_seri = @EvrakSeri AND sip_evrakno_sira = @MikroSiparisNo)

	--silinen sipariş proje gorevlerde kaydı varsa güncellenecek
	UPDATE XP_PROJE_GOREVLER SET UpdateDate=GETDATE(),UpdateUser=@ActiveUser,KapatFl='True',KapamaNedeni='Alınan Sipariş Red' WHERE SiparisID IN (SELECT sip_Guid FROM MikroDB_V16_MCM.dbo.SIPARISLER WHERE sip_evrakno_seri = @EvrakSeri AND sip_evrakno_sira = @MikroSiparisNo AND sip_SpecRECno NOT IN (Select items From dbo.Ayrac(@DetayUserTableIDs,',')) ) 

	--AYNI SERİ, SIRA VE sip_SpecRECno OLMAYAN KAYITLARI SİL (EĞER DETAYDAN KALDIRILDIYSA)
	DELETE MikroDB_V16_MCM.dbo.SIPARISLER WHERE sip_evrakno_seri = @EvrakSeri AND sip_evrakno_sira = @MikroSiparisNo AND sip_SpecRECno NOT IN (Select items From dbo.Ayrac(@DetayUserTableIDs,','))

	--EVRAK SERI VE SIRADA SIPARIS KAPALI İSE AÇILACAK
	IF EXISTS (SELECT * FROM MikroDB_V16_MCM.dbo.SIPARISLER WITH(NOLOCK) WHERE sip_evrakno_seri=@EvrakSeri AND sip_evrakno_sira=@MikroSiparisNo AND sip_kapat_fl=1)
	BEGIN
		UPDATE MikroDB_V16_MCM.dbo.SIPARISLER SET sip_kapat_fl=0, sip_aciklama='Xpoda onay verildi' WHERE sip_evrakno_seri=@EvrakSeri AND sip_evrakno_sira=@MikroSiparisNo
	END

	--değiştirilen kayıtları güncelle
	UPDATE MikroDB_V16_MCM.dbo.SIPARISLER
	SET [sip_lastup_date] = GETDATE()--<sip_lastup_date, datetime,>
      ,[sip_firmano] = SF.Firma--CASE WHEN SF.Firma=1 THEN 0 WHEN SF.Firma=2 THEN 2 WHEN SF.Firma=3 THEN 1 ELSE 0 END--<sip_firmano, int,>
      --,[sip_tarih] = convert(Date,SF.UpdateDate)--<sip_tarih, datetime,>
      ,[sip_teslim_tarih] = D.TeslimTarihi--<sip_teslim_tarih, datetime,>
      ,[sip_satici_kod] = SF.Satici--<sip_satici_kod, nvarchar(25),>
      ,[sip_musteri_kod] = SF.Cari--<sip_musteri_kod, nvarchar(25),>
      ,[sip_stok_kod] = D.Stok--<sip_stok_kod, nvarchar(25),>
      ,[sip_b_fiyat] = D.BirimFiyat--<sip_b_fiyat, float,>
      ,[sip_miktar] = D.Miktar--<sip_miktar, float,>
      ,[sip_tutar] = D.BirimFiyat* D.Miktar--<sip_tutar, float,>
      ,[sip_iskonto_1] =CASE WHEN 
		   ((D.BirimFiyat*D.Miktar*D.Iskonto)/100) 
				+ ((((D.BirimFiyat*D.Miktar)- ((D.BirimFiyat*D.Miktar*D.Iskonto)/100))*DipIskonto)/100) 

				>  (D.BirimFiyat* D.Miktar) 
					THEN (D.BirimFiyat* D.Miktar)
					ELSE ((D.BirimFiyat*D.Miktar*D.Iskonto)/100) 
						+ ((((D.BirimFiyat*D.Miktar)- ((D.BirimFiyat*D.Miktar*D.Iskonto)/100))*DipIskonto)/100) 
						END --<sip_iskonto_1, float,>
		 --  ,((D.BirimFiyat*D.Miktar*D.Iskonto)/100 - (DipIskonto/100)--<sip_iskonto_1, float,>
      ,[sip_vergi_pntr] = SF.KDV--<sip_vergi_pntr, tinyint,>
      ,[sip_vergi] = (((D.BirimFiyat*D.Miktar) - CASE WHEN 
		   ((D.BirimFiyat*D.Miktar*D.Iskonto)/100) 
				+ ((((D.BirimFiyat*D.Miktar)- ((D.BirimFiyat*D.Miktar*D.Iskonto)/100))*DipIskonto)/100) 

				>  (D.BirimFiyat* D.Miktar) 
					THEN (D.BirimFiyat* D.Miktar)
					ELSE ((D.BirimFiyat*D.Miktar*D.Iskonto)/100) 
						+ ((((D.BirimFiyat*D.Miktar)- ((D.BirimFiyat*D.Miktar*D.Iskonto)/100))*DipIskonto)/100) 
						END)*V.Tipi)/100--<sip_vergi, float,>
      ,[sip_opno] = @OdemePlanNo--<sip_opno, int,>
      ,[sip_depono] = SF.Depo--<sip_depono, int,>
      ,[sip_cari_sormerk] = SF.SorumlulukMerkezi--<sip_cari_sormerk, nvarchar(25),>
      ,[sip_stok_sormerk] = SF.SorumlulukMerkezi--<sip_stok_sormerk, nvarchar(25),>
      ,[sip_doviz_cinsi] = D.DetayDoviz--<sip_doviz_cinsi, tinyint,>
      ,[sip_doviz_kuru] = MikroDB_V16_MCM.dbo.fn_KurBul(SF.CreateDate,D.DetayDoviz,1)--<sip_doviz_kuru, float,>
      ,[sip_alt_doviz_kuru] = MikroDB_V16_MCM.dbo.fn_KurBul(SF.CreateDate,1,1)--<sip_alt_doviz_kuru, float,>**USD**
      ,[sip_projekodu] = SF.Proje--<sip_projekodu, nvarchar(25),>
      ,[sip_harekettipi] = D.Cinsi--<sip_harekettipi, tinyint,>
	  ,sip_HareketGrupKodu1 = SF.Marka
	  ,sip_HareketGrupKodu3 = CASE WHEN SF.IhracKayitli IN ('','1') THEN 'NORMAL' ELSE 'IHRAC KAYITLI' END
	  ,sip_cari_grupno = SF.CariDovizGrup

	FROM MikroDB_V16_MCM.dbo.SIPARISLER S WITH (NOLOCK)
	LEFT JOIN MCM_ALINAN_SIPARISLER_FORMU_DETAIL D WITH (NOLOCK) ON D.UserTableID = S.sip_SpecRECno AND S.sip_evrakno_seri = @EvrakSeri AND S.sip_evrakno_sira = @MikroSiparisNo
	LEFT JOIN MCM_ALINAN_SIPARISLER_FORMU SF WITH (NOLOCK) ON SF.UserTableID = D.MasterID
	LEFT JOIN  [dbo].[vw_Vergi] V WITH (NOLOCK) ON V.ID = SF.KDV
	WHERE D.MasterID = @UserTableID AND S.sip_SpecRECno IN (Select items From dbo.Ayrac(@DetayUserTableIDs,','))

	

	--YENİ EKLENEN SATIRLARI SIPARIS KALEMLERINE EKLE
	

	DECLARE YENI_SIPARIS_INSERT CURSOR FOR

	SELECT D.UserTableID 
	FROM MCM_ALINAN_SIPARISLER_FORMU_DETAIL D WITH (NOLOCK) 
	LEFT JOIN MikroDB_V16_MCM.[dbo].[SIPARISLER] S WITH (NOLOCK) ON D.UserTableID = S.sip_SpecRECno AND S.sip_evrakno_seri = @EvrakSeri AND S.sip_evrakno_sira = @MikroSiparisNo
	WHERE D.MasterID = @UserTableID AND S.sip_SpecRECno IS NULL

	OPEN YENI_SIPARIS_INSERT 
 
FETCH NEXT FROM YENI_SIPARIS_INSERT INTO @UserTableID
	WHILE @@FETCH_STATUS =0
		BEGIN
 
	INSERT INTO MikroDB_V16_MCM.[dbo].[SIPARISLER]
           ([sip_Guid]
           ,[sip_DBCno]
           ,[sip_SpecRECno]
           ,[sip_iptal]
           ,[sip_fileid]
           ,[sip_hidden]
           ,[sip_kilitli]
           ,[sip_degisti]
           ,[sip_checksum]
           ,[sip_create_user]
           ,[sip_create_date]
           ,[sip_lastup_user]
           ,[sip_lastup_date]
           ,[sip_special1]
           ,[sip_special2]
           ,[sip_special3]
           ,[sip_firmano]
           ,[sip_subeno]
           ,[sip_tarih]
           ,[sip_teslim_tarih]
           ,[sip_tip]
           ,[sip_cins]
           ,[sip_evrakno_seri]
           ,[sip_evrakno_sira]
           ,[sip_satirno]
           ,[sip_belgeno]
           ,[sip_belge_tarih]
           ,[sip_satici_kod]
           ,[sip_musteri_kod]
           ,[sip_stok_kod]
           ,[sip_b_fiyat]
           ,[sip_miktar]
           ,[sip_birim_pntr]
           ,[sip_teslim_miktar]
           ,[sip_tutar]
           ,[sip_iskonto_1]
           ,[sip_iskonto_2]
           ,[sip_iskonto_3]
           ,[sip_iskonto_4]
           ,[sip_iskonto_5]
           ,[sip_iskonto_6]
           ,[sip_masraf_1]
           ,[sip_masraf_2]
           ,[sip_masraf_3]
           ,[sip_masraf_4]
           ,[sip_vergi_pntr]
           ,[sip_vergi]
           ,[sip_masvergi_pntr]
           ,[sip_masvergi]
           ,[sip_opno]
           ,[sip_aciklama]
           ,[sip_aciklama2]
           ,[sip_depono]
           ,[sip_OnaylayanKulNo]
           ,[sip_vergisiz_fl]
           ,[sip_kapat_fl]
           ,[sip_promosyon_fl]
           ,[sip_cari_sormerk]
           ,[sip_stok_sormerk]
           ,[sip_cari_grupno]
           ,[sip_doviz_cinsi]
           ,[sip_doviz_kuru]
           ,[sip_alt_doviz_kuru]
           ,[sip_adresno]
           ,[sip_teslimturu]
           ,[sip_cagrilabilir_fl]
           ,[sip_prosip_uid]
           ,[sip_iskonto1]
           ,[sip_iskonto2]
           ,[sip_iskonto3]
           ,[sip_iskonto4]
           ,[sip_iskonto5]
           ,[sip_iskonto6]
           ,[sip_masraf1]
           ,[sip_masraf2]
           ,[sip_masraf3]
           ,[sip_masraf4]
           ,[sip_isk1]
           ,[sip_isk2]
           ,[sip_isk3]
           ,[sip_isk4]
           ,[sip_isk5]
           ,[sip_isk6]
           ,[sip_mas1]
           ,[sip_mas2]
           ,[sip_mas3]
           ,[sip_mas4]
           ,[sip_Exp_Imp_Kodu]
           ,[sip_kar_orani]
           ,[sip_durumu]
           ,[sip_stal_uid]
           ,[sip_planlananmiktar]
           ,[sip_teklif_uid]
           ,[sip_parti_kodu]
           ,[sip_lot_no]
           ,[sip_projekodu]
           ,[sip_fiyat_liste_no]
           ,[sip_Otv_Pntr]
           ,[sip_Otv_Vergi]
           ,[sip_otvtutari]
           ,[sip_OtvVergisiz_Fl]
           ,[sip_paket_kod]
           ,[sip_Rez_uid]
           ,[sip_harekettipi]
           ,[sip_yetkili_uid]
           ,[sip_kapatmanedenkod]
           ,[sip_gecerlilik_tarihi]
           ,[sip_onodeme_evrak_tip]
           ,[sip_onodeme_evrak_seri]
           ,[sip_onodeme_evrak_sira]
           ,[sip_rezervasyon_miktari]
           ,[sip_rezerveden_teslim_edilen]
           ,[sip_HareketGrupKodu1]
           ,[sip_HareketGrupKodu2]
           ,[sip_HareketGrupKodu3]
           ,[sip_Olcu1]
           ,[sip_Olcu2]
           ,[sip_Olcu3]
           ,[sip_Olcu4]
           ,[sip_Olcu5]
           ,[sip_FormulMiktarNo]
           ,[sip_FormulMiktar])
     SELECT
           NEWID()--(<sip_Guid, uniqueidentifier,>
           ,0--<sip_DBCno, smallint,>
           ,D.UserTableID--<sip_SpecRECno, int,>/*MCM_ALINAN_SIPARISLER_FORMU*/
           ,0--<sip_iptal, bit,>
           ,21--<sip_fileid, smallint,>
           ,0--<sip_hidden, bit,>
           ,0--<sip_kilitli, bit,>
           ,0--<sip_degisti, bit,>
           ,0--<sip_checksum, int,>
           ,@OnaylayanKullanici--P.MikroUserID-- [dbo].[MikroKullaniciNo](P.MikroPersonelKodu)--<sip_create_user, smallint,>
           ,GETDATE()--<sip_create_date, datetime,>
           ,@OnaylayanKullanici--P.MikroUserID-- [dbo].[MikroKullaniciNo](P.MikroPersonelKodu)--<sip_lastup_user, smallint,>
           ,GETDATE()--<sip_lastup_date, datetime,>
           ,'XPD'--<sip_special1, nvarchar(4),>
           ,D.CreateUser--<sip_special2, nvarchar(4),>
           ,''--<sip_special3, nvarchar(4),>
           ,SF.Firma--CASE WHEN SF.Firma=1 THEN 0 WHEN SF.Firma=2 THEN 2 WHEN SF.Firma=3 THEN 1 ELSE 0 END--<sip_firmano, int,>
           ,0--<sip_subeno, int,>
           ,convert(Date,SF.CreateDate)--<sip_tarih, datetime,>
           ,D.TeslimTarihi--<sip_teslim_tarih, datetime,>
           ,0--<sip_tip, tinyint,>
           ,0--<sip_cins, tinyint,>
           ,@EvrakSeri--<sip_evrakno_seri, [dbo].[evrakseri_str],>
           ,SF.MikroSiparisNo--<sip_evrakno_sira, int,>
           ,@SatirNo--<sip_satirno, int,>
           ,''--<sip_belgeno, [dbo].[belgeno_str],>
           ,GETDATE()--<sip_belge_tarih, datetime,>
           ,SF.Satici--<sip_satici_kod, nvarchar(25),>
           ,SF.Cari--<sip_musteri_kod, nvarchar(25),>
           ,D.Stok--<sip_stok_kod, nvarchar(25),>
           ,D.BirimFiyat--<sip_b_fiyat, float,>
           ,D.Miktar--<sip_miktar, float,>
           ,1--<sip_birim_pntr, tinyint,>
           ,0--<sip_teslim_miktar, float,>
		   ,D.BirimFiyat* D.Miktar --<sip_tutar, float,>
           --,D.Tutar--<sip_tutar, float,>
           --,(D.Tutar*SF.Iskonto)/100--<sip_iskonto_1, float,>
		   , CASE WHEN 
		   ((D.BirimFiyat*D.Miktar*D.Iskonto)/100) 
				+ ((((D.BirimFiyat*D.Miktar)- ((D.BirimFiyat*D.Miktar*D.Iskonto)/100))*DipIskonto)/100) 

				>  (D.BirimFiyat* D.Miktar) 
					THEN (D.BirimFiyat* D.Miktar)
					ELSE ((D.BirimFiyat*D.Miktar*D.Iskonto)/100) 
						+ ((((D.BirimFiyat*D.Miktar)- ((D.BirimFiyat*D.Miktar*D.Iskonto)/100))*DipIskonto)/100) 
						END --<sip_iskonto_1, float,>
		 --  ,((D.BirimFiyat*D.Miktar*D.Iskonto)/100 - (DipIskonto/100)--<sip_iskonto_1, float,>
           ,0--<sip_iskonto_2, float,>
           ,0--<sip_iskonto_3, float,>
           ,0--<sip_iskonto_4, float,>
           ,0--<sip_iskonto_5, float,>
           ,0--<sip_iskonto_6, float,>
           ,0--<sip_masraf_1, float,>
           ,0--<sip_masraf_2, float,>
           ,0--<sip_masraf_3, float,>
           ,0--<sip_masraf_4, float,>
           ,SF.KDV--<sip_vergi_pntr, tinyint,>
           ,(((D.BirimFiyat*D.Miktar) - CASE WHEN 
		   ((D.BirimFiyat*D.Miktar*D.Iskonto)/100) 
				+ ((((D.BirimFiyat*D.Miktar)- ((D.BirimFiyat*D.Miktar*D.Iskonto)/100))*DipIskonto)/100) 

				>  (D.BirimFiyat* D.Miktar) 
					THEN (D.BirimFiyat* D.Miktar)
					ELSE ((D.BirimFiyat*D.Miktar*D.Iskonto)/100) 
						+ ((((D.BirimFiyat*D.Miktar)- ((D.BirimFiyat*D.Miktar*D.Iskonto)/100))*DipIskonto)/100) 
						END)*V.Tipi)/100--<sip_vergi, float,>
           ,0--<sip_masvergi_pntr, tinyint,>
           ,0--<sip_masvergi, float,>
           ,@OdemePlanNo--<sip_opno, int,>
           ,''--<sip_aciklama, nvarchar(50),>
           ,''--<sip_aciklama2, nvarchar(50),>
           ,SF.Depo--<sip_depono, int,>
           ,@OnaylayanKullanici--<sip_OnaylayanKulNo, smallint,>
           ,0--<sip_vergisiz_fl, bit,>
           ,0--<sip_kapat_fl, bit,>
           ,0--<sip_promosyon_fl, bit,>
           ,SF.SorumlulukMerkezi--<sip_cari_sormerk, nvarchar(25),>
           ,SF.SorumlulukMerkezi--<sip_stok_sormerk, nvarchar(25),>
           ,SF.CariDovizGrup--<sip_cari_grupno, tinyint,>
           ,D.DetayDoviz--<sip_doviz_cinsi, tinyint,>
           ,MikroDB_V16_MCM.dbo.fn_KurBul(SF.CreateDate,D.DetayDoviz,1)--<sip_doviz_kuru, float,>
           ,MikroDB_V16_MCM.dbo.fn_KurBul(SF.CreateDate,1,1)--<sip_alt_doviz_kuru, float,>**USD**
           ,1--<sip_adresno, int,>
           ,''--<sip_teslimturu, nvarchar(4),>
           ,1--<sip_cagrilabilir_fl, bit,>
           ,@DefaultGuid--<sip_prosip_uid, uniqueidentifier,>
           ,0--<sip_iskonto1, tinyint,>
           ,1--<sip_iskonto2, tinyint,>
           ,1--<sip_iskonto3, tinyint,>
           ,1--<sip_iskonto4, tinyint,>
           ,1--<sip_iskonto5, tinyint,>
           ,1--<sip_iskonto6, tinyint,>
           ,1--<sip_masraf1, tinyint,>
           ,1--<sip_masraf2, tinyint,>
           ,1--<sip_masraf3, tinyint,>
           ,1--<sip_masraf4, tinyint,>
           ,0--<sip_isk1, bit,>
           ,0--<sip_isk2, bit,>
           ,0--<sip_isk3, bit,>
           ,0--<sip_isk4, bit,>
           ,0--<sip_isk5, bit,>
           ,0--<sip_isk6, bit,>
           ,0--<sip_mas1, bit,>
           ,0--<sip_mas2, bit,>
           ,0--<sip_mas3, bit,>
           ,0--<sip_mas4, bit,>
           ,''--<sip_Exp_Imp_Kodu, nvarchar(25),>
           ,0--<sip_kar_orani, float,>
           ,0--<sip_durumu, tinyint,>
           ,@DefaultGuid--<sip_stal_uid, uniqueidentifier,>
           ,0--<sip_planlananmiktar, float,>
           ,@DefaultGuid--<sip_teklif_uid, uniqueidentifier,>
           ,''--<sip_parti_kodu, nvarchar(25),>
           ,0--<sip_lot_no, int,>
           ,SF.Proje--<sip_projekodu, nvarchar(25),>
           ,0--<sip_fiyat_liste_no, int,>
           ,0--<sip_Otv_Pntr, tinyint,>
           ,0--<sip_Otv_Vergi, float,>
           ,0--<sip_otvtutari, float,>
           ,0--<sip_OtvVergisiz_Fl, tinyint,>
           ,''--<sip_paket_kod, nvarchar(25),>
           ,@DefaultGuid--<sip_Rez_uid, uniqueidentifier,>
           ,D.Cinsi--<sip_harekettipi, tinyint,>
           ,@DefaultGuid--<sip_yetkili_uid, uniqueidentifier,>
           ,''--<sip_kapatmanedenkod, nvarchar(25),>
           ,@DefaultTarih--<sip_gecerlilik_tarihi, datetime,>
           ,0--<sip_onodeme_evrak_tip, tinyint,>
           ,''--<sip_onodeme_evrak_seri, [dbo].[evrakseri_str],>
           ,0--<sip_onodeme_evrak_sira, int,>
           ,0--<sip_rezervasyon_miktari, float,>
           ,0--<sip_rezerveden_teslim_edilen, float,>
           ,SF.Marka--<sip_HareketGrupKodu1, nvarchar(25),>
           ,''--<sip_HareketGrupKodu2, nvarchar(25),>
           ,CASE WHEN SF.IhracKayitli IN ('','1') THEN 'NORMAL' ELSE 'IHRAC KAYITLI' END--<sip_HareketGrupKodu3, nvarchar(25),>
           ,0--<sip_Olcu1, float,>
           ,0--<sip_Olcu2, float,>
           ,0--<sip_Olcu3, float,>
           ,0--<sip_Olcu4, float,>
           ,0--<sip_Olcu5, float,>
           ,0--<sip_FormulMiktarNo, tinyint,>
           ,0--<sip_FormulMiktar, float,>)
		   
		FROM MCM_ALINAN_SIPARISLER_FORMU SF WITH (NOLOCK)
		LEFT JOIN MCM_ALINAN_SIPARISLER_FORMU_DETAIL D WITH (NOLOCK) ON D.MasterID = SF.UserTableID
		LEFT JOIN MCM_PERSONEL_TANITIM_KARTI P WITH (NOLOCK) ON P.XPUserID = @ActiveUser
		LEFT JOIN  [dbo].[vw_Vergi] V WITH (NOLOCK) ON V.ID = SF.KDV
		WHERE D.UserTableID = @UserTableID

		
	UPDATE MCM_ALINAN_SIPARISLER_FORMU_DETAIL SET IntegrationID = Convert(nvarchar(50),sip_Guid)
	
	FROM [MikroDB_V16_MCM].[dbo].[SIPARISLER] WITH (NOLOCK)
	LEFT JOIN MCM_ALINAN_SIPARISLER_FORMU_DETAIL D WITH (NOLOCK) ON sip_evrakno_seri = @EvrakSeri AND sip_evrakno_sira = @XPDevrakSonSira AND sip_SpecRECno = D.UserTableID

	where D.UserTableID = @UserTableID

		SET @SatirNo = @SatirNo + 1 

	 FETCH NEXT FROM YENI_SIPARIS_INSERT INTO @UserTableID
		END
 
	CLOSE YENI_SIPARIS_INSERT 
 
	DEALLOCATE YENI_SIPARIS_INSERT 


END

END
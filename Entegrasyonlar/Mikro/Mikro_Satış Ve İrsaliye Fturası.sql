CREATE PROC [dbo].[sp_SY_MIKRO_SATIS_IRSALIYE_VE_FATURASI]

( @SiparisID NVARCHAR(MAX))
AS
BEGIN 
DECLARE @EvrakAciklamasiGuid Uniqueidentifier
DECLARE @Sth_Guid Uniqueidentifier ,--=NEWID(),
	    @Cha_Guid Uniqueidentifier ,--=NEWID(),
        @Date DATETIME =GETDATE(),
		@Dateday DATE =CONVERT(DATE,GETDATE()),
		@sth_tip INT =1,--Çýkýþ
        @sth_cins INT =0--Toptan 
		,@sth_evraktip INT =4--Çýkýþ Faturasý
		,@EvrakSeri NVARCHAR(25)='EAR'
		,@sth_vergi FLOAT
		,@IrsaliyeDateDay DATE 
DECLARE @EvrekSira1 INT = (SELECT ISNULL(MAX(sth_evrakno_sira),0)
							FROM /*MikroDB_V16_TEGVIKTISADI*/[MikroDB_V16_TEGVIKTISADI].dbo.STOK_HAREKETLERI WITH (NOLOCK)
							WHERE sth_evrakno_seri =@EvrakSeri)
DECLARE @EvrekSira INT
       ,@Satirno INT =0
       ,@sth_alt_doviz_kuru FLOAT --= MikroDB_V16_TEGVIKTISADI.dbo.fn_KurBul(@Date,1,1)
	   , @BosGuid Uniqueidentifier='00000000-0000-0000-0000-000000000000'
	   ,@GirisDepo  INT--INT =1
	   ,@CikisDepo  INT--INT =1
	   ,@sth_adres_no INT =1
	   ,@cha_ebelge_turu INT =	0--:Ticari Fatura 
	   ,@cha_e_islem_turu INT =0--Tanýmsýz
	   ,@cha_fatura_belge_turu INT =0--Fatura 
	   ,@cha_adres_no INT =1
DECLARE
        @ID INT 
		,@DetailID INT,
        @Stok NVARCHAR(50),
        @Cari NVARCHAR(50),
		@Miktar FLOAT ,
		@Tutar FLOAT ,
		@KdvPntr INT ,
		@Proje NVARCHAR(50)

DECLARE @FaturaSira INT
DECLARE @FaturaSeri NVARCHAR(50) ='EAR'
DECLARE @FaturaSira1 INT =(SELECT ISNULL(MAX(cha_evrakno_sira),0)
							FROM /*MikroDB_V16_TEGVIKTISADI*/[MikroDB_V16_TEGVIKTISADI].dbo.[CARI_HESAP_HAREKETLERI] WITH (NOLOCK)
							WHERE cha_evrakno_seri =@FaturaSeri),
		@FaturaSatirno INT =0,
		@cha_tip INT =0--Borç
	   ,@cha_cinsi INT =6--Hizmet Faturasý
	   ,@cha_tpoz INT =0 --Açýk
	   ,@cha_cari_cins INT =0
	   ,@cha_altd_kur FLOAT --= MikroDB_V16_TEGVIKTISADI.dbo.fn_KurBul(@Date,1,1)
	   ,@cha_grupno  INT  =0
	   ,@cha_kasa_hizmet INT =0
	   ,@cha_kasa_hizkod NVARCHAR(50)=''
	   ,@cha_vade INT =0
	   ,@cha_fis_sirano INT =0
	   ,@FaturaDateDay DATE

DECLARE @FaturaProje NVARCHAR(50)
	   ,@FaturaCari NVARCHAR(50)
	   ,@FaturaMiktar FLOAT 
	   ,@Fatura_Tutar FLOAT 
	   ,@Fatura_Ara_Toplam Float
	   ,@Fatura_Kdn_Pntr INT =0
	   ,@FatuaID INT 
	   ,@FaturaDetail INT 
	   ,@cha_vergi1	FLOAT
	   ,@cha_vergi2	FLOAT
	   ,@cha_vergi3	FLOAT
	   ,@cha_vergi4	FLOAT
	   ,@cha_vergi5 FLOAT
DECLARE Mikro_Irsaliye CURSOR LOCAL READ_ONLY FAST_FORWARD FOR
SELECT 
DENSE_RANK() OVER(ORDER BY SG.UserTableID ASC)+ @EvrekSira1,
  ROW_NUMBER() OVER(PARTITION BY SG.UserTableID ORDER BY SGD.UserTableID  ASC)-1 ,

SG.UserTableID ,
SGD.UserTableID,
SG.[CariKodu],
SG.[Proje],
SGD.[UrunKodu],
SGD.[Miktar],
SGD.ToplamFiyat
 ,K.Pntr
 ,SG.E_FaturaDepo
 ,SG.E_FaturaDepo
 ,SGD.[FaturaTutar]-SGD.ToplamFiyat
 ,CONVERT(DATE,SG.SiparisTarihi)
 ,MikroDB_V16_TEGVIKTISADI.dbo.fn_KurBul(SG.SiparisTarihi,1,1)
FROM TEGV_SIPARIS_GIRISI SG WITH (NOLOCK) 
LEFT OUTER JOIN TEGV_SIPARIS_GIRISI_DETAIL SGD WITH (NOLOCK)  ON SG.UserTableID=SGD.MasterTableID
LEFT OUTER JOIN  MikroDB_V16_TEGVIKTISADI.dbo.STOKLAR S WITH (NOLOCK) ON S.sto_kod =SGD.UrunKodu 
LEFT OUTER JOIN dbo.vw_Kdv_Oranlari K WITH (NOLOCK) ON K.Kdv=SGD.Kdv
WHERE  SG.UserTableID IN (SELECT * FROM dbo.Ayrac (@SiparisID,','))
AND [EntegreTuru] =1 AND SG.Durum=0 AND SGD.IrsaliyeGuid=@BosGuid
AND S.sto_kod =SGD.UrunKodu 
ORDER BY SG.UserTableID ASC
OPEN Mikro_Irsaliye

FETCH NEXT FROM Mikro_Irsaliye INTO  
@EvrekSira,@Satirno,@ID,@DetailID,@Cari,@Proje,@Stok,@Miktar,@Tutar,@KdvPntr,@GirisDepo,@CikisDepo,@sth_vergi,
@IrsaliyeDateDay,@sth_alt_doviz_kuru
WHILE @@FETCH_STATUS = 0 
BEGIN

SET @Sth_Guid=NEWID()

INSERT INTO /*MikroDB_V16_TEGVIKTISADI*/[MikroDB_V16_TEGVIKTISADI].[dbo].[STOK_HAREKETLERI]
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
           ( @Sth_Guid            --<sth_Guid, uniqueidentifier,>
           ,  0           --<sth_DBCno, smallint,>
           ,  0           --<sth_SpecRECno, int,>
           ,  0           --<sth_iptal, bit,>
           ,  16           --<sth_fileid, smallint,>
           ,  0           --<sth_hidden, bit,>
           ,   0          --<sth_kilitli, bit,>
           ,   0          --<sth_degisti, bit,>
           ,   0          --<sth_checksum, int,>
           ,   1          --<sth_create_user, smallint,>
           ,   @Date          --<sth_create_date, datetime,>
           ,   1          --<sth_lastup_user, smallint,>
           ,   @Date          --<sth_lastup_date, datetime,>
           ,   'OCT'          --<sth_special1, nvarchar(4),>
           ,    N''         --<sth_special2, nvarchar(4),>
           ,    N''         --<sth_special3, nvarchar(4),>
           ,    0         --<sth_firmano, int,>
           ,    0         --<sth_subeno, int,>
           ,   @IrsaliyeDateDay --@Dateday         --<sth_tarih, datetime,>
           ,    @sth_tip         --<sth_tip, tinyint,>
           ,    @sth_cins         --<sth_cins, tinyint,>
           ,    0         --<sth_normal_iade, tinyint,>
           ,    @sth_evraktip         --<sth_evraktip, tinyint,>
           ,    @EvrakSeri         --<sth_evrakno_seri, [dbo].[evrakseri_str],>
           ,    @EvrekSira         --<sth_evrakno_sira, int,>
           ,    @Satirno         --<sth_satirno, int,>
           ,    N''         --<sth_belge_no, [dbo].[belgeno_str],>
           ,   @IrsaliyeDateDay-- @Dateday         --<sth_belge_tarih, datetime,>
           ,    @Stok         --<sth_stok_kod, nvarchar(25),>
           ,    0         --<sth_isk_mas1, tinyint,>
           ,    1         --<sth_isk_mas2, tinyint,>
           ,    1       --<sth_isk_mas3, tinyint,>
           ,    1       --<sth_isk_mas4, tinyint,>
           ,    1       --<sth_isk_mas5, tinyint,>
           ,    1       --<sth_isk_mas6, tinyint,>
           ,    1       --<sth_isk_mas7, tinyint,>
           ,    1       --<sth_isk_mas8, tinyint,>
           ,    1       --<sth_isk_mas9, tinyint,>
           ,    1       --<sth_isk_mas10, tinyint,>
           ,    0        --<sth_sat_iskmas1, bit,>
           ,    0        --<sth_sat_iskmas2, bit,>
           ,    0        --<sth_sat_iskmas3, bit,>
           ,    0        --<sth_sat_iskmas4, bit,>
           ,    0        --<sth_sat_iskmas5, bit,>
           ,    0        --<sth_sat_iskmas6, bit,>
           ,    0        --<sth_sat_iskmas7, bit,>
           ,    0        --<sth_sat_iskmas8, bit,>
           ,    0        --<sth_sat_iskmas9, bit,>
           ,    0        --<sth_sat_iskmas10, bit,>
           ,    0         --<sth_pos_satis, tinyint,>
           ,    0         --<sth_promosyon_fl, bit,>
           ,    0         --<sth_cari_cinsi, tinyint,>
           ,    @Cari         --<sth_cari_kodu, nvarchar(25),>
           ,    0         --<sth_cari_grup_no, tinyint,>
           ,    N''         --<sth_isemri_gider_kodu, nvarchar(25),>
           ,    N''         --<sth_plasiyer_kodu, nvarchar(25),>
           ,    0         --<sth_har_doviz_cinsi, tinyint,>
           ,    1         --<sth_har_doviz_kuru, float,>
           ,    @sth_alt_doviz_kuru         --<sth_alt_doviz_kuru, float,>
           ,    0         --<sth_stok_doviz_cinsi, tinyint,>
           ,    1         --<sth_stok_doviz_kuru, float,>
           ,    @Miktar         --<sth_miktar, float,>
           ,    @Miktar         --<sth_miktar2, float,>
           ,    1         --<sth_birim_pntr, tinyint,>
           ,    @Tutar         --<sth_tutar, float,>
           ,    0       --<sth_iskonto1, float,>
           ,    0       --<sth_iskonto2, float,>
           ,    0       --<sth_iskonto3, float,>
           ,    0       --<sth_iskonto4, float,>
           ,    0       --<sth_iskonto5, float,>
           ,    0       --<sth_iskonto6, float,>
           ,    0       --<sth_masraf1, float,>
           ,    0       --<sth_masraf2, float,>
           ,    0       --<sth_masraf3, float,>
           ,    0       --<sth_masraf4, float,>
           ,    @KdvPntr         --<sth_vergi_pntr, tinyint,>
           ,    @sth_vergi         --<sth_vergi, float,>
           ,    0         --<sth_masraf_vergi_pntr, tinyint,>
           ,    0         --<sth_masraf_vergi, float,>
           ,    0         --<sth_netagirlik, float,>
           ,    0        --<sth_odeme_op, int,>
           ,    N''         --<sth_aciklama, nvarchar(50),>
           ,    @BosGuid         --<sth_sip_uid, uniqueidentifier,>
           ,    @BosGuid         --<sth_fat_uid, uniqueidentifier,>
           ,    @GirisDepo          --<sth_giris_depo_no, int,>
           ,    @CikisDepo          --<sth_cikis_depo_no, int,>
           ,   @IrsaliyeDateDay-- @Dateday         --<sth_malkbl_sevk_tarihi, datetime,>
           ,    N''         --<sth_cari_srm_merkezi, nvarchar(25),>
           ,    N''         --<sth_stok_srm_merkezi, nvarchar(25),>
           ,    @IrsaliyeDateDay--@Dateday         --<sth_fis_tarihi, datetime,>
           ,    0         --<sth_fis_sirano, int,>
           ,    0         --<sth_vergisiz_fl, bit,>
           ,    0         --<sth_maliyet_ana, float,>
           ,    0         --<sth_maliyet_alternatif, float,>
           ,    0         --<sth_maliyet_orjinal, float,>
           ,    @sth_adres_no         --<sth_adres_no, int,>
           ,    N''         --<sth_parti_kodu, nvarchar(25),>
           ,    0         --<sth_lot_no, int,>
           ,    @BosGuid         --<sth_kons_uid, uniqueidentifier,>
           ,    @Proje         --<sth_proje_kodu, nvarchar(25),>
           ,     N''        --<sth_exim_kodu, nvarchar(25),>
           ,     0        --<sth_otv_pntr, tinyint,>
           ,     0        --<sth_otv_vergi, float,>
           ,     0        --<sth_brutagirlik, float,>
           ,     0        --<sth_disticaret_turu, tinyint,>
           ,     0        --<sth_otvtutari, float,>
           ,     0        --<sth_otvvergisiz_fl, bit,>
           ,     0        --<sth_oiv_pntr, tinyint,>
           ,     0        --<sth_oiv_vergi, float,>
           ,     0        --<sth_oivvergisiz_fl, bit,>
           ,     0        --<sth_fiyat_liste_no, int,>
           ,     0        --<sth_oivtutari, float,>
           ,     0        --<sth_Tevkifat_turu, tinyint,>
           ,     0        --<sth_nakliyedeposu, int,>
           ,     0        --<sth_nakliyedurumu, tinyint,>
           ,     @BosGuid        --<sth_yetkili_uid, uniqueidentifier,>
           ,     0        --<sth_taxfree_fl, bit,>
           ,     0        --<sth_ilave_edilecek_kdv, float,>
           ,     N''        --<sth_ismerkezi_kodu, nvarchar(25),>
           ,     N''        --<sth_HareketGrupKodu1, nvarchar(25),>
           ,     N''        --<sth_HareketGrupKodu2, nvarchar(25),>
           ,     N''        --<sth_HareketGrupKodu3, nvarchar(25),>
           ,     0        --<sth_Olcu1, float,>
           ,     0        --<sth_Olcu2, float,>
           ,     0        --<sth_Olcu3, float,>
           ,     0        --<sth_Olcu4, float,>
           ,     0        --<sth_Olcu5, float,>
           ,     0        --<sth_FormulMiktarNo, tinyint,>
           ,     0        --<sth_FormulMiktar, float,>
		   )






UPDATE TEGV_SIPARIS_GIRISI SET Durum =1 WHERE UserTableID =@ID
UPDATE TEGV_SIPARIS_GIRISI_DETAIL SET IrsaliyeGuid =CONVERT(NVARCHAR(50),@Sth_Guid) WHERE UserTableID =@DetailID


FETCH NEXT FROM Mikro_Irsaliye INTO  
@EvrekSira,@Satirno,@ID,@DetailID,@Cari,@Proje,@Stok,@Miktar,@Tutar,@KdvPntr,@GirisDepo,@CikisDepo,@sth_vergi,
@IrsaliyeDateDay,@sth_alt_doviz_kuru
END
CLOSE Mikro_Irsaliye
DEALLOCATE Mikro_Irsaliye

DECLARE Mikro_Fatura CURSOR LOCAL READ_ONLY FAST_FORWARD FOR

SELECT 
A.Sira
,A.[Satýr]
 ,A.ID
,A.[Cari]
,A.[Proje]
,A.[Miktar]
,SUM(ROUND(A.[FaturaTutar],2)  )
,SUM(ROUND(A.[ToplamFiyat],2)  )
--,SUM(ROUND(A.cha_vergi0	  ,2))
,SUM(ROUND(A.cha_vergi1	  ,2))
,SUM(ROUND(A.cha_vergi2	  ,2))
,SUM(ROUND(A.cha_vergi3	  ,2))
,SUM(ROUND(A.cha_vergi4	  ,2))
,SUM(ROUND(A.cha_vergi5   ,2)  )
,A.Tarih
,MikroDB_V16_TEGVIKTISADI.dbo.fn_KurBul(A.Tarih,1,1)
FROM 
(
SELECT 
DENSE_RANK() OVER(ORDER BY SG.UserTableID ASC)+ @FaturaSira1 aS [Sira],
  /*ROW_NUMBER() OVER(PARTITION BY SG.UserTableID ORDER BY SGD.UserTableID  ASC)-1 */0 As [Satýr] ,

SG.UserTableID AS ID ,
SG.[CariKodu] As [Cari],
SG.[Proje] AS [Proje],
0 AS [Miktar],
SUM(SGD.[FaturaTutar]) As [FaturaTutar],
SUM(SGD.ToplamFiyat)AS [ToplamFiyat]

-- ,CASE WHEN K.Pntr =0 THEN SUM(SGD.[FaturaTutar]) -SUM(SGD.ToplamFiyat)  ELSE 0 END As cha_vergi0
 ,CASE WHEN K.Pntr =1 THEN SUM(SGD.[FaturaTutar]) -SUM(SGD.ToplamFiyat) ELSE 0 END As    cha_vergi1
 ,CASE WHEN K.Pntr =2 THEN SUM(SGD.[FaturaTutar]) -SUM(SGD.ToplamFiyat) ELSE 0 END As    cha_vergi2
 ,CASE WHEN K.Pntr =3 THEN SUM(SGD.[FaturaTutar]) -SUM(SGD.ToplamFiyat) ELSE 0 END As    cha_vergi3
 ,CASE WHEN K.Pntr =4 THEN SUM(SGD.[FaturaTutar]) -SUM(SGD.ToplamFiyat) ELSE 0 END As    cha_vergi4
 ,CASE WHEN K.Pntr =5 THEN SUM(SGD.[FaturaTutar]) -SUM(SGD.ToplamFiyat) ELSE 0 END As    cha_vergi5
 ,CONVERT(DATE,SG.SiparisTarihi) AS [Tarih]
FROM TEGV_SIPARIS_GIRISI SG WITH (NOLOCK) 
LEFT OUTER JOIN TEGV_SIPARIS_GIRISI_DETAIL SGD WITH (NOLOCK)  ON SG.UserTableID=SGD.MasterTableID
LEFT OUTER JOIN  MikroDB_V16_TEGVIKTISADI.dbo.STOKLAR S WITH (NOLOCK) ON S.sto_kod =SGD.UrunKodu 
LEFT OUTER JOIN dbo.vw_Kdv_Oranlari K WITH (NOLOCK) ON K.Kdv=SGD.Kdv
WHERE 
SG.Durum =1 AND
SG.UserTableID IN (SELECT * FROM dbo.Ayrac (@SiparisID,','))
 AND SG.EntegreTuru=1 AND SGD.FaturaGuid =@BosGuid 
AND S.sto_kod =SGD.UrunKodu
GROUP BY SG.UserTableID ,SG.[CariKodu],SG.[Proje],K.Pntr,SGD.Kdv ,SG.SiparisTarihi 
)A
GROUP BY 
A.ID
,A.[Cari]
,A.[Proje]
,A.[Miktar]
,A.Satýr
,A.Sira
,A.Tarih
ORDER BY A.ID ASC

OPEN Mikro_Fatura

FETCH NEXT FROM Mikro_Fatura INTO  
@FaturaSira,@FaturaSatirno,@FatuaID,@FaturaCari,@FaturaProje,@FaturaMiktar,@Fatura_Tutar,@Fatura_Ara_Toplam
	   ,@cha_vergi1		   ,@cha_vergi2		   ,@cha_vergi3		   ,@cha_vergi4		   ,@cha_vergi5 ,@FaturaDateDay,@cha_altd_kur
WHILE @@FETCH_STATUS = 0 
BEGIN
 SET @Cha_Guid=NEWID()

INSERT INTO /*MikroDB_V16_TEGVIKTISADI*/[MikroDB_V16_TEGVIKTISADI].[dbo].[CARI_HESAP_HAREKETLERI]
           ([cha_Guid]
           ,[cha_DBCno]
           ,[cha_SpecRecNo]
           ,[cha_iptal]
           ,[cha_fileid]
           ,[cha_hidden]
           ,[cha_kilitli]
           ,[cha_degisti]
           ,[cha_CheckSum]
           ,[cha_create_user]
           ,[cha_create_date]
           ,[cha_lastup_user]
           ,[cha_lastup_date]
           ,[cha_special1]
           ,[cha_special2]
           ,[cha_special3]
           ,[cha_firmano]
           ,[cha_subeno]
           ,[cha_evrak_tip]
           ,[cha_evrakno_seri]
           ,[cha_evrakno_sira]
           ,[cha_satir_no]
           ,[cha_tarihi]
           ,[cha_tip]
           ,[cha_cinsi]
           ,[cha_normal_Iade]
           ,[cha_tpoz]
           ,[cha_ticaret_turu]
           ,[cha_belge_no]
           ,[cha_belge_tarih]
           ,[cha_aciklama]
           ,[cha_satici_kodu]
           ,[cha_EXIMkodu]
           ,[cha_projekodu]
           ,[cha_yat_tes_kodu]
           ,[cha_cari_cins]
           ,[cha_kod]
           ,[cha_ciro_cari_kodu]
           ,[cha_d_cins]
           ,[cha_d_kur]
           ,[cha_altd_kur]
           ,[cha_grupno]
           ,[cha_srmrkkodu]
           ,[cha_kasa_hizmet]
           ,[cha_kasa_hizkod]
           ,[cha_karsidcinsi]
           ,[cha_karsid_kur]
           ,[cha_karsidgrupno]
           ,[cha_karsisrmrkkodu]
           ,[cha_miktari]
           ,[cha_meblag]
           ,[cha_aratoplam]
           ,[cha_vade]
           ,[cha_Vade_Farki_Yuz]
           ,[cha_ft_iskonto1]
           ,[cha_ft_iskonto2]
           ,[cha_ft_iskonto3]
           ,[cha_ft_iskonto4]
           ,[cha_ft_iskonto5]
           ,[cha_ft_iskonto6]
           ,[cha_ft_masraf1]
           ,[cha_ft_masraf2]
           ,[cha_ft_masraf3]
           ,[cha_ft_masraf4]
           ,[cha_isk_mas1]
           ,[cha_isk_mas2]
           ,[cha_isk_mas3]
           ,[cha_isk_mas4]
           ,[cha_isk_mas5]
           ,[cha_isk_mas6]
           ,[cha_isk_mas7]
           ,[cha_isk_mas8]
           ,[cha_isk_mas9]
           ,[cha_isk_mas10]
           ,[cha_sat_iskmas1]
           ,[cha_sat_iskmas2]
           ,[cha_sat_iskmas3]
           ,[cha_sat_iskmas4]
           ,[cha_sat_iskmas5]
           ,[cha_sat_iskmas6]
           ,[cha_sat_iskmas7]
           ,[cha_sat_iskmas8]
           ,[cha_sat_iskmas9]
           ,[cha_sat_iskmas10]
           ,[cha_yuvarlama]
           ,[cha_StFonPntr]
           ,[cha_stopaj]
           ,[cha_savsandesfonu]
           ,[cha_avansmak_damgapul]
           ,[cha_vergipntr]
           ,[cha_vergi1]
           ,[cha_vergi2]
           ,[cha_vergi3]
           ,[cha_vergi4]
           ,[cha_vergi5]
           ,[cha_vergi6]
           ,[cha_vergi7]
           ,[cha_vergi8]
           ,[cha_vergi9]
           ,[cha_vergi10]
           ,[cha_vergisiz_fl]
           ,[cha_otvtutari]
           ,[cha_otvvergisiz_fl]
           ,[cha_oiv_pntr]
           ,[cha_oivtutari]
           ,[cha_oiv_vergi]
           ,[cha_oivergisiz_fl]
           ,[cha_fis_tarih]
           ,[cha_fis_sirano]
           ,[cha_trefno]
           ,[cha_sntck_poz]
           ,[cha_reftarihi]
           ,[cha_istisnakodu]
           ,[cha_pos_hareketi]
           ,[cha_meblag_ana_doviz_icin_gecersiz_fl]
           ,[cha_meblag_alt_doviz_icin_gecersiz_fl]
           ,[cha_meblag_orj_doviz_icin_gecersiz_fl]
           ,[cha_sip_uid]
           ,[cha_kirahar_uid]
           ,[cha_vardiya_tarihi]
           ,[cha_vardiya_no]
           ,[cha_vardiya_evrak_ti]
           ,[cha_ebelge_turu]
           ,[cha_tevkifat_toplam]
           ,[cha_ilave_edilecek_kdv1]
           ,[cha_ilave_edilecek_kdv2]
           ,[cha_ilave_edilecek_kdv3]
           ,[cha_ilave_edilecek_kdv4]
           ,[cha_ilave_edilecek_kdv5]
           ,[cha_ilave_edilecek_kdv6]
           ,[cha_ilave_edilecek_kdv7]
           ,[cha_ilave_edilecek_kdv8]
           ,[cha_ilave_edilecek_kdv9]
           ,[cha_ilave_edilecek_kdv10]
           ,[cha_e_islem_turu]
           ,[cha_fatura_belge_turu]
           ,[cha_diger_belge_adi]
           ,[cha_uuid]
           ,[cha_adres_no]
           ,[cha_vergifon_toplam]
           ,[cha_ilk_belge_tarihi]
           ,[cha_ilk_belge_doviz_kuru]
           ,[cha_HareketGrupKodu1]
           ,[cha_HareketGrupKodu2]
           ,[cha_HareketGrupKodu3])
     VALUES
           (       @Cha_Guid    --<cha_Guid, uniqueidentifier,>
           ,       0    --<cha_DBCno, smallint,>
           ,       0    --<cha_SpecRecNo, int,>
           ,       0    --<cha_iptal, bit,>
           ,       51    --<cha_fileid, smallint,>
           ,       0    --<cha_hidden, bit,>
           ,       0    --<cha_kilitli, bit,>
           ,       0    --<cha_degisti, bit,>
           ,       0    --<cha_CheckSum, int,>
           ,       1    --<cha_create_user, smallint,>
           ,       @Date    --<cha_create_date, datetime,>
           ,       1    --<cha_lastup_user, smallint,>
           ,       @Date    --<cha_lastup_date, datetime,>
           ,       'OCT'    --<cha_special1, nvarchar(4),>
           ,       N''    --<cha_special2, nvarchar(4),>
           ,       N''    --<cha_special3, nvarchar(4),>
           ,       0    --<cha_firmano, int,>
           ,       0    --<cha_subeno, int,>
           ,       63    --<cha_evrak_tip, tinyint,>
           ,       @FaturaSeri    --<cha_evrakno_seri, [dbo].[evrakseri_str],>
           ,       @FaturaSira    --<cha_evrakno_sira, int,>
           ,       @FaturaSatirno    --<cha_satir_no, int,>
           ,      @FaturaDateDay-- @Dateday    --<cha_tarihi, datetime,>
           ,       @cha_tip    --<cha_tip, tinyint,>
           ,       @cha_cinsi    --<cha_cinsi, tinyint,>
           ,       0    --<cha_normal_Iade, tinyint,>
           ,       @cha_tpoz    --<cha_tpoz, tinyint,>
           ,       0    --<cha_ticaret_turu, tinyint,>
           ,       N''    --<cha_belge_no, [dbo].[belgeno_str],>
           ,     @FaturaDateDay--  @Dateday    --<cha_belge_tarih, datetime,>
           ,       N''    --<cha_aciklama, nvarchar(40),>
           ,       N''    --<cha_satici_kodu, nvarchar(25),>
           ,       N''    --<cha_EXIMkodu, nvarchar(25),>
           ,       @FaturaProje    --<cha_projekodu, nvarchar(25),>
           ,       N''    --<cha_yat_tes_kodu, nvarchar(25),>
           ,       @cha_cari_cins    --<cha_cari_cins, tinyint,>
           ,       @FaturaCari    --<cha_kod, nvarchar(25),>
           ,        @FaturaCari    --<cha_ciro_cari_kodu, nvarchar(25),>
           ,       0    --<cha_d_cins, tinyint,>
           ,       1    --<cha_d_kur, float,>
           ,       @cha_altd_kur    --<cha_altd_kur, float,>
           ,       @cha_grupno    --<cha_grupno, tinyint,>
           ,       N''    --<cha_srmrkkodu, nvarchar(25),>
           ,       @cha_kasa_hizmet    --<cha_kasa_hizmet, tinyint,>
           ,       @cha_kasa_hizkod    --<cha_kasa_hizkod, nvarchar(25),>
           ,       0    --<cha_karsidcinsi, tinyint,>
           ,       1    --<cha_karsid_kur, float,>
           ,       0    --<cha_karsidgrupno, tinyint,>
           ,       N''    --<cha_karsisrmrkkodu, nvarchar(25),>
           ,       @FaturaMiktar    --<cha_miktari, float,>
           ,       @Fatura_Tutar    --<cha_meblag, float,>
           ,       @Fatura_Ara_Toplam    --<cha_aratoplam, float,>
           ,       @cha_vade    --<cha_vade, int,>
           ,       0    --<cha_Vade_Farki_Yuz, float,>
           ,       0   --<cha_ft_iskonto1, float,>
           ,       0   --<cha_ft_iskonto2, float,>
           ,       0   --<cha_ft_iskonto3, float,>
           ,       0   --<cha_ft_iskonto4, float,>
           ,       0   --<cha_ft_iskonto5, float,>
           ,       0   --<cha_ft_iskonto6, float,>
           ,       0   --<cha_ft_masraf1, float,>
           ,       0   --<cha_ft_masraf2, float,>
           ,       0   --<cha_ft_masraf3, float,>
           ,       0   --<cha_ft_masraf4, float,>
           ,       0   --<cha_isk_mas1, tinyint,>
           ,       0   --<cha_isk_mas2, tinyint,>
           ,       0   --<cha_isk_mas3, tinyint,>
           ,       0   --<cha_isk_mas4, tinyint,>
           ,       0   --<cha_isk_mas5, tinyint,>
           ,       0   --<cha_isk_mas6, tinyint,>
           ,       0   --<cha_isk_mas7, tinyint,>
           ,       0   --<cha_isk_mas8, tinyint,>
           ,       0   --<cha_isk_mas9, tinyint,>
           ,       0   --<cha_isk_mas10, tinyint,>
           ,       0   --<cha_sat_iskmas1, bit,>
           ,       0   --<cha_sat_iskmas2, bit,>
           ,       0   --<cha_sat_iskmas3, bit,>
           ,       0   --<cha_sat_iskmas4, bit,>
           ,       0   --<cha_sat_iskmas5, bit,>
           ,       0   --<cha_sat_iskmas6, bit,>
           ,       0   --<cha_sat_iskmas7, bit,>
           ,       0   --<cha_sat_iskmas8, bit,>
           ,       0   --<cha_sat_iskmas9, bit,>
           ,       0   --<cha_sat_iskmas10, bit,>
           ,       0   --<cha_yuvarlama, float,>
           ,       0   --<cha_StFonPntr, tinyint,>
           ,       0   --<cha_stopaj, float,>
           ,       0   --<cha_savsandesfonu, float,>
           ,       0   --<cha_avansmak_damgapul, float,>
           ,       @Fatura_Kdn_Pntr    --<cha_vergipntr, tinyint,>
           ,       @cha_vergi1    --<cha_vergi1, float,>
           ,       @cha_vergi2    --<cha_vergi2, float,>
           ,       @cha_vergi3    --<cha_vergi3, float,>
           ,       @cha_vergi4   --<cha_vergi4, float,>
           ,       @cha_vergi5    --<cha_vergi5, float,>
           ,       0    --<cha_vergi6, float,>
           ,       0    --<cha_vergi7, float,>
           ,       0    --<cha_vergi8, float,>
           ,       0    --<cha_vergi9, float,>
           ,       0    --<cha_vergi10, float,>
           ,       0    --<cha_vergisiz_fl, bit,>
           ,       0    --<cha_otvtutari, float,>
           ,       0    --<cha_otvvergisiz_fl, bit,>
           ,       0    --<cha_oiv_pntr, tinyint,>
           ,       0    --<cha_oivtutari, float,>
           ,       0    --<cha_oiv_vergi, float,>
           ,       0    --<cha_oivergisiz_fl, bit,>
           ,     @FaturaDateDay--  @Dateday    --<cha_fis_tarih, datetime,>
           ,       @cha_fis_sirano    --<cha_fis_sirano, int,>
           ,       N''    --<cha_trefno, nvarchar(25),>
           ,       0    --<cha_sntck_poz, tinyint,>
           ,       '18991230'    --<cha_reftarihi, datetime,>
           ,       0    --<cha_istisnakodu, tinyint,>
           ,       0    --<cha_pos_hareketi, tinyint,>
           ,       0    --<cha_meblag_ana_doviz_icin_gecersiz_fl, tinyint,>
           ,       0    --<cha_meblag_alt_doviz_icin_gecersiz_fl, tinyint,>
           ,       0    --<cha_meblag_orj_doviz_icin_gecersiz_fl, tinyint,>
           ,       @BosGuid    --<cha_sip_uid, uniqueidentifier,>
           ,       @BosGuid    --<cha_kirahar_uid, uniqueidentifier,>
           ,       '18991230'     --<cha_vardiya_tarihi, datetime,>
           ,        0   --<cha_vardiya_no, tinyint,>
           ,        0   --<cha_vardiya_evrak_ti, tinyint,>
           ,         @cha_ebelge_turu  --<cha_ebelge_turu, tinyint,>
           ,          0 --<cha_tevkifat_toplam, float,>
           ,        0 --<cha_ilave_edilecek_kdv1, float,>
           ,        0 --<cha_ilave_edilecek_kdv2, float,>
           ,        0 --<cha_ilave_edilecek_kdv3, float,>
           ,        0 --<cha_ilave_edilecek_kdv4, float,>
           ,        0 --<cha_ilave_edilecek_kdv5, float,>
           ,        0 --<cha_ilave_edilecek_kdv6, float,>
           ,        0 --<cha_ilave_edilecek_kdv7, float,>
           ,        0 --<cha_ilave_edilecek_kdv8, float,>
           ,        0 --<cha_ilave_edilecek_kdv9, float,>
           ,        0 --<cha_ilave_edilecek_kdv10, float,>
           ,        @cha_e_islem_turu   --<cha_e_islem_turu, tinyint,>
           ,         @cha_fatura_belge_turu  --<cha_fatura_belge_turu, tinyint,>
           ,         N''  --<cha_diger_belge_adi, nvarchar(50),>
           ,        @BosGuid   --<cha_uuid, nvarchar(40),>
           ,        @cha_adres_no   --<cha_adres_no, int,>
           ,        0   --<cha_vergifon_toplam, float,>
           ,        '18991230'    --<cha_ilk_belge_tarihi, datetime,>
           ,        0   --<cha_ilk_belge_doviz_kuru, float,>
           ,        N''   --<cha_HareketGrupKodu1, nvarchar(25),>
           ,        N''   --<cha_HareketGrupKodu2, nvarchar(25),>
           ,        N''   --<cha_HareketGrupKodu3, nvarchar(25),>
		   )




 
UPDATE TEGV_SIPARIS_GIRISI SET Durum =1 WHERE UserTableID =@FatuaID
UPDATE SGD SET FaturaGuid =CONVERT(NVARCHAR(50),@Cha_Guid) 
from TEGV_SIPARIS_GIRISI_DETAIL  SGD WITH (NOLOCK)
LEFT OUTER JOIN  MikroDB_V16_TEGVIKTISADI.dbo.STOKLAR S WITH (NOLOCK) ON S.sto_kod =SGD.UrunKodu 
WHERE MasterTableID =@FatuaID and S.sto_kod =SGD.UrunKodu 

UPDATE S Set sth_fat_uid =FaturaGuid

 FROM /*MikroDB_V16_TEGVIKTISADI*/[MikroDB_V16_TEGVIKTISADI].[dbo].[STOK_HAREKETLERI] S WITH (NOLOCK)  
LEFT OUTER JOIN TEGV_SIPARIS_GIRISI_DETAIL WITH (NOLOCK) ON IrsaliyeGuid=CONVERT(NVARCHAR(50),sth_Guid)
WHERE MasterTableID =@FatuaID  AND IrsaliyeGuid=CONVERT(NVARCHAR(50),sth_Guid)

 SET @EvrakAciklamasiGuid = NEWID ()
INSERT INTO /*MikroDB_V16_TEGVIKTISADI*/[MikroDB_V16_TEGVIKTISADI].[dbo].[EVRAK_ACIKLAMALARI]
           ([egk_Guid]
           ,[egk_DBCno]
           ,[egk_SpecRECno]
           ,[egk_iptal]
           ,[egk_fileid]
           ,[egk_hidden]
           ,[egk_kilitli]
           ,[egk_degisti]
           ,[egk_checksum]
           ,[egk_create_user]
           ,[egk_create_date]
           ,[egk_lastup_user]
           ,[egk_lastup_date]
           ,[egk_special1]
           ,[egk_special2]
           ,[egk_special3]
           ,[egk_dosyano]
           ,[egk_hareket_tip]
           ,[egk_evr_tip]
           ,[egk_evr_seri]
           ,[egk_evr_sira]
           ,[egk_evr_ustkod]
           ,[egk_evr_doksayisi]
           ,[egk_evracik1]
           ,[egk_evracik2]
           ,[egk_evracik3]
           ,[egk_evracik4]
           ,[egk_evracik5]
           ,[egk_evracik6]
           ,[egk_evracik7]
           ,[egk_evracik8]
           ,[egk_evracik9]
           ,[egk_evracik10]
           ,[egk_sipgenkarorani]
           ,[egk_kargokodu]
           ,[egk_kargono]
           ,[egk_tesaltarihi]
           ,[egk_tesalkisi]
           ,[egk_prevwiewsayisi]
           ,[egk_emailsayisi]
           ,[egk_Evrakopno_verildi_fl])
    SELECT 
            @EvrakAciklamasiGuid         --<egk_Guid, uniqueidentifier,>
           ,  0        --<egk_DBCno, smallint,>
           ,  0        --<egk_SpecRECno, int,>
           ,  0        --<egk_iptal, bit,>
           ,  66        --<egk_fileid, smallint,>
           ,  0        --<egk_hidden, bit,>
           ,  0        --<egk_kilitli, bit,>
           ,  0       --<egk_degisti, bit,>
           ,  0        --<egk_checksum, int,>
           ,  1        --<egk_create_user, smallint,>
           ,  @Date        --<egk_create_date, datetime,>
           ,  1        --<egk_lastup_user, smallint,>
           ,  @Date        --<egk_lastup_date, datetime,>
           ,   'OCT'       --<egk_special1, nvarchar(4),>
           ,    N''      --<egk_special2, nvarchar(4),>
           ,    N''      --<egk_special3, nvarchar(4),>
           ,    51      --<egk_dosyano, smallint,>
           ,    @cha_tip      --<egk_hareket_tip, tinyint,>
           ,    63      --<egk_evr_tip, tinyint,>
           ,    @FaturaSeri      --<egk_evr_seri, [dbo].[evrakseri_str],>
           ,     @FaturaSira     --<egk_evr_sira, int,>
           ,     N''     --<egk_evr_ustkod, nvarchar(25),>
           ,     0     --<egk_evr_doksayisi, smallint,>
           ,     SG.AliciAdSoyad     --<egk_evracik1, nvarchar(127),>
           ,     [dbo].[fn_SY_TC_KimlikNo_Duzenleme](SG.AliciTC)     --<egk_evracik2, nvarchar(127),>
           ,     SG.FaturaAdres     --<egk_evracik3, nvarchar(127),>
           ,     SG.PazarYeriNumarasi     --<egk_evracik4, nvarchar(127),>
           ,      SG.SevkAdres    --<egk_evracik5, nvarchar(127),>
           ,  N''        --<egk_evracik6, nvarchar(127),>
           ,  N''         --<egk_evracik7, nvarchar(127),>
           ,  N''         --<egk_evracik8, nvarchar(127),>
           ,  [dbo].[fn_Split](SG.AliciAdSoyad ,1,' ' )           --<egk_evracik9, nvarchar(127),>
           ,  REPLACE (SG.AliciAdSoyad ,[dbo].[fn_Split](SG.AliciAdSoyad ,1,' ' )  ,'')    --<egk_evracik10, nvarchar(127),>
           ,   0       --<egk_sipgenkarorani, float,>
           ,  N''         --<egk_kargokodu, nvarchar(25),>
           ,   N''        --<egk_kargono, nvarchar(15),>
           ,  '18991230'        --<egk_tesaltarihi, datetime,>
           ,   N''       --<egk_tesalkisi, nvarchar(50),>
           ,    0      --<egk_prevwiewsayisi, smallint,>
           ,   0       --<egk_emailsayisi, smallint,>
           ,   0       --<egk_Evrakopno_verildi_fl, bit,>)
FROM EMS_OCTOPOD.dbo.TEGV_SIPARIS_GIRISI SG WITH (NOLOCK)
WHERE SG.UserTableID =@FatuaID

UPDATE TEGV_SIPARIS_GIRISI
SET MikroEvrakAciklamalariGuid =@EvrakAciklamasiGuid ,
AliciTC=[dbo].[fn_SY_TC_KimlikNo_Duzenleme](AliciTC)

WHERE UserTableID=@FatuaID
FETCH NEXT FROM Mikro_Fatura INTO  
@FaturaSira,@FaturaSatirno,@FatuaID,@FaturaCari,@FaturaProje,@FaturaMiktar,@Fatura_Tutar,@Fatura_Ara_Toplam
	   ,@cha_vergi1		   ,@cha_vergi2		   ,@cha_vergi3		   ,@cha_vergi4		   ,@cha_vergi5 ,@FaturaDateDay,@cha_altd_kur
END
CLOSE Mikro_Fatura
DEALLOCATE Mikro_Fatura


SELECT 
MIN(cha_evrakno_seri) AS [FaturaSeri],
MIN(cha_evrakno_sira) As [FaturaSira]
FROM [dbo].[TEGV_SIPARIS_GIRISI] SG WITH (NOLOCK)
  LEFT OUTER JOIN [dbo].[TEGV_SIPARIS_GIRISI_DETAIL] SGD WITH (NOLOCK) ON SG.UserTableID=SGD.MasterTableID
  LEFT OUTER JOIN [dbo].[vw_SY_Siparis_Yonetimi_Entegre_Turu] ET WITH (NOLOCK) ON ET.ID=SG.EntegreTuru 
  LEFT OUTER JOIN MikroDB_V16_TEGVIKTISADI.dbo.CARI_HESAP_HAREKETLERI CH WITH (NOLOCK) ON CONVERT(NVARCHAR(50),CH.cha_Guid)=SGD.FaturaGuid

  WHERE (SG.Durum =1)
 AND  (SG.EntegreTuru =1 AND SGD.IrsaliyeGuid <>'00000000-0000-0000-0000-000000000000' AND SGD.FaturaGuid <>'00000000-0000-0000-0000-000000000000')  
 AND SG.UserTableID =@SiparisID
 GROUP BY SGD.FaturaGuid 


 END 

GO
/****** Object:  StoredProcedure [dbo].[sp_SY_MIKRO_SIPARISLER_INSERT]    Script Date: 10.5.2021 16:17:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

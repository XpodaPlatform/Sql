create PROC [dbo].[sp_XP_MCM_FlowApprove]
(
@UserID INT
,@OnayTipleri NVARCHAR(1000)
)
AS
BEGIN

DECLARE
@FlowString NVARCHAR(MAX)
,@TabloAdi NVARCHAR(200)
,@VarTabloAdi NVARCHAR(50)='#FLOW_APPROVE_TABLE'
,@Sayac INT = 1

IF OBJECT_ID('tempdb..#FLOW_APPROVE_TABLE','u') IS NOT NULL

BEGIN

DROP TABLE #FLOW_APPROVE_TABLE

END

CREATE TABLE #FLOW_APPROVE_TABLE
(
EvrakID INT-- T.UserTableID,
,FormID INT--T.FormTypeID,
,ProjeID INT--T.ProjectID,
,FlowID INT--F.FlowID
,SurecAdi NVARCHAR(100)--[Süreç Adı]
,IhtiyacTipi NVARCHAR(100)--satın alma  ihtiyaç tipi
--,Gorev NVARCHAR(200)--Gorev
,UserFullName NVARCHAR(100)--U.UserFullName
,Durumu NVARCHAR(50)--Durumu
,TalepEden NVARCHAR(50)--[Oluşturan Kullanıcı]
,TalepTarihi NVARCHAR(10)--[Oluşturma Zamanı],
,GuncelleyenKullanici NVARCHAR(50)--[Güncelleyen Kullanıcı]
,GuncellemeZamani DATETIME--[Güncelleme Zamanı] 
,OnayaSunulmaTarihi NVARCHAR(10)--[Onaya Sunulma Tarihi]
,OnayAciklamasi NVARCHAR(200)--[Açıklama]
)


IF @OnayTipleri IN ('','$POnayTipi$')
BEGIN
SET @OnayTipleri=(SELECT 
		  STUFF((SELECT ', ' + FT.FormTableName 
          FROM XPODA_FORM_TYPES FT WITH(NOLOCK)
		  LEFT OUTER JOIN XPODA_PROJECTS P WITH(NOLOCK) ON P.ProjectID=FT.ProjectID
          WHERE P.ApplicationID IN (10,17,7,21) AND FT.FormTypeID IN (251,252,275,286,336,431,433,447) AND FT.IsPassive=0
          FOR XML PATH('')), 1, 1, '') [TableNames])
END

WHILE MikroDB_V16_MCM.dbo.fn_Split(@OnayTipleri,@Sayac,',')COLLATE Turkish_CI_AS<>''
BEGIN
SELECT @TabloAdi=MikroDB_V16_MCM.dbo.fn_Split(@OnayTipleri,@Sayac,',')

SET @FlowString ='
INSERT INTO #InVarTabloAdi#

SELECT 
S.UserTableID As [UserTableID]
,S.FormTypeID AS [|FormTypeID]
,S.ProjectID AS [|ProjectID]
,F.FlowID AS [|FlowID]
, /*XFT.FormType*/
CASE WHEN XFT.FormTableName = ''MCM_ONAY_SATIN_ALMA'' THEN 
	case when (SELECT Sevkiyat FROM MCM_ONAY_SATIN_ALMA WHERE UserTableID = F.FlowDocumentID AND ProjectID = F.FlowProjectID) = ''TRUE'' then ''Sevkiyat'' else ''Sevkiyat Değil'' end
								ELSE XFT.FormType END AS [FormType]
,CASE WHEN XFT.FormTableName = ''MCM_ONAY_SATIN_ALMA'' THEN 
				(SELECT IhtiyacTipi FROM MCM_ONAY_SATIN_ALMA WHERE UserTableID = F.FlowDocumentID AND ProjectID = F.FlowProjectID) ELSE ''Belirtilmedi'' END  as [Satın Alma Tipi]
							
/*,F.FlowItemText as Gorev*/
,U.UserFullName
,case when F.FlowState=0 then ''Beklemede'' when  F.FlowState=1 then ''Tamamlandı''   when  F.FlowState=2 then ''Reddedildi'' else '''' end as Durumu
,(select UserFullName from XPODA_CLIENT_USERS WITH (NOLOCK) where UserID = S.CreateUser) as [Oluşturan Kullanıcı]
,CONVERT(nvarchar(10),(S.CreateDate),104) as [Talep Tarihi]
,(select UserFullName from XPODA_CLIENT_USERS WITH (NOLOCK) where UserID = S.UpdateUser) as [Güncelleyen Kullanıcı]
,S.UpdateDate as [Güncelleme Zamanı]
,CONVERT(nvarchar(10),(F.FlowDateTime),104) AS [Onaya Sunulma Tarihi]
,W.FlowUserDescription as Aciklama
  FROM #InTabloAdi# as S WITH (NOLOCK)/*aakışada gelecek tablo */
  LEFT OUTER JOIN XPODA_FORM_TYPES XFT WITH(NOLOCK) ON XFT.FormTypeID=S.FormTypeID
LEFT OUTER JOIN XPODA_WORK_FLOWS F WITH (NOLOCK) ON F.FlowProjectID=S.ProjectID AND F.FlowDocumentID=S.UserTableID
LEFT OUTER JOIN XPODA_WORK_FLOWS W WITH (NOLOCK) ON W.FlowID=(SELECT Top 1 K.FlowID FROM XPODA_WORK_FLOWS K WITH(NOLOCK) WHERE K.FlowProjectID=S.ProjectID AND K.FlowDocumentID=S.UserTableID AND K.FlowProses IN (''a23'',''a24'')  AND  K.FlowState IN (1,2)/*AND K.FlowState=1*/
 AND K.FlowUserID<>0 Order by K.FlowID Desc )
  left outer join dbo.XPODA_CLIENT_USERS as U WITH (NOLOCK) on U.UserID=F.FlowUserID 
WHERE F.FlowProses IN (''a23'',''a24'') and F.FlowState = 0 AND F.FlowUserID<>0 and F.FlowProjectID=S.ProjectID AND (F.FlowUserID=@InUserID OR @InUserID=0)'

SET @FlowString=REPLACE(@FlowString,'#InTabloAdi#',@TabloAdi)
SET @FlowString=REPLACE(@FlowString,'#InVarTabloAdi#',@VarTabloAdi)

EXEC sp_executesql @FlowString,
     N'@InUserID INT',
	@InUserID=@UserID
	SET @Sayac+=1
END
	
SELECT 

 EvrakID AS [|UserTableID]
,FormID AS [|FormTypeID]
,FlowID AS [|FlowID]
,EvrakID AS [|SatirID]
,FormID AS [|SatirFormID]
,ProjeID AS[|ProjectID]
,FlowID AS [|AkisID]
,EvrakID AS [Talep No]
,SurecAdi AS [Süreç Adı]
,IhtiyacTipi AS [İhtiyaç Tipi]
--,Gorev AS [Görev]
,UserFullName AS [Onay Kullanıcısı]
,Durumu AS Durumu
,TalepEden AS [Talep Eden]
,TalepTarihi AS [Talep Tarihi]
--,GuncelleyenKullanici AS [Güncelleyen Kullanıcı]
--,GuncellemeZamani AS [Güncelleme Zamanı]
,OnayaSunulmaTarihi AS [Onaya Sunulma Tarihi]
,OnayAciklamasi AS [Açıklama]
FROM #FLOW_APPROVE_TABLE
END
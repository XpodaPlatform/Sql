CREATE PROC [dbo].[sp_XP_MCM_Dynamic_Flow_Reporter]
(
@IlkTarih DATE
,@SonTarih DATE
,@Durum NVARCHAR(1)
,@OnayTipleri  NVARCHAR(1000)
,@UserID INT
)
AS
BEGIN
SELECT @IlkTarih=(DATEADD(Day,-1,@IlkTarih)),@SonTarih=(DATEADD(Day,1,@SonTarih))
DECLARE
@FlowString NVARCHAR(MAX)
,@TabloAdi NVARCHAR(200)
,@VarTabloAdi NVARCHAR(50)='#FLOW_DATA_TABLE'
,@ActiveUser INT
--@Personel INT
,@Sayac INT = 1

IF OBJECT_ID('tempdb..#FLOW_DATA_TABLE','u') IS NOT NULL

BEGIN

DROP TABLE #FLOW_DATA_TABLE

END



CREATE TABLE #FLOW_DATA_TABLE
(
 EvrakID INT-- T.UserTableID,
,FormID INT--T.FormTypeID,
,ProjeID INT--T.ProjectID,
,FlowID INT
,AkisAsamasi NVARCHAR(100)--[Akış Aşaması],
,SurecAdi NVARCHAR(100)--[Süreç Adı]
,Gorev NVARCHAR(200)--[Önceki Görev],
,TalepEden NVARCHAR(200)--[Onay Kullanıcısı],
,OnayKullanicisi NVARCHAR(200)--[Onay Kullanıcısı],
,OnayTarih NVARCHAR(10)--[Onay Tarihi],
,GorevAciklamasi NVARCHAR(200)--[Görev Açıklaması]
,OncekiGorev NVARCHAR(200)--[Önceki Görev],
,OncekiGorevKullanici NVARCHAR(200)--[Onceki Gorev Kullanıcı],
,OncekiOnayTarih NVARCHAR(10)--[Önceki Onay Tarihi],
,OncekiGorevAciklamasi NVARCHAR(200)--[Önceki Görev Açıklaması]
,Tarih datetime
)

IF @OnayTipleri IN ('','$PSablonSecimi$')
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
    T.UserTableID,
    T.FormTypeID,
    T.ProjectID,
	F.FlowID,
        [dbo].[fn_XP_MCM_AkisDurum](F.FlowDocumentID,F.FlowItemName,F.FlowUserID,T.ProjectID) as [Akış Aşaması],
		XFT.FormType,
		F.FlowItemText AS [Görev],
		XCU2.UserFullName AS TalepEden,
		XCU.UserFullName as [Onay Kullanıcısı],
		ISNULL(CASE WHEN F.FlowEndDateTime=F.FlowDateTime THEN ''Bekliyor'' ELSE CONVERT(nvarchar(10),(F.FlowEndDateTime),104) END,'''') as [Onay Tarihi],
		F.FlowUserDescription  As [Görev Açıklaması],
        W.FlowItemText AS [Önceki Görev],
        OP.UserFullName as [Önceki Görev Kullanıcı],
		ISNULL(CONVERT(nvarchar(10),(W.FlowEndDateTime),104),'''') as [Önceki Onay Tarihi],
        W.FlowUserDescription  As [Önceki Görev Açıklaması],
		F.FlowEndDateTime as [TarihSirala]
FROM #InTabloAdi# T WITH (NOLOCK)
LEFT OUTER JOIN XPODA_FORM_TYPES XFT WITH(NOLOCK) ON XFT.FormTypeID=T.FormTypeID
LEFT OUTER JOIN XPODA_WORK_FLOWS F WITH (NOLOCK) ON F.FlowProjectID=T.ProjectID and F.FlowDocumentID=T.UserTableID
LEFT OUTER JOIN XPODA_CLIENT_USERS XCU WITH (NOLOCK) ON XCU.UserID=F.FlowUserID   
LEFT OUTER JOIN XPODA_CLIENT_USERS XCU2 WITH (NOLOCK) ON XCU2.UserID=T.CreateUser
LEFT OUTER JOIN XPODA_WORK_FLOWS W WITH (NOLOCK) ON W.FlowID=(SELECT FlowID FROM(SELECT K.FlowID,ROW_NUMBER()OVER (ORDER BY K.FlowID Desc) AS Row FROM XPODA_WORK_FLOWS K WITH(NOLOCK) WHERE K.FlowProjectID=T.ProjectID AND K.FlowDocumentID=T.UserTableID AND K.FlowProses IN (''a23'',''a24'') AND K.FlowState IN (2,1,0) AND K.FlowUserID<>0 )S WHERE Row=2)    
LEFT OUTER JOIN XPODA_CLIENT_USERS OP WITH (NOLOCK) ON OP.UserID=W.FlowUserID    
WHERE 
((F.FlowDateTime BETWEEN @InIlkTarih AND @InSonTarih) OR (F.FlowEndDateTime BETWEEN @InIlkTarih AND @InSonTarih))
AND T.CreateUser=@InUser AND
F.FlowID=(
SELECT Top 1 K.FlowID FROM XPODA_WORK_FLOWS K WITH(NOLOCK)
LEFT OUTER JOIN #InTabloAdi# G WITH(NOLOCK) ON K.FlowDocumentID=G.UserTableID 
 WHERE K.FlowProjectID=T.ProjectID AND K.FlowDocumentID=T.UserTableID AND K.FlowProses IN (''a23'',''a24'')  
 and 1 = (case    when F.FlowState in(0,1,2,3,4)    and @InDurum  = 3 then 1
                        when F.FlowState in(2,4)    and @InDurum  = 2 then 1         
                        when F.FlowState in(1,3)    and @InDurum  = 1 then 1
                        when F.FlowState in(0)      and @InDurum  = 0 then 1 else 0 end)
  AND K.FlowUserID<>0  Order by K.FlowID Desc)'


SET @FlowString=REPLACE(@FlowString,'#InTabloAdi#',@TabloAdi)
SET @FlowString=REPLACE(@FlowString,'#InVarTabloAdi#',@VarTabloAdi)

EXEC sp_executesql @FlowString,
     N'@InIlkTarih DATE, @InSonTarih DATE, @InUser INT, @InDurum NVARCHAR(1)',
	@InIlkTarih=@IlkTarih ,@InSonTarih=@SonTarih, @InUser=@UserID, @InDurum=@Durum

	SET @Sayac+=1
END
SELECT 
 EvrakID AS UserTableID
,FormID AS FormTypeID
,ProjeID AS ProjectID
,EvrakID AS [Talep No]
,FlowID AS [|FlowID]
,AkisAsamasi AS [Akış Aşaması]
,SurecAdi AS [Süreç Adı]
,TalepEden AS [Talep Eden]
,Gorev AS [Görev]
,OnayKullanicisi [Onay Kullanıcısı]
,OnayTarih AS [İşlem Tarihi]
,GorevAciklamasi AS [İşlem Açıklaması]
--,OncekiGorev AS [Önceki Görev]
--,OncekiGorevKullanici AS [Önceki Görev Kullanıcı]
--,OncekiOnayTarih AS [Önceki Onay Tarihi]
--,OncekiGorevAciklamasi AS [Önceki Görev Açıklaması]

FROM #FLOW_DATA_TABLE
ORDER BY Tarih DESC
END

DECLARE @tarihbilgisi DATETIME=GETDATE()
SELECT 'Önceki Ayın Son Günü' Aciklama,CONVERT(VARCHAR(10),DATEADD(dd,-(DAY(@tarihbilgisi)),@tarihbilgisi),112)  Tarih
UNION ALL
SELECT 'Ayın İlk Günü',CONVERT(VARCHAR(10),DATEADD(dd,-(DAY(@tarihbilgisi)-1),@tarihbilgisi),112) AS Date_Value
UNION ALL
SELECT 'Bugünün Tarihi',CONVERT(VARCHAR(10),@tarihbilgisi,112) AS Date_Value
UNION ALL
SELECT 'Ayın Son Günü',CONVERT(VARCHAR(10),DATEADD(dd,-(DAY(DATEADD(mm,1,@tarihbilgisi))),DATEADD(mm,1,@tarihbilgisi)),112) 
UNION ALL
SELECT 'Sonraki Ayın İlk Günü',CONVERT(VARCHAR(10),DATEADD(dd,-(DAY(DATEADD(mm,1,@tarihbilgisi))-1),DATEADD(mm,1,@tarihbilgisi)),112) 
UNION ALL
SELECT 'Haftanın İlk Günü', DATEADD(ww, DATEDIFF(ww,0,GETDATE()), 0)
UNION ALL
SELECT 'Sonraki Haftanın İlk Günü', DATEADD(ww, DATEDIFF(ww,0,GETDATE())+1, 0)
UNION ALL
SELECT 'Yılın İlk Günü',DATEADD(yy, DATEDIFF(yy,0,getdate()), 0)
UNION ALL
SELECT 'Yılın Son Günü',DATEADD(dd,-1,DATEADD(yy,0,DATEADD(yy,DATEDIFF(yy,0,getdate())+1,0)))

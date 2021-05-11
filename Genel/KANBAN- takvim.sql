


declare @DateWeeks table (ID int NOT NULL identity(1,1),Day int,Date datetime,Appointment nvarchar(50) )
declare @sayi int = 0,@tarih datetime='20210103',@StartDate datetime
set @tarih =CONVERT(VARCHAR(10),DATEADD(dd,-(DAY(@tarih)-1),@tarih),112)


set @StartDate = DATEADD(ww, DATEDIFF(ww,0,@tarih), 0)
while @sayi!=35
begin


insert into @DateWeeks
SELECT datepart(day,@StartDate) as Day,@StartDate as Date,CASE WHEN ISNULL(COUNT(*),0)=0 THEN '' ELSE CONVERT(NVARCHAR,COUNT(*)) +' Patient' END as Appointment
FROM HA_PATIENT_ENTRY WITH (NOLOCK) WHERE CONVERT(DATE,Date) = CONVERT(DATE,@StartDate)

set @StartDate = dateadd(day,1,@StartDate)

set @sayi+=1
end

select * from @DateWeeks
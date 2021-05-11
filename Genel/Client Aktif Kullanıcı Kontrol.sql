UPDATE OCTOPOD_CLIENT_USERS 
SET UserOnline = 0,
UserAuthTicket = ''
WHERE UserOnline = 1 AND 
UserID IN ( 
/*Son 1 saat içerisinde bir işlem yapmamış olanların UserID lerini buluyoruz.*/
SELECT OCU.UserID FROM OCTOPOD_SERVICES_LOGS OSL WITH (NOLOCK)
LEFT JOIN OCTOPOD_CLIENT_USERS OCU WITH (NOLOCK) ON OCU.UserID = OSL.UserID
WHERE OCU.UserOnline = 1 
GROUP BY OCU.UserID 
HAVING DATEDIFF(MINUTE,MAX(OSL.CreateDate),GETDATE() ) >= 60
)


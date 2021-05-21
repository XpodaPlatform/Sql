SELECT 
   SS.SEC_NAME,
   STUFF((SELECT '; ' + US.USR_NAME 
          FROM USRS US
          WHERE US.SEC_ID = SS.SEC_ID
          FOR XML PATH('')), 1, 1, '') [SECTORS/USERS]
FROM SALES_SECTORS SS
GROUP BY SS.SEC_ID, SS.SEC_NAME
ORDER BY 1

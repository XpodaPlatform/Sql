USE [EMS_OCTOPOD]
GO
/****** Object:  StoredProcedure [dbo].[sp_NK_SAYIM_ENTEGRE]    Script Date: 7.12.2020 09:59:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_NK_SAYIM_ENTEGRE]							/** V16 - 20 **/
@UDepo INT,
@UStokKodu NVARCHAR(500)--,@UTarih nvarchar(30) 
AS    
DECLARE @Tarih DATETIME,
		@Special1 NVARCHAR(4),				
		@ErrMsg           NVARCHAR(4000),		
		@ErrSeverity      INT,		
		@StokKodu         NVARCHAR(50),		
		@MusteriKodu      NVARCHAR(25),		
		@BelgeNo          NVARCHAR(25),		
		@ATarih           DATETIME,		
		@Miktar           INT,		
		--@sym_RECno        INT,
		@sym_Guid		  NVARCHAR(36),		
		@LotNo            INT,		
		@PartiKodu        NVARCHAR(25),		
		@Barkod           NVARCHAR(25),		
		@EvrakTipi        INT,		
		@EvrakNo          INT,		
		@SatirNo          INT=0,		
		@UserTableID      INT,		
		@Depo             INT,		
		@EvrPartNumber    INT=0,		
		@OldEvrPartNumber INT=0,		
		@AltDovizKuru     FLOAT						
		SET @Tarih=MikroDB_V16_2020_NIKEL.dbo.fn_DatePart(GETDATE())
		SET @AltDovizKuru=MikroDB_V16_2020_NIKEL.dbo.fn_FirmaAlternatifDovizKuru()  
		SET @Special1='SG'
		--Sayım Girişi
		BEGIN TRY
		BEGIN TRANSACTION
		BEGIN    
		DECLARE SAYIM_GIRISI CURSOR LOCAL READ_ONLY FAST_FORWARD FOR  
		SELECT TOP 100 PERCENT	
		S.StokKodu AS StokKodu,	
		S.Miktar,	
		dbo.[fn_NK_CARI_KODU](P.RecNo,P.EvrakTipi) AS CariKodu,	
		P.BelgeNo,	P.EvrakTipi,	
		S.Parti,	
		S.LotNo,	
		S.UserTableID,	
		S.Depo,	
		S.Tarih,	
		S.Barkod,        
		DENSE_RANK() 
		OVER
		(ORDER BY S.Depo,S.Tarih ASC) FROM NK_SAYIM S WITH (NOLOCK)
		LEFT OUTER JOIN NK_PARTI_LOT_DETAYLARI P WITH (NOLOCK) ON S.Barkod=P.Barkod 
		WHERE S.IntegrationID IN ('','0') AND  S.Depo=@UDepo  /*AND S.Tarih=@UTarih*/ AND (P.StokKodu=@UStokKodu OR @UStokKodu='') 
		     
		OPEN SAYIM_GIRISI FETCH 
		 NEXT FROM SAYIM_GIRISI INTO
		@StokKodu,
		@Miktar,
		@MusteriKodu,
		@BelgeNo,
		@EvrakTipi,
		@PartiKodu,
		@LotNo,
		@UserTableID,
		@Depo,
		@ATarih,
		@Barkod,
		@EvrPartNumber 
		WHILE @@FETCH_STATUS = 0 
		BEGIN 
		IF @OldEvrPartNumber<>@EvrPartNumber
		BEGIN  
		SELECT TOP 1 @EvrakNo=MAX(sym_evrakno) from  [MikroDB_V16_2020_NIKEL].[dbo].[SAYIM_SONUCLARI] WITH (NOLOCK) 
		WHERE sym_depono=@UDepo AND sym_tarihi=@Tarih --   @UTarihSET
		set @EvrakNo=ISNULL(@EvrakNo,0)+1  
		SET @SatirNo=0
		SET @OldEvrPartNumber=@EvrPartNumber
		END     
		SET @sym_Guid =NEWID()
		INSERT INTO MikroDB_V16_2020_NIKEL.[dbo].[SAYIM_SONUCLARI]          
           ([sym_Guid]
           ,[sym_DBCno]
           ,[sym_SpecRECno]
           ,[sym_iptal]
           ,[sym_fileid]
           ,[sym_hidden]
           ,[sym_kilitli]
           ,[sym_degisti]
           ,[sym_checksum]
           ,[sym_create_user]
           ,[sym_create_date]
           ,[sym_lastup_user]
           ,[sym_lastup_date]
           ,[sym_special1]
           ,[sym_special2]
           ,[sym_special3]
           ,[sym_tarihi]
           ,[sym_depono]
           ,[sym_evrakno]
           ,[sym_satirno]
           ,[sym_Stokkodu]
           ,[sym_reyonkodu]
           ,[sym_koridorkodu]
           ,[sym_rafkodu]
           ,[sym_miktar1]
           ,[sym_miktar2]
           ,[sym_miktar3]
           ,[sym_miktar4]
           ,[sym_miktar5]
           ,[sym_birim_pntr]
           ,[sym_barkod]
           ,[sym_renkno]
           ,[sym_bedenno]
           ,[sym_parti_kodu]
           ,[sym_lot_no]
           ,[sym_serino])
		  VALUES           
		  (@sym_Guid--<sym_Guid, uniqueidentifier,>
		  ,0--,<sym_DBCno, smallint,>
		  ,0--<sym_SpecRECno, int,>           					
		  ,0--<sym_iptal, bit,>           						
		  ,28---<sym_fileid, smallint,>           				
		  ,0---<sym_hidden, bit,>           					
		  ,0--<sym_kilitli, bit,>           					
		  ,0--<sym_degisti, bit,>           					
		  ,0--<sym_checksum, int,>           					
		  ,1--<sym_create_user, smallint,>           			
		  ,GETDATE()--<sym_create_date, datetime,>           	
		  ,1--<sym_lastup_user, smallint,>           			
		  ,GETDATE()--<sym_lastup_date, datetime,>           	
		  ,@Special1--<sym_special1, nvarchar(4),>           	
		  ,''--<sym_special2, nvarchar(4),>           			
		  ,''--<sym_special3, nvarchar(4),>           			
		  ,@Tarih--<sym_tarihi, datetime,>           			
		  ,@Depo--<sym_depono, int,>           					
		  ,@EvrakNo-- <sym_evrakno, int,>           			
		  ,@SatirNo--<sym_satirno, int,>           				
		  ,@StokKodu --<sym_Stokkodu, nvarchar(25),>           	
		  ,''--<sym_reyonkodu, nvarchar(4),>           			
		  ,''--<sym_koridorkodu, nvarchar(4),>           		
		  ,''--<sym_rafkodu, nvarchar(4),>           			
		  ,@Miktar-- <sym_miktar1, float,>           			
		  ,0--<sym_miktar2, float,>           					
		  ,0--<sym_miktar3, float,>           					
		  ,0--<sym_miktar4, float,>           					
		  ,0--<sym_miktar5, float,>           					
		  ,0--<sym_birim_pntr, tinyint,>           				
		  ,@Barkod--<sym_barkod, nvarchar(25),>           		
		  ,0--<sym_renkno, int,>           						
		  ,0--<sym_bedenno, int,>           					
		  ,@PartiKodu--<sym_parti_kodu, nvarchar(25),>          
		  ,@LotNo--<sym_lot_no, int,>           				
		  ,'')--<sym_serino, nvarchar(25),>)		      		
		  SET @SatirNo=@SatirNo+1  
		  --SELECT @sym_RECno=SCOPE_IDENTITY()    
		 -- UPDATE [MikroDB_V16_2020_NIKEL].dbo.[SAYIM_SONUCLARI] SET sym_Gu=@sym_RECno WHERE sym_RECno=@sym_RECno  
		  UPDATE NK_SAYIM SET IntegrationID=@sym_Guid/*,Miktar=@Miktar*/ WHERE UserTableID=@UserTableID    
		  FETCH NEXT FROM SAYIM_GIRISI INTO @StokKodu,@Miktar,@MusteriKodu,@BelgeNo,@EvrakTipi,@PartiKodu,@LotNo,@UserTableID,@Depo,@ATarih,@Barkod,@EvrPartNumber 
		  END
		  CLOSE SAYIM_GIRISI
		  DEALLOCATE SAYIM_GIRISI  
		  COMMIT TRANSACTION        
		  END
		  END 
		  TRY
		  BEGIN 
		  CATCH ROLLBACK TRAN        
		  IF Cursor_Status('local', 'SAYIM_GIRISI') > -1 
		  CLOSE SAYIM_GIRISI    
		  IF Cursor_Status('local', 'SAYIM_GIRISI') = -1 
		  DEALLOCATE SAYIM_GIRISI                
		  SELECT ERROR_MESSAGE(),ERROR_SEVERITY()    
		  END CATCH


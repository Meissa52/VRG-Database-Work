/********************************************************************************/
/*																				*/
/*	Kroenke, Auer, Vandenberg, and Yoder										*/
/*  Database Processing (15th Edition) Chapters 07/10A							*/
/*																				*/
/*	The View Ridge Gallery (VRG) - Create Stored Procedures						*/
/*																				*/
/*	These are the Microsoft SQL Server 2016/2017 SQL code solutions				*/
/*																				*/
/********************************************************************************/

USE VRG
GO

/*   SQL Stored Procedure - InsertCustomerAndInterests							*/

CREATE PROCEDURE InsertCustomerAndInterests
			@NewLastName		Char(25),
			@NewFirstName		Char(25),
			@NewEmailAddress	Varchar(100),
			@NewAreaCode		Char(3),
			@NewPhoneNumber 	Char(8),
			@Nationality		Char(30)
AS
	DECLARE	@RowCount		AS	Int
	DECLARE	@ArtistID		AS	Int
	DECLARE	@CustomerID		AS	Int
	
	-- Check to see if Customer already exist in database
	
	SELECT	@RowCount = COUNT(*)
	FROM	dbo.CUSTOMER
	WHERE	LastName = @NewLastName
		AND	FirstName = @NewFirstName
		AND EmailAddress =	@NewEmailAddress
		AND AreaCode = @NewAreaCode
		AND PhoneNumber = @NewPhoneNumber;
		
		
	-- IF @RowCount > 0 THEN Customer already exists.
	IF (@RowCount > 0)
		BEGIN
			PRINT '******************************************************'
			PRINT ''
			PRINT '   The Customer is already in the database. '
			PRINT ''
			PRINT '   Customer Last Name         =  '+@NewLastName
			PRINT '   Customer First Name        =  '+@NewFirstName
			PRINT ''
			PRINT '******************************************************'
			RETURN
		END
	-- IF @RowCount = 0 THEN Customer does not exist in database.	
	ELSE
		BEGIN
		-- Insert new Customer data.
			INSERT INTO dbo.CUSTOMER
				(LastName, FirstName, EmailAddress, AreaCode, PhoneNumber)
				VALUES(
				@NewLastName, @NewFirstName,  @NewEmailAddress, @NewAreaCode,
				@NewPhoneNumber);
			-- Get new CustomerID surrogate key value.
			SELECT	@CustomerID = CustomerID
			FROM	dbo.CUSTOMER
			WHERE	LastName = @NewLastName
				AND	FirstName = @NewFirstName
				AND EmailAddress =	@NewEmailAddress
				AND AreaCode = @NewAreaCode
				AND PhoneNumber = @NewPhoneNumber;
				
			PRINT '******************************************************'
			PRINT ''
			PRINT '   The new Customer is now in the database. '
			PRINT ''
			PRINT '   Customer Last Name         =  '+@NewLastName
			PRINT '   Customer First Name        =  '+@NewFirstName
			PRINT ''
			PRINT '******************************************************'
			-- Create intersection record for each appropriate Artist.
			DECLARE ArtistCursor CURSOR FOR
					SELECT	ArtistID
					FROM	dbo.ARTIST
					WHERE	Nationality=@Nationality	
			--Process each appropriate Artist
			OPEN	ArtistCursor
				FETCH NEXT FROM ArtistCursor INTO @ArtistID
						WHILE @@FETCH_STATUS = 0
						BEGIN
							INSERT INTO dbo.CUSTOMER_ARTIST_INT
								(ArtistID, CustomerID)
								VALUES(@ArtistID, @CustomerID);
								PRINT '*************************************************'
								PRINT ''
								PRINT '   New CUSTOMER_ARTIST_INT row added. '
								PRINT ''
								PRINT '   ArtistID    =  '+CONVERT(Char(6), @ArtistID)
								PRINT '   CustomerID  =  '+CONVERT(Char(6), @CustomerID)
								PRINT ''  
								PRINT '*************************************************'
							FETCH NEXT FROM ArtistCursor INTO @ArtistID
						END
			CLOSE	ArtistCursor
			DEALLOCATE	ArtistCursor
		END
		
/*   SQL Stored Procedure - InsertCustomerAndInterests - Test Data				*/

EXEC InsertCustomerAndInterests
	@NewLastName = 'Bench', @NewFirstName = 'Michael',
	@NewEmailAddress = 'Michael.Bench@somewhere.com',
	@NewAreaCode = '206', @NewPhoneNumber = '876-8822',
	@Nationality = 'French';

EXEC InsertCustomerAndInterests
	@NewLastName = 'Benson', @NewFirstName = 'Craig',
	@NewEmailAddress = 'Craig.Benson@somewhere.com',
	@NewAreaCode = '206', @NewPhoneNumber = '876-8732',
	@Nationality = 'French';

/********************************************************************************/
/*   SQL Stored Procedure - InsertCustomerWithTransaction						*/

CREATE PROCEDURE InsertCustomerWithTransaction
			@NewCustomerLastName		Char(25),
			@NewCustomerFirstName		Char(25),
			@NewCustomerEmailAddress	Varchar(100),
			@NewCustomerAreaCode		Char(3),
			@NewCustomerPhoneNumber 	Char(8),
			@ArtistLastName				Char(25),
			@WorkTitle					Char(35),
			@WorkCopy					Char(12),
			@TransSalesPrice			Numeric(8,2)
			
AS
	DECLARE	@RowCount		AS	Int,
			@ArtistID		AS	Int,
			@CustomerID		AS	Int,
			@WorkID			AS	Int,
			@TransactionID	AS	Int
			
	-- Check to see if Customer already exists in database
	
	SELECT	@RowCount = COUNT(*)
	FROM	dbo.CUSTOMER
	WHERE	LastName = @NewCustomerLastName
		AND	FirstName = @NewCustomerFirstName
		AND EmailAddress =	@NewCustomerEmailAddress
		AND AreaCode = @NewCustomerAreaCode
		AND PhoneNumber = @NewCustomerPhoneNumber;
				
	-- IF @RowCount > 0 THEN Customer already exists.
	IF (@RowCount > 0)
		BEGIN
			PRINT '******************************************************'
			PRINT ''
			PRINT '   The Customer is already in the database. '
			PRINT ''
			PRINT '   Customer Last Name    =  '+@NewCustomerLastName
			PRINT '   Customer First Name   =  '+@NewCustomerFirstName
			PRINT ''
			PRINT '******************************************************'
			RETURN
		END
	-- IF @RowCount = 0 THEN Customer does not exist in database.	
	ELSE
		-- Start transaction - Rollback everything if unable to complete it.	
		BEGIN TRANSACTION
			-- Insert new Customer data.
			INSERT INTO dbo.CUSTOMER
				(LastName, FirstName, EmailAddress, AreaCode, PhoneNumber)
				VALUES(
				@NewCustomerLastName, @NewCustomerFirstName,
				@NewCustomerEmailAddress, @NewCustomerAreaCode, @NewCustomerPhoneNumber);
			-- Get new CustomerID surrogate key value.
			SELECT	@CustomerID = CustomerID
			FROM	dbo.CUSTOMER
			WHERE	LastName = @NewCustomerLastName
				AND	FirstName = @NewCustomerFirstName
				AND EmailAddress =	@NewCustomerEmailAddress
				AND AreaCode = @NewCustomerAreaCode
				AND PhoneNumber = @NewCustomerPhoneNumber;
				
			-- Get ArtistID surrogate key value, check for validity.
			SELECT	@ArtistID = ArtistID
			FROM	dbo.ARTIST
			WHERE	LastName = @ArtistLastName;
			
			IF @ArtistID IS NULL
				BEGIN
					PRINT '******************************************************'
					PRINT ''
					PRINT '   Invalid ArtistID '
					PRINT ''
					PRINT '******************************************************'
					ROLLBACK TRANSACTION
					RETURN
				END
			
			-- Get WorkID surrogate key value, check for validity.
			SELECT	@WorkID = WorkID
			FROM	dbo.WORK
			WHERE	ArtistID = @ArtistID
				AND	Title = @WorkTitle
				AND Copy = @WorkCopy;
			
			IF @WorkID IS NULL
				BEGIN
					PRINT '******************************************************'
					PRINT ''
					PRINT '   Invalid WorkID '
					PRINT ''
					PRINT '******************************************************'
					ROLLBACK TRANSACTION
					RETURN
				END
	
			-- Get TransID surrogate key value, check for validity.
			SELECT	@TransactionID = TransactionID
			FROM	dbo.TRANS
			WHERE	WorkID = @WorkID
				AND	SalesPrice IS NULL;
			
			IF @TransactionID IS NULL
				BEGIN
					PRINT '******************************************************'
					PRINT ''
					PRINT '   Invalid TransactionID '
					PRINT ''
					PRINT '******************************************************'
					ROLLBACK TRANSACTION
					RETURN
				END
			
			-- All surrogate key values of OK, complete the transaction
			BEGIN
				-- Update TRANS row
				UPDATE	dbo.TRANS
				SET		DateSold = GETDATE(),
						SalesPrice = @TransSalesPrice,
						CustomerID = @CustomerID
				WHERE	TransactionID = @TransactionID;
				-- Create CUSTOMER_ARTIST_INT row
				INSERT INTO dbo.CUSTOMER_ARTIST_INT (CustomerID, ArtistID)
						VALUES(@CustomerID, @ArtistID);
			END		
		-- Commit the Transaction
		COMMIT TRANSACTION
		-- The transaction is completed. Print output
		BEGIN
			-- Print Customer results.
			PRINT '******************************************************'
			PRINT ''
			PRINT '   The new Customer is now in the database. '
			PRINT ''
			PRINT '   Customer Last Name	=  '+@NewCustomerLastName
			PRINT '   Customer First Name	=  '+@NewCustomerFirstName
			PRINT ''
			PRINT '******************************************************'
			-- Print Transaction result
			PRINT ''
			PRINT '   Transaction complete. '
			PRINT ''
			PRINT '   TransactionID			=  '+CONVERT(Char(6), @TransactionID)
			PRINT '   ArtistID				=  '+CONVERT(Char(6), @ArtistID)
			PRINT '   WorkID				=  '+CONVERT(Char(6), @WorkID)
			PRINT '   Sales Price			=  '+CONVERT(Char(12), @TransSalesPrice)
			PRINT ''  
			PRINT '******************************************************'
			-- Print CUSTOMER_ARTIST_INT update	
			PRINT ''
			PRINT '   New CUSTOMER_ARTIST_INT row added. '
			PRINT ''
			PRINT '   ArtistID				=  '+CONVERT(Char(6), @ArtistID)
			PRINT '   CustomerID			=  '+CONVERT(Char(6), @CustomerID)
			PRINT ''  
			PRINT '******************************************************'
		END	
	-- ***** End of stored procedure InsertCustomerWithTransaction *****						

/*   SQL Stored Procedure - InsertCustomerWithTransaction - Test Data			*/

EXEC InsertCustomerWithTransaction
	@NewCustomerLastName = 'Gliddens', @NewCustomerFirstName = 'Melinda',
	@NewCustomerEmailAddress = 'Melinda.Gliddens@somewhere.com',
	@NewCustomerAreaCode = '360', @NewCustomerPhoneNumber = '765-8877',
	@ArtistLastName = 'Sargent', @WorkTitle = 'Spanish Dancer',
	@WorkCopy = '588/750', @TransSalesPrice = 350.00;

/********************************************************************************/



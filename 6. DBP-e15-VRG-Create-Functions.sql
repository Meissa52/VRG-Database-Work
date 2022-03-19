/********************************************************************************/
/*																				*/
/*	Kroenke, Auer, Vandenberg, and Yoder										*/
/*  Database Processing (15th Edition) Chapters 07/10A							*/
/*																				*/
/*	The View Ridge Gallery (VRG) - User-Defined Functions						*/
/*																				*/
/*	These are the Microsoft SQL Server 2016/2017 SQL code solutions				*/
/*																				*/
/********************************************************************************/

USE VRG
GO

/********************************************************************************/

CREATE FUNCTION dbo.NameConcatenation 

-- These are the input parameters
(
	@FirstName		CHAR(25),
	@LastName		CHAR(25)
)
RETURNS VARCHAR(60)
AS
BEGIN
	-- This is the variable that will hold the value to be returned
	DECLARE @FullName VARCHAR(60);

	-- SQL statements to concatenate the names in the proper order
	SELECT @FullName = RTRIM(@LastName);
	IF @FirstName IS NOT NULL
		SELECT @FullName = @FullName + ', ' + RTRIM(@FirstName);
	
	-- Return the concatentate name
	RETURN @FullName;
END


/************************************************************************/
USE VRG
GO

CREATE FUNCTION dbo.NameConcatenation 

-- These are the input parameters
(
	@FirstName		CHAR(25),
	@LastName		CHAR(25)
)
RETURNS VARCHAR(60)
AS
BEGIN
	-- This is the variable that will hold the value to be returned
	DECLARE @FullName VARCHAR(60);

	-- SQL statements to concatenate the names in the proper order
	SELECT @FullName = RTRIM(@LastName) + ', ' + RTRIM(@FirstName);
	
	-- Return the concatentate name
	RETURN @FullName;
END;


/************************************************************************/

/* *** SQL-Query-CH07-01 *** */

SELECT		RTRIM(LastName)+', '+RTRIM(FirstName) AS CustomerName, 
			AreaCode, PhoneNumber, EmailAddress
FROM		CUSTOMER
ORDER BY	CustomerName;

/************************************************************************/

/* *** SQL-Query-CH07-02 *** */

SELECT		dbo.NameConcatenation(FirstName, LastName) AS CustomerName, 
			AreaCode, PhoneNumber, EmailAddress
FROM		CUSTOMER
ORDER BY	CustomerName;

/************************************************************************/
/* *** SQL-Query-CH07-03 *** */

SELECT		dbo.NameConcatenation(FirstName, LastName) AS ArtistName, 
			DateOfBirth, DateDeceased
FROM		ARTIST
ORDER BY	ArtistName;

/************************************************************************/
/* *** Figure 7-21 SQL-Query-CH07-04 ***							    */

SELECT		dbo.NameConcatenation(C.FirstName, C.LastName) AS CustomerName,
			dbo.NameConcatenation(A.FirstName, A.LastName) AS ArtistName
FROM		CUSTOMER AS C JOIN CUSTOMER_ARTIST_INT AS CAI
	ON		C.CustomerID = CAI.CustomerID
				JOIN	ARTIST AS A
					ON	CAI.ArtistID = A.ArtistID
ORDER BY	CustomerName, ArtistName;


/************************************************************************/

USE VRG
GO

CREATE FUNCTION dbo.GetLastNameCommaSeparated

-- These are the input parameters
(
	@Name			VARCHAR(25)
)
RETURNS VARCHAR(25)
AS
BEGIN
	-- This is the variable that will hold the value to be returned
	DECLARE @LastName		VARCHAR(25);

	-- This is the variable that will hold the position of the comma
	DECLARE @IndexValue		INT;

	-- SQL statement to find the comma deparator 

	SELECT @IndexValue = CHARINDEX(',', @Name);
	
	-- SQL statement to determine last name
	SELECT @LastName = SUBSTRING(@Name, 1, (@IndexValue - 1));

	-- Return the last name
	RETURN @LastName;
END;


/************************************************************************/

SELECT		ArtistName, dbo.GetLastNameCommaSeparated(ArtistName) AS ArtistLastName 
FROM		POSTCARDS$
ORDER BY	ArtistName;

/************************************************************************/

ALTER TABLE POSTCARDS$
	ADD		ArtistLastName		Char(25)		NULL;

ALTER TABLE POSTCARDS$
	ADD		ArtistID			Int				NULL;


SELECT		*	FROM POSTCARDS$;

/************************************************************************/

UPDATE		POSTCARDS$
	SET		ArtistLastName = dbo.GetLastNameCommaSeparated(ArtistName);

UPDATE		POSTCARDS$
	SET		ArtistID =  
			(SELECT	ArtistID 
			 FROM	ARTIST
			 WHERE	ARTIST.LastName = POSTCARDS$.ArtistLastName);

SELECT		*	FROM POSTCARDS$;

/************************************************************************/
--  CREATE TABLE 

/************************************************************************/
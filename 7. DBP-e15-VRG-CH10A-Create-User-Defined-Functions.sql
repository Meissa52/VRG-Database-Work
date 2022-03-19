/********************************************************************************/
/*																				*/
/*	Kroenke and Auer - Database Processing (14th Edition) Chapter 10A			*/
/*																				*/
/*	The View Ridge Gallery (VRG) - User Defined Functions						*/
/*																				*/
/*	These are the Microsoft SQL Server 2012 / 2014 SQL code solutions			*/
/*																				*/
/********************************************************************************/


USE VRG
GO

/* *** SQL-Query-CH10A-02 *** */

SELECT		RTRIM(FirstName)+' '+RTRIM(LastName) AS CustomerName, 
			Street, City, State, ZIPorPostalCode
FROM		CUSTOMER
ORDER BY	CustomerName;

/********************************************************************************/

CREATE FUNCTION dbo.FirstNameFirst 

-- These are the input parameters
(
	@FirstName		CHAR(25),
	@LastName		CHAR(25)
)

RETURNS VARCHAR(60)
AS
BEGIN
	-- This is the variable that will hold the value to be returned
	DECLARE @FullName VARCHAR(60)

	-- SQL statements to concatenate the names in the proper order
	SELECT @FullName = RTRIM(@FirstName) + ' ' + RTRIM(@LastName);
	
	-- Return the concatenated name
	RETURN @FullName
END


/* *** SQL-Query-CH10A-03 *** */

SELECT		dbo.FirstNameFirst(FirstName, LastName) AS CustomerName, 
			Street, City, [State], ZIPorPostalCode
FROM		CUSTOMER
ORDER BY	CustomerName;

/* *** SQL-Query-CH10A-04 *** */

SELECT		dbo.FirstNameFirst(FirstName, LastName) AS ArtistName, 
				DateOfBirth, DateDeceased
FROM		ARTIST
ORDER BY	ArtistName;

/* *** SQL-Query-CH10A-05 *** */

SELECT		dbo.FirstNameFirst(C.FirstName, C.LastName) AS CustomerName,
			dbo.FirstNameFirst(A.FirstName, A.LastName) AS ArtistName
FROM		CUSTOMER AS C JOIN CUSTOMER_ARTIST_INT AS CAI
	ON		C.CustomerID = CAI.CustomerID
				JOIN		ARTIST AS A
					ON	CAI.ArtistID = A.ArtistID
ORDER BY	CustomerName, ArtistName;

/********************************************************************************/

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


/* *** SQL-Query-CH10A-06 *** */

SELECT		ArtistName,
			dbo.GetLastNameCommaSeparated(ArtistName) AS ArtistLastName
FROM		POSTCARDSwithID$
ORDER BY	ArtistName;

/* *** SQL-ALTER-TABLE-CH10A-01 *** */

ALTER TABLE POSTCARDSwithID$
	ADD ArtistLastName Char(25) NULL;

/* *** SQL-ALTER-TABLE-CH10A-01 *** */

ALTER TABLE POSTCARDSwithID$
	ADD ArtistID Int NULL;

/* *** SQL-Query-CH10A-03 *** */

SELECT		* 
FROM		POSTCARDSwithID$;

/* *** SQL-UPDATE-CH10A-01 *** */

UPDATE POSTCARDSwithID$
	SET ArtistLastName = dbo.GetLastNameCommaSeparated(ArtistName);

/* *** SQL-UPDATE-CH10A-02 *** */

UPDATE POSTCARDSwithID$
	SET ArtistID =
		(SELECT		ArtistID
		 FROM		ARTIST
		 WHERE		ARTIST.LastName = POSTCARDSwithID$.ArtistLastName);

/* *** SQL-Query-CH10A-04 *** */

SELECT		* 
FROM		POSTCARDSwithID$;

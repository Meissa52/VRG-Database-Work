/********************************************************************************/
/*																				*/
/*	Kroenke and Auer - Database Processing (14th Edition) Appendix K08			*/
/*																				*/
/*	The View Ridge Gallery (VRG) - Query Statements								*/
/*																				*/
/*	These are the Microsoft SQL Server 2012 / 2014 SQL code solutions			*/
/*																				*/
/********************************************************************************/

USE VRG
GO

/* *** SQL-Query-AppK-01 *** */

SELECT		*
FROM		ARTIST
		FOR	XML RAW;

/* *** SQL-Query-AppK-02 *** */

SELECT		*
FROM			ARTIST
		FOR	XML AUTO, ELEMENTS;
















/* *** SQL-Query-AppK-03 *** */

SELECT			CUSTOMER.LastName AS CustomerLastName,
				CUSTOMER.FirstName AS CustomerFirstName,
				ARTIST.LastName AS ArtistName
FROM			CUSTOMER JOIN CUSTOMER_ARTIST_INT
		ON		CUSTOMER.CustomerID = CUSTOMER_ARTIST_INT.CustomerID
				JOIN ARTIST
					ON		CUSTOMER_ARTIST_INT.ArtistID = ARTIST.ArtistID
ORDER BY		CUSTOMER.LastName, ARTIST.LastName
		FOR	XML AUTO, ELEMENTS;

/* *** SQL-Query-AppK-04 *** */

SELECT		CUSTOMER.LastName AS CustomerLastName,
				CUSTOMER.FirstName AS CustomerFirstName,
				TRANS.TransactionID, SalesPrice,
				WORK.WorkID, Title, Copy,
				ARTIST.LastName AS ArtistLastName,
				ARTIST.FirstName AS AristFirstName
FROM			CUSTOMER JOIN TRANS
		ON 	CUSTOMER.CustomerID = TRANS.CustomerID
				JOIN [WORK]
					ON		TRANS.WorkID = WORK.WorkID
							JOIN		ARTIST
										ON		WORK.ArtistID = ARTIST.ArtistID
ORDER BY	CUSTOMER.LastName, ARTIST.LastName
		FOR	XML AUTO, ELEMENTS;



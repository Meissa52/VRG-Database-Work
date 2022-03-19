/********************************************************************************/
/*																				*/
/*	Kroenke, Auer, Vandenberg, and Yoder										*/
/*	Database Processing (15th Edition) Chapters 07/10A							*/
/*																				*/
/*	The View Ridge Gallery (VRG) Database - Create Views						*/
/*																				*/
/*	These are the Microsoft SQL Server 2016/2017 SQL code solutions				*/
/*																				*/
/********************************************************************************/

USE VRG
GO


/*   SQL View SQL-CREATE-VIEW-CH07-01 - CustomerNameView						*/

CREATE VIEW CustomerNameView AS
	SELECT	LastName AS CustomerLastName,
			FirstName AS CustomerFirstName
	FROM	CUSTOMER;

/*   SQL View SQL-Query-View-CH07-01 - CustomerNameView						   */

SELECT		*
FROM		CustomerNameView
ORDER BY	CustomerLastName, CustomerFirstName; 

/*   SQL View SQL-CREATE-VIEW-CH07-02 - CustomerBasicDataView					*/

CREATE VIEW CustomerBasicDataView AS
	SELECT	LastName AS CustomerLastName,
			FirstName AS CustomerFirstName,
			AreaCode, PhoneNumber
	FROM 	CUSTOMER;

/*   SQL View SQL-Query-View-CH07-02 - CustomerBasicDataView					*/

SELECT		*
FROM		CustomerBasicDataView
ORDER BY	CustomerLastName, CustomerFirstName; 

/*   SQL View SQL-CREATE-VIEW-CH07-03 - CustomerBasicDataWAView					*/

CREATE VIEW CustomerBasicDataWAView AS
	SELECT	LastName AS CustomerLastName,
			FirstName AS CustomerFirstName,
			AreaCode, PhoneNumber
	FROM 	CUSTOMER
	WHERE	State = 'WA';

/*   SQL View SQL-Query-View-CH07-03 - CustomerBasicDataWAView					*/

SELECT		*
FROM		CustomerBasicDataWAView
ORDER BY	CustomerLastName, CustomerFirstName; 

/*   SQL View SQL-CREATE-VIEW-CH07-04 - CustomerPhoneView						*/

CREATE VIEW CustomerPhoneView AS
	SELECT	LastName AS CustomerLastName,
			FirstName AS CustomerFirstName,
			('(' + AreaCode + ') ' + PhoneNumber) As CustomerPhone
	FROM 	CUSTOMER;

/*   SQL View SQL-Query-View-CH07-04 - CustomerPhoneView						*/

SELECT		*
FROM		CustomerPhoneView
ORDER BY	CustomerLastName, CustomerFirstName; 

/*   SQL View SQL-CREATE-VIEW-CH07-05 - CustomerInterestsView					*/

CREATE VIEW CustomerInterestsView AS
	SELECT	C.LastName AS CustomerLastName,
			C.FirstName AS CustomerFirstName,
			A.LastName AS ArtistName
	FROM	CUSTOMER AS C JOIN CUSTOMER_ARTIST_INT AS CAI
		ON	C.CustomerID = CAI.CustomerID
			JOIN	ARTIST AS A
				ON	CAI.ArtistID = A.ArtistID;

/*   SQL View SQL-Query-View-CH07-05 - CustomerInterestsView					*/
 
SELECT		*
FROM		CustomerInterestsView
ORDER BY	CustomerLastName, CustomerFirstName; 

/*   SQL View SQL-CREATE-VIEW-CH07-06 - ArtistWorkNetView						*/

CREATE VIEW ArtistWorkNetView AS
	SELECT	LastName AS ArtistLastName,
			FirstName AS ArtistFirstName,
			W.WorkID, Title, Copy, DateSold,
			AcquisitionPrice, SalesPrice,
			(SalesPrice - AcquisitionPrice) AS NetProfit
	FROM	TRANS AS T JOIN	WORK AS W
		ON 	T.WorkID = W.WorkID
			JOIN 	ARTIST AS A
				ON 	W.ArtistID = A.ArtistID;

/*   SQL View SQL-Query-View-CH07-06 - ArtistWorkNetView						*/

SELECT		ArtistLastName, ArtistFirstName,
			WorkID, Title, Copy, DateSold, NetProfit
FROM		ArtistWorkNetView
WHERE		NetProfit > 5000
ORDER BY	DateSold;


/*   SQL View SQL-CREATE-VIEW-CH07-07 - ArtistWorkTotalNetView					*/

CREATE VIEW ArtistWorkTotalNetView AS
	SELECT		ArtistLastName, ArtistFirstName,
				WorkID, Title, Copy,
				SUM(NetProfit)AS TotalNetProfit
	FROM		ArtistWorkNetView
	GROUP BY	ArtistLastName, ArtistFirstName,
				WorkID, Title, Copy;

/*   SQL View SQL-Query-View-CH07-07 - ArtistWorkTotalNetView					*/
	
SELECT		*
FROM		ArtistWorkTotalNetView
WHERE		TotalNetProfit > 5000
ORDER BY	TotalNetProfit;

/*   SQL View SQL-CREATE-VIEW-CH07-08 - CustomerTableBasicDataView				*/

CREATE VIEW CustomerTableBasicDataView AS
	SELECT		*
	FROM		CUSTOMER;
	
/*   SQL View SQL-Query-View-CH07-08 - CustomerTableBasicDataView				*/	
	
SELECT		*
FROM		CustomerTableBasicDataView;


/* *** FOR CHAPTER 10A *** ******************************************************/


/*   SQL View SQL-CREATE-VIEW-CH10A-01 – WorkAndTransView						*/

CREATE VIEW		WorkAndTransView AS
	SELECT		Title, Copy, Medium, [Description], ArtistID,
				DateAcquired, AcquisitionPrice
	FROM		WORK AS W JOIN TRANS AS T
		ON		W.WorkID = T.WorkID;
	
		
/*   SQL View SQL-Query-View-CH10A-01 - WorkAndTransView							*/	
	
SELECT		*
FROM		WorkAndTransView
ORDER BY	DateAcquired;


/********************************************************************************/


						
			
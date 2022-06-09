DROP DATABASE DBHousing;
CREATE DATABASE DBHousing;	
CREATE TABLE Customer (
    CustomerID varchar(255) PRIMARY KEY,
    FullName Nvarchar(255),
    PhoneNumber varchar(255),
	Company Nvarchar(255) 
);
CREATE TABLE House (
    HouseID varchar(255) PRIMARY KEY,
    Address Nvarchar(255),
    Price money,
	Host Nvarchar(255) 
);

CREATE TABLE Contract (
    HouseID varchar(255),
    CustomerID varchar(255),
    StartDate date,
	EndDate date,
	CONSTRAINT PK_Contract PRIMARY KEY (HouseID,CustomerID),
	CONSTRAINT FK_Contract1 FOREIGN KEY (HouseID)
    REFERENCES House(HouseID),
	CONSTRAINT FK_Contract2 FOREIGN KEY (CustomerID)
    REFERENCES Customer(CustomerID)
);




SELECT Address,Host 
FROM House
WHERE Price > 10000000;

SELECT Customer.CustomerID,FullName,Company
FROM Customer
JOIN Contract ON Customer.CustomerID = Contract.CustomerID
JOIN House ON Contract.HouseID = House.HouseID
WHERE House.Host = N'Nông Văn Dền';

SELECT * FROM House
WHERE HouseID NOT IN (
	SELECT HouseID FROM Contract
);
-- Ming
SELECT Price as MaxPrice FROM House
WHERE Price >= ALL ( Select Price FROM House 
						WHERE HouseID IN (SELECT DISTINCT HouseID FROM Contract) );

DROP INDEX Customer.index_Company;
DROP INDEX House.index_Host;

SELECT * FROM Customer 
WHERE Company = 'Placerat Orci Industries';

SELECT Host,Count(HouseID) as HouseNumber
FROM House
Group BY Host;



CREATE INDEX index_Company
ON Customer (Company);

CREATE INDEX index_Host
ON House (Host);

SELECT * FROM Customer 
WHERE Company = 'Placerat Orci Industries';

SELECT Host,Count(HouseID) as HouseNumber
FROM House
Group BY Host;

GO
CREATE PROCEDURE ListContract @Money money
AS
SELECT * FROM Contract 
JOIN House ON Contract.HouseID = House.HouseID
WHERE Price >= @Money;
GO

EXEC ListContract @Money = 10000000;

GO
CREATE PROCEDURE TotalConTract @Money money
AS
with foo as(
select DATEDIFF (month,StartDate,EndDate) as RentMonth ,CustomerID from Contract
Group BY CustomerID,StartDate,EndDate
)
SELECT Customer.CustomerID,Customer.FullName,Customer.PhoneNumber,Customer.Company FROM Customer
JOIN foo ON Customer.CustomerID = foo.CustomerID
JOIN Contract ON foo.CustomerID = Contract.CustomerID
JOIN House ON Contract.HouseID = House.HouseID
GROUP BY Customer.CustomerID,Customer.FullName,Customer.PhoneNumber,Customer.Company 
HAVING SUM(House.Price*RentMonth) >= @Money;
GO

EXEC TotalContract @Money = 70000000;
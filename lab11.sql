USE master
GO

IF(DB_ID('lab11')IS NOT NULL)
	DROP DATABASE lab11
GO

CREATE DATABASE lab11
GO

USE lab11
GO

CREATE TABLE Customer(
	CusTel varchar(10) constraint pk_custel primary key,
	CusName nvarchar(30),
	CusAddress nvarchar(100),
	CusBirthDay date
)

CREATE TABLE PhoneBook(
	Tel varchar(10),constraint fk_tel foreign key (Tel) references Customer(CusTel),
	Phone varchar(10),constraint pk_phonebook primary key (Tel,Phone)
)

SELECT * FROM Customer,PhoneBook
--3
INSERT INTO Customer
VALUES  ('0987654321','Nguyen Van A','111 Nguyen Trai, Thanh Xuan, Ha Noi','2000-01-01'),
		('0987654322','Nguyen Van B','112 Nguyen Trai, Thanh Xuan, Ha Noi','2000-02-02'),
		('0987654323','Nguyen Van C','113 Nguyen Trai, Thanh Xuan, Ha Noi','2000-03-03'),
		('0987654324','Nguyen Van D','114 Nguyen Trai, Thanh Xuan, Ha Noi','2000-04-04'),
		('0987654325','Nguyen Van E','115 Nguyen Trai, Thanh Xuan, Ha Noi','2000-05-05')
		
INSERT INTO PhoneBook
VALUES  ('0987654321','0987654322'),
		('0987654321','0987654323'),
		('0987654321','0987654324'),
		('0987654321','0987654325'),
		('0987654322','0987654321'),
		('0987654322','0987654323'),
		('0987654322','0987654324'),
		('0987654322','0987654325'),
		('0987654323','0987654321'),
		('0987654323','0987654322'),
		('0987654323','0987654324'),
		('0987654323','0987654325'),
		('0987654324','0987654321'),
		('0987654324','0987654322'),
		('0987654324','0987654323'),
		('0987654324','0987654325')

--4
SELECT PhoneBook.Phone,Customer.* 
FROM PhoneBook 
INNER JOIN Customer 
ON Customer.CusTel = PhoneBook.Phone 
WHERE PhoneBook.Tel = '0987654321' --a

SELECT Phone FROM PhoneBook WHERE PhoneBook.Tel = '0987654321' --b

--5
SELECT PhoneBook.Phone,Customer.* 
FROM PhoneBook 
INNER JOIN Customer 
ON Customer.CusTel = PhoneBook.Phone 
WHERE PhoneBook.Tel = '0987654321'
ORDER BY Customer.CusName --a

SELECT CusTel FROM Customer WHERE CusName = 'Nguyen Van A' --b

SELECT CusName FROM Customer WHERE CusBirthDay = '2000-03-03' --c

--6
SELECT CusName, COUNT(CusTel) AS 'Total Phone Number' 
FROM Customer 
GROUP BY CusName --a

SELECT COUNT(CusBirthDay) AS 'SN T2' FROM Customer
WHERE CONVERT(varchar,DATEPART(mm,CusBirthDay)) = '2' --b

SELECT * FROM Customer --c

SELECT * FROM Customer WHERE CusTel = '0987654321'

--7
ALTER TABLE Customer
	ADD CONSTRAINT CHK_birthday CHECK(CusBirthDay<GETDATE()) --a

EXECUTE sp_depends Customer --b

ALTER TABLE Customer
	ADD StartDate DATE --c

--8
CREATE INDEX IX_HoTen ON Customer(CusName)
CREATE INDEX IX_SoDienThoai ON Customer(CusTel) --a

CREATE VIEW View_SoDienThoai AS
SELECT CusTel, CusName
FROM Customer
GO
SELECT * FROM View_SoDienThoai

CREATE VIEW View_SinhNhat AS
SELECT CusName, CusTel, CusBirthDay
FROM Customer
WHERE CONVERT(varchar,DATEPART(mm,CusBirthDay)) = CONVERT(varchar,DATEPART(mm,GETDATE()))
GO
SELECT * FROM View_SinhNhat --b

CREATE PROCEDURE SP_Them_DanhBa 
	@Tel varchar(10),
	@Name nvarchar(30),
	@Address nvarchar(100),
	@BirthDay date
AS
BEGIN
INSERT INTO Customer(CusTel,CusName,CusAddress,CusBirthDay)
VALUES(@Tel,@Name,@Address,@BirthDay)
END
GO

EXECUTE SP_Them_DanhBa '0123456789','Nguyen Van G','HCM','1999-01-01'

CREATE PROCEDURE SP_Tim_DanhBa 
	@Name nvarchar(30)
AS
SELECT * FROM Customer
WHERE Customer.CusName LIKE @Name
GO


EXECUTE SP_Tim_DanhBa 'nguyen van a' --c
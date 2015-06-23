
CREATE PROCEDURE CRY(@COL VARCHAR(20))
AS
BEGIN
	/*DECLARE @SQL NVARCHAR(2000)
	SET @SQL = 'UPDATE test SET '+@COL+' = DBO.decrypt('+@COL+')'
	EXEC SP_EXECUTESQL @SQL, N'@COL VARCHAR(20)', @COL	
	DECLARE @SQL_INSERT NVARCHAR(2000)
	SET @SQL_INSERT = 'INSERT INTO mark(colu)VALUES(@COL)'
	EXEC SP_EXECUTESQL @SQL_INSERT, N'@COL VARCHAR(20)', @COL
	
	DECLARE @A INT, @B INT, @C INT
	IF(EXISTS(SELECT * FROM mark WHERE colu='sname'))
		SET @A = 1
	ELSE
		SET @A = 0
	IF(EXISTS(SELECT * FROM mark WHERE colu='sage'))
		SET @B = 1
	ELSE
		SET @B = 0
	IF(EXISTS(SELECT * FROM mark WHERE colu='sdept'))
		SET @C = 1
	ELSE
		SET @C = 0
	EXEC('ALTER VIEW test_s
			AS 
			SELECT id,sname = CASE WHEN '+@A+' = 1 THEN dbo.decrypt(sname) ELSE sname END,
			sage = CASE WHEN '+@B+' = 1 THEN dbo.decrypt(sage) ELSE sage END,
			sdept = CASE WHEN '+@C+' = 1 THEN dbo.decrypt(sdept) ELSE sdept END FROM test;')
	*/
	DECLARE @SQL_DEL NVARCHAR(2000)
	SET @SQL_DEL = 'DELETE mark WHERE colu=@COL'
	EXEC SP_EXECUTESQL @SQL_DEL, N'@COL VARCHAR(20)', @COL
END

EXEC CRY 'sage';
select * from mark
SELECT * FROM test
SELECT * FROM test_s
--DROP PROCEDURE CRY

--修改插入触发器











--修改视图测试
DECLARE @SQL1 NVARCHAR(2000)
DECLARE @A INT
DECLARE @B INT
DECLARE @C INT
SET @A = 1
SET @B = 0
SET @C = 1
EXEC('ALTER VIEW TEST_SS
			AS 
			SELECT id,sname = CASE WHEN '+@A+' = 1 THEN dbo.encrypt(sname) ELSE sname END,
			sage = CASE WHEN '+@B+' = 1 THEN dbo.encrypt(sage) ELSE sage END,
			sdept = CASE WHEN '+@C+' = 1 THEN dbo.encrypt(sdept) ELSE sdept END FROM test;')

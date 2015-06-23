CREATE PROCEDURE DECRY(@COL VARCHAR(20))
AS
BEGIN
	IF(EXISTS(SELECT id FROM mark WHERE colu = @COL))	
		BEGIN
			DECLARE @SQL_TABLE NVARCHAR(200) --构造解密的SQL语句
			DECLARE @SQL_DEL NVARCHAR(200) --构造删除mark表中解密列的语句
			
			--三个临时变量 记录每个列是否被加密
			DECLARE @A INT, @B INT, @C INT
			--删除mark表中解密的列	
			SET @SQL_DEL = 'DELETE mark WHERE colu=@COL'
			EXEC SP_EXECUTESQL @SQL_DEL, N'@COL VARCHAR(20)', @COL
			
			--解密表中的列
			SET @SQL_TABLE = 'UPDATE test SET '+@COL+' = DBO.decrypt('+@COL+')'	
			EXEC SP_EXECUTESQL @SQL_TABLE, N'@COL VARCHAR(20)', @COL	
					
			--将表中解密的列内容在视图中解密显示出来(T_T 修改视图)
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
				
			--修改插入触发器
			EXEC('ALTER TRIGGER insert_test ON test_s
				  INSTEAD OF INSERT
				  AS
				  INSERT INTO test(sname, sage, sdept)
				  SELECT sname = CASE WHEN '+@A+' = 1 THEN dbo.encrypt(sname) ELSE sname END,
			   			 sage =  CASE WHEN '+@B+' = 1 THEN dbo.encrypt(sage) ELSE sage END,
						 sdept = CASE WHEN '+@C+' = 1 THEN dbo.encrypt(sdept) ELSE sdept END FROM inserted');
						 
			--修改触发器	
			EXEC('ALTER TRIGGER updt_test ON test_s
				  INSTEAD OF UPDATE
				  AS
				  BEGIN 
					IF UPDATE(sname) 
					UPDATE test 	
						SET sname = (SELECT sname = CASE WHEN '+@A+' = 1 THEN dbo.encrypt(sname) ELSE sname END FROM inserted WHERE id = test.id)		
					WHERE test.id IN (SELECT id FROM inserted)
					IF UPDATE(sage) 
					UPDATE test 			
						SET sage = (SELECT sage =  CASE WHEN '+@B+' = 1 THEN dbo.encrypt(sage) ELSE sage END FROM inserted WHERE id = test.id)
					WHERE test.id IN (SELECT id FROM inserted)
					IF UPDATE(sdept) 
					UPDATE test 	
						SET sdept = (SELECT sdept = CASE WHEN '+@C+' = 1 THEN dbo.encrypt(sdept) ELSE sdept END FROM inserted WHERE id = test.id)
					WHERE test.id IN (SELECT id FROM inserted)
				  END')								
			SELECT * FROM test
		END
	ELSE
		PRINT 'this column do not encrypt'
END
GO

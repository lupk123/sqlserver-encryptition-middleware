--�洢����ÿ���������
CREATE PROCEDURE ENCRY(@COL VARCHAR(20))
AS
BEGIN
	IF(NOT EXISTS(SELECT id FROM mark WHERE colu = @COL))	
		BEGIN
			DECLARE @SQL_TABLE NVARCHAR(200) --������ܵ�SQL���
			DECLARE @SQL_INSERT NVARCHAR(200) --������mark���в����¼�����			
			--������ʱ���� ��¼ÿ�����Ƿ񱻼���
			DECLARE @A INT, @B INT, @C INT
			--��mark���в����¼��ܵ���	
			SET @SQL_INSERT = 'INSERT INTO mark(colu)VALUES(@COL)'
			EXEC SP_EXECUTESQL @SQL_INSERT, N'@COL VARCHAR(20)', @COL			
			--���ܱ��е���
			SET @SQL_TABLE = 'UPDATE test SET '+@COL+' = DBO.encrypt('+@COL+')'	
			EXEC SP_EXECUTESQL @SQL_TABLE, N'@COL VARCHAR(20)', @COL			
			--�������¼����е����ݽ�������ͼ����ʾ����(T_T �����޸���ͼ)
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
					SELECT id,
					sname = CASE WHEN '+@A+' = 1 THEN dbo.decrypt(sname) ELSE sname END,
					sage = CASE WHEN '+@B+' = 1 THEN dbo.decrypt(sage) ELSE sage END,
					sdept = CASE WHEN '+@C+' = 1 THEN dbo.decrypt(sdept) ELSE sdept END
				 FROM test;')
					
			--�޸Ĳ��봥����
			EXEC('ALTER TRIGGER insert_test ON test_s
				  INSTEAD OF INSERT
				  AS
				  INSERT INTO test(sname, sage, sdept)
				  SELECT sname = CASE WHEN '+@A+' = 1 THEN dbo.encrypt(sname) ELSE sname END,
		   				 sage =  CASE WHEN '+@B+' = 1 THEN dbo.encrypt(sage) ELSE sage END,
						 sdept = CASE WHEN '+@C+' = 1 THEN dbo.encrypt(sdept) ELSE sdept END 
				  FROM inserted');
						 
			--�޸ĸ��´�����	
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
		PRINT 'this column has been encrypted'
END
GO

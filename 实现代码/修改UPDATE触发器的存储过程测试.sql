CREATE PROCEDURE TRIGG(@COL VARCHAR(20))
AS
BEGIN	
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
	EXEC('ALTER TRIGGER insert_test ON test_s
			 INSTEAD OF INSERT
			 AS
			 INSERT INTO test(sname, sage, sdept)
			 SELECT sname = CASE WHEN '+@A+' = 1 THEN dbo.encrypt(sname) ELSE sname END,
			   	    sage =  CASE WHEN '+@B+' = 1 THEN dbo.encrypt(sage) ELSE sage END,
					sdept = CASE WHEN '+@C+' = 1 THEN dbo.encrypt(sdept) ELSE sdept END
			 FROM inserted');
					
	/*EXEC('ALTER TRIGGER updt_test ON test_s
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
		  END')*/
END
GO
EXEC TRIGG 's';
DROP PROCEDURE TRIGG;


CREATE TRIGGER insert_test ON test_s
INSTEAD OF INSERT
AS
INSERT INTO test(sname, sage, sdept)
SELECT sname, dbo.encrypt(sage), sdept FROM inserted;
GO
DROP TRIGGER insert_test


CREATE TRIGGER ins_S ON S
INSTEAD OF INSERT
AS
	INSERT INTO student(sname, sage, sdept)
	SELECT	sname, dbo.encrypt(sage), sdept FROM inserted	


CREATE TRIGGER updt_test on test_s
INSTEAD OF UPDATE
AS
	BEGIN 
	IF UPDATE(sname) 
	UPDATE test 	
		SET sname = (SELECT sname FROM inserted WHERE id = test.id)		
	WHERE test.id IN (SELECT id FROM inserted)
	IF UPDATE(sage) 
	UPDATE test 			
		SET sage = (SELECT dbo.encrypt(sage) FROM inserted WHERE id = test.id)
	WHERE test.id IN (SELECT id FROM inserted)
	IF UPDATE(sdept) 
	UPDATE test 	
		SET sdept = (SELECT sdept FROM inserted WHERE id = test.id)
	WHERE test.id IN (SELECT id FROM inserted)
	END
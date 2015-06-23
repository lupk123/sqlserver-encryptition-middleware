EXEC DECRY 'sname';
EXEC DECRY 'sage';
EXEC DECRY 'sdept';

EXEC ENCRY 'sname'
EXEC ENCRY 'sage'
EXEC ENCRY 'sdept'

SELECT * FROM mark
SELECT * FROM test
SELECT * FROM test_s



INSERT INTO test_s(sname, sage, sdept)VALUES(15, 16, 18);
SELECT * FROM test
SELECT * FROM test_s

INSERT INTO test_s(sname, sage, sdept)VALUES(13, 14, 15);
INSERT INTO test_s(sname, sage, sdept)VALUES(18, 17, 16);

UPDATE test_s SET sname = 115, sage = 104 WHERE id = 30;
SELECT * FROM test
SELECT * FROM test_s



UPDATE test_s SET sname = 13, sage = 14 WHERE id = 13;
UPDATE test_s SET sname = 15, sage = 14 WHERE id = 13;


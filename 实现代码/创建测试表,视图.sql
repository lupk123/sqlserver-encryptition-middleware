CREATE TABLE test
(
id INT IDENTITY,
sname INT,
sage INT,
sdept INT
);
INSERT INTO test(sname, sage, sdept)VALUES(12, 13, 14);
INSERT INTO test(sname, sage, sdept)VALUES(13, 14, 15);
INSERT INTO test(sname, sage, sdept)VALUES(18, 17, 16);
SELECT * FROM test;






CREATE VIEW test_s
AS
SELECT id, sname, dbo.decrypt(sage) as sage, sdept FROM test;

SELECT * FROM test_s;
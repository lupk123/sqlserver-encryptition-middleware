CREATE TABLE mark
(
id INT IDENTITY ,
colu VARCHAR(20) NOT NULL,
encrypt TINYINT NOT NULL
);

SELECT * FROM mark;

INSERT INTO mark(colu, encrypt)VALUES('sname', 0);
INSERT INTO mark(colu, encrypt)VALUES('sage', 1);
INSERT INTO mark(colu, encrypt)VALUES('sdept', 0);
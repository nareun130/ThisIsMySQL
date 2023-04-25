## 1. 인덱스
CREATE TABLE indexTBL (
	first_name varchar(14), 
    last_name varchar(16),
    hire_date date);
INSERT INTO indexTBL SELECT first_name, last_name, hire_date FROM employees.employees LIMIT 500;
SELECT * FROM indexTBL;

SELECT * FROM indexTBL WHERE first_name = 'Mary';

-- 인덱스를 사용함으로써 데이터를 찾는 속도가 더 빨라진다. 지금은 500건 밖에 없지만 나중에 수천 ~ 수만건일 경우 속도차이가 확 벌어진다.
CREATE INDEX idx_indexTBL_firstname ON indexTBL(first_name);

SELECT * FROM indexTBL WHERE first_name = 'Mary';

## 2. 뷰
-- 회원이름과 주소만 볼 수 있도록 view를 설정
CREATE VIEW uv_memberTBL 
AS
 SELECT memberName, memberAddress FROM memberTBL;
 
SELECT * FROM uv_memberTBL;

## 3. 스토어드 프로시저
-- SQL문을 하나로 묶어서 편리하게 사용
SELECT * FROM memberTBL WHERE memberName = '당탕이';
SELECT * FROM productTBL WHERE productName = '냉장고';

-- DELIMITER : 구분 문자
DELIMITER //
CREATE PROCEDURE myProc()
BEGIN
	SELECT * FROM memberTBL WHERE memberName = '당탕이';
	SELECT * FROM productTBL WHERE productName = '냉장고';
END //
DELIMITER ;

CALL myProc();

## 4. 트리거
-- 테이블에 부착 -> INSERT, UPDATE, DELETE작업이 발생되면 실행되는 코드

INSERT INTO memberTBL VALUES('Figure','연아','경기도 군포시 당정동');
SELECT * FROM memberTBL;
DELETE FROM memberTBL WHERE memberName = '연아'; 
SELECT * FROM memberTBL;

-- 트리거 생성
CREATE TABLE deletedMemberTBL(
	memberID CHAR(8),
    memberName CHAR(5),
    memberAddress CHAR(20),
    deletedDate DATE 
);

DELIMITER //
CREATE TRIGGER trg_deletedMemberTBL
	AFTER DELETE
    ON memberTBL
    FOR EACH ROW
BEGIN
	INSERT INTO deletedMemberTBL
			VALUES(OLD.memberID, OLD.memberName, OLD.memberAddress, CURDATE() );
END//
DELIMITER ;

-- 트리거 확인
SELECT * FROM memberTBL;
DELETE FROM memberTBL WHERE memberName = '당탕이';
SELECT * FROM deletedMemberTBL;
-- 외래 키 검사를 비활성화
SET FOREIGN_KEY_CHECKS = 0;

-- 모든 테이블 삭제
DROP TABLE IF EXISTS 범죄자_검거기록;
DROP TABLE IF EXISTS 범죄자_범죄기록;
DROP TABLE IF EXISTS 검거기록;
DROP TABLE IF EXISTS 범죄기록;
DROP TABLE IF EXISTS 범죄;
DROP TABLE IF EXISTS 국적;
DROP TABLE IF EXISTS 범죄자;
DROP TABLE IF EXISTS 직책;
DROP TABLE IF EXISTS 사용자;
DROP TABLE IF EXISTS 경찰서;

-- 외래 키 검사를 다시 활성화
SET FOREIGN_KEY_CHECKS = 1;

-- 직책 테이블 생성
CREATE TABLE 직책 (
    직책번호 VARCHAR(30) PRIMARY KEY,
    직책명 VARCHAR(30),
    권한 VARCHAR(100)
);

-- 경찰서 테이블 생성
CREATE TABLE 경찰서 (
    경찰서식별번호 VARCHAR(30) PRIMARY KEY,
    경찰서명 VARCHAR(100)
);

-- 사용자 테이블 생성
CREATE TABLE 사용자 (
    사용자ID VARCHAR(30) PRIMARY KEY,
    사용자명 VARCHAR(100) NOT NULL,
    비밀번호 VARCHAR(255) NOT NULL,
    직책번호 VARCHAR(30) NOT NULL,
    경찰서식별번호 VARCHAR(30) NOT NULL,
    연락처 VARCHAR(20) NOT NULL,
    FOREIGN KEY (직책번호) REFERENCES 직책 (직책번호),
    FOREIGN KEY (경찰서식별번호) REFERENCES 경찰서 (경찰서식별번호)
);


-- 국적 테이블 생성
CREATE TABLE 국적 (
    국적번호 INT PRIMARY KEY,
    국가명 VARCHAR(100) NOT NULL,
    특별관리국적여부 CHAR(1) NOT NULL
);

-- 범죄자 테이블 생성
CREATE TABLE 범죄자(
    범죄자ID VARCHAR(30) PRIMARY KEY,
    범죄자명 VARCHAR(100) NOT NULL,
    범죄자연락처 VARCHAR(20) NOT NULL,
    범죄자주소 VARCHAR(255) NOT NULL,
    성별 CHAR(3) NOT NULL,
    주민등록번호 VARCHAR(20) NOT NULL,
    키 INT NOT NULL,
    몸무게 INT NOT NULL,
    국적번호 INT NOT NULL,
    생성한사용자ID VARCHAR(30) NOT NULL,
    수정한사용자ID VARCHAR(30),
    FOREIGN KEY (국적번호) REFERENCES 국적 (국적번호),
    FOREIGN KEY (생성한사용자ID) REFERENCES 사용자 (사용자ID), 
    FOREIGN KEY (수정한사용자ID) REFERENCES 사용자 (사용자ID)
);

-- 범죄 테이블 생성
CREATE TABLE 범죄 (
    범죄유형번호 VARCHAR(10) PRIMARY KEY,
    범죄명 VARCHAR(20) NOT NULL,
    범죄신상기록여부 CHAR(1) NOT NULL
);

-- 범죄기록 테이블 생성
CREATE TABLE 범죄기록 (
    범죄기록고유번호 VARCHAR(20) PRIMARY KEY,
    범죄발생일 DATE NOT NULL,
    범죄유형번호 VARCHAR(10) NOT NULL,
    범죄설명 VARCHAR(100) NOT NULL,
    범죄발생장소 VARCHAR(50) NOT NULL,
    FOREIGN KEY (범죄유형번호) REFERENCES 범죄 (범죄유형번호)
);

-- 검거기록 테이블 생성
CREATE TABLE 검거기록 (
    검거기록고유번호 VARCHAR(20) PRIMARY KEY,
    범죄기록고유번호 VARCHAR(20) NOT NULL,
    검거일 DATE NOT NULL,
    검거장소 VARCHAR(255) NOT NULL,
    관할경찰서번호 VARCHAR(30) NOT NULL,
    현장검거자ID VARCHAR(30) NOT NULL,
    FOREIGN KEY (범죄기록고유번호) REFERENCES 범죄기록 (범죄기록고유번호),
    FOREIGN KEY (관할경찰서번호) REFERENCES 경찰서 (경찰서식별번호),
    FOREIGN KEY (현장검거자ID) REFERENCES 사용자 (사용자ID)
);

-- 범죄자-범죄기록 테이블 생성
CREATE TABLE 범죄자_범죄기록 (
    범죄자ID VARCHAR(30) NOT NULL,
    범죄기록고유번호 VARCHAR(20) NOT NULL,
    생성한사용자ID VARCHAR(30) NOT NULL,
    수정한사용자ID VARCHAR(30),
    PRIMARY KEY (범죄자ID, 범죄기록고유번호),
    FOREIGN KEY (범죄자ID) REFERENCES 범죄자 (범죄자ID),
    FOREIGN KEY (범죄기록고유번호) REFERENCES 범죄기록 (범죄기록고유번호),
    FOREIGN KEY (생성한사용자ID) REFERENCES 사용자 (사용자ID), 
    FOREIGN KEY (수정한사용자ID) REFERENCES 사용자 (사용자ID) 
);

-- 범죄자-검거기록 테이블 생성
CREATE TABLE 범죄자_검거기록 (
    범죄자ID VARCHAR(30) NOT NULL,
    검거기록고유번호 VARCHAR(20) NOT NULL,
    생성한사용자ID VARCHAR(30) NOT NULL,
    수정한사용자ID VARCHAR(30),
    PRIMARY KEY (범죄자ID, 검거기록고유번호),
    FOREIGN KEY (범죄자ID) REFERENCES 범죄자 (범죄자ID),
    FOREIGN KEY (검거기록고유번호) REFERENCES 검거기록 (검거기록고유번호), 
    FOREIGN KEY (생성한사용자ID) REFERENCES 사용자 (사용자ID), 
    FOREIGN KEY (수정한사용자ID) REFERENCES 사용자 (사용자ID)
);

-- 직책 테이블에 데이터 삽입
INSERT INTO 직책 (직책번호, 직책명, 권한)
VALUES
('pr01', '치안총감', '관리자'),
('pr02', '치안정감', '관리자'),
('pr03', '치안감', '관리자'),
('pr04', '경무관', '관리자'),
('pr05', '총경', '관리자'),
('pr06', '경정', '관리자'),
('pr07', '경감', '관리자'),
('pr08', '경위', '관리자'),
('pr09', '경사', '사용자'),
('pr10', '경장', '사용자'),
('pr11', '순경', '사용자');

-- 경찰서 테이블에 데이터 삽입
INSERT INTO 경찰서 (경찰서식별번호, 경찰서명)
VALUES
('P001', '서울중부경찰서'),
('P002', '부산해운대경찰서'),
('P003', '인천연수경찰서'),
('P004', '대구중부경찰서'),
('P005', '광주동부경찰서'),
('P006', '대전유성경찰서'),
('P007', '울산남부경찰서'),
('P008', '수원중부경찰서'),
('P009', '창원중부경찰서'),
('P010', '청주흥덕경찰서'),
('P011', '전주덕진경찰서'),
('P012', '포항북부경찰서'),
('P013', '안산단원경찰서'),
('P014', '김해중부경찰서'),
('P015', '의정부경찰서'),
('P016', '평택경찰서'),
('P017', '구미경찰서'),
('P018', '강릉경찰서'),
('P019', '군산경찰서'),
('P020', '천안동남경찰서');

-- 사용자 테이블에 데이터 삽입
INSERT INTO 사용자 (사용자ID, 사용자명, 비밀번호, 직책번호, 경찰서식별번호, 연락처) VALUES
('plcofcr1', '김동현', '123', 'pr01', 'P002', '010-3409-5937'),
('plcofcr2', '이수정', '32', 'pr02', 'P007', '010-5726-9347'),
('plcofcr3', '박지민', '13', 'pr03', 'P010', '010-7589-4973'),
('plcofcr4', '최현우', '56547', 'pr04', 'P014', '010-4575-3919'),
('plcofcr5', '강서현', '42', 'pr05', 'P016', '010-4702-4785'),
('plcofcr6', '윤준영', '6', 'pr06', 'P001', '010-6739-8909'),
('plcofcr7', '장민호', '67', 'pr07', 'P005', '010-4628-5749'),
('plcofcr8', '정다은', '2344', 'pr08', 'P018', '010-7280-8349'),
('plcofcr9', '서민재', '34', 'pr09', 'P012', '010-4820-5738'),
('plcofcr10', '한지훈', '5345', 'pr10', 'P020', '010-6748-2344'),
('plcofcr11', '김민정', '986', 'pr11', 'P008', '010-4726-3948'),
('plcofcr12', '오세준', '465', 'pr07', 'P012', '010-4564-3049'),
('plcofcr13', '임하영', '40835', 'pr08', 'P003', '011-485-3827'),
('plcofcr14', '배민수', '374856', 'pr09', 'P004', '010-8257-4856'),
('plcofcr15', '신다은', '928364', 'pr10', 'P006', '010-6872-1038'),
('plcofcr16', '서지훈', '18927346', 'pr11', 'P008', '010-3457-2947'),
('plcofcr17', '윤혜린', '132984', 'pr09', 'P020', '010-8475-3947'),
('plcofcr18', '황정민', '27098534', 'pr10', 'P019', '010-5768-2031'),
('plcofcr19', '박수현', '23695847', 'pr11', 'P015', '010-8362-9455'),
('plcofcr20', '채은지', '5347980', 'pr11', 'P013', '010-8364-2838');

-- 국적 테이블에 데이터 삽입
INSERT INTO 국적 (국적번호, 국가명, 특별관리국적여부)
VALUES
(1, '대한민국', 'X'),
(2, '미국', 'X'),
(3, '일본', 'X'),
(4, '독일', 'X'),
(5, '영국', 'X'),
(6, '중국', 'X'),
(7, '프랑스', 'X'),
(8, '이란', 'O'),
(9, '러시아', 'O'),
(10, '북한', 'O');

-- 범죄자 테이블에 데이터 삽입
INSERT INTO 범죄자 (범죄자ID, 범죄자명, 범죄자연락처, 범죄자주소, 주민등록번호, 성별, 키, 몸무게, 국적번호, 생성한사용자ID, 수정한사용자ID)
VALUES
('CJ101', '김성호', '010-1234-5678', '서울시 강남구', '820320-1234567', '남', 175, 70, 1, 'plcofcr1', 'plcofcr2'),
('CJ102', '이지은', '010-2435-6729', '부산시 해운대구', '940222-2345678', '여', 165, 55, 1, 'plcofcr2', null),
('CJ103', 'Michael', '010-3456-7890', '인천시 남동구', '000102-3456789', '남', 180, 75, 2, 'plcofcr5', 'plcofcr5'),
('CJ104', 'Anna', '010-4567-8901', '대구시 북구', '010401-4567890', '여', 160, 50, 6, 'plcofcr6', 'plcofcr7'),
('CJ105', 'Takashi', '010-5678-9012', '광주시 서구', '567890-5678901', '남', 170, 65, 3, 'plcofcr7', 'plcofcr8'),
('CJ106', 'Wei', '010-6789-0123', '대전시 유성구', '678901-6789012', '여', 155, 45, 4, 'plcofcr8', null),
('CJ107', 'Sophia', '010-7890-1234', '울산시 남구', '789012-7890123', '남', 185, 80, 6, 'plcofcr3', 'plcofcr7'),
('CJ108', 'Ivan', '010-8901-2345', '수원시 장안구', '890123-8901234', '여', 175, 70, 5, 'plcofcr4', 'plcofcr5'),
('CJ109', 'Maria', '010-9012-3456', '창원시 성산구', '901234-7012345', '남', 165, 60, 5, 'plcofcr5', 'plcofcr7'),
('CJ110', 'Emily', '010-0123-4567', '청주시 상당구', '012345-8123456', '여', 170, 55, 8, 'plcofcr12', 'plcofcr12'),
('CJ111', 'Yuki', '010-1148-4728', '천안시 동남구', '567230-5678901', '남', 175, 70, 3, 'plcofcr7', 'plcofcr1'),
('CJ112', 'Pierre', '010-2345-6789', '전주시 완산구', '672991-6789012', '여', 165, 55, 7, 'plcofcr6', 'plcofcr7'),
('CJ113', 'Li', '010-3456-7809', '포항시 북구', '785042-7890123', '남', 180, 75, 4, 'plcofcr7', 'plcofcr7'),
('CJ114', 'Kim Sun-woo', '010-4567-8432', '안산시 단원구', '456789-4567890', '여', 160, 50, 9, 'plcofcr5', null),
('CJ115', 'Mohammad Reza', '010-5678-9009', '김해시 삼안동', '567890-5678901', '남', 170, 65, 10, 'plcofcr5', 'plcofcr3'),
('CJ116', '박서연', '010-6789-4563', '의정부시 가능동', '678901-6789012', '여', 155, 45, 1, 'plcofcr3', 'plcofcr8'),
('CJ117', '최준호', '010-7890-1687', '평택시 비전동', '789012-7890123', '남', 185, 80, 1, 'plcofcr6', 'plcofcr6'),
('CJ118', 'Sarah', '010-8901-2573', '구미시 인동동', '890123-8901234', '여', 175, 70, 2, 'plcofcr12', null),
('CJ119', '김지수', '010-9012-3925', '강릉시 옥계동', '901234-9012345', '남', 165, 60, 1, 'plcofcr13', 'plcofcr6'),
('CJ120', 'Zhang Ming', '010-0123-4495', '군산시 옥도동', '012345-0123456', '여', 170, 55, 4, 'plcofcr6', 'plcofcr6');

-- 범죄 테이블 데이터 삽입
INSERT INTO 범죄 (범죄유형번호, 범죄명, 범죄신상기록여부) VALUES
('CRIME1', '절도', 'O'),
('CRIME2', '강도', 'O'),
('CRIME3', '폭행', 'X'),
('CRIME4', '살인', 'O'),
('CRIME5', '사기', 'O');


-- 범죄기록 테이블에 데이터 삽입
INSERT INTO 범죄기록 (범죄기록고유번호, 범죄발생일, 범죄유형번호, 범죄설명, 범죄발생장소) VALUES
('CR001', '2023-01-01', 'CRIME1', '상점에서 절도', '서울 명동'),
('CR002', '2023-01-02', 'CRIME2', '은행 강도 사건', '부산 해운대'),
('CR003', '2023-01-03', 'CRIME3', '거리에서 폭행', '인천 송도'),
('CR004', '2023-01-04', 'CRIME4', '살인 사건 발생', '대구 동성로'),
('CR005', '2023-01-05', 'CRIME5', '금융 사기 사건', '광주 충장로'),
('CR006', '2023-01-06', 'CRIME1', '주택에서 절도', '대전 유성'),
('CR007', '2023-01-07', 'CRIME3', '아버지 폭행', '울산 태화강'),
('CR008', '2023-01-08', 'CRIME3', '공원 행인 폭행', '수원 화성'),
('CR009', '2023-01-09', 'CRIME4', '연쇄 살인 사건', '창원 상남동'),
('CR010', '2023-01-10', 'CRIME5', '보험 사기 사건', '청주 상당산'),
('CR011', '2023-01-11', 'CRIME1', '차량에서 절도', '전주 한옥마을'),
('CR012', '2023-01-12', 'CRIME2', '주택 강도 사건', '포항 북부해수욕장'),
('CR013', '2023-01-13', 'CRIME3', '술집에서 폭행', '안산 단원'),
('CR014', '2023-01-14', 'CRIME4', '유흥가 살인 사건', '김해 롯데워터파크'),
('CR015', '2023-01-15', 'CRIME5', '인터넷 사기 사건', '의정부 가능'),
('CR016', '2023-01-16', 'CRIME1', '마트에서 절도', '평택 비전'),
('CR017', '2023-01-17', 'CRIME2', '편의점 강도 사건', '구미 인동'),
('CR018', '2023-01-18', 'CRIME3', '주점에서 폭행', '강릉 경포해변'),
('CR019', '2023-01-19', 'CRIME4', '공원에서 살인 사건', '군산 미장동'),
('CR020', '2023-01-20', 'CRIME5', '대출 사기 사건', '천안 신부동');


-- 검거기록 테이블에 데이터 삽입
INSERT INTO 검거기록 (검거기록고유번호, 범죄기록고유번호, 검거일, 검거장소, 관할경찰서번호, 현장검거자ID)
VALUES
('AR001', 'CR001', '2023-01-01', '서울 명동', 'P001', 'plcofcr1'),
('AR002', 'CR002', '2023-01-02', '부산 해운대', 'P002', 'plcofcr2'),
('AR003', 'CR003', '2023-01-03', '인천 송도', 'P005', 'plcofcr5'),
('AR004', 'CR004', '2023-01-04', '대구 동성로', 'P006', 'plcofcr6'),
('AR005', 'CR005', '2023-01-05', '광주 충장로', 'P007', 'plcofcr7'),
('AR006', 'CR006', '2023-01-06', '대전 유성', 'P008', 'plcofcr8'),
('AR007', 'CR007', '2023-01-07', '울산 태화강', 'P005', 'plcofcr3'),
('AR008', 'CR008', '2023-01-08', '수원 화성', 'P009', 'plcofcr4'),
('AR009', 'CR009', '2023-01-09', '창원 상남동', 'P009', 'plcofcr5'),
('AR010', 'CR010', '2023-01-10', '청주 상당산', 'P010', 'plcofcr12'),
('AR011', 'CR011', '2023-01-11', '전주 한옥마을', 'P011', 'plcofcr7'),
('AR012', 'CR012', '2023-01-12', '포항 북부해수욕장', 'P012', 'plcofcr6'),
('AR013', 'CR013', '2023-01-13', '안산 단원', 'P013', 'plcofcr7'),
('AR014', 'CR014', '2023-01-14', '김해 롯데워터파크', 'P014', 'plcofcr5'),
('AR015', 'CR015', '2023-01-15', '의정부 가능', 'P015', 'plcofcr5'),
('AR016', 'CR016', '2023-01-16', '평택 비전', 'P016', 'plcofcr3'),
('AR017', 'CR017', '2023-01-17', '구미 인동', 'P017', 'plcofcr7'),
('AR018', 'CR018', '2023-01-18', '강릉 경포해변', 'P018', 'plcofcr6'),
('AR019', 'CR019', '2023-01-19', '군산 미장동', 'P019', 'plcofcr7'),
('AR020', 'CR020', '2023-01-20', '천안 신부동', 'P020', 'plcofcr6');

-- 범죄자_검거기록 테이블에 데이터 삽입
INSERT INTO 범죄자_검거기록 (범죄자ID, 검거기록고유번호, 생성한사용자ID, 수정한사용자ID)
VALUES
('CJ101', 'AR001', 'plcofcr1', 'plcofcr2'),
('CJ102', 'AR002', 'plcofcr2', null),
('CJ103', 'AR003', 'plcofcr5', 'plcofcr5'),
('CJ104', 'AR004', 'plcofcr6', 'plcofcr7'),
('CJ105', 'AR005', 'plcofcr7', 'plcofcr8'),
('CJ106', 'AR006', 'plcofcr8', null),
('CJ107', 'AR007', 'plcofcr3', 'plcofcr7'),
('CJ108', 'AR008', 'plcofcr4', 'plcofcr5'),
('CJ109', 'AR009', 'plcofcr5', 'plcofcr7'),
('CJ110', 'AR010', 'plcofcr12', 'plcofcr12'),
('CJ111', 'AR011', 'plcofcr7', 'plcofcr1'),
('CJ112', 'AR012', 'plcofcr6', 'plcofcr7'),
('CJ113', 'AR013', 'plcofcr7', 'plcofcr7'),
('CJ114', 'AR014', 'plcofcr5', null),
('CJ115', 'AR015', 'plcofcr5', 'plcofcr3'),
('CJ116', 'AR016', 'plcofcr3', 'plcofcr3'),
('CJ117', 'AR017', 'plcofcr6', 'plcofcr6'),
('CJ118', 'AR018', 'plcofcr12', null),
('CJ119', 'AR019', 'plcofcr13', 'plcofcr6'),
('CJ120', 'AR020', 'plcofcr6', 'plcofcr6');

-- 범죄자_범죄기록 테이블에 데이터 삽입
INSERT INTO 범죄자_범죄기록 (범죄기록고유번호, 범죄자ID, 생성한사용자ID, 수정한사용자ID)
VALUES
('CR001', 'CJ101', 'plcofcr1', 'plcofcr2'),
('CR002', 'CJ102', 'plcofcr2', NULL),
('CR003', 'CJ103', 'plcofcr5', 'plcofcr5'),
('CR004', 'CJ104', 'plcofcr6', 'plcofcr7'),
('CR005', 'CJ105', 'plcofcr7', 'plcofcr8'),
('CR006', 'CJ106', 'plcofcr8', NULL),
('CR007', 'CJ107', 'plcofcr3', 'plcofcr7'),
('CR008', 'CJ108', 'plcofcr4', 'plcofcr5'),
('CR009', 'CJ109', 'plcofcr5', 'plcofcr7'),
('CR010', 'CJ110', 'plcofcr12', 'plcofcr12'),
('CR011', 'CJ111', 'plcofcr7', 'plcofcr1'),
('CR012', 'CJ112', 'plcofcr6', 'plcofcr7'),
('CR013', 'CJ113', 'plcofcr7', 'plcofcr7'),
('CR014', 'CJ114', 'plcofcr5', NULL),
('CR015', 'CJ115', 'plcofcr5', 'plcofcr3'),
('CR016', 'CJ116', 'plcofcr3', 'plcofcr8'),
('CR017', 'CJ117', 'plcofcr6', 'plcofcr6'),
('CR018', 'CJ118', 'plcofcr12', NULL),
('CR019', 'CJ119', 'plcofcr13', 'plcofcr6'),
('CR020', 'CJ120', 'plcofcr6', 'plcofcr6');

-- 모든 범죄자 데이터 검색
SELECT * FROM 범죄자;

-- 특정 범죄 유형(절도) 범죄 유형 검색
SELECT 범죄기록고유번호, 범죄발생일, 범죄설명, 범죄발생장소
FROM 범죄기록
WHERE 범죄유형번호 = 'CRIME1';

-- 특정 범죄자(김성호)의 모든 범죄 기록 검색 
SELECT bj.범죄자명, bj.범죄자연락처, bj.범죄자주소, br.범죄발생일, br.범죄설명, br.범죄발생장소
FROM 범죄자 bj
JOIN 범죄자_범죄기록 bbr ON bj.범죄자ID = bbr.범죄자ID
JOIN 범죄기록 br ON bbr.범죄기록고유번호 = br.범죄기록고유번호
WHERE bj.범죄자명 = '김성호';

-- 특정 날짜에 발생한 모든 범죄 검색
SELECT 범죄기록고유번호, 범죄발생일, 범죄설명, 범죄발생장소
FROM 범죄기록
WHERE 범죄발생일 = '2023-01-01';

-- 특정 경찰서(서울중부경찰서)의 사용자 목록 검색
SELECT 사용자ID, 사용자명, 직책번호, 연락처
FROM 사용자
WHERE 경찰서식별번호 = 'P001';

-- 특정 사용자가 생성한 범죄자 목록 검색
SELECT 범죄자ID, 범죄자명, 범죄자연락처, 범죄자주소
FROM 범죄자
WHERE 생성한사용자ID = 'plcofcr1';

-- 특정 국적(중국) 범죄자 목록 검색
SELECT bj.범죄자ID, bj.범죄자명, bj.범죄자연락처, bj.범죄자주소
FROM 범죄자 bj
JOIN 국적 n ON bj.국적번호 = n.국적번호
WHERE n.국가명 = '중국';


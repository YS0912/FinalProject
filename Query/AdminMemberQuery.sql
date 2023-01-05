-- ● AdminMemberDAO

-- ▷ list 회원 리스트 조회
-- 출력 데이터 : 등록번호, 아이디, 닉네임, 가입일, 경고받은 횟수, 정지여부(Y/N) (#54)
--               ------------------------------- ---------------------------
-- 테이블 :                  회원테이블           댓글/여행책/여행카드 신고처리 테이블, 경고해제 테이블

SELECT U.SIGN_NUM, U.USER_ID, U.USER_NAME, U.USER_DATE
, NVL(V.WARNING_COUNT,0) AS WARNING_COUNT, NVL(V.STOP_TYPE, 'N') AS STOP_TYPE
FROM USERS U FULL JOIN VIEW_USERWARNINGCOUNT V
ON U.SIGN_NUM = V.WARNING_USER
ORDER BY SIGN_NUM;

-- ▷ idSearchList 회원 아이디 리스트 조회
SELECT SIGN_NUM, USER_ID, USER_NAME, USER_DATE
FROM USERS
WHERE USER_ID LIKE '%k%';

-- ▷ nicknameSearchList 회원 닉네임 리스트 조회
SELECT SIGN_NUM, USER_ID, USER_NAME, USER_DATE
FROM USERS
WHERE USER_NAME LIKE '%나%';

-- ▷  search 회원 번호로 조회 (개인정보 조회)
SELECT U.USER_NAME AS USER_NAME, U.USER_ID AS USER_ID, NVL(U.USER_INTRO, '안녕하세요.') AS USER_INTRO
, U.USER_EMAIL AS USER_EMAIL, U.USER_TEL AS USER_TEL, G.GENDER_NAME AS USER_GENDER, U.USER_BIRTH
FROM USERS U JOIN GENDER G
           ON U.GENDER_NUM = G.GENDER_NUM
WHERE U.SIGN_NUM = 124;

-- ▷ bookList 회원 번호로 여행책 리스트 조회
-- 출력 데이터 : 여행책번호, 책제목, 작성일, 블라인드 여부
SELECT B.BOOK_NUM, B.BOOK_TITLE, B.BOOK_DATE
,NVL((
    SELECT CASE WHEN (STATUS_NUM = 0) OR (STATUS = 1)  THEN '○'
    ELSE 'Ⅹ' END AS BLIND
    FROM VIEW_REPORTLIST
    WHERE TYPE='book' AND CANCEL_NUM IS NULL
    AND ARTICLE = B.BOOK_NUM
    )
 , 'Ⅹ') AS BLINE
FROM BOOK B
WHERE SIGN_NUM = 124
ORDER BY B.BOOK_NUM;

-- ▷ cardList 회원 번호로 여행카드 리스트 조회
-- 출력 데이터 : 여행카드번호, 장소, 작성자, 작성일
SELECT C.CARD_NUM, C.CARD_LOCATION
, NVL(( SELECT CASE WHEN CANCEL_NUM IS NULL THEN '○' 
                WHEN CANCEL_NUM IS NOT NULL THEN 'Ⅹ' ELSE 'Ⅹ' END AS BLIND
    FROM VIEW_REPORTLIST
    WHERE TYPE = 'card'
    AND C.CARD_NUM = ARTICLE
   ), 'Ⅹ') AS BLIND
, NVL(C.CARD_BUDGET, 0) AS CARD_BUDGET
, ( SELECT USER_NAME
    FROM USERS
    WHERE C.SIGN_NUM = SIGN_NUM 
   ) AS USER_NAME
, TO_DATE(C.CARD_DATE, 'YYYY-MM-DD') AS CARD_DATE
FROM CARD C
WHERE C.OPEN_NUM = 1 AND C.CARD_DATE IS NOT NULL
AND C.SIGN_NUM = 124
ORDER BY C.CARD_NUM;


-- ▷ commentList 회원 번호로 댓글 리스트 조회
-- 출력 데이터 : 댓글번호, 작성일, 댓글내용
SELECT V.COMMENT_NUM, V.COMMENT_CONTENT, COMMENT_DATE
,NVL((SELECT CASE WHEN (STATUS_NUM = 0) OR (STATUS = 1)  THEN '○'
    ELSE 'Ⅹ' END AS BLIND
    FROM VIEW_REPORTLIST
    WHERE TYPE='comment' AND CANCEL_NUM IS NULL
    AND ARTICLE = V.COMMENT_NUM
), 'Ⅹ') AS BLINE
FROM VIEW_COMMENTLIST V
WHERE SIGN_NUM = 124
ORDER BY COMMENT_NUM;

--▷ warningList 회원 번호로 경고 리스트 조회
SELECT TYPE, STATUS_NUM, STATUS_ADMIN, STATUS_DATE, CANCEL_DATE, REASON, CANCEL_ADMIN, WARNING_USER
FROM VIEW_USERWARNINGLIST
WHERE WARNING_USER = 149
ORDER BY STATUS_NUM;


-- ▷ searchBook 여행책 번호로 여행책 조회
-- 출력 : 여행책번호, 여행책제목, 코멘트, 작성일, 최종수정일, 등록번호(작성자) // 확인 필요..
SELECT BOOK_NUM, BOOK_TITLE, BOOK_COMMENT
, TO_DATE(BOOK_DATE, 'YYYY-MM-DD') AS BOOK_DATE
, TO_DATE(BOOK_REDATE, 'YYYY-MM-DD') AS BOOK_REDATE
, SIGN_NUM 
FROM BOOK
WHERE BOOK_NUM = 5;

-- ▷ searchCard 여행카드 번호로 여행카드로 조회(공개된 여행카드만)
-- OPEN 컬럼 Y AND CARD_DATE IS NOT NULL 조건이면 공개된 여행카드
-- 카드번호, 장소명, 생성일, 예산(출력)
SELECT CARD_NUM, CARD_LOCATION, TO_DATE(CARD_DATE, 'YYYY-MM-DD') AS CARD_DATE, NVL(CARD_BUDGET, 0) AS CARD_BUDGET
FROM CARD
WHERE OPEN_NUM = 1 AND CARD_DATE IS NOT NULL
AND SIGN_NUM = 124;


-- CARD, PAY 테이블 조인 (카드 상세내용 출력)
-- 장소명, 시간, 예산, 지출, 메모, 사진 (회원 여행카드 상세내역 - 팝업창, 여행카드 번호 일치할 때 조건)
SELECT C.CARD_LOCATION, C.CARD_TIME, C.CARD_BUDGET, C.CARD_COMMENT, C.CARD_IMG1, C.CARD_IMG2, C.CARD_IMG3 
, P.PAY_NUM, P.CARD_NUM, P.PTYPE_NUM, P.PAY_NAME, P.PAY_AMOUNT
FROM PAY P FULL OUTER JOIN CARD C
ON P.CARD_NUM = C.CARD_NUM
WHERE C.CARD_NUM = 4;


-- ▷ searchComment 댓글번호로 여행책 조회
SELECT BOOK_NUM
FROM VIEW_COMMENTLIST
WHERE COMMENT_NUM=3;


-- ▷ searchWarning 경고 번호로 경고 조회
-- 경고해제 테이블을 경고이력 테이블을 쓸 수 있도록 하는 방안이 나왔었음
-- 출력 : 경고번호, 담당자, 처리일, 해제일, 경고 사유
-- 경고해제테이블, 신고처리테이블 JOIN
SELECT TYPE, STATUS_NUM, STATUS_ADMIN, STATUS_DATE, CANCEL_DATE, REASON, CANCEL_ADMIN, WARNING_USER
FROM VIEW_USERWARNINGLIST
WHERE STATUS_NUM = 1
AND TYPE = 'book';

-- ▷ bReportStatusInsert 여행책 경고 처리를 위해 신고 처리 테이블에 신규 등록
INSERT INTO BREPORT_STATUS(BSTATUS_NUM, ADMIN_NUM, BREPORT_NUM, TYPE_NUM, BSTATUS_CHECK)
VALUES(BREPORT_STATUS_SEQ.NEXTVAL, 1, 1, 1, NULL);

-- ▷ cReportStatusInsert 여행카드 경고 처리를 위해 신고 처리 테이블에 신규 등록
INSERT INTO CREPORT_STATUS(CSTATUS_NUM, ADMIN_NUM, CREPORT_NUM, TYPE_NUM, CSTATUS_CHECK)
VALUES(CREPORT_STATUS_SEQ.NEXTVAL, 1, 1, 1, NULL);


-- ▷ bWarningCancelInsert 여행책 경고 해제를 위해 경고 해제 테이블에 신규 등록
INSERT INTO BWARNING_CANCEL(CCANCEL_NUM, ADMIN_NUM, BSTATUS_NUM, REASON_NUM, CCANCEL_MEMO)
VALUES(BWARNING_CANCEL_SEQ.NEXVAL, 1, 1, 1, '');


-- ▷ cWarningCancelInsert 여행카드 경고 해제를 위해 경고 해제 테이블에 신규 등록
INSERT INTO CWARNING_CANCEL(CCANCEL_NUM, ADMIN_NUM, BSTATUS_NUM, REASON_NUM, CCANCEL_MEMO)
VALUES(CWARNIN_CANCEL_SEQ.NEXTVAL, 1, 1, 1, '');


-- ▷ coWarningCancelInsert 댓글 경고 해제를 위해 경고 해제 테이블에 신규 등록
INSERT INTO COWARNING_CANCEL(COCANCEL_NUM, ADMIN_NUM, COSTATUS_NUM, REASON_NUM, COCANCEL_MEMO)
VALUES(COWARNING_CANCEL_SEQ.NEXTVAL, 1, 1, 1, '');
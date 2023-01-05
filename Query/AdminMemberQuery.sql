-- �� AdminMemberDAO

-- �� list ȸ�� ����Ʈ ��ȸ
-- ��� ������ : ��Ϲ�ȣ, ���̵�, �г���, ������, ������ Ƚ��, ��������(Y/N) (#54)
--               ------------------------------- ---------------------------
-- ���̺� :                  ȸ�����̺�           ���/����å/����ī�� �Ű�ó�� ���̺�, ������� ���̺�

SELECT U.SIGN_NUM, U.USER_ID, U.USER_NAME, U.USER_DATE
, NVL(V.WARNING_COUNT,0) AS WARNING_COUNT, NVL(V.STOP_TYPE, 'N') AS STOP_TYPE
FROM USERS U FULL JOIN VIEW_USERWARNINGCOUNT V
ON U.SIGN_NUM = V.WARNING_USER
ORDER BY SIGN_NUM;

-- �� idSearchList ȸ�� ���̵� ����Ʈ ��ȸ
SELECT SIGN_NUM, USER_ID, USER_NAME, USER_DATE
FROM USERS
WHERE USER_ID LIKE '%k%';

-- �� nicknameSearchList ȸ�� �г��� ����Ʈ ��ȸ
SELECT SIGN_NUM, USER_ID, USER_NAME, USER_DATE
FROM USERS
WHERE USER_NAME LIKE '%��%';

-- ��  search ȸ�� ��ȣ�� ��ȸ (�������� ��ȸ)
SELECT U.USER_NAME AS USER_NAME, U.USER_ID AS USER_ID, NVL(U.USER_INTRO, '�ȳ��ϼ���.') AS USER_INTRO
, U.USER_EMAIL AS USER_EMAIL, U.USER_TEL AS USER_TEL, G.GENDER_NAME AS USER_GENDER, U.USER_BIRTH
FROM USERS U JOIN GENDER G
           ON U.GENDER_NUM = G.GENDER_NUM
WHERE U.SIGN_NUM = 124;

-- �� bookList ȸ�� ��ȣ�� ����å ����Ʈ ��ȸ
-- ��� ������ : ����å��ȣ, å����, �ۼ���, ����ε� ����
SELECT B.BOOK_NUM, B.BOOK_TITLE, B.BOOK_DATE
,NVL((
    SELECT CASE WHEN (STATUS_NUM = 0) OR (STATUS = 1)  THEN '��'
    ELSE '��' END AS BLIND
    FROM VIEW_REPORTLIST
    WHERE TYPE='book' AND CANCEL_NUM IS NULL
    AND ARTICLE = B.BOOK_NUM
    )
 , '��') AS BLINE
FROM BOOK B
WHERE SIGN_NUM = 124
ORDER BY B.BOOK_NUM;

-- �� cardList ȸ�� ��ȣ�� ����ī�� ����Ʈ ��ȸ
-- ��� ������ : ����ī���ȣ, ���, �ۼ���, �ۼ���
SELECT C.CARD_NUM, C.CARD_LOCATION
, NVL(( SELECT CASE WHEN CANCEL_NUM IS NULL THEN '��' 
                WHEN CANCEL_NUM IS NOT NULL THEN '��' ELSE '��' END AS BLIND
    FROM VIEW_REPORTLIST
    WHERE TYPE = 'card'
    AND C.CARD_NUM = ARTICLE
   ), '��') AS BLIND
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


-- �� commentList ȸ�� ��ȣ�� ��� ����Ʈ ��ȸ
-- ��� ������ : ��۹�ȣ, �ۼ���, ��۳���
SELECT V.COMMENT_NUM, V.COMMENT_CONTENT, COMMENT_DATE
,NVL((SELECT CASE WHEN (STATUS_NUM = 0) OR (STATUS = 1)  THEN '��'
    ELSE '��' END AS BLIND
    FROM VIEW_REPORTLIST
    WHERE TYPE='comment' AND CANCEL_NUM IS NULL
    AND ARTICLE = V.COMMENT_NUM
), '��') AS BLINE
FROM VIEW_COMMENTLIST V
WHERE SIGN_NUM = 124
ORDER BY COMMENT_NUM;

--�� warningList ȸ�� ��ȣ�� ��� ����Ʈ ��ȸ
SELECT TYPE, STATUS_NUM, STATUS_ADMIN, STATUS_DATE, CANCEL_DATE, REASON, CANCEL_ADMIN, WARNING_USER
FROM VIEW_USERWARNINGLIST
WHERE WARNING_USER = 149
ORDER BY STATUS_NUM;


-- �� searchBook ����å ��ȣ�� ����å ��ȸ
-- ��� : ����å��ȣ, ����å����, �ڸ�Ʈ, �ۼ���, ����������, ��Ϲ�ȣ(�ۼ���) // Ȯ�� �ʿ�..
SELECT BOOK_NUM, BOOK_TITLE, BOOK_COMMENT
, TO_DATE(BOOK_DATE, 'YYYY-MM-DD') AS BOOK_DATE
, TO_DATE(BOOK_REDATE, 'YYYY-MM-DD') AS BOOK_REDATE
, SIGN_NUM 
FROM BOOK
WHERE BOOK_NUM = 5;

-- �� searchCard ����ī�� ��ȣ�� ����ī��� ��ȸ(������ ����ī�常)
-- OPEN �÷� Y AND CARD_DATE IS NOT NULL �����̸� ������ ����ī��
-- ī���ȣ, ��Ҹ�, ������, ����(���)
SELECT CARD_NUM, CARD_LOCATION, TO_DATE(CARD_DATE, 'YYYY-MM-DD') AS CARD_DATE, NVL(CARD_BUDGET, 0) AS CARD_BUDGET
FROM CARD
WHERE OPEN_NUM = 1 AND CARD_DATE IS NOT NULL
AND SIGN_NUM = 124;


-- CARD, PAY ���̺� ���� (ī�� �󼼳��� ���)
-- ��Ҹ�, �ð�, ����, ����, �޸�, ���� (ȸ�� ����ī�� �󼼳��� - �˾�â, ����ī�� ��ȣ ��ġ�� �� ����)
SELECT C.CARD_LOCATION, C.CARD_TIME, C.CARD_BUDGET, C.CARD_COMMENT, C.CARD_IMG1, C.CARD_IMG2, C.CARD_IMG3 
, P.PAY_NUM, P.CARD_NUM, P.PTYPE_NUM, P.PAY_NAME, P.PAY_AMOUNT
FROM PAY P FULL OUTER JOIN CARD C
ON P.CARD_NUM = C.CARD_NUM
WHERE C.CARD_NUM = 4;


-- �� searchComment ��۹�ȣ�� ����å ��ȸ
SELECT BOOK_NUM
FROM VIEW_COMMENTLIST
WHERE COMMENT_NUM=3;


-- �� searchWarning ��� ��ȣ�� ��� ��ȸ
-- ������� ���̺��� ����̷� ���̺��� �� �� �ֵ��� �ϴ� ����� ���Ծ���
-- ��� : ����ȣ, �����, ó����, ������, ��� ����
-- ����������̺�, �Ű�ó�����̺� JOIN
SELECT TYPE, STATUS_NUM, STATUS_ADMIN, STATUS_DATE, CANCEL_DATE, REASON, CANCEL_ADMIN, WARNING_USER
FROM VIEW_USERWARNINGLIST
WHERE STATUS_NUM = 1
AND TYPE = 'book';

-- �� bReportStatusInsert ����å ��� ó���� ���� �Ű� ó�� ���̺� �ű� ���
INSERT INTO BREPORT_STATUS(BSTATUS_NUM, ADMIN_NUM, BREPORT_NUM, TYPE_NUM, BSTATUS_CHECK)
VALUES(BREPORT_STATUS_SEQ.NEXTVAL, 1, 1, 1, NULL);

-- �� cReportStatusInsert ����ī�� ��� ó���� ���� �Ű� ó�� ���̺� �ű� ���
INSERT INTO CREPORT_STATUS(CSTATUS_NUM, ADMIN_NUM, CREPORT_NUM, TYPE_NUM, CSTATUS_CHECK)
VALUES(CREPORT_STATUS_SEQ.NEXTVAL, 1, 1, 1, NULL);


-- �� bWarningCancelInsert ����å ��� ������ ���� ��� ���� ���̺� �ű� ���
INSERT INTO BWARNING_CANCEL(CCANCEL_NUM, ADMIN_NUM, BSTATUS_NUM, REASON_NUM, CCANCEL_MEMO)
VALUES(BWARNING_CANCEL_SEQ.NEXVAL, 1, 1, 1, '');


-- �� cWarningCancelInsert ����ī�� ��� ������ ���� ��� ���� ���̺� �ű� ���
INSERT INTO CWARNING_CANCEL(CCANCEL_NUM, ADMIN_NUM, BSTATUS_NUM, REASON_NUM, CCANCEL_MEMO)
VALUES(CWARNIN_CANCEL_SEQ.NEXTVAL, 1, 1, 1, '');


-- �� coWarningCancelInsert ��� ��� ������ ���� ��� ���� ���̺� �ű� ���
INSERT INTO COWARNING_CANCEL(COCANCEL_NUM, ADMIN_NUM, COSTATUS_NUM, REASON_NUM, COCANCEL_MEMO)
VALUES(COWARNING_CANCEL_SEQ.NEXTVAL, 1, 1, 1, '');
-- 경고 수 조회(등록번호, 경고수, 정지여부)
CREATE OR REPLACE VIEW VIEW_USERWARNINGCOUNT
AS
SELECT WARNING_USER, COUNT(WARNING_USER) AS WARNING_COUNT
, CASE WHEN COUNT(*) >= 3 THEN 'Y'
ELSE 'N'
END AS STOP_TYPE
FROM VIEW_USERWARNINGLIST
WHERE (SYSDATE-365) < STATUS_DATE  
AND CANCEL_DATE IS NULL
GROUP BY WARNING_USER;
-->
/*
관리자 사이트의 회원관리 페이지에서 
각 회원의 정지여부와 경고 수를 출력해주는 뷰
정지기준 : 현재 날짜 - 365일 기간 기준으로 유효경고 3회 시 정지
경고 수  : 현재 날짜 - 365일 기간 내 유효경고 수 
*/

SELECT *
FROM VIEW_USERWARNINGCOUNT;
--==>>
/*
134	2	N
144	2	N
149	3	Y
139	1	N
*/


-- 각 게시글 기준 경고내역 조회
-- WARNING_USER (허위신고의 경우 신고자에게 경고, 작성한 게시글로 인한 경고는 게시글 작성자에게 경고)
CREATE OR REPLACE VIEW VIEW_USERWARNINGLIST
AS
SELECT TYPE, STATUS_NUM
,(SELECT ADMIN_ID
 FROM ADMIN A
 WHERE STATUS_ADMIN = A.ADMIN_NUM) AS STATUS_ADMIN
, STATUS_DATE, CANCEL_DATE, REASON AS REASON
,(SELECT ADMIN_ID
 FROM ADMIN A
 WHERE CANCEL_ADMIN = A.ADMIN_NUM) AS CANCEL_ADMIN
, WRITER AS WARNING_USER
FROM VIEW_REPORTLIST
WHERE STATUS = 1
UNION ALL
SELECT TYPE, STATUS_NUM
,(SELECT ADMIN_ID
 FROM ADMIN A
 WHERE STATUS_ADMIN = A.ADMIN_NUM) AS STATUS_ADMIN
, STATUS_DATE, CANCEL_DATE, '허위신고' AS REASON
,(SELECT ADMIN_ID
 FROM ADMIN A
 WHERE CANCEL_ADMIN = A.ADMIN_NUM) AS CANCEL_ADMIN
, REPORTER AS WARNING_USER
FROM VIEW_REPORTLIST
WHERE STATUS = 3;

SELECT *
FROM VIEW_USERWARNINGLIST;
--==>>
/*
card    	1	admin01	2023-01-02	2023-01-02	기타	            admin01	124
card	    5	admin02	2023-01-03		        스팸홍보/도배글		    134
book	    1	admin01	2023-01-02	2023-01-02	기타	            admin01	124
book	    4	admin01	2023-01-03	2023-01-03	음란물	        admin01	139
book	    5	admin01	2023-01-03	2023-01-03	스팸홍보/도배글	admin01	144
comment	2	admin02	2023-01-03	2023-01-03	기타	            admin02	144
comment	4	admin02	2023-01-03		        스팸홍보/도배글		    139
card	    4	admin01	2023-01-03		        허위신고		            144
card	    3	admin02	2023-01-03		        허위신고		            134
book	    2	admin01	2023-01-03	2023-01-03	허위신고	        admin01	134
book	    3	admin01	2023-01-03	2023-01-03	허위신고    	    admin01	139
book	    6	admin02	2023-01-05		        허위신고		            149
book	    7	admin02	2023-01-05		        허위신고		            149
book	    8	admin02	2023-01-05		        허위신고		            149
comment	1	admin01	2023-01-02	2023-01-02	허위신고	        admin01	124
comment	1	admin01	2023-01-02	2023-01-03	허위신고    	    admin01	124
comment	3	admin02	2023-01-03		        허위신고		            144
*/


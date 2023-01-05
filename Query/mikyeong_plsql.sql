-- ��� �� ��ȸ(��Ϲ�ȣ, ����, ��������)
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
������ ����Ʈ�� ȸ������ ���������� 
�� ȸ���� �������ο� ��� ���� ������ִ� ��
�������� : ���� ��¥ - 365�� �Ⱓ �������� ��ȿ��� 3ȸ �� ����
��� ��  : ���� ��¥ - 365�� �Ⱓ �� ��ȿ��� �� 
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


-- �� �Խñ� ���� ����� ��ȸ
-- WARNING_USER (�����Ű��� ��� �Ű��ڿ��� ���, �ۼ��� �Խñ۷� ���� ���� �Խñ� �ۼ��ڿ��� ���)
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
, STATUS_DATE, CANCEL_DATE, '�����Ű�' AS REASON
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
card    	1	admin01	2023-01-02	2023-01-02	��Ÿ	            admin01	124
card	    5	admin02	2023-01-03		        ����ȫ��/�����		    134
book	    1	admin01	2023-01-02	2023-01-02	��Ÿ	            admin01	124
book	    4	admin01	2023-01-03	2023-01-03	������	        admin01	139
book	    5	admin01	2023-01-03	2023-01-03	����ȫ��/�����	admin01	144
comment	2	admin02	2023-01-03	2023-01-03	��Ÿ	            admin02	144
comment	4	admin02	2023-01-03		        ����ȫ��/�����		    139
card	    4	admin01	2023-01-03		        �����Ű�		            144
card	    3	admin02	2023-01-03		        �����Ű�		            134
book	    2	admin01	2023-01-03	2023-01-03	�����Ű�	        admin01	134
book	    3	admin01	2023-01-03	2023-01-03	�����Ű�    	    admin01	139
book	    6	admin02	2023-01-05		        �����Ű�		            149
book	    7	admin02	2023-01-05		        �����Ű�		            149
book	    8	admin02	2023-01-05		        �����Ű�		            149
comment	1	admin01	2023-01-02	2023-01-02	�����Ű�	        admin01	124
comment	1	admin01	2023-01-02	2023-01-03	�����Ű�    	    admin01	124
comment	3	admin02	2023-01-03		        �����Ű�		            144
*/


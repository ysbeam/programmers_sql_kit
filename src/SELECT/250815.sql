/*
[#1 조건에 부합하는 중고거래 댓글 조회하기]
a와 b는 alias로 별명임
DATE_FORMAT이라는 함수를 사용하여 날짜를 원하는 형식의 문자열로 변환해줌
뒤에 정렬은 각각 1차 정렬, 2차정렬임
 */
SELECT a.TITLE, a.BOARD_ID, b.REPLY_ID, b.WRITER_ID, b.CONTENTS, DATE_FORMAT(b.CREATED_DATE, '%Y-%m-%d') as CREATED_DATE FROM USED_GOODS_BOARD a JOIN USED_GOODS_REPLY b ON a.BOARD_ID = b.BOARD_ID WHERE DATE_FORMAT(a.CREATED_DATE,'%Y-%m') = '2022-10' ORDER BY b.CREATED_DATE, a.TITLE;

/*
[#2 과일로 만든 아이스크림 고르기]
WHERE 절 사용 시 조건이 여러 개일 경우 AND로 연결해주기
 */
SELECT a.FLAVOR FROM FIRST_HALF a JOIN ICECREAM_INFO b ON a.FLAVOR = b.FLAVOR WHERE a.TOTAL_ORDER > 3000 AND b.INGREDIENT_TYPE = 'fruit_based' ORDER BY a.TOTAL_ORDER DESC

/*
[#3 흉부외과 또는 일반외과 의사 목록 출력하기]
IN 문법: WHERE 절에서 여러 개의 값 중 하나라도 일치하는지를 확인할 때 사용하는 조건식
 */
SELECT DR_NAME, DR_ID, MCDP_CD, DATE_FORMAT(HIRE_YMD, '%Y-%m-%d') AS HIRE_YMD FROM DOCTOR WHERE MCDP_CD IN('CS', 'GS') ORDER BY HIRE_YMD DESC, DR_NAME

/*
[#4 12세 이하인 여자 환자 목록 출력하기]
풀이 1. IF문, ISNULL 함께 사용: 컬럼이 NULL인지 검사해서 조건에 따라 값을 반환
        IF(ISNULL(칼럼명), 참일 때 값, 거짓일 때 값)

풀이 2. IFNULL 함수 사용: 컬럼명이 NULL이면 대체값을 반환, NULL이 아니면 원래 값을 반환
        IFNULL(컬럼명, 대체값)

풀이 3. COALESCE 함수 사용: 여러 개의 인자를 받아서, 왼쪽부터 차례대로 NULL이 아닌 첫 번째 값을 반환
        COALESCE(값1, 값2, 값3, ..., 기본값)
        - 첫번째 값 -> NULL -> 넘어감
        - 두번째 값 -> '값2' -> 여기서 반환
        - 세번째 값은 확인 X
        (모든 값이 NULL일 경우, NULL 반환)
 */
SELECT PT_NAME, PT_NO, GEND_CD, AGE, IF(ISNULL(TLNO), 'NONE', TLNO) FROM PATIENT WHERE AGE <= 12 AND GEND_CD = 'W' ORDER BY AGE DESC, PT_NAME
SELECT PT_NAME, PT_NO, GEND_CD, AGE, ifnull(TLNO, 'NONE') AS TLNO FROM PATIENT WHERE AGE <= 12 AND GEND_CD = 'W' ORDER BY AGE DESC, PT_NAME
SELECT PT_NAME, PT_NO, GEND_CD, AGE, COALESCE(TLNO, 'NONE') AS TLNO FROM PATIENT WHERE AGE <= 12 AND GEND_CD = 'W' ORDER BY AGE DESC, PT_NAME

/*
[#5 인기있는 아이스크림]
 */
SELECT FLAVOR FROM FIRST_HALF ORDER BY TOTAL_ORDER DESC, SHIPMENT_ID

/*
[#6 조건에 맞는 도서 리스트 출력하기]
올바른 형태: '%Y-%m-%d' ('%Y-%M-%D' 불가능)
 */
SELECT BOOK_ID, DATE_FORMAT(PUBLISHED_DATE, '%Y-%m-%d') AS PUBLISHED_DATE FROM BOOK WHERE YEAR(PUBLISHED_DATE) = 2021 AND CATEGORY = '인문' ORDER BY PUBLISHED_DATE

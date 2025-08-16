/*
 [#7 평균 일일 대여 요금 구하기]
 TRUNC 함수: 소수점 이하가 전부 잘리고, 정수 부분만 반환
 */
SELECT TRUNC(AVG(DAILY_FEE)) AS AVERAGE_FEE FROM CAR_RENTAL_COMPANY_CAR WHERE CAR_TYPE = 'SUV';

/*
 [#8 3월에 태어난 여성 회원 목록 출력하기]
 IS NOT NULL: NULL 제외 조건
 */
SELECT MEMBER_ID, MEMBER_NAME, GENDER, TO_CHAR(DATE_OF_BIRTH, 'YYYY-MM-DD') AS DATE_OF_BIRTH FROM MEMBER_PROFILE WHERE EXTRACT(MONTH FROM DATE_OF_BIRTH) = 03 AND TLNO IS NOT NULL AND GENDER = 'W' ORDER BY MEMBER_ID;

/*
 [#9 강원도에 위치한 생산공장 목록 출력하기]
 LIKE '패턴': 문자열 패턴 매칭
 */
SELECT FACTORY_ID, FACTORY_NAME, ADDRESS FROM FOOD_FACTORY WHERE ADDRESS LIKE '강원도%' ORDER BY FACTORY_ID;

/*
 [#10 재구매가 일어난 상품과 회원 리스트 구하기]
 GROUP BY: 같은 조합별로 묶음(SELECT 결과를 특정 컬럼 값 기준으로 그룹화, 뒤에 컬럼 하나가 와도 됨)
 HAVING 절: GROUP BY로 묶은 그룹 단위 조건 (이와 달리 WHERE은 행 단위 조건임)
 */
SELECT USER_ID, PRODUCT_ID FROM ONLINE_SALE GROUP BY(USER_ID, PRODUCT_ID) HAVING COUNT(*) > 1 ORDER BY USER_ID, PRODUCT_ID DESC;

-- [#11 모든 레코드 조회하기]
SELECT * FROM ANIMAL_INS ORDER BY ANIMAL_ID

-- [#12 역순 정렬하기]
SELECT NAME, DATETIME FROM ANIMAL_INS ORDER BY ANIMAL_ID DESC;

-- [#13 아픈 동물 찾기]
SELECT ANIMAL_ID, NAME FROM ANIMAL_INS WHERE INTAKE_CONDITION = 'Sick' ORDER BY ANIMAL_ID;

/*
 [#14 어린 동물 찾기]
 != : 같지 않을 때 비교 연산자 사용
 */
SELECT ANIMAL_ID, NAME FROM ANIMAL_INS WHERE INTAKE_CONDITION != 'Aged' ORDER BY ANIMAL_ID;

-- [#15 동물의 아이디와 이름]
SELECT ANIMAL_ID, NAME FROM ANIMAL_INS ORDER BY ANIMAL_ID;

-- [#16 여러 기준으로 정렬하기]
SELECT ANIMAL_ID, NAME, DATETIME FROM ANIMAL_INS ORDER BY NAME, DATETIME DESC;

/*
 [#17 상위 n개 레코드]
 ROWNUM 적용 시 괄호(서브쿼리)를 사용해야 하는 이유: 실행 순서 때문. ORDER BY(정렬)가 먼저 적용되어야 한다. 결과적으로는 정렬된 결과에서 원하는 행만큼 가져오는 것임.
 */
SELECT NAME FROM (SELECT NAME FROM ANIMAL_INS ORDER BY DATETIME) WHERE ROWNUM = 1;

/*
 [#18 조건에 맞는 회원 수 구하기]
 TO_CHAR 이용해서 날짜 형식 맞춰준 상태로 WHERE 절 쓴게 핵심
 범위조건: 컬럼명 BETWEEN 하한값 AND 상한값 (TO가 아니라 AND임)
 */
SELECT COUNT(USER_ID) AS USERS FROM USER_INFO WHERE TO_CHAR(JOINED, 'YYYY') = '2021' AND AGE BETWEEN 20 AND 29;

/*
 [#19 서울에 위치한 식당 목록 출력하기]
 ***중요: SELECT 절에서 집계함수(AVG, SUM, COUNT 등)와 일반 컬럼을 같이 쓰려면 집계함수를 제외한 일반 컬럼들을 그룹화 기준(GROUP BY)으로 지정해야 함.
 */
SELECT a.REST_ID, a.REST_NAME, a.FOOD_TYPE, a.FAVORITES, a.ADDRESS, ROUND(AVG(b.REVIEW_SCORE),2) AS SCORE FROM REST_INFO a JOIN REST_REVIEW b ON a.REST_ID = b.REST_ID WHERE ADDRESS LIKE '서울%' GROUP BY a.REST_ID, a.REST_NAME, a.FOOD_TYPE, a.FAVORITES, a.ADDRESS ORDER BY SCORE DESC, a.FAVORITES DESC;

/*
 [#20 오프라인/온라인 판매 데이터 통합하기] *SELECT 채널 문제 중 가장 난이도 있었던 문제
 1. UNION vs UNION ALL
 - UNION: 두 SELECT 결과를 합친 후 중복 제거
 - UNION ALL: 두 SELECT 결과를 그냥 합침(중복 제거 X)
 ==> 이 문제에서 UNION ALL을 쓰는 이유: 온라인 판매 + 오프라인 판매 그냥 합쳐서 보여주는 것이 목적이며, 오프라인은 USER_ID가 없음. 중복 제거가 필요없으며 오히려 있는 그대로 보여줘야 함.

 2. NULL AS user_id
 - 사용 이유: UNION이나 UNION ALL 사용 시, 양쪽 SELECT의 컬럼 개수, 타입, 순서가 같아야 함. 따라서 오프라인 부분에는 없는 USER_ID 자리에 NULL을 넣어줘야 함.
 */
SELECT TO_CHAR(sales_date,'YYYY-MM-DD') AS SALES_DATE, product_id, user_id, sales_amount
FROM (
    SELECT a.sales_date, a.product_id, a.user_id, a.sales_amount
    FROM ONLINE_SALE a
    WHERE a.SALES_DATE >= DATE '2022-03-01' AND a.SALES_DATE < DATE '2022-04-01'
    UNION ALL
    SELECT b.sales_date, b.product_id, NULL AS user_id, b.sales_amount
    FROM OFFLINE_SALE b
    WHERE b.SALES_DATE >= DATE '2022-03-01' AND b.SALES_DATE < DATE '2022-04-01'
     )
ORDER BY sales_date, product_id, user_id;

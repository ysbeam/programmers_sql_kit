/*
 [#1 진료과별 총 예약 횟수 출력하기]
 -- 의문점
 1. SELECT문에 두번째꺼가 왜 COUNT(*)인지?
     - 여기서 COUNT(*)란, 그룹 안에 속한 모든 행의 개수를 세는 함수임. 한 행 = 하나의 예약

 2. GROUP BY를 MCDP_CD로만 묶음. 왜 PT_NO는 안 들어가는지?
    - 문제는 '진료과 코드별 예약 수'만 구하라고 했기 때문에 해당 요소 하나로 충분

 -- 기존 나의 코드와 다른점: 정답코드의 경우, TO_CHAR로 포맷 변경 후 비교하는 부분을 WHERE 절에서 씀. (EXTRACT 사용 안 함)
 -- 참고: 정렬 시 앞에서 이미 GROUP BY로 묶어주었기 때문에 COUNT(*)로 충분
 */
SELECT MCDP_CD AS "진료과코드", COUNT(*) AS "5월예약건수" FROM APPOINTMENT WHERE TO_CHAR(APNT_YMD, 'YYMM') = '2205' GROUP BY MCDP_CD ORDER BY COUNT(*), MCDP_CD;

/*
 [#2 성분으로 구분한 아이스크림 총 주문량]
 -- 기존 나의 코드와 다른점: SELECT문에서 COUNT가 아닌 SUM을 씀. 이어서 컬럼명도 지어줌
 -- 주의점: 마지막 정렬 시 b.TOTAL_ORDER이 아니라 그냥 TOTAL_ORDER임. 컬럼명을 별도로 지정해줬기 때문임.
 */
SELECT a.INGREDIENT_TYPE, SUM(b.TOTAL_ORDER) AS TOTAL_ORDER FROM ICECREAM_INFO a JOIN FIRST_HALF b ON a.FLAVOR = b.FLAVOR GROUP BY a.INGREDIENT_TYPE ORDER BY TOTAL_ORDER;

/*
 [#3 자동차 종류 별 특정 옵션이 포함된 자동차 수 구하기]
 -- 의문점
 1. IN 함수를 사용하지 못하는 이유 ex. IN('열선시트','가죽시트') : OPTIONS 컬럼에 단일 값이 들어있을 때만 가능한 방법이기 때문.
 */
SELECT CAR_TYPE, COUNT(*) AS CARS
FROM CAR_RENTAL_COMPANY_CAR
WHERE OPTIONS LIKE '%__시트%'
GROUP BY CAR_TYPE ORDER BY CAR_TYPE;

-- [#4 고양이와 개는 몇 마리 있을까]
SELECT ANIMAL_TYPE, COUNT(*) AS count
FROM ANIMAL_INS
GROUP BY ANIMAL_TYPE
ORDER BY ANIMAL_TYPE;

/*
 [#5 동명 동물 수 찾기] -- 배울점이 많은 문항
 1. ***중요: WHERE 절 안에서는 집계함수를 사용할 수 없음. -> 집계함수를 사용하기 위해 HAVING 절을 사용하는 것.
 2. SELECT문에서 COUNT(NAME)라고 명시했기 때문에 뒤에 HAVING 절에서도 COUNT(NAME)라고 작성해야 함. COUNT(*)라고 작성하면 오답임.
 3. COUNT의 응용: COUNT(컬럼명) -> 그 컬럼 값이 NULL이 아닌 행 개수임. 따라서 NULL이 아닌 행의 개수만 카운트 됨.
 */
SELECT NAME, COUNT(NAME) AS COUNT FROM ANIMAL_INS GROUP BY NAME HAVING COUNT(NAME) > 1 ORDER BY NAME;

/*
 [#6 입양 시각 구하기(1)
 TO_CHAR과 TO_NUMBER의 차이(ex. HH24 포맷일 경우): TO_CHAR -> 09, TO_NUMBER -> 9 (이름 그대로 문자열이 아닌 숫자로 변환해줌)
 *** 중요: TO_NUMBER(칼럼명, 'HH24') -> 사용 불가. TO_NUMBER(TO_CHAR(칼럼명, 'HH24')) -> 이렇게 사용해야 함.
 */
SELECT TO_NUMBER(TO_CHAR(DATETIME, 'HH24')) AS HOUR, COUNT(*) AS COUNT
FROM ANIMAL_OUTS
WHERE TO_CHAR(DATETIME, 'HH24') BETWEEN 09 AND 19
GROUP BY TO_CHAR(DATETIME, 'HH24')
ORDER BY HOUR;

/*
 [#7 가격대 별 상품 개수 구하기]
 FLOOR문 + 차이점 분석
 */
-- SELECT FLOOR(PRICE/10000)*10000 AS PRICE_GROUP,
--     COUNT(*) AS PRODUCTS FROM PRODUCT
--     WHERE PRICE < 40000
--     GROUP BY FLOOR(PRICE/10000)*10000
--     ORDER BY PRICE_GROUP;

SELECT FLOOR(PRICE/10000)*10000 PRICE_GROUP, COUNT(PRODUCT_CODE) PRODUCTS
FROM PRODUCT
GROUP BY FLOOR(PRICE/10000)
ORDER BY PRICE_GROUP;

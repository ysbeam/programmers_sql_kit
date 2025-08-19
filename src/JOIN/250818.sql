/*
 [#1 조건에 맞는 도서와 저자 리스트 출력하기]
 */
SELECT a.BOOK_ID, b.AUTHOR_NAME, TO_CHAR(a.PUBLISHED_DATE, 'YYYY-MM-DD') AS PUBLISHED_DATE FROM BOOK a JOIN AUTHOR b ON a.AUTHOR_ID = b.AUTHOR_ID WHERE CATEGORY = '경제' ORDER BY a.PUBLISHED_DATE;

/*
 [#2 ]
 1) SUM 집계함수를 사용해야 하는 이유: 여러 판매건(행)을 합쳐서 총합 매출액 계산(상풍별 총 매출액). 안 쓰면 각 판매 건 매출액이 됨.
 2) GROUP BY를 사용해야 하는 이유: 같은 상품코드를 기준으로 묶어서 합계를 계산하기 때문
 */
SELECT a.PRODUCT_CODE, SUM(a.PRICE*b.SALES_AMOUNT) AS SALES FROM PRODUCT a JOIN OFFLINE_SALE b ON a.PRODUCT_ID = b.PRODUCT_ID GROUP BY a.PRODUCT_CODE ORDER BY SALES DESC, a.PRODUCT_CODE;

/*
 [#3 없어진 기록 찾기]
 1) WHERE 칼럼명 IS NULL 적극 활용하기
 2) ***JOIN(=INNER JOIN)은 양쪽 테이블 모두에 존재하는 행만 가져옴. 즉, ANIMAL_OUTS와 ANIMAL_INS에 둘 다 존재하는 동물 ID만 조회됨.
    하지만 문제에서는 INS에 없는 동물을 찾는 게 목적이므로 LEFT JOIN을 활용해야 함.
    LEFT JOIN(FROM 뒤에 먼저 나온 테이블)은 왼쪽 테이블(ANIMAL_OUTS)의 모든 데이터를 가져오고, 오른쪽 테이블(ANIMAL_INS)에 매칭되는 게 없으면 NULL을 채움.
    즉, LEFT JOIN + IS NULL: 차집합(OUTS에는 있는데 INS에는 없는 동물 찾기)
 */
SELECT b.ANIMAL_ID, b.NAME FROM ANIMAL_OUTS b LEFT JOIN ANIMAL_INS a ON a.ANIMAL_ID = b.ANIMAL_ID WHERE a.ANIMAL_ID IS NULL ORDER BY b.ANIMAL_ID;

/*
 [#4 있었는데요 없었습니다]
 1) 날짜 비교는 숫자 비교처럼 더 늦은 날짜 = 더 큰 값, 더 이른 날짜 = 더 작은 값으로 취급함
    ex) WHERE a.DATETIME(보호시작일) > b.DATETIME(입양일) -> 이 조건이 참이 되려면 보호 시작일이 입양일보다 늦어야 한다는 의미임.
 */
SELECT a.ANIMAL_ID, a.NAME FROM ANIMAL_INS a JOIN ANIMAL_OUTS b ON a.ANIMAL_ID = b.ANIMAL_ID WHERE a.DATETIME > b.DATETIME ORDER BY a.DATETIME;

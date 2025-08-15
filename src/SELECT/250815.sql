-- 조건에 부합하는 중고거래 댓글 조회하기
SELECT a.TITLE, a.BOARD_ID, b.REPLY_ID, b.WRITER_ID, b.CONTENTS, DATE_FORMAT(b.CREATED_DATE, '%Y-%m-%d') as CREATED_DATE FROM USED_GOODS_BOARD a JOIN USED_GOODS_REPLY b ON a.BOARD_ID = b.BOARD_ID WHERE DATE_FORMAT(a.CREATED_DATE,'%Y-%m') = '2022-10' ORDER BY b.CREATED_DATE, a.TITLE;

/*
a와 b는 alias로 별명임
DATE_FORMAT이라는 함수를 사용하여 날짜를 원하는 형식의 문자열로 변환해줌
뒤에 정렬은 각각 1차 정렬, 2차정렬임
 */

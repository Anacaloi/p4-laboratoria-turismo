## Segmenta Lead_time em Curto, Médio e Longo
SELECT *,
CASE
  WHEN lead_time BETWEEN 0 AND 29 THEN "Curto"
  WHEN lead_time BETWEEN 29 AND 90 THEN "Médio"
  WHEN lead_time > 90 THEN "Longo"
  END AS lead_time_segment
 FROM `projeto-4-ana-caloi.hotel_bookings.tabela3` 


 ## Transforma a variável arrival_date para o formato DATE YYYY-MM-DD
 SELECT *,
 CASE
  WHEN arrival_date_month IN ('January') THEN "01"
  WHEN arrival_date_month IN ('February') THEN "02"
  WHEN arrival_date_month IN ('March') THEN "03"
  WHEN arrival_date_month IN ('April') THEN "04"
  WHEN arrival_date_month IN ('May') THEN "05"
  WHEN arrival_date_month IN ('June') THEN "06"
  WHEN arrival_date_month IN ('July') THEN "07"
  WHEN arrival_date_month IN ('August') THEN "08"
  WHEN arrival_date_month IN ('September') THEN "09"
  WHEN arrival_date_month IN ('October') THEN "10"
  WHEN arrival_date_month IN ('November') THEN "11"
  WHEN arrival_date_month IN ('December') THEN "12"
  END AS arrival_month_number
 FROM `projeto-4-ana-caloi.hotel_bookings.tabela4` 

 SELECT *, CONCAT(arrival_date_year,'-', arrival_month_number, '-', arrival_date_day_of_month) AS arrival_date_2
  FROM `projeto-4-ana-caloi.hotel_bookings.arrival_date_month_number` 

SELECT *,
 CAST (arrival_date_2 AS DATE) AS arrival_date_v2 
 FROM `projeto-4-ana-caloi.hotel_bookings.arrival_date2`


 ## Cria coluna booking_date

SELECT *,
date_sub(arrival_date_v2, INTERVAL lead_time day) AS booking_date
 FROM `projeto-4-ana-caloi.hotel_bookings.arrival_date_v2` 
 

 ## Calcula o Adr médio por tipo de hotel
SELECT hotel, AVG(adr) AS pag_medio_por_noite
FROM `projeto-4-ana-caloi.hotel_bookings.booking_date`
GROUP BY hotel


 ## Calcula o número de reservas por segmento de lead time 
SELECT lead_time_segment,
  COUNT (arrival_date_v2) AS reservations_leadtime_segment
  FROM `projeto-4-ana-caloi.hotel_bookings.booking_date`
 GROUP BY lead_time_segment

 ## Calcula o número de reservas por tipo de hotel 
SELECT hotel,
  COUNT (arrival_date_v2) AS bookings_per_hotel_2015_2016
  FROM `projeto-4-ana-caloi.hotel_bookings.booking_date` WHERE arrival_date_year BETWEEN 2015 AND 2016
 GROUP BY hotel

 ## Calcula o número de reservas que existe para cada ano e para cada tipo de hotel
 SELECT hotel, arrival_date_year,
  COUNT (arrival_date_v2) AS bookings_per_hotel_year
  FROM `projeto-4-ana-caloi.hotel_bookings.booking_date` 
 GROUP BY hotel, arrival_date_year

 ## Calcula o número de reservas que existe para cada ano-mês e para cada tipo de hotel
SELECT *, CONCAT(arrival_date_year,'-', arrival_month_number) AS arrival_date_year_month
  FROM `projeto-4-ana-caloi.hotel_bookings.arrival_date_month_number` 

 SELECT hotel, arrival_date_year_month,
  COUNT (arrival_date) AS bookings_per_hotel_year_month
  FROM `projeto-4-ana-caloi.hotel_bookings.arrival_date_year_month`
 GROUP BY hotel, arrival_date_year_month


## Calcula o número de reservas que existe para cada ano-mês e para cada tipo de hotel em que foram feitas mais de 3.500 reservas

 SELECT hotel, arrival_date_year_month,
  COUNT (arrival_date) AS bookings_per_hotel_year_month
  FROM `projeto-4-ana-caloi.hotel_bookings.arrival_date_year_month` 
 GROUP BY hotel, arrival_date_year_month HAVING bookings_per_hotel_year_month > 3500


## Agrupa o número de reservas feitas por tipo de hotel e por data e compara com os cancelamentos
 SELECT hotel, arrival_date_v2,
  COUNT (arrival_date) AS bookings_per_hotel_date,
  SUM(is_canceled) AS num_canceled
  FROM `projeto-4-ana-caloi.hotel_bookings.arrival_date_v2` 
 GROUP BY arrival_date_v2, hotel
 ORDER BY hotel, arrival_date_v2


## Calcula o impacto de um cancelamento devido ao pagamento de comissão de MKT
SELECT booking_date,
SUM(is_canceled) AS canceled_bookings,
COUNT(*) - SUM(is_canceled)  AS not_canceled_bookings,
SUM(is_canceled)*1.5 AS canceled_bookings_payment,
(COUNT(*) - SUM(is_canceled))*1.5  AS not_canceled_bookings_payment,
FROM `projeto-4-ana-caloi.hotel_bookings.booking_date` 
GROUP BY booking_date
ORDER BY booking_date


## Calcula o impacto de um cancelamento feito com menos de 3 dias de antecedência
SELECT booking_date,
DATE_DIFF(arrival_date_v2, reservation_status_date, DAY) AS days_between_cancelation_and_arrival
FROM `projeto-4-ana-caloi.hotel_bookings.booking_date` 
ORDER BY booking_date

## Hipótese 1: Reservas feitas com antecedência correm alto risco de cancelamento


## Hipótese 2: Reservas que incluem crianças têm menor risco de cancelamento


## Hipótese 3: Os usuários que fizeram uma alteração em sua reserva têm menor risco de cancelamento


## Hipótese 4: Quando o usuário fez uma solicitação especial, o risco de cancelamento é menor


## Hipótese 5: Reservas que possuem um baixo "adr" o risco é menor

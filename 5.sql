select customer_id,
count(*) as total_record -- có bao nhiêu bản ghi đơn hàng được thanh toán
from payment
where payment_date >= '2020-01-30'
group by customer_id -- mỗi khách hàng có bao nhiêu đơn hàng
having count(*) <= 15 -- khách hàng có tổng số đơn hàng nhỏ hơn 15
order by total_record desc -- sắp xếp
limit 5 -- giới hạn 
--Thứ tự:
select -> from -> where -> group by -> having -> order by -> limit
--- Bài 5
1. Lower, upper, length
select email,
lower(email) as lower_email,
upper(email) as upper_email,
length(email) as length_email
from customer
where length(email) >=30
--Challenge: Liệt kê khách hàng có họ và tên lớn hơn 10 kí tự
		--: Kết quả trả ra ở dạng chữ thường
	select 
	lower(first_name) as first_name,
	lower(last_name) as last_name
	from customer
	where length(first_name)>10
	or length(last_name) >10
2. Left(). right(): Hiển thị một vài kí tự đầu hoặc kí tự cuối
select first_name,
left(first_name,3),
right(first_name,2)
from customer
--
select first_name,
right(left(first_name,3),2)
from customer
--Challenge: trích xuất 5 ký tự cuối cùng của email
-- địa chỉ email luôn kết thúc bằng 'org'
-- Làm thế nào để trích xuất chỉ dấu chấm '.' từ email
select 
left(right(email,4),1)
from customer
3. Concatenate ( nối chuỗi )
select customer_id, first_name, last_name,
first_name || ' ' || last_name as full_name, -- || dùng để nối chuỗi
concat(first_name,' ', last_name) as full_name
from customer
--Challenge: bảo mật dữ liệu khách hàng cần mask địa chỉ email như sau:
--mary.smith@sakilacustomer.org
--> mar***h@sakilacustomer.org
select email,
left(email,3) || '***' || right(email,20)
from customer
4. Replace()
select email,
replace(email,'.org','.com') as new_email
from customer
-- EX3 _ Practice 02
select
ceil(avg(salary)-avg(replace(salary,'0','')))
from emplyees
5. Position: Xác định vị trí 
select email,
left(email,position('@' in email)-1)
from customer
6. Substring: Lấy ra kí tự
  --Lấy ra kí tự từ 2 đến 4 của first_name
select
right(left(first_name,4),3),
substring(first_name from 2 for 3 ) --trích xuất các kí tự từ first name bắt đầu từ kí tự thứ 2 3 kí tự
from customer;
--Lấy thông tin họ của khách hàng từ email
select
substring(email from position('.' in email)+1 for position ('@' in email)-position('.' in email)-1)
from customer
--Challenge: Chỉ có email và họ khách hàng
--Cần trích xuất tên từ địa chỉ email và nối nó với họ
--Kết quả phải ở dạng "Họ,tên"
select email,
last_name,
substring(email from 1 for position('.' in email)-1) as first_name,
last_name ||' '||','||' '|| substring(email from 1 for position('.' in email)-1)
from customer
7. Extract
Date/Time Type
- Date: Ngày tháng năm --> Ex: 2024-01-21
- Time: Có hoặc không múi giờ --> Ex: 01:02:03.678
- Timestamp: Ngày giờ và có thể có hoặc không múi giờ
- Intervals: Chênh lệch ngày và giờ 
* Cú pháp: 
Select extract ( field from date/time/intervals)
field: part of date/time
date/time/intervals: date/time we want to extract
select rental_date,
extract(month from rental_date),
extract(year from rental_date),
extract(hour from rental_date),
extract(dow from rental_date),
extract(doy from rental_date)
from rental;
--Năm 2020 có bao nhiêu đơn hàng cho thuê trong mỗi tháng
select extract(month from rental_date),
count(*) 
from rental
where extract(year from rental_date) ='2020'
group by extract(month from rental_date)
Challenge: Phân tích các khoản thanh toán
--Tháng nào có tổng số tiền thanh toán cao nhất
--Ngày nào trong tuần có tổng số tiền thanh toán cao nhất (0 là chủ nhật)
--Số tiền cao nhất mà khách hàng đã chi tiêu 1 tuần là bao nhiêu
select extract (month from payment_date) as month_of_year,
sum(amount) as total_amount
from payment
group by extract (month from payment_date)
order by sum (amount) desc;

select extract (day from payment_date) as day_of_week,
sum(amount) as total_amount
from payment
group by extract (day from payment_date)
order by sum (amount) desc;

select customer_id, extract(week from payment_date),
sum(amount) as total_amount
from payment
group by customer_id,extract(week from payment_date)
order by sum (amount)  desc
8. To_char: hiển thị theo thứ tự Linh hoạt đưa về bất cứ dạng nào mong muốn
to_char(trường thông tin muốn thay đổi format,format)
select payment_date,
extract (day from payment_date ),
to_char(payment_date,'dd-mm-yy hh:mm:ss'),
to_char(payment_date,'dd-mm'),
to_char(payment_date,'month'),
to_char(payment_date,'yyyy')
from payment
9. Interval và timestamp: khoảng thời gian giữa hai ngày bất kì
select current_date, current_timestamp,
customer_id,
rental_date,
return_date,
extract(day from return_date - rental_date)*24 + 
extract (hour from return_date - rental_date) ||' '||'giờ'
from rental
--Challenge: tạo danh sách tất cả thời gian đã thuê của khách hàng với customer_id 35
--Ngoài ra tìm hiểu khách hàng nào có thời gian thuê trung bình dài nhất
select 
customer_id
rental_date,
return_date,
return_date - rental_date as rental_time
from rental
where customer_id = 35;

select customer_id,
avg(return_date - rental_date) as avg_rental_time
from rental
group by customer_id 
order by customer_id desc ;



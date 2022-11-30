drop table if exists analysis.tmp_rfm_monetary_value;
CREATE TABLE analysis.tmp_rfm_monetary_value (
 user_id INT NOT NULL PRIMARY KEY,
 monetary_value INT NOT NULL CHECK(monetary_value >= 1 AND monetary_value <= 5)
);

insert into analysis.tmp_rfm_monetary_value (user_id, monetary_value) (
with asp as (select o.user_id, 
					o.order_ts,
					o.payment,
					os.key
			from analysis.orders o
			left join analysis.orderstatuses as os on o.status = os.id
			where os.key = 'Closed' and o.status = os.id and o.order_ts >= '2022-01-01'),
asd as (select u.id, 
				sum(coalesce (payment, 0)) as sum_payment
		from analysis.users u 
		left join asp on u.id = asp.user_id
		group by u.id)
select id,
		ntile(5) over (order by sum_payment) as monetary_value
from asd
);
drop table if exists analysis.tmp_rfm_frequency;
CREATE TABLE analysis.tmp_rfm_frequency (
 user_id INT NOT NULL PRIMARY KEY,
 frequency INT NOT NULL CHECK(frequency >= 1 AND frequency <= 5)
);

insert into analysis.tmp_rfm_frequency (user_id, frequency) (
with asp as (select o.user_id, 
					o.order_ts,
					os.key
			from analysis.orders o
			left join analysis.orderstatuses as os on o.status = os.id
			where os.key = 'Closed' and o.status = os.id and o.order_ts >= '2022-01-01'),
asd as (select u.id, 
				count(coalesce (order_ts, '2022-01-01'::timestamp)) as last_order
		from analysis.users u 
		left join asp on u.id = asp.user_id
		group by u.id)
select id,
		ntile(5) over (order by last_order) as frequency
from asd
);
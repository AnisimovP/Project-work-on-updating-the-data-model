CREATE TABLE analysis.tmp_rfm_recency (
 user_id INT NOT NULL PRIMARY KEY,
 recency INT NOT NULL CHECK(recency >= 1 AND recency <= 5)
);

insert into analysis.tmp_rfm_recency(
with asp as (select o.user_id, 
					o.order_ts, 
					os.key
			from analysis.orders o
			left join analysis.orderstatuses as os on o.status = os.id
			where os.key = 'Closed' and o.status = os.id and o.order_ts >= '2022-01-01'),
asd as (select u.id, 
				MAX(coalesce (order_ts, '2022-01-01'::timestamp)) as last_order
		from analysis.users u 
		left join asp on u.id = asp.user_id
		group by u.id),
recency as (select id,
				(localtimestamp - last_order) as recency
			from asd)
select id,
		ntile(5) over (order by recency desc) as recency
from recency
);
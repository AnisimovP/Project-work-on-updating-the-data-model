insert into analysis.dm_rfm_segments (
select 
		f.user_id ,
		r.recency,
		f.frequency,
		m.monetary_value
from analysis.tmp_rfm_frequency as f
full join analysis.tmp_rfm_monetary_value as m on f.user_id = m.user_id
full join analysis.tmp_rfm_recency as r on f.user_id = r.user_id
order by f.user_id
);

user_id	recency	frequency	monetary_value
0	1	3	4
1	4	3	3
2	2	3	5
3	2	3	3
4	4	3	3
5	5	5	5
6	1	3	5
7	4	2	2
8	1	2	3
9	1	2	2
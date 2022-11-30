create table analysis.dm_rfm_segments(
	user_id int4 not null,
	recency int4 not null,
	frequency int4 not null,
	monetary_value int4 not null,
	CONSTRAINT recency_check check (recency between 1 AND 5),
	CONSTRAINT frequency_check check (frequency between 1 AND 5),
	CONSTRAINT monetary_check check (monetary_value between 1 AND 5),
	constraint user_id_pk primary key (user_id)
);
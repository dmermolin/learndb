
-- Создание таблицы дней декабрь 2021
SELECT * into days
FROM generate_series(
  '2021-12-01'::TIMESTAMP,
  '2021-12-01'::TIMESTAMP + INTERVAL '1 month -1 day',
  INTERVAL '1 day'
) AS days(day);
-----
create table departments(id_d serial primary key,
						name_d varchar(50),
						date_create date);
----
insert into departments(name_d, date_create)
values ('юридический','20/12/2021'),
		('бухгалтерия','05/12/2021'),
		('продажи','10/12/2021');
---
create table workers(id_w serial primary key,
		fio varchar(100),
		date_create date,
		id_d integer,
		CONSTRAINT fk_dep_id FOREIGN KEY (id_d)
        REFERENCES public.departments (id_d));

insert into workers(fio, date_create, id_d)
values ('Иванов', '05/12/2021', 1),
		('Савин', '10/12/2021', 2),
		('Клюев', '11/12/2021', 2),
		('Павлов', '15/12/2021', NULL);

--------CROSS JOIN
select * from days cross join departments;

select * from days, departments;

select * from days inner join departments on 1 = 1;
---- 

select * from days inner join departments 
						on day >= date_create;

select * from days inner join departments on 1 = 1
	where day >= date_create;

select * from days inner join departments on true
	where day >= date_create;
	
select * from days cross join departments
	where day >= date_create;	

--- INNER JOIN

select * from departments inner join workers 
		on  departments.id_d = workers.id_d;
		
select * from departments, workers 
	where departments.id_d = workers.id_d;


select * from days, departments inner join workers 
		on departments.id_d = workers.id_d;

select * from days as dys, departments as dpt inner join workers as wrr 
		on dpt.id_d = wrr.id_d;

select * from days as dys, departments as dpt inner join workers as wrr 
		on dys.day >= wrr.date_create;

select * from days as dys cross join departments as dpt inner join workers as wrr 
		on dys.day >= wrr.date_create;


select * from days as dys cross join departments as dpt  
			full join workers as wrr on dpt.id_d = wrr.id_d;

----	using	
select * from departments join workers 
		using(id_d);

----- NATURAL
select * from departments natural join workers; 

select * from departments join workers 
		using(id_d, date_create);
		
select * from departments natural join days;


------- Left, Rigth, Full
select * from departments left join workers 
		using(id_d);

select * from departments right join workers 
		using(id_d);

select * from departments full join workers 
		using(id_d);

----отделы с количеством человек в них
select name_d, count(workers.id_d) from departments join workers 
	on departments.id_d = workers.id_d
	group by departments.name_d;


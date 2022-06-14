create table if not exists dc.fractions
(
    id serial not null constraint fractions_pk primary key,
    code varchar(20) not null unique ,
    name varchar(20) not null
);

comment on table dc.fractions is 'Справочник. Фракции действий или приспешников';

comment on column dc.fractions.code is 'уникальный в рамках таблицы код записи, тип varchar, длина 20';
comment on column dc.fractions.name is 'понятное человеку наименование фракции на русском языке, тип varchar, длина 20';


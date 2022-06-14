create table if not exists dc.turn_stage
(
    id smallserial constraint turn_stage_pk primary key,
    code varchar(20)not null unique,
    name varchar(20) not null
);
comment on table dc.turn_stage is 'Этапы хода игрока, описаные в пункте 9.';

comment on column dc.turn_stage.code is 'уникальный в рамках таблицы код записи, тип varchar, длина 20';
comment on column dc.turn_stage.name is 'понятное человеку наименование фракции на русском языке, тип varchar, длина 20';


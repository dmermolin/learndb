create table if not exists dc.card_action_type
(
    id serial constraint card_action_type_pk primary key,
    code varchar(20) not null unique ,
    name varchar(20) not null
);

comment on table dc.card_action_type is 'Справочник. Специальное действие при розыгрывании карт.';

comment on column dc.card_action_type.code is 'уникальный в рамках таблицы код записи, тип varchar, длина 20';
comment on column dc.card_action_type.name is 'понятное человеку наименование фракции на русском языке, тип varchar, длина 20';


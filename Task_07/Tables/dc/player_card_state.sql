create table if not exists dc.player_card_state
(
    id serial constraint player_card_state_pk primary key,
    code varchar(20) not null unique ,
    name varchar(20) not null
);

comment on table dc.player_card_state is 'Справочник. Фракции действий или приспешников';

comment on column dc.player_card_state.code is 'уникальный в рамках таблицы код записи, тип varchar, длина 20';
comment on column dc.player_card_state.name is 'понятное человеку наименование фракции на русском языке, тип varchar, длина 20';
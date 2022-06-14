create table if not exists dc.play_cards
(
    id serial constraint play_cards_pk primary key,
    fraction int constraint play_cards_fk_01 references dc.fractions,
	name varchar(20) not null,
	description varchar(200),
	action_type int constraint play_cards_fk_02 references dc.card_action_type not null,
	damage smallint not null,
	quantity_in_deck smallint not null,
	code varchar(20) not null unique,
	type_play_card char(1) not null
);
comment on table dc.play_cards is 'Это карты, из которых каждый игрок составляет себе колоду. Заполняется заранее и корректируется только по мере необходимости.';

comment on column dc.play_cards.fraction  is 'фракция приспешника или действия, тип integer, размерность четыре байта, ключ на таблицу fractions ';
comment on column dc.play_cards.name is 'понятное человеку наименование карты на русском языке, тип varchar, длина 20';
comment on column dc.play_cards.description is 'описание карты, какими свойствами обладает, что делает при разыгрывании на поле и т.д. на русском языке, тип varchar, длина 200';
comment on column dc.play_cards.action_type is 'action_type - специальное действие при розыгрывании карты и т.д. на русском языке, тип integer, размерность четыре байта, ключ на таблицу card_action_type';
comment on column dc.play_cards.damage is 'атака, тип integer, размерность два байта';
comment on column dc.play_cards.quantity_in_deck is 'количество экземпляров карты в колоде игрока, тип integer, размерность два байта';
comment on column dc.play_cards.code is 'уникальный в рамках таблицы код записи, тип varchar, длина 20';
comment on column dc.play_cards.type_play_card is 'тип карты, приспешник или действие, тип char, длина 1';
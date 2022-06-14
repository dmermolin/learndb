create table if not exists dc.bases
(
    id serial constraint bases_pk primary key,
	name varchar(20) not null,
	code varchar(20) not null unique,
	description varchar(200),
	lives int not null,
	first_place_award smallint not null,
	second_place_award smallint not null,
	third_place_award smallint not null
);
comment on table dc.bases is 'Справочник. Все базы, которые возможно разыграть на игровое поле.';

comment on column dc.bases.code is 'уникальный в рамках таблицы код записи, тип varchar, длина 20';
comment on column dc.bases.name is 'понятное человеку наименование действия на русском языке, тип varchar, длина 20';
comment on column dc.bases.description is 'описание базы, что делает при разыгрывании на поле, особые свойства и т.д. на русском языке, тип varchar, длина 200';
comment on column dc.bases.lives is 'жизни базы, тип integer, размерность два байта';
comment on column dc.bases.first_place_award is 'количество очков, получаемое игроком при захвате базы за первое место, тип integer, размерность два байта';
comment on column dc.bases.second_place_award is 'количество очков, получаемое игроком при захвате базы за второе место, тип integer, размерность два байта';
comment on column dc.bases.third_place_award is 'количество очков, получаемое игроком при захвате базы за третье место, тип integer, размерность два байта';
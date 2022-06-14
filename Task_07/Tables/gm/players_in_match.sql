create table if not exists gm.players_in_match
(
    id serial not null constraint players_in_match_pk primary key,
    game_match int not null constraint players_in_match_fk_01 references gm.game_match,
	players int not null constraint players_in_match_fk_02 references gm.players,
	num_in_match smallint not null ,
	points smallint not null
);

comment on table gm.players_in_match is 'Игроки, участвующие в конкретном матче.';

comment on column gm.players_in_match.game_match is 'текущая игра, тип integer, размерность четыре байта, ключ на таблицу pk_match';
comment on column gm.players_in_match.players is 'игрок, тип integer, размерность четыре байта, ключ на таблицу players';
comment on column gm.players_in_match.num_in_match is 'номер игрока в конкретном матче, тип integer, размерность два байта';
comment on column gm.players_in_match.points is 'количество очков игрока в конкретном матче, обновляется по ходу игры, тип integer, размерность два байта';


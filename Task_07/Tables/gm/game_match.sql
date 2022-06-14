create table if not exists gm.game_match
(
    id serial4 not null constraint game_match_pk primary key,
    begin_match date not null ,
    end_match date not null,
	count_players int2 not null
);

comment on table gm.game_match is 'Текущая игра.';

comment on column gm.game_match.begin_match is 'начало игры, тип date';
comment on column gm.game_match.end_match is 'окончание игры, тип data';
comment on column gm.game_match.count_players is 'количество игроков, тип integer, размерность два байта';


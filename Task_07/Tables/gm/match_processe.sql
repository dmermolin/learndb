create table if not exists gm.match_process
(
    id serial not null constraint match_process_pk primary key,
    players_in_match int not null constraint match_process_fk_01 references dc.turn_stage,
	turn_stage int not null constraint match_process_fk_02 references gm.players_in_match,
	start_stage date,
	end_stage date,
	left_to_play_minions smallint,
	left_to_play_actions smallint,
	played_card int not null constraint match_process_fk_03 references gm.player_card,
	captured_the_base int4 not null constraint match_process_fk_04 references gm.bases_in_playing_field,
	got_point smallint
);

comment on table gm.match_process is 'Процесс игры. Довольно примитивный лог';

comment on column gm.match_process.players_in_match is 'игрок, участвующий в конкретном матче, тип integer, размерность четыре байта, ключ на таблицу players_in_match';
comment on column gm.match_process.turn_stage is 'этап ходя, тип integer, размерность четыре байта, ключ на таблицу turn_stage';
comment on column gm.match_process.start_stage  is 'начало этапа, тип date';
comment on column gm.match_process.end_stage is 'окончание этапа, тип date';
comment on column gm.match_process.left_to_play_minions is 'осталось сыграть приспешников, при изменении добавляется новая запись, тип integer, размерность два байта';
comment on column gm.match_process.left_to_play_actions is 'осталось сыграть действий, при изменении добавляется новая запись, тип integer, размерность два байта';
comment on column gm.match_process.played_card is 'сыгранная карта игрока, тип integer, размерность четыре байта, ключ на таблицу players_cards';
comment on column gm.match_process.captured_the_base is 'захваченная база, тип integer, размерность четыре байта, ключ на таблицу bases_in_playing_field';
comment on column gm.match_process.got_point is 'сколько очков заработал очков, тип integer, размерность два байта';

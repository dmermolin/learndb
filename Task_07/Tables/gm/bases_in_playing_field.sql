create table if not exists gm.bases_in_playing_field
(
    id serial not null constraint bases_in_playing_field_pk primary key,
    base int not null constraint bases_in_playing_field_fk_01 references dc.bases,
	base_life int2 not null ,
	pk_match int not null constraint bases_in_playing_field_fk_02 references gm.game_match,
	state_base char(1) not null
);

comment on table gm.bases_in_playing_field is 'Базы на игровом поле. Поля';

comment on column gm.bases_in_playing_field.base is 'база, тип integer, размерность четыре байта, ключ на таблицу bases';
comment on column gm.bases_in_playing_field.base_life is 'текущие жизни базы, обновляется по ходу игры, тип integer, размерность два байта';
comment on column gm.bases_in_playing_field.pk_match is 'текущая игра, тип integer, размерность четыре байта';
comment on column gm.bases_in_playing_field.state_base is 'текущее состояние базы, активна или уничтожена, тип char, длина 1';

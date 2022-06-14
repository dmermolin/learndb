create table if not exists gm.cards_in_bases
(
    id serial not null constraint cards_in_bases_pk primary key,
    bases_in_playing_field int not null constraint cards_in_bases_fk_01 references gm.bases_in_playing_field,
	players_cards int not null constraint cards_in_bases_fk_02 references gm.player_card,
	damage_card int not null
);

comment on table gm.cards_in_bases is 'Карты игроков на базе в текущей игре.';

comment on column gm.cards_in_bases.bases_in_playing_field is 'база на игровом поле, тип integer, размерность четыре байта, ключ на таблицу bases_in_playing_field';
comment on column gm.cards_in_bases.players_cards is 'карта игрока, тип integer, размерность четыре байта, ключ на таблицу players_cards';
comment on column gm.cards_in_bases.damage_card is 'текущая атака карты, может обновляться по ходу игры, тип integer, размерность два байта';


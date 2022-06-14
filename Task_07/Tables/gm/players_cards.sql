create table if not exists gm.player_card
(
    id serial not null constraint player_card_pk primary key,
    player_in_match int not null constraint player_card_fk_01 references gm.players_in_match,
	play_card int not null constraint player_card_fk_02 references dc.play_cards,
	player_card_state int not null constraint play_cards_fk_03 references dc.player_card_state
);

comment on table gm.player_card is 'Карты игрока в конкретном матче.';

comment on column gm.player_card.player_in_match is 'игрок, участвующий в конкретном матче, тип integer, размерность четыре байта, ключ на таблицу players_in_match';
comment on column gm.player_card.play_card is 'игровая карта, тип integer, размерность четыре байта, ключ на таблицу play_cards';
comment on column gm.player_card.player_card_state is 'состояние карты (в колоде, в сбросе и т.д.), по ходу игры обновляется, тип integer, размерность четыре байта, ключ на таблицу player_card_state';


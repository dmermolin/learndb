# DDL: создание, изменение и удаление объектов в PostgreSQL 

### База, роль и схема
Создал роль **smashup**

```
create role smashup with password 'qwerty' login createdb ;
```

Потом базу данных, назвал так же **smashup**. Назвал так же, что бы самому не запутаться, что юзер **smashup** работает с базой, с таким же именем. Издержки работы в Оракле с поьзователем и схемой пользователя) 
Если так делать не стоит, то переделаю, может быть плохая практика? 

Потом создал базу 
```
create database smashup OWNER = smashup;
```

И дал гранты

```
grant all privileges on database smashup to smashup;
```

Создал две схемы: 
- dc - условно для справочников, какие то постоянные вещи, которые особо изменять и не нужно будет
- gm уже непосредственно относящиеся к игре таблицы, пользователи, матч и т.д. 

База:

![image](https://user-images.githubusercontent.com/95203401/174113073-003caeef-a577-4ec2-b762-f1e40686a3ae.png)

Подключился под **smashup**, смотрю схемы

![image](https://user-images.githubusercontent.com/95203401/174113516-aeb802ad-7add-4c56-a1b0-40947b90b8e0.png)


### Таблицы

Схема *dc*

Таблицы **bases**

```sql
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
```

Таблицы **card_action_type**

```
create table if not exists dc.card_action_type
(
    id serial constraint card_action_type_pk primary key,
    code varchar(20) not null unique ,
    name varchar(20) not null
);

comment on table dc.card_action_type is 'Справочник. Специальное действие при розыгрывании карт.';

comment on column dc.card_action_type.code is 'уникальный в рамках таблицы код записи, тип varchar, длина 20';
comment on column dc.card_action_type.name is 'понятное человеку наименование фракции на русском языке, тип varchar, длина 20';

```
Таблицы **fractions**

```
create table if not exists dc.fractions
(
    id serial not null constraint fractions_pk primary key,
    code varchar(20) not null unique ,
    name varchar(20) not null
);

comment on table dc.fractions is 'Справочник. Фракции действий или приспешников';

comment on column dc.fractions.code is 'уникальный в рамках таблицы код записи, тип varchar, длина 20';
comment on column dc.fractions.name is 'понятное человеку наименование фракции на русском языке, тип varchar, длина 20';

```
Таблицы **play_cards**

```
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

```
Таблицы **player_card_state**

```
create table if not exists dc.player_card_state
(
    id serial constraint player_card_state_pk primary key,
    code varchar(20) not null unique ,
    name varchar(20) not null
);

comment on table dc.player_card_state is 'Справочник. Фракции действий или приспешников';

comment on column dc.player_card_state.code is 'уникальный в рамках таблицы код записи, тип varchar, длина 20';
comment on column dc.player_card_state.name is 'понятное человеку наименование фракции на русском языке, тип varchar, длина 20';

```
Таблицы **turn_stage**

```
create table if not exists dc.turn_stage
(
    id smallserial constraint turn_stage_pk primary key,
    code varchar(20)not null unique,
    name varchar(20) not null
);
comment on table dc.turn_stage is 'Этапы хода игрока, описаные в пункте 9.';

comment on column dc.turn_stage.code is 'уникальный в рамках таблицы код записи, тип varchar, длина 20';
comment on column dc.turn_stage.name is 'понятное человеку наименование фракции на русском языке, тип varchar, длина 20';

```
Схема *gm*

Таблицы **bases_in_playing_field**

```
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

```
Таблицы **cards_in_bases**

```
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

```
Таблицы **game_match**

```
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

```
Таблицы **match_process**

```
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

```
Таблицы **players**

```
create table if not exists gm.players
(
    id serial4 not null constraint players_pk primary key,
    nickname varchar(20) not null unique ,
    email varchar(50) not null unique,
	pass varchar(30) not null
);

comment on table gm.players is 'Игроки. Предполагается, что нужно зарегистрироваться и далее использовать свои учетные данные. ';

comment on column gm.players.nickname is 'пседвоним игрока, тип varchar, длина 20';
comment on column gm.players.email is 'email игрока, тип varchar, длина 50';
comment on column gm.players.pass is 'пароль игрока, тип varchar, длина 30';

```
Таблицы **player_card**

```
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

```
Таблицы **players_in_match**

```
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

```

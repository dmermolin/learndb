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


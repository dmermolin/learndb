alter table dc.bases
    alter column name type varchar(100) using name::varchar(100);

alter table dc.bases
    alter column code type varchar(100) using code::varchar(100);

alter table dc.play_cards
    alter column name type varchar(100) using name::varchar(100);

alter table dc.play_cards
    alter column action_type drop not null;

alter table dc.play_cards
    alter column description type varchar(400) using description::varchar(400);

alter table dc.play_cards
    alter column damage drop not null;

alter table dc.card_action_type
    alter column code type varchar(100) using code::varchar(100);

alter table dc.card_action_type
    alter column name type varchar(100) using name::varchar(100);

alter table dc.fractions
    alter column code type varchar(100) using code::varchar(100);

alter table dc.fractions
    alter column name type varchar(100) using name::varchar(100);

alter table dc.play_cards
    alter column code type varchar(100) using code::varchar(100);


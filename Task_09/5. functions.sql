--p_set_bases
create or replace procedure ur.p_set_bases(pr_bases ur.bases) as
$$
declare
    v_count integer;
begin

    select count(1) into v_count from dc.bases where name = ur.def_str(pr_bases.name);

    if v_count = 0 then
        insert into dc.bases (name,
                              code,
                              description,
                              lives,
                              first_place_award,
                              second_place_award,
                              third_place_award)
        values (ur.def_str(pr_bases.name),
                ur.def_str(ur.ru_translit(pr_bases.name)),
                pr_bases.properties,
                pr_bases.health, pr_bases.first_place,
                pr_bases.second_place,
                pr_bases.third_place);
    end if;
end;
$$ language plpgsql;

--f_set_fractions
create or replace function ur.f_set_fractions(p_name varchar) returns integer as
$$
declare
    v_fraction_id integer;
begin
    begin
        select id into v_fraction_id from dc.fractions where name = ur.def_str(p_name);
    exception
        when no_data_found then v_fraction_id := null;
    end;

    if v_fraction_id is null then
        insert into dc.fractions(code, name)
        VALUES (ur.def_str(ur.ru_translit(p_name)), ur.def_str(p_name))
        returning id into v_fraction_id;
    end if;

    return v_fraction_id;
end;
$$ LANGUAGE plpgsql;

--f_card_action_type
create or replace function ur.f_set_card_action_type(p_name varchar) returns integer as
$$
declare
    v_card_action_type integer;
begin
    if p_name is not null then
        begin
            select id into v_card_action_type from dc.card_action_type where name = ur.def_str(p_name);
        exception
            when no_data_found then v_card_action_type := null;
        end;

        if v_card_action_type is null then
            insert into dc.card_action_type(code, name)
            VALUES (ur.def_str(ur.ru_translit(p_name)), ur.def_str(p_name))
            returning id into v_card_action_type;
        end if;
    else
        v_card_action_type := null;
    end if;
    return v_card_action_type;
end;
$$ language plpgsql;

--p_set_play_cards
create or replace procedure ur.p_set_play_cards(p_fraction varchar,
                                                p_name varchar,
                                                p_description varchar,
                                                p_action_type varchar,
                                                p_damage integer,
                                                p_quantity_in_deck integer,
                                                p_type_play_card char
) as
$$
declare
    v_count integer;
begin
    select count(1)
    into v_count
    from dc.play_cards
    where name = ur.def_str(p_name)
      and type_play_card = upper(p_type_play_card);
    if v_count = 0 then
        insert into dc.play_cards (fraction,
                                   name,
                                   description,
                                   action_type,
                                   damage,
                                   quantity_in_deck,
                                   code,
                                   type_play_card)
        values (ur.f_set_fractions(p_fraction),
                ur.def_str(p_name),
                p_description,
                ur.f_set_card_action_type(p_action_type),
                p_damage,
                p_quantity_in_deck,
                ur.def_str(ur.ru_translit(p_name)),
                upper(p_type_play_card));
    end if;
end;
$$ language plpgsql;

--p_set_player_card_state
create or replace procedure ur.p_set_player_card_state(p_name varchar) as
$$
declare
    v_count int;
begin
    select count(1) into v_count from dc.player_card_state where name = ur.def_str(p_name);

    if v_count = 0 then
        insert into dc.player_card_state(code, name) VALUES (ur.def_str(ur.ru_translit(p_name)), ur.def_str(p_name));
    end if;
end;
$$ language plpgsql;
do
$$
    declare
        vr_bases ur.bases%rowtype;
        vr_minions ur.minions%rowtype;
        vr_actions ur.actions%rowtype;
    begin
        for vr_bases in select * from ur.bases
        loop
            call ur.p_set_bases(vr_bases.*);
        end loop;

        for vr_minions in select * from ur.minions
        loop
            call ur.p_set_play_cards(p_fraction := vr_minions.fractions,
                p_name := vr_minions.name,
                p_description := vr_minions.properties,
                p_action_type := vr_minions.action_type,
                p_damage := vr_minions.attack,
                p_quantity_in_deck := vr_minions.count_in_desc,
                p_type_play_card := 'm');
        end loop;

        for vr_actions in select * from ur.actions
        loop
            call ur.p_set_play_cards(p_fraction := vr_actions.fractions,
                p_name := vr_actions.name,
                p_description := vr_actions.description,
                p_action_type := vr_actions.type_action,
                p_damage := null,
                p_quantity_in_deck := vr_actions.count_in_desc,
                p_type_play_card := 'a');
        end loop;

        commit;
    end;
$$ language plpgsql;

call ur.p_set_player_card_state('колода');
call ur.p_set_player_card_state('рука');
call ur.p_set_player_card_state('база');
call ur.p_set_player_card_state('сброс');
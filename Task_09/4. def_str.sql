CREATE OR REPLACE FUNCTION ur.def_str(p_string character varying)
  RETURNS character varying AS
$BODY$
    select upper(
                replace(
                    replace(
                        replace(
                            replace(
                                trim($1),
                                    '"',
                                        ''),
                                            '-',
                                                ''),
                                                    ' ',
                                                        '_'),
                                                            '__',
                                                                '_')) ;
$BODY$
LANGUAGE sql;
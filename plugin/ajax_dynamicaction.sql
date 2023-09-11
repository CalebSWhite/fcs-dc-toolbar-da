----------------------------------------------------------
-- function ajax
----------------------------------------------------------
FUNCTION f_ajax(p_dynamic_action IN apex_plugin.t_dynamic_action,
                p_plugin         IN apex_plugin.t_plugin)
  RETURN apex_plugin.t_dynamic_action_ajax_result IS
  -- plugin attributes
  l_result        apex_plugin.t_dynamic_action_ajax_result;
  c_item2submit   constant varchar2(32767) := upper(p_dynamic_action.attribute_01);
  c_affectedItems constant varchar2(32767) := upper(p_dynamic_action.attribute_02);
  --
BEGIN
  -- Debug
  IF apex_application.g_debug THEN
    apex_plugin_util.debug_dynamic_action(p_plugin => p_plugin,
                                          p_dynamic_action => p_dynamic_action);
  END IF;
  --

  FOR item IN (
      SELECT regexp_substr(itm, '[^,]+', 1, level) name
        FROM (SELECT c_affectedItems as itm FROM dual)
        CONNECT BY level <= length(itm) - length(replace(itm, ',')) + 1
  )
  LOOP
    apex_util.set_session_state(p_name  => item.name,
                                p_value => v(c_item2submit));
  END LOOP;

  apex_json.open_object;
  apex_json.write('success', true);
  apex_json.close_object;
  --
  RETURN l_result;
  --
END f_ajax;

----------------------------------------------------------
-- function render
----------------------------------------------------------
FUNCTION f_render (p_dynamic_action IN apex_plugin.t_dynamic_action,
                   p_plugin         IN apex_plugin.t_plugin)
  RETURN apex_plugin.t_dynamic_action_render_result AS
  --
  l_result        apex_plugin.t_dynamic_action_render_result;
  c_item2submit   constant varchar2(32767) := apex_plugin_util.page_item_names_to_jquery(p_dynamic_action.attribute_01);
  c_affectedItems constant varchar2(32767) := apex_plugin_util.page_item_names_to_jquery(p_dynamic_action.attribute_02);
  --
BEGIN
  -- Debug
  IF apex_application.g_debug THEN
    apex_plugin_util.debug_dynamic_action(p_plugin => p_plugin,
                                          p_dynamic_action => p_dynamic_action);
  END IF;

  l_result.javascript_function := 'function () { fcsDCToolbar.initialize(this, '
                                    || apex_javascript.add_value(apex_plugin.get_ajax_identifier, TRUE)
                                    || apex_javascript.add_value(c_item2submit, TRUE)
                                    || apex_javascript.add_value(c_affectedItems, TRUE)
                                    || '); }';

  RETURN l_result;
  --
END f_render;

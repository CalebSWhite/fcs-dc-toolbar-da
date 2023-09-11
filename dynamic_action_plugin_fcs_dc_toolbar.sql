--------------------------------------------------------------------------------
-- © Fresh Computer Systems
--------------------------------------------------------------------------------
prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run the script connected to SQL*Plus as the owner (parsing schema)
-- of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2022.10.07'
,p_release=>'22.2.1'
,p_default_workspace_id=>144143746093734758
,p_default_application_id=>401
,p_default_id_offset=>154853250706142553
,p_default_owner=>'TDHMDC'
);
end;
/
 
prompt APPLICATION 401 - Fresh Direct
--
-- Application Export:
--   Application:     401
--   Name:            Fresh Direct
--   Date and Time:   09:52 Tuesday September 12, 2023
--   Exported By:     CALEB
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 430412484181794442
--   Manifest End
--   Version:         22.2.1
--   Instance ID:     203727919721006
--

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/dynamic_action/fcs_dc_toolbar_da
begin
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(430412484181794442)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'FCS.DC_TOOLBAR_DA'
,p_display_name=>'FCS DC Toolbar DA'
,p_category=>'EXECUTE'
,p_javascript_file_urls=>'#PLUGIN_FILES#fcs-dc-toolbar#MIN#.js'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'----------------------------------------------------------',
'-- function render',
'----------------------------------------------------------',
'FUNCTION f_render (p_dynamic_action IN apex_plugin.t_dynamic_action,',
'                   p_plugin         IN apex_plugin.t_plugin)',
'  RETURN apex_plugin.t_dynamic_action_render_result AS',
'  --',
'  l_result        apex_plugin.t_dynamic_action_render_result;',
'  c_item2submit   constant varchar2(32767) := apex_plugin_util.page_item_names_to_jquery(p_dynamic_action.attribute_01);',
'  c_affectedItems constant varchar2(32767) := apex_plugin_util.page_item_names_to_jquery(p_dynamic_action.attribute_02);',
'  --',
'BEGIN',
'  -- Debug',
'  IF apex_application.g_debug THEN',
'    apex_plugin_util.debug_dynamic_action(p_plugin => p_plugin,',
'                                          p_dynamic_action => p_dynamic_action);',
'  END IF;',
'',
'  l_result.javascript_function := ''function () { fcsDCToolbar.initialize(this, ''',
'                                    || apex_javascript.add_value(apex_plugin.get_ajax_identifier, TRUE)',
'                                    || apex_javascript.add_value(c_item2submit, TRUE)',
'                                    || apex_javascript.add_value(c_affectedItems, TRUE)',
'                                    || ''); }'';',
'',
'  RETURN l_result;',
'  --',
'END f_render;',
'----------------------------------------------------------',
'-- function ajax',
'----------------------------------------------------------',
'FUNCTION f_ajax(p_dynamic_action IN apex_plugin.t_dynamic_action,',
'                p_plugin         IN apex_plugin.t_plugin)',
'  RETURN apex_plugin.t_dynamic_action_ajax_result IS',
'  -- plugin attributes',
'  l_result        apex_plugin.t_dynamic_action_ajax_result;',
'  c_item2submit   constant varchar2(32767) := upper(p_dynamic_action.attribute_01);',
'  c_affectedItems constant varchar2(32767) := upper(p_dynamic_action.attribute_02);',
'  --',
'BEGIN',
'  -- Debug',
'  IF apex_application.g_debug THEN',
'    apex_plugin_util.debug_dynamic_action(p_plugin => p_plugin,',
'                                          p_dynamic_action => p_dynamic_action);',
'  END IF;',
'  --',
'',
'  FOR item IN (',
'      SELECT regexp_substr(itm, ''[^,]+'', 1, level) name',
'        FROM (SELECT c_affectedItems as itm FROM dual)',
'        CONNECT BY level <= length(itm) - length(replace(itm, '','')) + 1',
'  )',
'  LOOP',
'    apex_util.set_session_state(p_name  => item.name,',
'                                p_value => v(c_item2submit));',
'  END LOOP;',
'',
'  apex_json.open_object;  ',
'  apex_json.write(''success'', true);  ',
'  apex_json.close_object; ',
'  --',
'  RETURN l_result;',
'  --',
'END f_ajax;',
''))
,p_api_version=>2
,p_render_function=>'f_render'
,p_ajax_function=>'f_ajax'
,p_standard_attributes=>'STOP_EXECUTION_ON_ERROR:WAIT_FOR_RESULT'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'0.1'
,p_about_url=>'www.freshcomputers.com.au'
,p_files_version=>69
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(430465847050772929)
,p_plugin_id=>wwv_flow_imp.id(430412484181794442)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Item to submit'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>true
,p_is_translatable=>false
,p_examples=>'P0_DC_SELECT'
,p_help_text=>'The name of DC checkbox group'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(430432217601596767)
,p_plugin_id=>wwv_flow_imp.id(430412484181794442)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Affected Item(s)'
,p_attribute_type=>'PAGE ITEMS'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_imp.id(430465847050772929)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'NOT_NULL'
,p_examples=>'P10000_DC_ITEM,P10001_DC_ITEM'
,p_help_text=>'Items to set value with DC values.'
);
wwv_flow_imp_shared.create_plugin_event(
 p_id=>wwv_flow_imp.id(430414158778121275)
,p_plugin_id=>wwv_flow_imp.id(430412484181794442)
,p_name=>'fcs_dctoolbarchangedevent'
,p_display_name=>'FCS DC Toolbar Changed Event'
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '636F6E7374206663734443546F6F6C626172203D202866756E6374696F6E202829207B0D0A202020202775736520737472696374273B0D0A20202020636F6E73742066656174757265203D2027464353202D20444320546F6F6C626172204441273B0D0A';
wwv_flow_imp.g_varchar2_table(2) := '0D0A20202020636F6E7374207365744974656D46756E6374696F6E203D2066756E6374696F6E2028704974656D325375626D69742C207041666665637465644974656D732C20704461746129207B0D0A2020202020202020636F6E737420646373497465';
wwv_flow_imp.g_varchar2_table(3) := '6D203D20617065782E6974656D28704974656D325375626D6974293B0D0A2020202020202020636F6E737420646349447354657874203D206463734974656D3F2E67657456616C756528293F2E6A6F696E28273A27293B0D0A2020202020202020617065';
wwv_flow_imp.g_varchar2_table(4) := '782E6576656E742E7472696767657228646F63756D656E742C20276663735F6463746F6F6C6261726368616E6765646576656E74272C207B206964733A20646349447354657874207D293B0D0A20202020202020202F2F2068616E646C6520616C6C2061';
wwv_flow_imp.g_varchar2_table(5) := '66666563746564206974656D730D0A20202020202020207041666665637465644974656D732E666F72456163682866756E6374696F6E2028656C656D656E7429207B0D0A202020202020202020202020636F6E7374206974656D203D20617065782E6974';
wwv_flow_imp.g_varchar2_table(6) := '656D28656C656D656E74293B0D0A2020202020202020202020202F2F20736574206974656D20746578740D0A2020202020202020202020206974656D2E73657456616C756528646349447354657874293B0D0A2020202020202020202020202F2F207265';
wwv_flow_imp.g_varchar2_table(7) := '6672657368206974656D0D0A2020202020202020202020206974656D2E7265667265736828293B0D0A20202020202020207D293B0D0A202020207D3B0D0A0D0A20202020636F6E7374206C6F616444617461203D2066756E6374696F6E20287054686973';
wwv_flow_imp.g_varchar2_table(8) := '2C2070414A415849442C20704974656D325375626D69742C207041666665637465644974656D7329207B0D0A20202020202020202F2F206D616B6520616A61782063616C6C20746F2064620D0A2020202020202020617065782E7365727665722E706C75';
wwv_flow_imp.g_varchar2_table(9) := '67696E2870414A415849442C207B0D0A202020202020202020202020706167654974656D733A20617065782E7574696C2E746F417272617928704974656D325375626D6974292C0D0A20202020202020207D2C207B0D0A20202020202020202020202073';
wwv_flow_imp.g_varchar2_table(10) := '7563636573733A2066756E6374696F6E2028704461746129207B0D0A20202020202020202020202020202020617065782E64656275672E696E666F28666561747572652C207044617461293B0D0A20202020202020202020202020202020736574497465';
wwv_flow_imp.g_varchar2_table(11) := '6D46756E6374696F6E28704974656D325375626D69742C207041666665637465644974656D732C207044617461293B0D0A20202020202020202020202020202020617065782E64612E726573756D652870546869732E726573756D6543616C6C6261636B';
wwv_flow_imp.g_varchar2_table(12) := '2C2066616C7365293B0D0A2020202020202020202020207D2C0D0A2020202020202020202020206572726F723A2066756E6374696F6E2028706A715848522C2070546578745374617475732C20704572726F725468726F776E29207B0D0A202020202020';
wwv_flow_imp.g_varchar2_table(13) := '20202020202020202020636F6E736F6C652E7761726E2827706A71584852272C20706A71584852293B0D0A20202020202020202020202020202020636F6E736F6C652E7761726E28277054657874537461747573272C207054657874537461747573293B';
wwv_flow_imp.g_varchar2_table(14) := '0D0A20202020202020202020202020202020636F6E736F6C652E7761726E2827704572726F725468726F776E272C20704572726F725468726F776E293B0D0A20202020202020202020202020202020617065782E64612E68616E646C65416A6178457272';
wwv_flow_imp.g_varchar2_table(15) := '6F727328706A715848522C2070546578745374617475732C20704572726F725468726F776E2C2070546869732E726573756D6543616C6C6261636B293B0D0A2020202020202020202020207D2C0D0A20202020202020207D293B0D0A202020207D3B0D0A';
wwv_flow_imp.g_varchar2_table(16) := '0D0A2020202072657475726E207B0D0A2020202020202020696E697469616C697A653A2066756E6374696F6E202870546869732C2070414A415849442C20704974656D325375626D69742C207041666665637465644974656D7329207B0D0A2020202020';
wwv_flow_imp.g_varchar2_table(17) := '20202020202020636F6E736F6C652E6C6F6728666561747572652C207054686973293B0D0A202020202020202020202020636F6E737420706167654974656D203D20704974656D325375626D69742E736C6963652831293B0D0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(18) := '2020636F6E736F6C652E6C6F6728666561747572652C20274974656D20746F205375626D6974272C20706167654974656D293B0D0A2020202020202020202020202F2F20636F6E73742061666665637465644974656D73203D2070546869732E61637469';
wwv_flow_imp.g_varchar2_table(19) := '6F6E2E6166666563746564456C656D656E74732E73706C697428272C27293B0D0A202020202020202020202020636F6E73742061666665637465644974656D73203D20617065782E7574696C2E746F4172726179287041666665637465644974656D732C';
wwv_flow_imp.g_varchar2_table(20) := '20272C27292E6D6170286974656D203D3E206974656D2E736C696365283129293B0D0A202020202020202020202020636F6E736F6C652E6C6F6728666561747572652C20274166666563746564204974656D73205B5D272C206166666563746564497465';
wwv_flow_imp.g_varchar2_table(21) := '6D73293B0D0A0D0A2020202020202020202020206C6F6164446174612870546869732C2070414A415849442C20706167654974656D2C2061666665637465644974656D73293B0D0A20202020202020207D2C0D0A202020207D3B0D0A7D2928293B0D0A';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(430412654540802112)
,p_plugin_id=>wwv_flow_imp.id(430412484181794442)
,p_file_name=>'fcs-dc-toolbar.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '636F6E7374206663734443546F6F6C6261723D66756E6374696F6E28297B2275736520737472696374223B636F6E737420653D22464353202D20444320546F6F6C626172204441222C6F3D66756E6374696F6E286F2C6E2C742C61297B617065782E7365';
wwv_flow_imp.g_varchar2_table(2) := '727665722E706C7567696E286E2C7B706167654974656D733A617065782E7574696C2E746F41727261792874297D2C7B737563636573733A66756E6374696F6E286E297B617065782E64656275672E696E666F28652C6E292C66756E6374696F6E28652C';
wwv_flow_imp.g_varchar2_table(3) := '6F2C6E297B636F6E737420743D617065782E6974656D2865293F2E67657456616C756528293F2E6A6F696E28223A22293B617065782E6576656E742E7472696767657228646F63756D656E742C226663735F6463746F6F6C6261726368616E6765646576';
wwv_flow_imp.g_varchar2_table(4) := '656E74222C7B6964733A747D292C6F2E666F7245616368282866756E6374696F6E2865297B636F6E7374206F3D617065782E6974656D2865293B6F2E73657456616C75652874292C6F2E7265667265736828297D29297D28742C61292C617065782E6461';
wwv_flow_imp.g_varchar2_table(5) := '2E726573756D65286F2E726573756D6543616C6C6261636B2C2131297D2C6572726F723A66756E6374696F6E28652C6E2C74297B636F6E736F6C652E7761726E2822706A71584852222C65292C636F6E736F6C652E7761726E2822705465787453746174';
wwv_flow_imp.g_varchar2_table(6) := '7573222C6E292C636F6E736F6C652E7761726E2822704572726F725468726F776E222C74292C617065782E64612E68616E646C65416A61784572726F727328652C6E2C742C6F2E726573756D6543616C6C6261636B297D7D297D3B72657475726E7B696E';
wwv_flow_imp.g_varchar2_table(7) := '697469616C697A653A66756E6374696F6E286E2C742C612C63297B636F6E736F6C652E6C6F6728652C6E293B636F6E737420723D612E736C6963652831293B636F6E736F6C652E6C6F6728652C224974656D20746F205375626D6974222C72293B636F6E';
wwv_flow_imp.g_varchar2_table(8) := '737420733D617065782E7574696C2E746F417272617928632C222C22292E6D61702828653D3E652E736C69636528312929293B636F6E736F6C652E6C6F6728652C224166666563746564204974656D73205B5D222C73292C6F286E2C742C722C73297D7D';
wwv_flow_imp.g_varchar2_table(9) := '7D28293B';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(430486910369408463)
,p_plugin_id=>wwv_flow_imp.id(430412484181794442)
,p_file_name=>'fcs-dc-toolbar.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done

" Vim syntax file
" Language: C goocanvas extension (for version 0.15)
" Maintainer: David Nečas (Yeti) <yeti@physics.muni.cz>
" Last Change: 2009-10-21
" URL: http://physics.muni.cz/~yeti/vim/gtk-syntax.tar.gz
" Generated By: vim-syn-gen.py

syn keyword goocanvasFunction goo_cairo_antialias_get_type goo_cairo_fill_rule_get_type goo_cairo_hint_metrics_get_type goo_cairo_line_cap_get_type goo_cairo_line_join_get_type goo_cairo_matrix_copy goo_cairo_matrix_free goo_cairo_matrix_get_type goo_cairo_operator_get_type goo_cairo_pattern_get_type goo_canvas_accessible_factory_get_type goo_canvas_animate_type_get_type goo_canvas_bounds_get_type goo_canvas_convert_bounds_to_item_space goo_canvas_convert_from_item_space goo_canvas_convert_from_pixels goo_canvas_convert_to_item_space goo_canvas_convert_to_pixels goo_canvas_create_cairo_context goo_canvas_create_item goo_canvas_create_path goo_canvas_ellipse_get_type goo_canvas_ellipse_model_get_type goo_canvas_ellipse_model_new goo_canvas_ellipse_new goo_canvas_get_bounds goo_canvas_get_default_line_width goo_canvas_get_item goo_canvas_get_item_at goo_canvas_get_items_at goo_canvas_get_items_in_area goo_canvas_get_root_item goo_canvas_get_root_item_model goo_canvas_get_scale goo_canvas_get_static_root_item goo_canvas_get_static_root_item_model goo_canvas_get_type goo_canvas_grab_focus goo_canvas_grid_get_type goo_canvas_grid_model_get_type goo_canvas_grid_model_new goo_canvas_grid_new goo_canvas_group_get_type goo_canvas_group_model_get_type goo_canvas_group_model_new goo_canvas_group_new goo_canvas_image_get_type goo_canvas_image_model_get_type goo_canvas_image_model_new goo_canvas_image_new goo_canvas_item_accessible_factory_get_type goo_canvas_item_add_child goo_canvas_item_allocate_area goo_canvas_item_animate goo_canvas_item_class_find_child_property goo_canvas_item_class_install_child_property goo_canvas_item_class_list_child_properties goo_canvas_item_ensure_updated goo_canvas_item_find_child goo_canvas_item_get_bounds goo_canvas_item_get_canvas goo_canvas_item_get_child goo_canvas_item_get_child_properties goo_canvas_item_get_child_properties_valist goo_canvas_item_get_child_property goo_canvas_item_get_is_static goo_canvas_item_get_items_at goo_canvas_item_get_model goo_canvas_item_get_n_children goo_canvas_item_get_parent goo_canvas_item_get_requested_area goo_canvas_item_get_requested_height goo_canvas_item_get_simple_transform goo_canvas_item_get_style goo_canvas_item_get_transform goo_canvas_item_get_transform_for_child goo_canvas_item_get_type goo_canvas_item_is_container goo_canvas_item_is_visible goo_canvas_item_lower goo_canvas_item_model_add_child goo_canvas_item_model_animate goo_canvas_item_model_class_find_child_property goo_canvas_item_model_class_install_child_property goo_canvas_item_model_class_list_child_properties goo_canvas_item_model_find_child goo_canvas_item_model_get_child goo_canvas_item_model_get_child_properties goo_canvas_item_model_get_child_properties_valist goo_canvas_item_model_get_child_property goo_canvas_item_model_get_n_children goo_canvas_item_model_get_parent goo_canvas_item_model_get_simple_transform goo_canvas_item_model_get_style goo_canvas_item_model_get_transform goo_canvas_item_model_get_type goo_canvas_item_model_is_container goo_canvas_item_model_lower goo_canvas_item_model_move_child goo_canvas_item_model_raise goo_canvas_item_model_remove goo_canvas_item_model_remove_child goo_canvas_item_model_rotate goo_canvas_item_model_scale goo_canvas_item_model_set_child_properties goo_canvas_item_model_set_child_properties_valist goo_canvas_item_model_set_child_property goo_canvas_item_model_set_parent goo_canvas_item_model_set_simple_transform goo_canvas_item_model_set_style goo_canvas_item_model_set_transform goo_canvas_item_model_simple_get_type goo_canvas_item_model_skew_x goo_canvas_item_model_skew_y goo_canvas_item_model_stop_animation goo_canvas_item_model_translate goo_canvas_item_move_child goo_canvas_item_paint goo_canvas_item_raise goo_canvas_item_remove goo_canvas_item_remove_child goo_canvas_item_request_update goo_canvas_item_rotate goo_canvas_item_scale goo_canvas_item_set_canvas goo_canvas_item_set_child_properties goo_canvas_item_set_child_properties_valist goo_canvas_item_set_child_property goo_canvas_item_set_is_static goo_canvas_item_set_model goo_canvas_item_set_parent goo_canvas_item_set_simple_transform goo_canvas_item_set_style goo_canvas_item_set_transform goo_canvas_item_simple_changed goo_canvas_item_simple_check_in_path goo_canvas_item_simple_check_style goo_canvas_item_simple_get_line_width goo_canvas_item_simple_get_path_bounds goo_canvas_item_simple_get_type goo_canvas_item_simple_paint_path goo_canvas_item_simple_set_model goo_canvas_item_simple_user_bounds_to_device goo_canvas_item_simple_user_bounds_to_parent goo_canvas_item_skew_x goo_canvas_item_skew_y goo_canvas_item_stop_animation goo_canvas_item_translate goo_canvas_item_update goo_canvas_item_visibility_get_type goo_canvas_keyboard_grab goo_canvas_keyboard_ungrab goo_canvas_line_dash_get_type goo_canvas_line_dash_new goo_canvas_line_dash_newv goo_canvas_line_dash_ref goo_canvas_line_dash_unref goo_canvas_new goo_canvas_parse_path_data goo_canvas_path_command_type_get_type goo_canvas_path_get_type goo_canvas_path_model_get_type goo_canvas_path_model_new goo_canvas_path_new goo_canvas_pointer_events_get_type goo_canvas_pointer_grab goo_canvas_pointer_ungrab goo_canvas_points_get_type goo_canvas_points_new goo_canvas_points_ref goo_canvas_points_unref goo_canvas_polyline_get_type goo_canvas_polyline_model_get_type goo_canvas_polyline_model_new goo_canvas_polyline_model_new_line goo_canvas_polyline_new goo_canvas_polyline_new_line goo_canvas_rect_get_type goo_canvas_rect_model_get_type goo_canvas_rect_model_new goo_canvas_rect_new goo_canvas_register_widget_item goo_canvas_render goo_canvas_request_item_redraw goo_canvas_request_redraw goo_canvas_request_update goo_canvas_scroll_to goo_canvas_set_bounds goo_canvas_set_root_item goo_canvas_set_root_item_model goo_canvas_set_scale goo_canvas_set_static_root_item goo_canvas_set_static_root_item_model goo_canvas_style_copy goo_canvas_style_get_parent goo_canvas_style_get_property goo_canvas_style_get_type goo_canvas_style_new goo_canvas_style_set_fill_options goo_canvas_style_set_parent goo_canvas_style_set_property goo_canvas_style_set_stroke_options goo_canvas_table_get_type goo_canvas_table_model_get_type goo_canvas_table_model_new goo_canvas_table_new goo_canvas_text_get_natural_extents goo_canvas_text_get_type goo_canvas_text_model_get_type goo_canvas_text_model_new goo_canvas_text_new goo_canvas_unregister_item goo_canvas_unregister_widget_item goo_canvas_update goo_canvas_widget_accessible_factory_get_type goo_canvas_widget_get_type goo_canvas_widget_new
syn keyword goocanvasTypedef GooCairoAntialias GooCairoFillRule GooCairoHintMetrics GooCairoLineCap GooCairoLineJoin GooCairoMatrix GooCairoOperator GooCairoPattern
syn keyword goocanvasConstant GOO_CANVAS_ANIMATE_BOUNCE GOO_CANVAS_ANIMATE_FREEZE GOO_CANVAS_ANIMATE_RESET GOO_CANVAS_ANIMATE_RESTART GOO_CANVAS_EVENTS_ALL GOO_CANVAS_EVENTS_FILL GOO_CANVAS_EVENTS_FILL_MASK GOO_CANVAS_EVENTS_NONE GOO_CANVAS_EVENTS_PAINTED GOO_CANVAS_EVENTS_PAINTED_MASK GOO_CANVAS_EVENTS_STROKE GOO_CANVAS_EVENTS_STROKE_MASK GOO_CANVAS_EVENTS_VISIBLE GOO_CANVAS_EVENTS_VISIBLE_FILL GOO_CANVAS_EVENTS_VISIBLE_MASK GOO_CANVAS_EVENTS_VISIBLE_PAINTED GOO_CANVAS_EVENTS_VISIBLE_STROKE GOO_CANVAS_ITEM_HIDDEN GOO_CANVAS_ITEM_INVISIBLE GOO_CANVAS_ITEM_VISIBLE GOO_CANVAS_ITEM_VISIBLE_ABOVE_THRESHOLD GOO_CANVAS_PATH_CLOSE_PATH GOO_CANVAS_PATH_CURVE_TO GOO_CANVAS_PATH_ELLIPTICAL_ARC GOO_CANVAS_PATH_HORIZONTAL_LINE_TO GOO_CANVAS_PATH_LINE_TO GOO_CANVAS_PATH_MOVE_TO GOO_CANVAS_PATH_QUADRATIC_CURVE_TO GOO_CANVAS_PATH_SMOOTH_CURVE_TO GOO_CANVAS_PATH_SMOOTH_QUADRATIC_CURVE_TO GOO_CANVAS_PATH_VERTICAL_LINE_TO
syn keyword goocanvasStruct GooCanvas GooCanvasBounds GooCanvasClass GooCanvasEllipse GooCanvasEllipseClass GooCanvasEllipseData GooCanvasEllipseModel GooCanvasEllipseModelClass GooCanvasGrid GooCanvasGridClass GooCanvasGridData GooCanvasGridModel GooCanvasGridModelClass GooCanvasGroup GooCanvasGroupClass GooCanvasGroupModel GooCanvasGroupModelClass GooCanvasImage GooCanvasImageClass GooCanvasImageData GooCanvasImageModel GooCanvasImageModelClass GooCanvasItem GooCanvasItemIface GooCanvasItemModel GooCanvasItemModelIface GooCanvasItemModelSimple GooCanvasItemModelSimpleClass GooCanvasItemSimple GooCanvasItemSimpleClass GooCanvasItemSimpleData GooCanvasLineDash GooCanvasPath GooCanvasPathClass GooCanvasPathData GooCanvasPathModel GooCanvasPathModelClass GooCanvasPoints GooCanvasPolyline GooCanvasPolylineArrowData GooCanvasPolylineClass GooCanvasPolylineData GooCanvasPolylineModel GooCanvasPolylineModelClass GooCanvasRect GooCanvasRectClass GooCanvasRectData GooCanvasRectModel GooCanvasRectModelClass GooCanvasStyle GooCanvasStyleClass GooCanvasStyleProperty GooCanvasTable GooCanvasTableClass GooCanvasTableData GooCanvasTableDimension GooCanvasTableLayoutData GooCanvasTableModel GooCanvasTableModelClass GooCanvasText GooCanvasTextClass GooCanvasTextData GooCanvasTextModel GooCanvasTextModelClass GooCanvasWidget GooCanvasWidgetClass
syn keyword goocanvasUnion GooCanvasPathCommand
syn keyword goocanvasMacro GOO_CANVAS GOO_CANVAS_CLASS GOO_CANVAS_ELLIPSE GOO_CANVAS_ELLIPSE_CLASS GOO_CANVAS_ELLIPSE_GET_CLASS GOO_CANVAS_ELLIPSE_MODEL GOO_CANVAS_ELLIPSE_MODEL_CLASS GOO_CANVAS_ELLIPSE_MODEL_GET_CLASS GOO_CANVAS_GET_CLASS GOO_CANVAS_GRID GOO_CANVAS_GRID_CLASS GOO_CANVAS_GRID_GET_CLASS GOO_CANVAS_GRID_MODEL GOO_CANVAS_GRID_MODEL_CLASS GOO_CANVAS_GRID_MODEL_GET_CLASS GOO_CANVAS_GROUP GOO_CANVAS_GROUP_CLASS GOO_CANVAS_GROUP_GET_CLASS GOO_CANVAS_GROUP_MODEL GOO_CANVAS_GROUP_MODEL_CLASS GOO_CANVAS_GROUP_MODEL_GET_CLASS GOO_CANVAS_IMAGE GOO_CANVAS_IMAGE_CLASS GOO_CANVAS_IMAGE_GET_CLASS GOO_CANVAS_IMAGE_MODEL GOO_CANVAS_IMAGE_MODEL_CLASS GOO_CANVAS_IMAGE_MODEL_GET_CLASS GOO_CANVAS_ITEM GOO_CANVAS_ITEM_GET_IFACE GOO_CANVAS_ITEM_MODEL GOO_CANVAS_ITEM_MODEL_GET_IFACE GOO_CANVAS_ITEM_MODEL_SIMPLE GOO_CANVAS_ITEM_MODEL_SIMPLE_CLASS GOO_CANVAS_ITEM_MODEL_SIMPLE_GET_CLASS GOO_CANVAS_ITEM_SIMPLE GOO_CANVAS_ITEM_SIMPLE_CLASS GOO_CANVAS_ITEM_SIMPLE_GET_CLASS GOO_CANVAS_PATH GOO_CANVAS_PATH_CLASS GOO_CANVAS_PATH_GET_CLASS GOO_CANVAS_PATH_MODEL GOO_CANVAS_PATH_MODEL_CLASS GOO_CANVAS_PATH_MODEL_GET_CLASS GOO_CANVAS_POLYLINE GOO_CANVAS_POLYLINE_CLASS GOO_CANVAS_POLYLINE_GET_CLASS GOO_CANVAS_POLYLINE_MODEL GOO_CANVAS_POLYLINE_MODEL_CLASS GOO_CANVAS_POLYLINE_MODEL_GET_CLASS GOO_CANVAS_RECT GOO_CANVAS_RECT_CLASS GOO_CANVAS_RECT_GET_CLASS GOO_CANVAS_RECT_MODEL GOO_CANVAS_RECT_MODEL_CLASS GOO_CANVAS_RECT_MODEL_GET_CLASS GOO_CANVAS_STYLE GOO_CANVAS_STYLE_CLASS GOO_CANVAS_STYLE_GET_CLASS GOO_CANVAS_TABLE GOO_CANVAS_TABLE_CLASS GOO_CANVAS_TABLE_GET_CLASS GOO_CANVAS_TABLE_MODEL GOO_CANVAS_TABLE_MODEL_CLASS GOO_CANVAS_TABLE_MODEL_GET_CLASS GOO_CANVAS_TEXT GOO_CANVAS_TEXT_CLASS GOO_CANVAS_TEXT_GET_CLASS GOO_CANVAS_TEXT_MODEL GOO_CANVAS_TEXT_MODEL_CLASS GOO_CANVAS_TEXT_MODEL_GET_CLASS GOO_CANVAS_WIDGET GOO_CANVAS_WIDGET_CLASS GOO_CANVAS_WIDGET_GET_CLASS GOO_IS_CANVAS GOO_IS_CANVAS_CLASS GOO_IS_CANVAS_ELLIPSE GOO_IS_CANVAS_ELLIPSE_CLASS GOO_IS_CANVAS_ELLIPSE_MODEL GOO_IS_CANVAS_ELLIPSE_MODEL_CLASS GOO_IS_CANVAS_GRID GOO_IS_CANVAS_GRID_CLASS GOO_IS_CANVAS_GRID_MODEL GOO_IS_CANVAS_GRID_MODEL_CLASS GOO_IS_CANVAS_GROUP GOO_IS_CANVAS_GROUP_CLASS GOO_IS_CANVAS_GROUP_MODEL GOO_IS_CANVAS_GROUP_MODEL_CLASS GOO_IS_CANVAS_IMAGE GOO_IS_CANVAS_IMAGE_CLASS GOO_IS_CANVAS_IMAGE_MODEL GOO_IS_CANVAS_IMAGE_MODEL_CLASS GOO_IS_CANVAS_ITEM GOO_IS_CANVAS_ITEM_MODEL GOO_IS_CANVAS_ITEM_MODEL_SIMPLE GOO_IS_CANVAS_ITEM_MODEL_SIMPLE_CLASS GOO_IS_CANVAS_ITEM_SIMPLE GOO_IS_CANVAS_ITEM_SIMPLE_CLASS GOO_IS_CANVAS_PATH GOO_IS_CANVAS_PATH_CLASS GOO_IS_CANVAS_PATH_MODEL GOO_IS_CANVAS_PATH_MODEL_CLASS GOO_IS_CANVAS_POLYLINE GOO_IS_CANVAS_POLYLINE_CLASS GOO_IS_CANVAS_POLYLINE_MODEL GOO_IS_CANVAS_POLYLINE_MODEL_CLASS GOO_IS_CANVAS_RECT GOO_IS_CANVAS_RECT_CLASS GOO_IS_CANVAS_RECT_MODEL GOO_IS_CANVAS_RECT_MODEL_CLASS GOO_IS_CANVAS_STYLE GOO_IS_CANVAS_STYLE_CLASS GOO_IS_CANVAS_TABLE GOO_IS_CANVAS_TABLE_CLASS GOO_IS_CANVAS_TABLE_MODEL GOO_IS_CANVAS_TABLE_MODEL_CLASS GOO_IS_CANVAS_TEXT GOO_IS_CANVAS_TEXT_CLASS GOO_IS_CANVAS_TEXT_MODEL GOO_IS_CANVAS_TEXT_MODEL_CLASS GOO_IS_CANVAS_WIDGET GOO_IS_CANVAS_WIDGET_CLASS
syn keyword goocanvasEnum GooCanvasAnimateType GooCanvasItemVisibility GooCanvasPathCommandType GooCanvasPointerEvents
syn keyword goocanvasVariable goo_canvas_style_antialias_id goo_canvas_style_fill_pattern_id goo_canvas_style_fill_rule_id goo_canvas_style_font_desc_id goo_canvas_style_hint_metrics_id goo_canvas_style_line_cap_id goo_canvas_style_line_dash_id goo_canvas_style_line_join_id goo_canvas_style_line_join_miter_limit_id goo_canvas_style_line_width_id goo_canvas_style_operator_id goo_canvas_style_stroke_pattern_id
syn keyword goocanvasDefine GOO_TYPE_CAIRO_ANTIALIAS GOO_TYPE_CAIRO_FILL_RULE GOO_TYPE_CAIRO_HINT_METRICS GOO_TYPE_CAIRO_LINE_CAP GOO_TYPE_CAIRO_LINE_JOIN GOO_TYPE_CAIRO_MATRIX GOO_TYPE_CAIRO_OPERATOR GOO_TYPE_CAIRO_PATTERN GOO_TYPE_CANVAS GOO_TYPE_CANVAS_ANIMATE_TYPE GOO_TYPE_CANVAS_BOUNDS GOO_TYPE_CANVAS_ELLIPSE GOO_TYPE_CANVAS_ELLIPSE_MODEL GOO_TYPE_CANVAS_GRID GOO_TYPE_CANVAS_GRID_MODEL GOO_TYPE_CANVAS_GROUP GOO_TYPE_CANVAS_GROUP_MODEL GOO_TYPE_CANVAS_IMAGE GOO_TYPE_CANVAS_IMAGE_MODEL GOO_TYPE_CANVAS_ITEM GOO_TYPE_CANVAS_ITEM_MODEL GOO_TYPE_CANVAS_ITEM_MODEL_SIMPLE GOO_TYPE_CANVAS_ITEM_SIMPLE GOO_TYPE_CANVAS_ITEM_VISIBILITY GOO_TYPE_CANVAS_LINE_DASH GOO_TYPE_CANVAS_PATH GOO_TYPE_CANVAS_PATH_COMMAND_TYPE GOO_TYPE_CANVAS_PATH_MODEL GOO_TYPE_CANVAS_POINTER_EVENTS GOO_TYPE_CANVAS_POINTS GOO_TYPE_CANVAS_POLYLINE GOO_TYPE_CANVAS_POLYLINE_MODEL GOO_TYPE_CANVAS_RECT GOO_TYPE_CANVAS_RECT_MODEL GOO_TYPE_CANVAS_STYLE GOO_TYPE_CANVAS_TABLE GOO_TYPE_CANVAS_TABLE_MODEL GOO_TYPE_CANVAS_TEXT GOO_TYPE_CANVAS_TEXT_MODEL GOO_TYPE_CANVAS_WIDGET NUM_ARROW_POINTS

" Default highlighting
if version >= 508 || !exists("did_goocanvas_syntax_inits")
  if version < 508
    let did_goocanvas_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink goocanvasFunction Function
  HiLink goocanvasTypedef Type
  HiLink goocanvasConstant Constant
  HiLink goocanvasStruct Type
  HiLink goocanvasUnion Type
  HiLink goocanvasMacro Macro
  HiLink goocanvasEnum Type
  HiLink goocanvasVariable Identifier
  HiLink goocanvasDefine Constant

  delcommand HiLink
endif


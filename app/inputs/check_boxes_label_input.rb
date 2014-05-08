class CheckBoxesLabelInput < SimpleForm::Inputs::CollectionCheckBoxesInput
  def input
    label_method, value_method = detect_collection_methods

    @builder.send("collection_check_boxes",
      attribute_name, collection, value_method, label_method,
      input_options, input_html_options, &collection_block_for_nested_boolean_style
    )
  end

  protected

  def build_nested_boolean_style_item_tag(collection_builder)
    collection_builder.check_box.html_safe + "&nbsp;".html_safe + collection_builder.text.html_safe
  end
end
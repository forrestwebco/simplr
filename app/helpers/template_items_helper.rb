module TemplateItemsHelper
  def item_img_with_link tag, _class=nil
    # initializes editable string
    editable = ""
    # finds item by tag if there is one
    item = TemplateItem.find_by_tag tag
    # creates new item with tag if there isn't one
    item = TemplateItem.create tag: tag unless item
    # sets displayed img to item image or placeholder dance img if none
    img = (item and item.image_url) ? item.image_url : "on_point/dance.png"
    # adds image tag to be rendered
    editable << image_tag(img, class: (_class ? _class[:class] : "ui large rounded image"))
    # add edit link to image tag if signed in and item found/created
    editable << link_to("Edit Image", on_point_edit_path(item.unique_token)) if current_user and item
    # sanitizes string to safely render to html
    editable.html_safe
  end

  def item_with_link tag
    editable = ""

    item = TemplateItem.find_by_tag tag

    # creates new placeholder item if ones not been set
    unless item
      item = TemplateItem.new body: "This template item has not been set.", tag: tag
      item.save
    end

    editable << item.body + " "
    editable << link_to("Edit", on_point_edit_path(item.unique_token)) if current_user

    editable.html_safe
  end

  def item_url_with_link tag
    editable = ""

    item = TemplateItem.find_by_tag tag

    # creates new placeholder item if ones not been set
    unless item
      item = TemplateItem.new body: "This template item has not been set.", tag: tag
      item.save
    end

    editable << link_to(item.body, item.url) + " "
    editable << link_to(" Edit", on_point_edit_path(item.unique_token)) if current_user

    editable.html_safe
  end
end

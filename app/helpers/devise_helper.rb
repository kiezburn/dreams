module DeviseHelper
  def devise_error_messages!
    return "" unless devise_error_messages?

    puts resource.errors.messages.first.inspect
    messages = resource.errors.messages.map { |msg| content_tag(:li, msg.last.join) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)

    html = <<-HTML
    <div id="error_explanation">
      <h2>#{sentence}</h2>
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end

  def devise_error_messages?
    !resource.errors.empty?
  end

end
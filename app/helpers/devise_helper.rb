module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages
                       .map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      count: resource.errors.count,
                      resource: resource.class.model_name.human.downcase)

    html = <<-HTML
    <div id="error_explanation" class="red-gradient">
      <h4 class="text-center"><b>#{sentence}</b></h2>
      <ul>#{messages}</ul>
    </div>
    <br>
    HTML

    html.html_safe
  end
end
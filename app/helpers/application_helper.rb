module ApplicationHelper
  def flash_class(key)
    case key
    when 'alert'
      'red-gradient'
    when 'notice'
      'green-gradient'
    else
      key
    end
  end
end

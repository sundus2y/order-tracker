module SalesHelper
  def get_change_style(change)
    case change <=> 0
      when 0
        return {color: 'yellow', icon: 'fa-caret-left'}
      when 1
        return {color: 'green', icon: 'fa-caret-up'}
      when -1
        return {color: 'red', icon: 'fa-caret-down'}
    end
  end
end

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :block_user

  def json_for_autocomplete(results, method, extra_data=[])
    results.collect do |result|
      hash = {"id" => result.id.to_s, "label" => result.send(method), "value" => result.label}
      extra_data.each do |datum|
        hash[datum] = result.send(datum)
      end if extra_data
      # TODO: Come back to remove this if clause when test suite is better
      hash
    end
  end


  def block_user
    if ENV['READ_ONLY'] && (!/sign_out|in/.match(request.url))
      if current_user && !current_user.admin? #&& !request.url.include?('users/sign_out')
        render file: 'public/disabled.html'
        return
      end

      blocked_paths =
          %w(customers\/new customers\/.*\/edit customers\/.*\/pop_up_edit
sales\/new sales\/.*\/edit sales\/return
items\/new items\/.*\/edit items\/.*\/pop_up_edit items\/.*\/copy
sale_items\/new sale_items\/.*\/edit
orders\/new orders\/.*\/edit
transfers\/new transfers\/.*\/edit
users)

      blocked_http_methods = %w(POST PATCH)

      block_path = blocked_paths.any? do |path|
        rg_path = Regexp.new path
        rg_path.match(request.url)
      end

      block_http_method = blocked_http_methods.any? do |http_method|
        request.method.include?(http_method)
      end

      # debugger if block_path || block_http_method
      render file: 'public/disabled.html' if block_path || block_http_method
    end
  end

end

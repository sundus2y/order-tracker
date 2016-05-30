class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

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

end

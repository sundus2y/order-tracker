class Results
  attr_accessor :current_page, :total_pages, :search_term, :data

  def initialize(current_page, total_pages, search_term, data)
    @current_page = current_page
    @total_pages = total_pages
    @search_term = search_term
    @data = data
  end
end
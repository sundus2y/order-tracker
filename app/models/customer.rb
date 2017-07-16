class Customer < ActiveRecord::Base
  enum category: [:retail, :wholesale, :company]

  has_many :sales, dependent: :destroy

  def self.top_5
    connection.execute(
        <<SQL
        SELECT name, count(sales.id) as ct, sum(sales.grand_total) as gt 
FROM "customers" INNER JOIN "sales" ON "sales"."customer_id" = "customers"."id"
WHERE sales.status = 'sold' AND name <> 'Cash' 
GROUP BY name  
ORDER BY gt desc
LIMIT 5
SQL
    )
  end

  def autocomplete_display
    str = "".html_safe
    str << "<div class='row'>".html_safe
    str << "<div data-index='0'>#{name}</div>".html_safe
    str << "<div data-index='1'>#{company.present? ? company : 'Unknown'}</div>".html_safe
    str << "<div data-index='2'>#{phone.present? ? phone : 'Unknown'}</div>".html_safe
    str << "<div data-index='3'>#{tin_no.present? ? tin_no : 'Unknown'}</div>".html_safe
    str << "<div data-index='4'>#{category}</div>".html_safe
    str << "</div>".html_safe
  end

  def label
    name
  end

  def category_label
    category.upcase
  end

  def can_be_deleted?
    sales.empty?
  end

end

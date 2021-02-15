class ApplicationController < ActionController::API
  def paginate(per_page, page, model)
    page_size = if !per_page.nil?
                  per_page.to_i
                else
                  20
                end
    page_number = if !page.nil?
                    page.to_i
                  else
                    1
                  end
    low_index = ((page_number - 1) * page_size)
    high_index = (page_number * page_size) - 1
    results = []
    results << model.all[low_index..high_index] unless model.all[low_index..high_index].nil?
    results.flatten
  end
end

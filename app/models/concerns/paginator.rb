module Paginator
  extend ActiveSupport::Concern
  module ClassMethods
		def list(per_page = nil, page = nil)
		  per_page = 25 if per_page == 0
		  paginated_list = self.page(page || 1).per(per_page)
		  FilteredList.new(paginated_list)
		end
	end
end

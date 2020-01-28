class FilteredList
  attr_reader :data, :paging

  def initialize(paginated_list)
    self.data   = paginated_list
    self.paging = paginated_list
  end

  def data=(data)
    @data = []
    @data = data unless data.blank?
  end

  def paging=(paginated_list)
    @paging = {
      total_items:  paginated_list.total_count,
      current_page: paginated_list.current_page,
      total_pages:  paginated_list.total_pages
    }
  end
end

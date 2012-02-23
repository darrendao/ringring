module CallListsHelper
  def setup_call_list(call_list)
    limit = 2 - call_list.call_list_owners.size
    (0..limit).each do |i|
      call_list.call_list_owners.build
    end
    call_list
  end
end

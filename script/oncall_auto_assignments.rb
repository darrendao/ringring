CallList.all.each do |call_list|
  next unless call_list.oncall_assignments_gen
  next unless call_list.oncall_assignments_gen.enable == true
  call_list.gen_oncall_assignments
end

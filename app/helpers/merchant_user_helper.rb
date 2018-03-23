module MerchantUserHelper
	def merchantable_options_for_select(f_object)
		grouped_options = "".html_safe
    selected_key = f_object.merchantable.try(:to_global_id)

    # TODO : outlets Eager load may affect on large amount of data  
    Store.allowed_stores.includes(:outlets).sort.each do |i|
    	grouped_options.concat options_for_select([[i.name, i.to_global_id]], selected_key)
      if i.has_outlets?
      	outlet_options = i.outlets.map { |k| ["#{i.name} - #{k.locality}", k.to_global_id] }
        grouped_options.concat options_for_select(outlet_options, selected_key)
      end
    end
    grouped_options
	end

  def merchantable_link_to(f_object)
    merchantable = f_object.merchantable

    if merchantable.is_a?(Outlet)
      link_to "#{merchantable.store.name} - #{merchantable.locality}", [merchantable.store, merchantable]
    elsif merchantable.is_a?(Store)
      link_to merchantable.name, merchantable
    end
  end
end

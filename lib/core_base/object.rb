# INFO :
# To use below method, please include file as `require 'core_base/object'`

class Array
  def sort_floating(key, is_floating = true)
    sort do |a, b|
      a, b = a.try(key).to_s, b.try(key).to_s
      
      if is_floating
        a = a.scan(/[\d\.]+/).first.try(:to_f) 
        b = b.scan(/[\d\.]+/).first.try(:to_f) 
      end

      ((a <=> b).blank? || (a <=> b) == 1) ? 1 : -1
    end 
  end
end

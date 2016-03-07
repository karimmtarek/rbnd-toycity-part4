class Module
  def create_finder_methods(*attributes)
    attributes.each do |attribute|
      send(:define_method, "find_by_#{attribute}") do |arg|
        where(attribute.to_sym => arg).first
      end
    end
  end
end

Module.create_finder_methods('brand', 'name')

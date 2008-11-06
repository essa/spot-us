#  taken from Rails Recipes Recipe 64
#  "validating non-active record objects"

module Validateable
  [:save, :save!, :update_attribute].each do |attr|
    define_method(attr) {}
  end

  def new_record?
    true
  end

  def method_missing(symbol, *params)
    if (symbol.to_s =~ /(.*)_before_type_cast$/)
      send($1)
    else
      super
    end
  end

  def self.append_features(base)
    super
    base.send(:include, ActiveRecord::Validations)
  end
end


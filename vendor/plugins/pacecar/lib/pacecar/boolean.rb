module Pacecar
  module Boolean
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def self.extended(base)
        base.send :define_boolean_scopes
      end

      protected

      def define_boolean_scopes
        boolean_column_names.each do |name|
          named_scope name.to_sym, :conditions => ["#{quoted_table_name}.#{name} = ?", true]
          named_scope "not_#{name}".to_sym, :conditions => ["#{quoted_table_name}.#{name} = ?", false]
        end
      end

    end
  end
end

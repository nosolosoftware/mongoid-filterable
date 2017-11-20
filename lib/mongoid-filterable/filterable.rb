##
# Let you add scopes to mongoid document for filters.
#
module Mongoid
  module Filterable
    module ClassMethods
      ##
      # Applies params scopes to current scope
      #
      def filter(filtering_params, operator = '$and')
        return all unless filtering_params
        results = all
        selectors = []
        criteria = unscoped

        filtering_params.each do |key, value|
          if value.present? && respond_to?("filter_with_#{key}")
            if value.is_a?(Array) && scopes["filter_with_#{key}".to_sym][:scope].arity > 1
              selectors.push criteria.public_send("filter_with_#{key}", *value).selector
            else
              selectors.push criteria.public_send("filter_with_#{key}", value).selector
            end
          end
        end

        selectors.empty? ? results : results.where(operator => selectors)
      end

      ##
      # Adds attr scope
      #
      def filter_by(attr, filter = nil)
        if filter
          scope "filter_with_#{attr}", filter
        elsif fields[attr.to_s].type == String
          scope "filter_with_#{attr}", ->(value) { where(attr => Regexp.new(value)) }
        else
          scope "filter_with_#{attr}", ->(value) { where(attr => value) }
        end
      end

      ##
      # Adds attr scope using normalized values
      # (see gem mongoid-normalize-strings)
      #
      def filter_by_normalized(attr)
        normalized_name = (attr.to_s + '_normalized').to_sym
        scope "filter_with_#{attr}", lambda { |value|
          where(normalized_name => Regexp.new(I18n.transliterate(value), 'i'))
        }
      end
    end

    ##
    # Adds class methods
    #
    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end

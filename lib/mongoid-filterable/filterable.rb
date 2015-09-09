##
# Let you add scopes to mongoid document for filters.
#
module Mongoid
  module Filterable
    module ClassMethods
      ##
      # Applies params scopes to current scope
      #
      def filter(filtering_params, operator='$and')
        results = self.all
        selectors = []

        filtering_params.each do |key, value|
          selectors.push self.public_send("filter_with_#{key}", value).selector if value.present?
        end

        results.selector = {operator => selectors} if selectors.size > 0
        results
      end

      ##
      # Adds attr scope
      #
      def filter_by(attr, filter=nil)
        if filter
          self.scope "filter_with_#{attr}", filter
        else
          self.scope "filter_with_#{attr}", lambda{ |value| where(attr => value)}
        end
      end

      ##
      # Adds attr scope using normalized values
      # (see gem mongoid-normalize-strings)
      #
      def filter_by_normalized(attr)
        normalized_name = (attr.to_s + '_normalized').to_sym
        self.scope "filter_with_#{attr}", lambda{ |value|
          where( normalized_name => Regexp.new(I18n.transliterate(value), 'i') )
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

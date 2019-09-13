# frozen_string_literal: true

module SolidusSitemap
  module Spree
    module ProductDecorator
      module ClassMethods
        def last_updated
          order(updated_at: :desc).take.try(:updated_at)
        end
      end

      def self.prepended(base)
        base.singleton_class.prepend ClassMethods
      end

      ::Spree::Product.prepend self
    end
  end
end

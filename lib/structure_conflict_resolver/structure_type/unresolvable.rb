# frozen_string_literal: true

module StructureConflictResolver
  module StructureType
    class Unresolvable

      attr_accessor :original_text

      def initialize(original_text)
        @original_text = original_text
      end

      def resolved
        raise StandardError
      end
    end
  end
end

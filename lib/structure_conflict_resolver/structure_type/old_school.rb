# frozen_string_literal: true

module StructureConflictResolver
  module StructureType
    class OldSchool

      attr_accessor :original_text

      def initialize(original_text)
        @original_text = original_text
      end

      def resolved
        original_text
          .split("\n")
          .reject { |line| line.empty? }
          .sort
          .uniq
          .join("\n\n") + "\n"
      end
    end
  end
end

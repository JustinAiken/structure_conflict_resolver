# frozen_string_literal: true

module StructureConflictResolver
  module StructureType
    class Modern

      attr_accessor :original_text

      def initialize(original_text)
        @original_text = original_text
      end

      def resolved
        original_text
          .gsub(";", ",")
          .split("\n")
          .reject(&:empty?)
          .sort
          .uniq
          .tap { |strings| strings.last.gsub! ",", ";\n" }
          .join("\n")
      end
    end
  end
end

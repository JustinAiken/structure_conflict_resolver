# frozen_string_literal: true

module StructureConflictResolver
  module StructureType

    def self.from(text_blob)
      klass = case text_blob
      when /INSERT INTO schema_migrations/ then OldSchool
      when /\(\'\d{5,14}\'\)[,; ]?/        then Modern
      else                                      Unresolvable
      end

      klass.new(text_blob)
    end
  end
end

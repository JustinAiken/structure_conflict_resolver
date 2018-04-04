begin
  require "pry"
rescue LoadError
end

require "aasm"
require "rainbow"
require "structure_conflict_resolver/version"
require "structure_conflict_resolver/structure_type"
require "structure_conflict_resolver/structure_type/modern"
require "structure_conflict_resolver/structure_type/old_school"
require "structure_conflict_resolver/structure_type/unresolvable"
require "structure_conflict_resolver/merge_conflict"

module StructureConflictResolver

  class Resolver

    attr_accessor :filename, :conflicts, :potential_conflict

    def initialize(filename)
      @filename           = filename
      @conflicts          = []
      @potential_conflict = MergeConflict.new
    end

    def resolve!
      validate_file
      scan_for_conflicts
      substitute_content
      check_content
      write_content
    end

    def validate_file
      end_with :error, "No filename provided!" if filename.nil?
      end_with :error, "db/schema.rb is not currently supported" if filename =~ /schema\.rb/
      end_with :error, "#{filename} not found" unless File.exist?(filename)
    end

    def scan_for_conflicts
      content.each_line do |line|
        potential_conflict.parse! line
        if potential_conflict.scanning_completed?
          conflicts << potential_conflict
          potential_conflict = MergeConflict.new
        end
      end
    end

    def substitute_content
      conflicts
        .select(&:scanning_completed?)
        .each { |c| new_content.gsub! c.original_blob, c.resolved_text }
    end

    def check_content
      end_with :error, "Unparsable conflicts!"    if conflicts.any?(&:parse_error?)
      end_with :error, "No resolvable conflicts!" if conflicts.all? { |c| !c.resolvable? }
      end_with :error, "Nothing changed!"         if content == new_content

      if new_content =~ /\<{7} |\={7}|\<{7}/ || conflicts.any? { |c| !c.resolvable? }
        puts Rainbow("Warning!").yellow
        puts ""
        puts "There are conflicts remaining.  You'll have to fix those manually"
        puts ""
      end
    end

    def write_content
      File.open(filename, "w") { |file| file.write new_content }
      end_with :success, "✅  Version conflicts resolved!\n\n You'll probably want to \`git add #{filename}\`,\n and continue your rebase/merge.\n\n"
    end

  private

    def content
      @content ||= File.read(filename)
    end

    def new_content
      @new_content ||= content.dup
    end

    def end_with(exit_type, msg)
      puts ""
      if exit_type == :error
        puts Rainbow("Error!").red
        puts ""
        puts msg
        puts ""
        exit 1
      else
        puts Rainbow("Success!").green
        puts ""
        puts msg
        puts ""
      end
      exit 0
    end
  end
end

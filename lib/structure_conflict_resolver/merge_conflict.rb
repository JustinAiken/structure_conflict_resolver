# frozen_string_literal: true

module StructureConflictResolver
  class MergeConflict
    include AASM

    CONFLICT_A = /^\<{7} (.*)$/
    DIVIDER    = /^\={7}$/
    CONFLICT_B = /^\>{7} (.+)$/

    attr_accessor :current_line, :original_blob, :head_branch_blob, :our_commit_blob

    def initialize
      @original_blob    = String.new
      @head_branch_blob = String.new
      @our_commit_blob  = String.new
    end

    aasm do
      state :not_detected, initial: true
      state :in_head_blob
      state :in_our_blob
      state :scanning_completed

      event :enter_head_blob, if: :matches_conflict_start? do
        transitions from: :not_detected, to: :in_head_blob
      end

      event :enter_our_blob, if: :at_divider? do
        transitions from: :in_head_blob, to: :in_our_blob
      end

      event :complete_scanning, if: :matches_conflict_end? do
        transitions from: :in_our_blob, to: :scanning_completed
      end
    end

    def parse!(line)
      @current_line = line
      enter_head_blob   if may_enter_head_blob?
      enter_our_blob    if may_enter_our_blob?
      complete_scanning if may_complete_scanning?

      store_lines!
    end

    def parse_error?
      !not_detected? && !scanning_completed?
    end

    def resolvable?
      !resolved_text.nil?
    end

    def resolved_text
      @resolved_text ||= StructureType.from(head_branch_blob + our_commit_blob).resolved
    rescue
    end

  private

    def store_lines!
      original_blob << current_line if in_head_blob? || in_our_blob? || git_noise?

      unless git_noise?
        head_branch_blob << current_line if in_head_blob?
        our_commit_blob  << current_line if in_our_blob?
      end
    end

    def git_noise?
      matches_conflict_start? || at_divider? || matches_conflict_end?
    end

    def matches_conflict_start?
      current_line =~ CONFLICT_A
    end

    def matches_conflict_end?
      current_line =~ CONFLICT_B
    end

    def at_divider?
      current_line =~ DIVIDER
    end
  end
end

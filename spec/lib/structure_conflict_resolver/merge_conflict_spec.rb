# frozen_string_literal: true
require "spec_helper"

describe StructureConflictResolver::MergeConflict do
  subject(:conflict) { described_class.new }

  describe ".aasm" do
    it "moves through the states" do
      conflict.parse! "OK LINE"
      expect(conflict).to be_not_detected
      conflict.parse! "OK LINE"
      expect(conflict).to be_not_detected

      conflict.parse! "<<<<<<< HEAD"
      expect(conflict).to be_in_head_blob
      conflict.parse! "foo line"
      expect(conflict).to be_in_head_blob

      conflict.parse! "======="
      expect(conflict).to be_in_our_blob
      conflict.parse! "another line"
      expect(conflict).to be_in_our_blob

      conflict.parse! ">>>>>>> some commit I just broke"
      expect(conflict).to be_scanning_completed
    end
  end

  describe "#resolvable? / # resolved_text" do
    before  { lines.each_line { |line| conflict.parse! line } }

    context "when it's a tangled mess" do
      let(:lines) do
        <<~TEXT
          <<<<<<< HEAD
          CREATE TABLE `foos` (
          `id` int(11) NOT NULL AUTO_INCREMENT
          =======
          `id` int(11) DEFAULT NULL AUTO_INCREMENT
          >>>>>>> my branch
        TEXT
      end

      it { should_not be_resolvable }
    end

    context "when it's doable with the modern style" do
      let(:lines) do
        <<~TEXT
          <<<<<<< HEAD
          ('20140521142114'),
          ('20140521195156');
          =======
          ('20140521195156'),
          ('20140521195156');
          >>>>>>> my branch
        TEXT
      end

      it { should be_resolvable }

      it "is resolved correctly" do
        expect(conflict.resolved_text).to eq(
          <<~TEXT
          ('20140521142114'),
          ('20140521195156');
          TEXT
        )
      end
    end

    context "when it's doable with the old school style" do
      let(:lines) do
        <<~TEXT
          <<<<<<< HEAD
          INSERT INTO schema_migrations (version) VALUES ('20170101120000');

          INSERT INTO schema_migrations (version) VALUES ('20170101150000');
          =======
          INSERT INTO schema_migrations (version) VALUES ('20170101110000');

          INSERT INTO schema_migrations (version) VALUES ('20170101130000');

          INSERT INTO schema_migrations (version) VALUES ('20170101150000');
          >>>>>>> my branch
        TEXT
      end

      it { should be_resolvable }

      it "is resolved correctly" do
        expect(conflict.resolved_text).to eq(
          <<~TEXT
          INSERT INTO schema_migrations (version) VALUES ('20170101110000');

          INSERT INTO schema_migrations (version) VALUES ('20170101120000');

          INSERT INTO schema_migrations (version) VALUES ('20170101130000');

          INSERT INTO schema_migrations (version) VALUES ('20170101150000');
          TEXT
        )
      end
    end
  end
end

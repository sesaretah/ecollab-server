require "rails_helper"

RSpec.describe FullTextSearcher::Searcher do
  let!(:user) { create(:user) }
  let!(:event) { create(:event) }
  let(:meetings) { create_list(:meeting, 5, event_id: event.id) }
  let(:tags) { create_list(:tag, 5) }
  let(:taggings) { build_list(:tagging, 5) }

  before do
    taggings.each_with_index.map { |a, i| a.update(tag_id: meetings[i].id, taggable_id: meetings[i].id, taggable_type: "Meeting") }
  end

  subject { FullTextSearcher::Searcher.new(params: params, user: user, per_page: 10, searchable: Meeting) }

  context "fulltext search without tags" do
    let(:params) { { q: meetings[0].title, page: 1, tags: [], registration_status: "all", start_from: 2.days.ago.to_i * 1000, start_to: DateTime.now.to_i * 1000 } }
    it "should return the first meeting" do
      expect(subject.call.length).to eq(2)
      expect(subject.call[:meetings].first.id).to eq(1)
    end
  end
end

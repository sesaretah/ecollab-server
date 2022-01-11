require "rails_helper"

RSpec.describe DateRangeQuery do
  let!(:user) { create(:user) }
  let!(:event) { create(:event) }
  let(:meetings) { create_list(:meeting, 5, event_id: event.id) }
  let(:attendances) { build_list(:attendance, 3, user_id: user.id, attendable_type: "Meeting") }

  before do
    attendances.each_with_index.map { |a, i| a.update(attendable_id: meetings[i].id) }
    meetings[0].update(start_time: 4.days.ago, end_time: 3.days.ago) # no overlap
    meetings[1].update(start_time: 4.days.ago, end_time: 1.day.ago) # back overlap
    meetings[2].update(start_time: 4.days.ago, end_time: 2.days.from_now) # full overlap
    meetings[2].update(start_time: 1.day.ago, end_time: 2.days.from_now) # front overlap
  end

  subject { DateRangeQuery.new(from: 2.days.ago.to_i * 1000, to: DateTime.now.to_i * 1000, user_id: user.id) }

  context "#publics" do
    before(:each) do
      meetings.last(2).map { |m| m.update(is_private: true) }
    end
    it "should return public meetings only" do
      expect(subject.publics.length).to eq(2)
    end
  end

  context "#registered" do
    it "should return registered meetings only" do
      expect(subject.registered.length).to eq(2)
    end
  end

  context "#not_registered" do
    it "should return not_registered meetings " do
      expect(subject.not_registered.length).to eq(2)
    end
  end

  context "#all" do
    it "should return all meetings " do
      expect(subject.all.length).to eq(4)
    end
  end
end

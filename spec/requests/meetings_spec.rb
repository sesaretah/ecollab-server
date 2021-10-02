require "rails_helper"
include JWTWrapper

describe "Meetings API", type: :request do
  it "return active meetings releated to an event" do
    user = FactoryBot.create(:user)
    ev = FactoryBot.create(:event, title: "event 1", start_date: 10.days.ago, end_date: 2.days.since)
    ev2 = FactoryBot.create(:event, title: "event 2", start_date: 10.days.ago, end_date: 2.days.since)
    FactoryBot.create(:meeting, title: "meeting 1", start_time: 1.hour.ago, end_time: 2.hour.since, event_id: ev.id)
    FactoryBot.create(:meeting, title: "meeting 2", start_time: 2.hour.ago, end_time: 3.hour.since, event_id: ev2.id)

    get "/v1/meetings?event_id=#{ev.id}", headers: { 'Content-Type': "application/json", 'Authorization': "bearer " + JWTWrapper.encode({ user_id: user.id }) }
    data = JSON.parse(response.body)["data"]

    expect(response).to have_http_status(:success)
    expect(data.size).to eq(1)
  end

  it "return all active meetings" do
    user = FactoryBot.create(:user)
    ev = FactoryBot.create(:event, title: "event 1", start_date: 10.days.ago, end_date: 2.days.since)
    FactoryBot.create(:meeting, title: "meeting 1", start_time: 1.hour.ago, end_time: 2.hour.since, event_id: ev.id)
    FactoryBot.create(:meeting, title: "meeting 2", start_time: 2.hour.ago, end_time: 1.hour.ago, event_id: ev.id)

    get "/v1/meetings", headers: { 'Content-Type': "application/json", 'Authorization': "bearer " + JWTWrapper.encode({ user_id: user.id }) }
    data = JSON.parse(response.body)["data"]

    expect(response).to have_http_status(:success)
    expect(data.size).to eq(2)
  end

  it "return search meetings" do
    user = FactoryBot.create(:user)
    ev = FactoryBot.create(:event, title: "event 1", start_date: 10.days.ago, end_date: 2.days.since)
    FactoryBot.create(:meeting, title: "test title", start_time: 1.hour.ago, end_time: 2.hour.since, is_private: false, event_id: ev.id)
    FactoryBot.create(:meeting, title: "another test title", start_time: 4.hour.ago, end_time: 3.hour.ago, is_private: false, event_id: ev.id)
    FactoryBot.create(:meeting, title: "some title", start_time: 2.hour.ago, end_time: 1.hour.since, is_private: false, event_id: ev.id)

    get "/v1/meetings/search?q=test&start_from=#{1.hour.ago.to_i * 1000}&start_to=#{Time.now.to_i * 1000}", headers: { 'Content-Type': "application/json", 'Authorization': "bearer " + JWTWrapper.encode({ user_id: user.id }) }
    data = JSON.parse(response.body)["data"]

    expect(response).to have_http_status(:success)
    expect(data.size).to eq(1)
  end

  it "return search meetings limit to an event" do
    user = FactoryBot.create(:user)
    ev1 = FactoryBot.create(:event, title: "event 1", start_date: 10.days.ago, end_date: 2.days.since)
    ev2 = FactoryBot.create(:event, title: "event 2", start_date: 10.days.ago, end_date: 2.days.since)
    FactoryBot.create(:meeting, title: "test title", start_time: 1.hour.ago, end_time: 2.hour.since, is_private: false, event_id: ev1.id)
    FactoryBot.create(:meeting, title: "another test title", start_time: 3.hour.ago, end_time: 2.hour.ago, is_private: false, event_id: ev1.id)
    FactoryBot.create(:meeting, title: "some test title", start_time: 2.hour.ago, end_time: 1.hour.since, is_private: false, event_id: ev2.id)

    get "/v1/meetings/search?q=test&start_from=#{1.hour.ago.to_i * 1000}&start_to=#{Time.now.to_i * 1000}&event_id=#{ev1.id}", headers: { 'Content-Type': "application/json", 'Authorization': "bearer " + JWTWrapper.encode({ user_id: user.id }) }
    data = JSON.parse(response.body)["data"]
    expect(response).to have_http_status(:success)
    expect(data.size).to eq(1)
  end
end

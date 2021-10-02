require "rails_helper"
include JWTWrapper

describe "Meetings API", type: :request do
  it "return exhibitions releated to an event" do
    user = FactoryBot.create(:user)
    ev = FactoryBot.create(:event, title: "event 1", start_date: 10.days.ago, end_date: 2.days.since)
    ev2 = FactoryBot.create(:event, title: "event 2", start_date: 10.days.ago, end_date: 2.days.since)
    FactoryBot.create(:exhibition, title: "exhibition 1", event_id: ev.id)
    FactoryBot.create(:exhibition, title: "exhibition 2", event_id: ev2.id)

    get "/v1/exhibitions?event_id=#{ev.id}", headers: { 'Content-Type': "application/json", 'Authorization': "bearer " + JWTWrapper.encode({ user_id: user.id }) }
    data = JSON.parse(response.body)["data"]

    expect(response).to have_http_status(:success)
    expect(data.size).to eq(1)
  end

  it "return all active exhibitions" do
    user = FactoryBot.create(:user)
    ev = FactoryBot.create(:event, title: "event 1", start_date: 10.days.ago, end_date: 2.days.since)
    FactoryBot.create(:exhibition, title: "exhibition 1", event_id: ev.id)
    FactoryBot.create(:exhibition, title: "exhibition 2", event_id: ev.id)

    get "/v1/exhibitions", headers: { 'Content-Type': "application/json", 'Authorization': "bearer " + JWTWrapper.encode({ user_id: user.id }) }
    data = JSON.parse(response.body)["data"]

    expect(response).to have_http_status(:success)
    expect(data.size).to eq(2)
  end

  it "return search exhibitions" do
    user = FactoryBot.create(:user)
    ev = FactoryBot.create(:event, title: "event 1", start_date: 10.days.ago, end_date: 2.days.since)
    FactoryBot.create(:exhibition, title: "test title", event_id: ev.id)
    FactoryBot.create(:exhibition, title: "another test title", event_id: ev.id)
    FactoryBot.create(:exhibition, title: "some title", event_id: ev.id)

    get "/v1/exhibitions/search?q=test", headers: { 'Content-Type': "application/json", 'Authorization': "bearer " + JWTWrapper.encode({ user_id: user.id }) }
    data = JSON.parse(response.body)["data"]

    expect(response).to have_http_status(:success)
    expect(data.size).to eq(1)
  end

  it "return search exhibitions limit to an event" do
    user = FactoryBot.create(:user)
    ev1 = FactoryBot.create(:event, title: "event 1", start_date: 10.days.ago, end_date: 2.days.since)
    ev2 = FactoryBot.create(:event, title: "event 2", start_date: 10.days.ago, end_date: 2.days.since)
    FactoryBot.create(:exhibition, title: "test title", event_id: ev1.id)
    FactoryBot.create(:exhibition, title: "another test title", event_id: ev1.id)
    FactoryBot.create(:exhibition, title: "some test title", event_id: ev2.id)

    get "/v1/exhibitions/search?q=test&start_from=#{1.hour.ago.to_i * 1000}&start_to=#{Time.now.to_i * 1000}&event_id=#{ev1.id}", headers: { 'Content-Type': "application/json", 'Authorization': "bearer " + JWTWrapper.encode({ user_id: user.id }) }
    data = JSON.parse(response.body)["data"]
    expect(response).to have_http_status(:success)
    expect(data.size).to eq(1)
  end
end

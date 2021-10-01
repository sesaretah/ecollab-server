require "rails_helper"
include JWTWrapper

describe "Events API", type: :request do
  it "return active events" do
    user = FactoryBot.create(:user)
    FactoryBot.create(:event, title: "event 1", start_date: 10.days.ago, end_date: 10.days.since)
    FactoryBot.create(:event, title: "event 2", start_date: 3.days.ago, end_date: 2.days.ago)

    get "/v1/events", headers: { 'Content-Type': "application/json", 'Authorization': "bearer " + JWTWrapper.encode({ user_id: user.id }) }
    data = JSON.parse(response.body)["data"]

    expect(response).to have_http_status(:success)
    expect(data.size).to eq(1)
  end

  it "return inactive events" do
    user = FactoryBot.create(:user)
    FactoryBot.create(:event, title: "event 1", start_date: 1.days.ago, end_date: 2.days.since)
    FactoryBot.create(:event, title: "event 2", start_date: 3.days.ago, end_date: 2.days.ago)

    get "/v1/events/search?start_from=#{3.days.ago}&start_to=#{2.days.since}", headers: { 'Content-Type': "application/json", 'Authorization': "bearer " + JWTWrapper.encode({ user_id: user.id }) }
    data = JSON.parse(response.body)["data"]

    expect(response).to have_http_status(:success)
    expect(data.size).to eq(2)
  end

  it "return search events" do
    user = FactoryBot.create(:user)
    FactoryBot.create(:event, title: "test-event 1", start_date: 1.days.ago, end_date: 2.days.since)
    FactoryBot.create(:event, title: "test-event 2", start_date: 3.days.ago, end_date: 2.days.ago)

    get "/v1/events/search?q=test", headers: { 'Content-Type': "application/json", 'Authorization': "bearer " + JWTWrapper.encode({ user_id: user.id }) }
    data = JSON.parse(response.body)["data"]

    expect(response).to have_http_status(:success)
    expect(data.size).to eq(2)
  end
end

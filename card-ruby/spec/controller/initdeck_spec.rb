require "rails_helper"

describe "[Initiate a new set of Deck]", :type => :request do

  # Test Case 1
  # Get Card Master List for Game Creation

  it "get 4 master cards", :focus => true do
    get "/v1/deck/init"
    expect(response).to have_http_status(:ok)

    response_body = JSON.parse(response.body)
    expect(response_body["success"]).to eq(true)

    response_data = response_body["data"]
    expect(response_data["deck"].length).to eq(4)
  end
end

require "rails_helper"
describe "[Create a new Game]", :type => :request do

=begin
    Sample Request /v1/deck/initgame?gameid={code}&userid={userid}&deckid={deckid}
    Sample Response
            {
                "message": "DECK_INITIATED",
                "success": true,
                "data": {
                    "data": {
                        "decks": [
                            {
                                "id": 1,
                                "name": "Sutha: The Skull Crusher",
                                "isselected": 0,
                                "userid": ""
                            },
                            {
                                "id": 2,
                                "name": "Azzan: The Mystic",
                                "isselected": 0,
                                "userid": ""
                            },
                            {
                                "id": 3,
                                "name": "Lia: The Radiant",
                                "isselected": 0,
                                "userid": ""
                            },
                            {
                                "id": 4,
                                "name": "Oriax: The Clever",
                                "isselected": 1,
                                "userid": "dkyi8fdskj"
                            }
                        ]
                    }
                }
            }
=end

  # Test Case 1
  # no parameter provided

  it "can not submit without paramter", :focus => true do
    get "/v1/deck/initgame"
    expect(response).to have_http_status(:bad_request)

    response_body = JSON.parse(response.body)
    expect(response_body["success"]).to eq(false)
    response_data = response_body["data"]
    expect(response_data).to eq(nil)
  end

  # Test Case 2
  # gameid parameter provided

  it "can not submit without paramter", :focus => true do
    get "/v1/deck/initgame?userid=user-fdasnjf&deckid=4"
    expect(response).to have_http_status(:bad_request)

    response_body = JSON.parse(response.body)
    expect(response_body["success"]).to eq(false)
    response_data = response_body["data"]
    expect(response_data).to eq(nil)
  end

  # Test Case 3
  # userid parameter provided

  it "can not submit without paramter", :focus => true do
    get "/v1/deck/initgame?gameid=daSFnjf&deckid=4"
    expect(response).to have_http_status(:bad_request)

    response_body = JSON.parse(response.body)
    expect(response_body["success"]).to eq(false)
    response_data = response_body["data"]
    expect(response_data).to eq(nil)
  end

  # Test Case 4
  # deckid parameter provided

  it "can not submit without paramter", :focus => true do
    get "/v1/deck/initgame?gameid=daSFnjf&userid=user-fdasnjf"
    expect(response).to have_http_status(:bad_request)

    response_body = JSON.parse(response.body)
    expect(response_body["success"]).to eq(false)
    response_data = response_body["data"]
    expect(response_data).to eq(nil)
  end

  #Test Case 5
  # valid response is returned

  it "valid response with deck data", :focus => true do
    get "/v1/deck/init"
    get "/v1/deck/initgame?gameid=daSFnjf&userid=user-fdasnjf&deckid=2"
    expect(response).to have_http_status(:ok)

    response_body = JSON.parse(response.body)
    expect(response_body["success"]).to eq(true)

    response_data = response_body["data"]
    deck_data  = response_data["data"]
    expect(deck_data["decks"].length).to eq(4) 

  end
  
end

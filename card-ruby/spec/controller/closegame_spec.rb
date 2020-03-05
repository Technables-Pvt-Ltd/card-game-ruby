require "rails_helper"
describe "[Close a Game]", :type => :request do

=begin
    Sample Request /v1/deck/close?gameid={code}&userid={userid}
    Sample Response
            {
                "message": "GAME_CLOSED",
                "success": true,
                "data": {
                    "data": {
                        "result": {
                            "proceed": true,
                            "error": ""
                        }
                    }
                }
            }
=end

  # Test Case 1
  # no parameter provided

  it "can not submit without paramter", :focus => true do
    get "/v1/deck/close"
    expect(response).to have_http_status(:bad_request)

    response_body = JSON.parse(response.body)
    expect(response_body["success"]).to eq(false)
    response_data = response_body["data"]
    expect(response_data).to eq(nil)
  end

  # Test Case 2
  # gameid parameter provided

  it "can not submit without paramter", :focus => true do
    get "/v1/deck/close?userid=user-fdasnjf"
    expect(response).to have_http_status(:bad_request)

    response_body = JSON.parse(response.body)
    expect(response_body["success"]).to eq(false)
    response_data = response_body["data"]
    expect(response_data).to eq(nil)
  end

  # Test Case 3
  # userid parameter provided

  it "can not submit without paramter", :focus => true do
    get "/v1/deck/close?gameid=daSFnjf"
    expect(response).to have_http_status(:bad_request)

    response_body = JSON.parse(response.body)
    expect(response_body["success"]).to eq(false)
    response_data = response_body["data"]
    expect(response_data).to eq(nil)
  end

  
  #Test Case 4
  # valid response is returned

  it "valid response with deck data", :focus => true do
    get "/v1/deck/init"
    get "/v1/deck/initgame?gameid=daSFnjf&userid=user-fdasnjf&deckid=2"
    get "/v1/deck/join?gameid=daSFnjf&userid=user-fdasndaf&deckid=1"
    get "/v1/deck/leave?gameid=daSFnjf&userid=user-fdasndaf&deckid=1"
    get "/v1/deck/close?gameid=daSFnjf&userid=user-fdasnjf"
    expect(response).to have_http_status(:ok)

    response_body = JSON.parse(response.body)
    expect(response_body["success"]).to eq(true)

    response_data = response_body["data"]
    close_data  = response_data["data"]
    close_result = close_data["result"]

    expect(close_result["proceed"]).to eq(true) 

  end
  
end

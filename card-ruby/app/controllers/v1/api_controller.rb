class V1::ApiController < ApplicationController
    def index
        message = "Hello"
        success = true
        data = {
            :deck => DECK_MASTER
        }

        response_data = ApiResponse.new(message, success, data);
        render json: response_data, status: 200
    end
end

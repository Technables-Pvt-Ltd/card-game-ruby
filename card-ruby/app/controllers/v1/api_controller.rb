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

    def view 
        users = Office.all
        message = "Hello"
        success = true
        data = {
            :deck => users
        }

        response_data = ApiResponse.new(message, success, data);
        render json: response_data, status: 200
    end
    def add 
        
        office = Office.create(name: 'cd', location: "ratopul");

        message = "Hello"
        success = true
        data = {
            :deck => office
        }

        response_data = ApiResponse.new(message, success, data);
        render json: response_data, status: 200
    end
    
end

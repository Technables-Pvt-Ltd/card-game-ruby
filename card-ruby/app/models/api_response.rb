class ApiResponse
  attr_accessor :message, :success, :data

  def initialize(_message, _success, _data)
    self.message = _message;
    self.success = _success;
    self.data = _data;
  end
end

class HomeController < ApplicationController
  def index
    @rooms = fetch_rooms
    @users = fetch_users
  end

  private

  def fetch_rooms
    response = ApiClient.rooms
    return [] unless response&.dig("data")
    response["data"]
  rescue StandardError
    []
  end

  def fetch_users
    response = ApiClient.users
    return [] unless response&.dig("data")
    response["data"]
  rescue StandardError
    []
  end
end

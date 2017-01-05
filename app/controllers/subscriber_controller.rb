class SubscriberController < ApplicationController
  def welcome
    @subscrib = Subscrib.new
  end
end

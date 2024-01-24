class DogsController < ApplicationController
  before_action :set_dog_search_channel

  def index
    if request.post?
      breed = params[:breed]
      is_found = true
      @image = nil

      begin
        @image = get_breed_image(breed)
      rescue => e
        @image = fail_rescue_image
        is_found = false
      end

      puts @image

      broadcast_search_results(breed, @image, is_found)
      render nothing: true, status: :ok, content_type: "text/html"
    else
      @dogs = get_random_breed_dogs
    end
  end

  private

  def set_dog_search_channel
    @dog_search_channel = 'dog_search_channel'
  end

  def broadcast_search_results(breed, image, is_found)
    ActionCable.server.broadcast(@dog_search_channel, {breed: breed, image: image, is_found: is_found})
  end

  def get_random_breed_dogs(limit=12)
    response = RestClient.get "https://dog.ceo/api/breeds/image/random/#{limit}"
    JSON.parse(response.body)['message']
  end

  def get_breed_image(breed)
    response = RestClient.get "https://dog.ceo/api/breed/#{breed}/images/random"
    JSON.parse(response.body)['message']
  end

  def fail_rescue_image
    response = RestClient.get "https://dog.ceo/api/breeds/image/random"
    JSON.parse(response.body)['message']
  end
end

class DogsController < ApplicationController
  before_action :set_dog_search_channel

  def index
    if request.post?
      breed = params[:breed]
      @image = get_breed_image(breed)

      puts @image

      broadcast_search_results(breed, @image)
      render nothing: true, status: :ok, content_type: "text/html"
    end
  end

  private

  def set_dog_search_channel
    @dog_search_channel = 'dog_search_channel'
  end

  def broadcast_search_results(breed, image)
    ActionCable.server.broadcast(@dog_search_channel, {breed: breed, image: image})
  end

  def get_breed_image(breed)
    response = RestClient.get "https://dog.ceo/api/breed/#{breed}/images/random"
    images = JSON.parse(response.body)['message']
    images
  end
end

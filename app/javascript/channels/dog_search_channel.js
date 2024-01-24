import consumer from "channels/consumer"

consumer.subscriptions.create("DogSearchChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    if (data.breed && data.image) {
      console.log(data.breed)
      console.log(data.image)
      let searchResults = document.getElementById('search-results');
      let newResults = document.createElement('div');
      newResults.innerHTML = `<h2>${data.breed} Images</h2><img src="${data.image}" alt="${data.breed}"/>`;
      searchResults.innerHTML = '';
      searchResults.appendChild(newResults);
    }
  }
});

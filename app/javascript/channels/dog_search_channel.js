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
      document.getElementById('random-dogs-container').classList.add('hidden');

      let searchResults = document.getElementById('search-results');
      let newResults = document.createElement('div');
      let resultHtml = `<h2 class="text-lg font-extrabold mb-2 capitalize">${data.breed} Images</h2>`;

      if (!data.is_found) {
        resultHtml = `
          <h2 class="text-lg text-gray-500 mb-4">No <span class="font-extrabold capitalize underline">${data.breed}</span> breed image found</h2>
          <h2 class="text-lg font-extrabold mb-2">But here a cute dog for you <i class="fa-regular fa-face-smile-beam"></i></h2>
        `;
      }
      resultHtml += `<img class="mx-auto" src="${data.image}" alt="${data.breed}"/>`;
      newResults.innerHTML = resultHtml;
      searchResults.innerHTML = '';
      searchResults.appendChild(newResults);
    }
  }
});

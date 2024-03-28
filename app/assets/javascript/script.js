document.addEventListener('DOMContentLoaded', function() {
  const toggleFontButton = document.getElementById('toggleFontButton');

  // Vérifie si la préférence de police est stockée dans localStorage
  const fontPreference = localStorage.getItem('fontPreference');

  // Si la préférence de police est 'altFont', appliquer la classe 'altFont' au body
  if (fontPreference === 'altFont') {
    document.body.classList.add('altFont');
    toggleFontButton.textContent = 'Utiliser la police principale';
  }

  toggleFontButton.addEventListener('click', function() {
    document.body.classList.toggle('altFont');

    // Stocker la préférence de police dans localStorage
    if (document.body.classList.contains('altFont')) {
      localStorage.setItem('fontPreference', 'altFont');
      toggleFontButton.textContent = 'Utiliser la police principale';
    } else {
      localStorage.removeItem('fontPreference');
      toggleFontButton.textContent = 'Changer la police en Opendys';
    }
  });
});


document.addEventListener("DOMContentLoaded", function() {
  var select = document.getElementById("quantity");
  var total = document.getElementById("total");
  var price = <%= @workout.price %>; // Remplacez ceci par le prix de l'entraînement

  select.addEventListener("change", function() {
    total.textContent = (this.value * price);
  });
});
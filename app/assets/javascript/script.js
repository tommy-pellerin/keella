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


//Javascript in workout show page
let reservationBox = document.getElementById('step-before-reservation');
console.log(reservationBox);
let reservationButton = document.getElementById('reservation-button');
console.log(reservationButton);
let showReservation = function(){
  if (reservationBox.classList.contains("d-none")){
    reservationBox.classList.remove("d-none");
    reservationButton.textContent = 'Annuler';
    reservationButton.classList.remove("btn-primary");
    reservationButton.classList.add("btn-danger");
  } else {
    reservationBox.classList.add("d-none");  
    reservationButton.textContent = 'Reserver';
    reservationButton.classList.remove("btn-danger");
    reservationButton.classList.add("btn-primary");
  }
};
reservationButton.addEventListener("click",showReservation);

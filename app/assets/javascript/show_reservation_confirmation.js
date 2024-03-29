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

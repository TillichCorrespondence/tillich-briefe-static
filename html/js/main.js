/**
 * Toggles highlight for elements based on a checkbox state
 * @param {HTMLInputElement} checkbox - The checkbox element
 */
function toggleHighlight(checkbox) {
    // Use the checkbox's value as the data-bs-target
    const dataTarget = checkbox.value;

    // Select all elements with the specified data-bs-target
    const elements = document.querySelectorAll(`[data-bs-target="#${dataTarget}"]`);
    console.log(elements)
    
    // Add or remove the highlight class based on the checkbox state
    if (checkbox.checked) {
        elements.forEach(element => element.classList.add('highlight'));
    } else {
        elements.forEach(element => element.classList.remove('highlight'));
    }
}

function replaceCurrentDate() {
    var currentDate = new Date();
    var elements = document.getElementsByClassName("currentDate");
    for (var i = 0; i < elements.length; i++) {
      elements[i].innerHTML =
        currentDate.getDate() + "." + (currentDate.getMonth() + 1) + "." + currentDate.getFullYear();
    }
  }
  
  //Replaces every class="currentDateYYYYMMDD" element with the current date in the format "YYYY-MM-DD".
  function replaceCurrentDateYYYYMMDD() {
    var currentDate = new Date();
    var elements = document.getElementsByClassName("currentDateYYYYMMDD");
    for (var i = 0; i < elements.length; i++) {
      elements[i].innerHTML =
        currentDate.getFullYear() + "-" + (currentDate.getMonth() + 1) + "-" + currentDate.getDate();
    }
  }
  
  document.addEventListener("DOMContentLoaded", function () {
    replaceCurrentDate();
    replaceCurrentDateYYYYMMDD();
  });
  
// function to allow open modal window from a link with data-bs-toggle="modal" and data-bs-target="#modalId"
document.addEventListener("DOMContentLoaded", function () {
    const modalLinks = document.querySelectorAll('a[data-bs-toggle="modal"]');
    modalLinks.forEach(function (link) {
        link.addEventListener("keydown", function (event) {
      // Check if Space bar (key code 32 or event.key === ' ')
      if (event.key === ' ' || event.keyCode === 32) {
        event.preventDefault(); // Prevent page scroll
        
        const targetModal = link.getAttribute('data-bs-target');
        const modal = new bootstrap.Modal(document.querySelector(targetModal));
        modal.show();
      }
    });
    });
});
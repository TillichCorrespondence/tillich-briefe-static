/**
 * Toggles highlight for elements based on a checkbox state
 * @param {HTMLInputElement} checkbox - The checkbox element
 */
function toggleHighlight(checkbox) {
    // checkbox value is the person ID, e.g., "tillich_person_id__1"
    const entityId = checkbox.value;
    
    // 1. Single person: direct match on data-bs-target
    const singlePersonElements = document.querySelectorAll(`[data-bs-target="#${entityId}"]`);
    
    // 2. Multiple persons: check if entityId is in data-refs
    const allElements = document.querySelectorAll('[data-refs]');
    const multiPersonElements = Array.from(allElements).filter(element => {
        const refs = element.getAttribute('data-refs');
        // Check if refs contains this entityId (with or without #)
        return refs.includes(`#${entityId}`) || refs.includes(entityId);
    });
    
    // Combine both results
    const allMatchingElements = [...singlePersonElements, ...multiPersonElements];
    
    // Add or remove the highlight class
    if (checkbox.checked) {
        allMatchingElements.forEach(element => element.classList.add('highlight'));
    } else {
        allMatchingElements.forEach(element => element.classList.remove('highlight'));
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
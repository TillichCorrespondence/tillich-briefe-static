function showEntities() {
  hideEntitieError();
  let entities = document.getElementsByClassName("entities");
  for (let i = 0; i < entities.length; i++) {
    entities[i].style.display = "block";
  }
  window.scrollTo(0, 0);
}

function hideEntities() {
  hideEntitieError();
  let entities = document.getElementsByClassName("entities");
  for (let i = 0; i < entities.length; i++) {
    entities[i].style.display = "none";
  }
}
function hideEntitieError() {
  document.getElementById("entity-error").style.display = "none";
}

function displayEntity(entity) {
  console.log(entity);
  hideEntities();
  let entityDiv = document.getElementById(entity);
  if (!entityDiv) {
    document.getElementById("entity-error").style.display = "block";
    return;
  }
  entityDiv.style.display = "block";
}

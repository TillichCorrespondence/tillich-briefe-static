document.getElementById("download-pdf").addEventListener("click", function () {
  console.log("hallo");
  var container = document.createElement("div");
  var pdfTitle = document.getElementById("pdf-title");
  pdfTitle.classList.add("fs-5");
  var pdfTranscript = document.getElementById("pdf-transcript");
  var pdfFootnotes = document.getElementById("pdf-footnotes");
  var pdfMetadata = document.getElementById("pdf-metadata");
  container.appendChild(pdfTitle.cloneNode(true));
  container.appendChild(pdfTranscript.cloneNode(true));
  container.appendChild(pdfFootnotes.cloneNode(true));
  container.appendChild(pdfMetadata.cloneNode(true));
  document.body.appendChild(container);
  var entityElements = container.querySelectorAll('[class*="entity"]');
  entityElements.forEach(function (element) {
    element.style.textDecoration = "underline dashed";
  });

  var filename = document.getElementById("filename").value;
  html2pdf(container, {
    margin: 1,
    pagebreak: { mode: ["avoid-all", "css", "legacy"] },
    filename: filename,
    image: { type: "jpeg", quality: 0.8 },
    html2canvas: { scale: 2 },
    jsPDF: { unit: "in", format: "letter", orientation: "portrait" },
  }).then(function () {
    // Remove the temporary container after PDF generation
    document.body.removeChild(container);
  });
});

// Scripts for PDF rendering in the browser

var pdfDoc = null,
    pdfPageNum = 1,
    pdfPageRendering = false,
    pdfPageNumPending = null,
    pdfScale = 0.8,
    pdfCanvas = null,
    pdfContext = null;

function renderPdf(url, elementId) {
  //
  // The workerSrc property shall be specified.
  //
  pdfjsLib.GlobalWorkerOptions.workerSrc = '/lib/pdfjs-2/build/pdf.worker.js';

  pdfCanvas = document.getElementById(elementId);
  pdfContext = pdfCanvas.getContext('2d');

  //
  // Asynchronous download PDF
  //
  var loadingTask = pdfjsLib.getDocument(url);
  loadingTask.promise.then(function(pdf) {

		pdfDoc = pdf;
		renderPdfPage(pdfPageNum);

  });
}



function renderPdfPage(num) {

  pdfPageRendering = true;

  // Using promise to fetch the page
  pdfDoc.getPage(num).then(function(page) {

    var viewport = page.getViewport({ scale: pdfScale, });
    pdfCanvas.height = viewport.height;
    pdfCanvas.width = viewport.width;

		// Render PDF page into canvas context
    var renderContext = {
      canvasContext: pdfContext,
      viewport: viewport,
    };

    var renderTask = page.render(renderContext);

    // Wait for rendering to finish
    renderTask.promise.then(function () {
      pdfPageRendering = false;
      if (pdfPageNumPending !== null) {
        // New page rendering is pending
        renderPage(pdfPageNumPending);
        pdfPageNumPending = null;
      }
    });
  });

  // Update page counters
  // document.getElementById('page_num').textContent = num;
}


function pdfNextPage() {
  if (pdfPageNum >= pdfDoc.numPages) {
    return;
  }
  pdfPageNum++;
  renderPdfPage(pdfPageNum);
}

function pdfPreviousPage() {
    if (pdfPageNum <= 1) {
      return;
    }
    pdfPageNum--;
    renderPdfPage(pdfPageNum);
  }

//     //
//     // Fetch the first page
//     //
//     pdf.getPage(1).then(function(page) {
//       var scale = 1.0;
//       var viewport = page.getViewport({ scale: scale, });
//       //
//       // Prepare canvas using PDF page dimensions
//       //
//       var canvas = document.getElementById(elementId);
// //      var context = canvas.getContext('2d');
//       canvas.height = viewport.height;
//       canvas.width = viewport.width;
//       //
//       // Render PDF page into canvas context
//       //
//       var renderContext = {
//         canvasContext: context,
//         viewport: viewport,
//       };
//       page.render(renderContext);
//     });

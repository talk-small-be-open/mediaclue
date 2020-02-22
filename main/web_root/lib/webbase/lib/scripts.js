// JavaScripts für webbase-Library

function saveScroll(id) {
	var y = $(document).scrollTop();
	// Kurze Dauer, sonst können sich zuviele anhäufen
	var inFifteenMinutes = new Date(new Date().getTime() + 15 * 60 * 1000);
	Cookies.set("page_scroll_" + id, y, { expires: inFifteenMinutes });
}

function loadScroll(id) {
	var y = Cookies.get("page_scroll_" + id);
	if (!y) {return}
	$(document).scrollTop(y);
}



function appendToTagList(inputId, text) {
  var currentValue;
  var newValue;
  var inputElement;
  
  inputElement = $('#' + inputId)[0];
  
  currentValue = inputElement.value;
  
  if (currentValue) {
    newValue = currentValue + ', ' + text;
  } else {
    newValue = text;
  };
  
  inputElement.value = newValue;
  inputElement.focus();
  
}

function selectText(elementId) {
  var doc = document,
      text = doc.getElementById(elementId),
      range,
      selection;
  
  if (doc.body.createTextRange) {
    range = document.body.createTextRange();
    range.moveToElementText(text);
    range.select();
  } else if (window.getSelection) {
    selection = window.getSelection();        
    range = document.createRange();
    range.selectNodeContents(text);
    selection.removeAllRanges();
    selection.addRange(range);
  }

  document.execCommand("copy");

}


//
// LAZY Images
//


var lazy = [];

function setLazy(){
    lazy = document.querySelectorAll('img.lazy');
//    console.log('Found ' + lazy.length + ' lazy images');
} 

function lazyLoad(){
    for(var i=0; i<lazy.length; i++){
        if(isInViewport(lazy[i])){
            if (lazy[i].getAttribute('data-src')){
                lazy[i].src = lazy[i].getAttribute('data-src');
                lazy[i].removeAttribute('data-src');
            }
        }
    }
    
    cleanLazy();
}

// Schneller filter
function cleanLazy(){
    lazy = Array.prototype.filter.call(lazy, function(l){ return l.getAttribute('data-src');});
}

// OPTIMIZE: Abfrage auch auf visible? Schwierig: Reagieren auf, wenn eingeblendet
function isInViewport(el){
    var rect = el.getBoundingClientRect();
    
    return (
        rect.bottom >= 0 && 
        rect.right >= 0 && 
        rect.top <= (window.innerHeight || document.documentElement.clientHeight) && 
        rect.left <= (window.innerWidth || document.documentElement.clientWidth)
     );
}


//
// Session expiry checker
//
function handleSessionCheck(responseData) {

	switch (responseData) {
	case 'OK':
		// alert('Session OK');
	  break;
	case 'expired':
		alert('Ihre Sitzung ist wegen Inaktivität abgelaufen.');
		location.reload(true);
		break;
	case 'nearlyExpired':
		$('#sessionNearlyExpired').modal('show');
		break;
	default:
		// alert('Sitzung meldet ' + responseData);
	}
	
}



//
// Starter
//
$(document).ready(function() {
  // autosize($("textarea"));

	// $(".chosen-select").chosen({
  //   allow_single_deselect:true,
  //   placeholder_text:" ",
  //   search_contains:true,
	// 	//Evt. nötig wegen Tablets?		hide_results_on_select:false
	// 	hide_results_on_select: true
  // });

	// Lazy load von Bildern installieren
	setLazy();
	lazyLoad();
	$(window).on('scroll', lazyLoad);

	// Fallback von HTML5 Date-Inputs, falls der Browser nur ein Textinput anzeigt
	// if ( $('[type="date"]').prop('type') != 'date' ) {
  //   $('[type="date"]').datepicker();
	// }
	
})

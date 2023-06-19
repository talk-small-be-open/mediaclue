// mediaclue Javascript



/**
 * Element.requestFullScreen() polyfill
 * @author Chris Ferdinandi
 * @license MIT
 */
if (!Element.prototype.requestFullscreen) {
	Element.prototype.requestFullscreen = Element.prototype.mozRequestFullscreen || Element.prototype.webkitRequestFullscreen || Element.prototype.msRequestFullscreen;
	document.fullscreenElement = function () { return document.mozFullscreenElement || document.webkitFullscreenElement || document.msFullscreenElement };
	document.exitFullscreen = document.mozExitFullscreen || document.webkitExitFullscreen || document.msExitFullscreen;
}
Element.prototype.toggleFullscreen = function () {
	if (document.fullscreenElement) { 
		document.exitFullscreen();
	} else {
		this.requestFullscreen();
	}
};


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

// Call fire on checkboxes. fire ist ein eigener Event, bei komplexeren Checkboxen, um nicht den click-Event zu nehmen
function fireCheckboxes(cssSelector) {
	$(cssSelector).each(function(){
		$(this).prop('checked', !$(this).prop('checked'));
		$(this).trigger('fire');
	});	
}

function onClickFireCheckboxes(event, cssSelectorOfCheckboxes) {

	// Clicks von Inhaltselementen verhindern. Nur Klicks von DIVs, sonst gibts
	// evt. double triggering, wenn auf anchors oder checkboxes geklickt wird, etc.
	if (event.target.tagName != 'DIV') {
		return
	}

	fireCheckboxes(cssSelectorOfCheckboxes);
}

function showZoomedImage(urlString) {
	$('<div>').css({
    background: 'black url(' + urlString + ') no-repeat center',
    backgroundSize: 'contain',
		backgroundOrigin: 'content-box',
		padding: '0.5em',
    width: '100%', height: '100%',
    position: 'fixed',
    zIndex: '10000',
    top: '0', left: '0',
    cursor: 'zoom-out'
  }).click(function(){
    $(this).remove();
  }).appendTo('body');
}


$(document).ready(function(){

  var layout = document.getElementById('layout');
  var mainMenuLink = document.getElementById('mainMenuLink');
  var sideMenuLink = document.getElementById('sideMenuLink');
  var content  = document.getElementById('main');


  function toggleMainMenu() {
		$(layout).toggleClass('mainMenuActive');
  }

	function toggleSideMenu() {
		$(layout).toggleClass('sideMenuActive');
  }

	if (mainMenuLink) {
		mainMenuLink.onclick = function (e) {
			e.preventDefault();
			e.stopPropagation();
			toggleMainMenu();
		};
	}

	// Nur falls sideMenu vorhanden
	if (sideMenuLink) {
		sideMenuLink.onclick = function (e) {
			e.preventDefault();
			e.stopPropagation();
			toggleSideMenu();
		};
	}

	if (content) {
		content.onclick = function(e) {
			if ($(layout).hasClass('mainMenuActive')) {
				toggleMainMenu()
			}
			if ($(layout).hasClass('sideMenuActive')) {
				toggleSideMenu()
			}
		}
	}
	

	$('div.grid.magritte.selectized select:not([multiple])').selectize({
//		plugins: ["remove_button"],
	});

	$('div.grid.magritte.selectized select[multiple]').selectize({
		plugins: ["remove_button"],
	});

	autosize($('textarea'));

})

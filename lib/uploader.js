// function seasideCallbackFileUploaded(ajaxParameter) {
// 	// Must be defined dynamically
// }

// function seasideUploadSessionUuid() {
// 	// Must be defined dynamically
//  return 'qwer345qwefqwrqw';
// }

// function seasideAllowedFileExtensions() {
// 	// Must be defined dynamically
//  return 'jpg,gif,png';
// }

// function seasideMaxFileUploads() {
// 	// Must be defined dynamically
//  return 100;
// }

$(document).ready(function() {

	var uploadFilesCount = 0;
	
	$("#pluploadStartButton").hide();

	var uploader = new plupload.Uploader({
		browse_button: "pluploadBrowseButton",
		url: ("/lib/webbase/lib/upload_gateway/upload.php?id=" + seasideUploadSessionUuid() ),
		drop_element: 'pluploadDropzone',
		// multipart_params: {
		// 	importMetadata: '1'
		// },
		//	chunk_size: "200kb",
		runtimes: "html5",
		max_retries: 3,

	  filters: {
	    max_file_size: pluploadMaxFileSize,
			max_files_count: seasideMaxFileUploads(),
	    prevent_duplicates: true,
	    mime_types : [
	      { title : "Mediendateien", extensions : seasideAllowedFileExtensions() }
	    ]
	  }    
	});


	plupload.addFileFilter('max_files_count', function(max, file, cb) {

		if (uploadFilesCount < max) {
			cb(true);
		} else {
			// this.trigger('Error', {
			// 	code : plupload.FILE_SIZE_ERROR,
			// 	message : plupload.translate('File size error.'),
			// });
			cb(false);
		}

	});	


	// After files have been added from the file dialog
	uploader.bind("FileFiltered", function(up, file) {
		uploadFilesCount++;
	});


	// After files have been added from the file dialog
	uploader.bind("FilesAdded", function(up, files) {
		
		var html = "";
		plupload.each(files, function(file) {
			html += "<li id=\"" + file.id + "\"><span class=\"uploadStatus\">0%</span> " + file.name + " (" + plupload.formatSize(file.size) + ")</li>";
		});
		document.getElementById("pluploadFilelist").innerHTML += html;
		$("#pluploadStartButton").show();

	});

	// When a file is being uploaded
	uploader.bind("UploadProgress", function(up, file) {
		var element = document.getElementById(file.id).querySelector("span.uploadStatus");
		element.scrollIntoView(false);
		
		if (file.percent == 100) {
			element.innerHTML = "<span>FERTIG</span>";
		} else {
			element.innerHTML = "<span>" + file.percent + "%</span>";
		}
	});

	// After a file is finished uploading
	uploader.bind("FileUploaded", function(up, file, result) {
		if (result.status == 200) {
			var ajaxParameter = result.response + "/" + file.name;
			seasideCallbackFileUploaded(ajaxParameter);
		} else {
			alert("Upload-Fehler!");
		}
	});

	// When all files have been uploaded
	uploader.bind("UploadComplete", function(up, file) {
		// Timeout, damit ajax calls fertig machen können
		uploadFilesCount = 0;
		setTimeout(function() {
			location.reload();
		}, 2000)
	});

	uploader.bind('PostInit', function(up) {
		if (!up.features.dragdrop) {
			$('#pluploadDropzone').addClass('inactive')
		}
	});
	

	uploader.bind("Error", function(up, err) {
		alert("\nFehler #" + err.code + ": " + err.message);
	});

	document.getElementById("pluploadStartButton").onclick = function() {
		uploader.start();
	};

	uploader.init();


});

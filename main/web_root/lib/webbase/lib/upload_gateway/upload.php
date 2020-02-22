<?php

//
// Uploader handler for Plupload
// Andreas Brodbeck
//

if (gethostname() == 'mindclue-dassi-main.local') {
	 $DEVELOPMENT = true;
} else {
	 $DEVELOPMENT = false;
}

// No cache headers
header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");
header("Last-Modified: " . gmdate("D, d M Y H:i:s") . " GMT");
header("Cache-Control: no-store, no-cache, must-revalidate");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");

// Assume failure, if script will exit before end
http_response_code(500);

// 30 minutes max execution time
@set_time_limit(30 * 60);

// Settings
$albusUploadSessionId = $_GET['id'];
$targetDir = ini_get("upload_tmp_dir") . DIRECTORY_SEPARATOR . "plupload" . DIRECTORY_SEPARATOR . $albusUploadSessionId;

// Create target dir
if (!file_exists($targetDir)) {
	@mkdir($targetDir, 0777, true);
}

// Create unique filename
$fileName = uniqid("file_");
$filePath = $targetDir . DIRECTORY_SEPARATOR . $fileName;

// Chunking enabled?
$chunk = isset($_REQUEST["chunk"]) ? intval($_REQUEST["chunk"]) : 0;
$chunks = isset($_REQUEST["chunks"]) ? intval($_REQUEST["chunks"]) : 0;

// Open the temp file
if (!$out = @fopen("{$filePath}.part", $chunks ? "ab" : "wb")) {
	die('Failed to open output stream.');
}

if (!empty($_FILES)) {
	if ($_FILES["file"]["error"] || !is_uploaded_file($_FILES["file"]["tmp_name"])) {
		die('Failed to move uploaded file.');
	}

	// Read binary input stream and append it to temp file
	if (!$in = @fopen($_FILES["file"]["tmp_name"], "rb")) {
		die('Failed to open input stream.');
	}
} else {	
	if (!$in = @fopen("php://input", "rb")) {
		die('Failed to open input stream.');
	}
}

// Write input to temp file
while ($buff = fread($in, 4096)) {
	fwrite($out, $buff);
}

@fclose($out);
@fclose($in);

// Check if file has been uploaded
if (!$chunks || $chunk == $chunks - 1) {
	// Strip the temp .part suffix off 
	rename("{$filePath}.part", $filePath);
}

if ($DEVELOPMENT) {
	$nginx_usergroup = '_www';
} else {
	$nginx_usergroup = 'www-data';
}

// chown($filePath, 'ubuntu');
chgrp($targetDir, $nginx_usergroup);
chmod($targetDir, 0775);
chgrp($filePath, $nginx_usergroup);
chmod($filePath, 0660);

// Status is OK, if we get to here
http_response_code(200);

// Return the name of the temp file
exit($fileName);

chrome.app.runtime.onLaunched.addListener(function() {
	var windowoption = {
		'bounds':{'width':454, 'height':696},
		'minWidth':454,
		'minHeight':260
	}

	chrome.app.window.create('main.html', windowoption, function() {
	});
});

chrome.app.runtime.onLaunched.addListener(function() {
	var windowoption = {
		'bounds':{'width':320, 'height':320},
		'minWidth':320,
		'minHeight':320
	}

	chrome.app.window.create('main.html', windowoption, function() {
	});
});

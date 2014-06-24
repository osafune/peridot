chrome.app.runtime.onLaunched.addListener(function() {
	var windowoption = {
		'bounds':{'width':486, 'height':662},
		'minWidth':486,
		'minHeight':260
	}

	chrome.app.window.create('main.html', windowoption, function() {
	});
});

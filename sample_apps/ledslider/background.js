chrome.app.runtime.onLaunched.addListener(function() {
	var windowoption = {
		bounds :{
			width : 320,
			height : 320
		},
		resizable : false
	}

	chrome.app.window.create('main.html', windowoption, function() {
	});
});

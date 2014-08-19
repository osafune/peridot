chrome.app.runtime.onLaunched.addListener(function() {
	chrome.app.window.create('main.html', {
		id: "rbfwriter-main",		// idを付けると多重起動とウィンドウサイズ指定が効かなくなる 
		innerBounds: {width: 360, height: 340},
		resizable: false
	}, function() {
	});
});

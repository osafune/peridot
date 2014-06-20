//////////////////////////////////////////////////
//  physicaloid.js サンプル 
//////////////////////////////////////////////////

// コンフィグレーションするRBF先 
var rbfurl = "https://dl.dropboxusercontent.com/u/68933379/peridot/lib/peridot/sample_ledslider/sample_ledslider_top.rbf";

// RBFバイナリオブジェクトを生成(URL取得に失敗した場合) 
//var rbfbin = new sample_ledslider_rbf();

// PERIDOTオブジェクトを生成 
var myps = new Canarium();


// 開始時に呼び出される 
var select;

window.onload = function() {

	select = document.getElementById('ports');

	// シリアルポートの取得 
	var scanport = function() {
		chrome.serial.getDevices(function (ports) {
			// エレメントを全て削除 
			while(select.firstChild){
				select.removeChild(select.firstChild);
			}

			// スキャン結果を追加 
			for (var i=0; i<ports.length; i++) {
				var port = ports[i].path;
				select.appendChild(new Option(port, port));
			}

			// 選択できるポートがあるか 
			if (select.firstChild) {
				document.getElementById('connect').disabled = false;
			} else {
				document.getElementById('connect').disabled = true;
			}
		});
	}

	document.getElementById('connect').addEventListener('click', connectPort);
	document.getElementById('scanport').addEventListener('click', scanport);

	document.getElementById('config').addEventListener('click', configSetup);
	document.getElementById('ledrange').addEventListener('change', iowrite);

    scanport();
}


// シリアルポートの接続と切断 
var onConnect = false;

function connectPort() {
	if (!onConnect) {
		var selectedPort = select.childNodes[select.selectedIndex].value;
		document.getElementById('waitingicon').src="img/loading02_r2_c4.gif";

		myps.open(selectedPort, function (result) {
			if (result) {
				onConnect = true;
				select.disabled = true;
				document.getElementById('connect').value="Disconnect";
				document.getElementById('scanport').disabled = true;
				document.getElementById('config').disabled = false;

				document.getElementById('waitingicon').src="img/icon_ok_24x24.png";
			} else {
				document.getElementById('waitingicon').src="img/close03-001-24.png";
			}
		});
	} else {
		myps.close(function (result) {
			select.disabled = false;

			document.getElementById('connect').value="Connect";
			document.getElementById('scanport').disabled = false;
			document.getElementById('waitingicon').src="img/dummy_1x1.png";

			document.getElementById('config').disabled = true;
			document.getElementById('configicon').src="img/dummy_1x1.png";
			document.getElementById('sysid').innerHTML = "";

			document.getElementById('ledrange').disabled = true;

			onConnect = false;
	    });
	}
}


// FPGAのコンフィグレーション 
function configSetup() {
	var retry = false;

	// コンフィグレーション実行 
	var doconfig = function(rbf) {
		if (rbf == null) {
			rbf = new sample_ledslider_rbf();			// ローカルRBFデータを利用する 
			retry = true;
		}

		myps.config(0, rbf, function (result) {
			if (result) {
				document.getElementById('configicon').src="img/icon_ok_24x24.png";
				document.getElementById('ledrange').disabled = false;
				getsysid();
			} else {
				if (!retry) {
					doconfig(null);
				} else {
					document.getElementById('configicon').src="img/close03-001-24.png";
					document.getElementById('ledrange').disabled = true;
					document.getElementById('sysid').innerHTML = "";
				}
			}
		});
	};

	// SysIDを表示 
	var getsysid = function() {
		var address = 0x10000000;
		myps.avm.iord(address, 0, function(result, data) {
			if (result) {
				var str = " SYSID : 0x" + ("00000000" + data.toString(16)).slice(-8);
				document.getElementById('sysid').innerHTML = str;
			}
		});
	};

	// RBFを読み込む 
	var xhr = new XMLHttpRequest();
	xhr.open('GET', rbfurl, true);
	xhr.responseType = "arraybuffer";
	xhr.onload = function(e) {
		doconfig(xhr.response);
	};
	xhr.timeout = function(e) {
		doconfig(null);
	};
	xhr.abort = function(e) {
		document.getElementById('configicon').src="img/close03-001-24.png";
	};
	xhr.error = function(e) {
		document.getElementById('configicon').src="img/close03-001-24.png";
	};

	// 実行 
	document.getElementById('configicon').src="img/loading02_r2_c4.gif";
	xhr.send();
}


// スライダーが動いたら値をPWMレジスタに書き込む 
function iowrite() {
	var address = 0x10000100;
	var data = parseInt(document.getElementById('ledrange').value);

	myps.avm.iowr(address, 0, data, function(result) {
	});
}



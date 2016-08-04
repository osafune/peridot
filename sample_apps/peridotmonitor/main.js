//////////////////////////////////////////////////
//  パネルの初期化 
//////////////////////////////////////////////////

var testps = new Canarium();		// アクセスオブジェクトを生成 

// 開始時に呼び出される 
var select = null;

window.onload = function() {

	// Chrome Package Apps を前提とするのでFileAPIのチェックは省略 //

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

	document.getElementById('rbffiles').addEventListener('change', handleFileSelect, false);
	document.getElementById('config').addEventListener('click', configSetup);

	document.getElementById('avm_iord').addEventListener('click', readqsysio);
	document.getElementById('avm_iowr').addEventListener('click', writeqsysio);
	document.getElementById('avm_read').addEventListener('click', memdump);
	document.getElementById('avm_write').addEventListener('click', memwrite);

	document.getElementById('dropfile').disabled = true;
	document.getElementById('dropfile').addEventListener('change', handleFileSend, false);
//	document.getElementById('fileprogress').style.top = "-1px";

	document.getElementById('lib_ver').innerHTML = testps.version;

	scanport();
}


// シリアルポートの接続と切断 
var onConnect = false;

function connectPort () {
	if (!onConnect) {
		var selectedPort = select.childNodes[select.selectedIndex].value;
		document.getElementById('waitingicon').src="img/loading02_r2_c4.gif";

		testps.open(selectedPort, function (result) {
			if (result) {
				select.disabled = true;
				document.getElementById('connect').value="Disconnect";
				document.getElementById('scanport').disabled = true;

				document.getElementById('boardid').innerHTML = "Board Serial : <progress></progress>";
				testps.getinfo(function (result, boardinfo) {
					if (result) {
						document.getElementById('boardid').innerHTML = "Board Serial : " + boardinfo.id + "-" + boardinfo.serialcode;

						if (boardinfo.id == "J72X") {
							document.getElementById('config').disabled = true;
							document.getElementById('rbffiles').disabled = true;
							document.getElementById('configicon').src="img/close03-001-24.png";
							getsysid(true);
						} else {
							if (confdata != null) document.getElementById('config').disabled = false;
						}
					}

					onConnect = true;
					document.getElementById('waitingicon').src="img/icon_ok_24x24.png";

					document.getElementById('dropfile').disabled = false;
				});
			} else {
				document.getElementById('waitingicon').src="img/close03-001-24.png";
			}
		});
	} else {
		testps.close(function (result) {
			select.disabled = false;

			document.getElementById('connect').value="Connect";
			document.getElementById('scanport').disabled = false;
			document.getElementById('waitingicon').src="img/dummy_1x1.png";
			document.getElementById('boardid').innerHTML = "Board Serial : ";

			document.getElementById('config').disabled = true;
			document.getElementById('rbffiles').disabled = false;
			document.getElementById('configicon').src="img/dummy_1x1.png";
			document.getElementById('sysid').innerHTML = "SYSID : ";

			document.getElementById('dropfile').disabled = true;

			onConnect = false;
	    });
	}
}


// RBFファイルの読み込み 
var confdata = null;		// 読み込んだRBFデータ 

function handleFileSelect(evt) {
	var rbf = evt.target.files[0];

	if (rbf == null) {
		console.log("config : [!] rbf file not selected.");
		confdata = null;
		document.getElementById('config').disabled = true;		// コンフィグレーションボタンを無効化 
		return;
	}

	var rbfreader = new FileReader();
	rbfreader.onload = function(e) {
		confdata = e.target.result;
		console.log("config : rbffile = " + rbf.name + ", " + e.loaded + "bytes loaded.");

		// コンフィグレーションボタンを有効化 
		if (onConnect) document.getElementById('config').disabled = false;
	}

	rbfreader.readAsArrayBuffer(rbf);		// ファイルの読み込みを開始 
}


// FPGAのコンフィグレーション 
function configSetup() {

	var boardinfo = null;
	document.getElementById('configicon').src="img/loading02_r2_c4.gif";

	testps.config(boardinfo, confdata, function (result) {
		if (result) {
			document.getElementById('configicon').src="img/icon_ok_24x24.png";
			getsysid(true);
		} else {
			document.getElementById('configicon').src="img/close03-001-24.png";
			getsysid(false);
		}
	});
}


// Qsysペリフェラルの読み出し 
function readqsysio() {
	var address = (parseInt(document.getElementById('avm_address').value, 16))>>>0;

	if (onConnect && address != NaN) {
		testps.avm.iord(address, 0, function(result, readdata) {
			if (result) {
				readdata = readdata>>>0;		// unsigned intへ変換 
				document.getElementById('avm_data').value = ("00000000"+readdata.toString(16)).slice(-8);
			}
		});
	}
}

// Qsysペリフェラルの書き込み 
function writeqsysio() {
	var address = (parseInt(document.getElementById('avm_address').value, 16))>>>0;
	var data = (parseInt(document.getElementById('avm_data').value, 16))>>>0;

	if (onConnect &&(address != NaN && data != NaN)) {
		testps.avm.iowr(address, 0, data, function(result) {
		});
	}
}


// SysIDを表示 
function getsysid(result) {
	var sysid_addr = 0x10000000 >>> 0;
	var sysid_str = "SYSID : ";

	if (!result) {
		document.getElementById('sysid').innerHTML = sysid_str;
		return;
	}

	document.getElementById('sysid').innerHTML = sysid_str + "<progress></progress>";

	testps.avm.iord(sysid_addr, 0, function(result, iddata) {
		if (result) {
			sysid_str = sysid_str + "0x" + ("00000000" + iddata.toString(16)).slice(-8);

			testps.avm.iord(sysid_addr, 1, function(result, tmdata) {
				sysid_str = sysid_str + ", 0x" + ("00000000" + tmdata.toString(16)).slice(-8);
				document.getElementById('sysid').innerHTML = sysid_str;
			});
		}
	});
}


// メモリダンプ 
function memdump() {
	var address = (parseInt(document.getElementById('mem_address').value, 16))>>>0;

	var textdump = function(readdata) {
		var readdata_arr = new Uint8Array(readdata);
		var memaddr = address;
		var str = " address   +0 +1 +2 +3 +4 +5 +6 +7 +8 +9 +a +b +c +d +e +f  sum\n" + 
				  "----------------------------------------------------------------";

		for(var i=0 ; i<16 ; i++) {
			var sum = 0;
			str += ("\n" + ("00000000"+memaddr.toString(16)).slice(-8) + " :");
			for(var j=0 ; j<16 ; j++) {
				var m = readdata_arr[i*16+j];
				sum = (sum + m) & 0xff;
				str += (" " + ("0"+m.toString(16)).slice(-2));
			}
			str += (" | " + ("0"+sum.toString(16)).slice(-2));
			memaddr += 16;
		}

		document.getElementById('mem_dumpdata').value = str;
	};

	if (onConnect && address != NaN) {
		testps.avm.read(address, 256, function(result, readdata) {
			if (result) {
				textdump(readdata);
			}
		});
	}
}


// メモリにテストデータを書き込む 
function memwrite() {
	var address = (parseInt(document.getElementById('mem_address').value, 16))>>>0;

	if (onConnect && address != NaN) {
		var writedata = new ArrayBuffer(256);
		var writedata_arr = new Uint8Array(writedata);

		for(var i=0 ; i<writedata.byteLength ; i++) writedata_arr[i] = (i & 0xff);

		testps.avm.write(address, writedata, function(result) {
			if (result) {
			}
		});
	}
}


// メモリにファイルを転送 
function handleFileSend(evt) {
	var address = (parseInt(document.getElementById('mem_address').value, 16))>>>0;
	if (address == NaN) return;

	var bindata;
	var bindata_arr;
	var bindata_bytes = 0;
	var senddata_bytes = 0;
	var bin = evt.target.files[0];
	if (bin == null) return;

	// ファイル読み込みと転送 
	var _sendchunk = function(callback) {
		var size = 256;
		if (senddata_bytes+size > bindata_bytes) size = bindata_bytes - senddata_bytes;

		var sendbuff = new ArrayBuffer(size);
		var sendbuff_arr = new Uint8Array(sendbuff);
		for(var i=0 ; i<size ; i++) sendbuff_arr[i] = bindata_arr[senddata_bytes+i];

		testps.avm.write(address+senddata_bytes, sendbuff, function(result) {
			if (result) {
				senddata_bytes = senddata_bytes + size;
				document.getElementById('filesend').value = senddata_bytes;

				if (senddata_bytes < bindata_bytes) {
					_sendchunk(callback);
				} else {
					callback(true);
				}
			} else {
				callback(false);
			}
		});
	}

	var binreader = new FileReader();
	binreader.onload = function(e) {
		bindata = e.target.result;
		bindata_arr = new Uint8Array(bindata);
		bindata_bytes = e.loaded;
		senddata_bytes = 0;

		document.getElementById('filesend').max = bindata_bytes;
		console.log("avm : sendfile = " + bin.name + ", " + e.loaded + "bytes.");

		testps.avm.option({fastAcknowledge:true}, function() {

			_sendchunk(function(result) {
				document.getElementById('dropfile').value = "";
				document.getElementById('dropfile').disabled = false;
				document.getElementById('fileprogress').style.top = "-45px";

				testps.avm.option({fastAcknowledge:false}, function() {
					if (result) {
						memdump();
					}
				});
			});
		});
	}


	document.getElementById('dropfile').disabled = true;
	document.getElementById('fileprogress').style.top = "-1px";
	document.getElementById('filesend').value = 0;

	binreader.readAsArrayBuffer(bin);		// ファイルの読み込みを開始 
}

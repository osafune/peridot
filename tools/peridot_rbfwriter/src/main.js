// ------------------------------------------------------------------- //
//  PERIDOT - RBF data writer                                          //
// ------------------------------------------------------------------- //
//
//  ver 0.2
//		2014/08/20	s.osafune@gmail.com
//
// ******************************************************************* //
//     Copyright (C) 2014, J-7SYSTEM Works.  All rights Reserved.      //
//                                                                     //
// * This module is a free sourcecode and there is NO WARRANTY.        //
// * No restriction on use. You can use, modify and redistribute it    //
//   for personal, non-profit or commercial products UNDER YOUR        //
//   RESPONSIBILITY.                                                   //
// * Redistributions of source code must retain the above copyright    //
//   notice.                                                           //
//                                                                     //
//         PERIDOT Project - https://github.com/osafune/peridot        //
//                                                                     //
// ******************************************************************* //

var apps_version = "0.2";
var apps_title = "RBF-WRITER";


//  パネルの初期化 

var testps = new Canarium();		// アクセスオブジェクトを生成 

var select;
var btnconn;
var btnscan;
var confmes;
var dropmes;
var btnfile;

window.onload = function() {

	// id付きで生成するとサイズがオーバーライドされるので元に戻す 
	chrome.app.window.current().innerBounds.width  = 360;
	chrome.app.window.current().innerBounds.height = 340;


	// aboutパネルの呼び出し 
	document.getElementById('banner').addEventListener('click', function() {
		chrome.app.window.create('about.html', {
			id: "rbfwriter-about",
			resizable: false
		}, function() {
		});
	}, false);

	chrome.app.window.current().onClosed.addListener(function() {
		chrome.app.window.get("rbfwriter-about").close();
	});


	// ウィンドウのオブジェクトを取得 
	select = document.getElementById('ports');
	btnconn = document.getElementById('connect');
	btnscan = document.getElementById('scanport');
	btnfile = document.getElementById('dropfile');
	confmes = document.getElementById('configstatus');
	dropmes = document.getElementById('rbfstatus');


	// 初期化 
	btnconn.addEventListener('click', connectPort, false);
	btnscan.addEventListener('click', portarea_set, false);
	btnfile.addEventListener('change', handleFileSelect, false);
	droparea_set();
	portarea_set();
}


// PERIDOTボードの接続と切断 
var onConnect = false;

function connectPort() {
	if (!onConnect) {
		var selectedPort = select.childNodes[select.selectedIndex].value;
		portarea_set("WAITING");
		confmes.innerHTML = "通信ポートを開いています...";

		testps.open(selectedPort, function (result) { if (result) {
			var rbf = new rbfwriter_rbf();
			confmes.innerHTML = "PERIDOTボードをコンフィグレーションしています...";

			testps.config(0, rbf, function (result) { if (result) {
				qsys_init(testps, function (result) { if (result) {
					onConnect = true;
					portarea_set("READY");
					confmes.innerHTML = "PERIDOTボードに接続しました";
					droparea_set("ON");
					dropmes.innerHTML = "RBFファイルをここにドロップしてください";

				} else {
					testps.close(function () {
					portarea_set("ERROR");
					confmes.innerHTML = "PERIDOTボードとの通信ができません";
					});

				} });
			} else {
				testps.reset(function (result, respbyte) {
					if (result && (respbyte & (1<<0))!= 0) {
						testps.close(function () {
						portarea_set("ERROR");
						confmes.innerHTML = "スイッチをPS側に切り替えてください";
						});

					} else {
						testps.close(function () {
						portarea_set("ERROR");
						confmes.innerHTML = "PERIDOTボードがコンフィグレーションできません";
						});
					}
				});
			} });
		} else {
			portarea_set("ERROR");
			confmes.innerHTML = "PERIDOTボードに接続できません";
		} });

	} else {
		testps.close(function () {
		onConnect = false;
		portarea_set("CLOSE");
		droparea_set();
		});
	}
}


// シリアルポートエリアの有効化・無効化 
function portarea_set(flag) {
	var wicon = document.getElementById('waitingicon');

	// シリアルポートの取得 
	var rescanport = function() {
		btnscan.disabled = true;

		chrome.serial.getDevices(function (ports) {
			// エレメントを全て削除 
			while(select.firstChild) select.removeChild(select.firstChild);

			// スキャン結果を追加 
			for (var i=0; i<ports.length; i++) {
				var port = ports[i].path;
				select.appendChild(new Option(port, port));
			}

			// 選択できるポートがあるか 
			if (select.firstChild) {
				btnconn.disabled = false;
			} else {
				btnconn.disabled = true;
			}

			btnscan.disabled = false;
		});
	};

	// 各オブジェクトの状態を変更 
	switch(flag) {
	case "READY" :
		select.disabled = true;
		btnscan.disabled = true;
		btnconn.disabled = false;
		btnconn.value="切断";
		wicon.src="img/icon_ok_24x24.png";
		break;

	case "CLOSE" :
		select.disabled = false;
		btnscan.disabled = false;
		btnconn.disabled = false;
		btnconn.value="接続";
		wicon.src="img/dummy_1x1.png";
		confmes.innerHTML = "";
		break;

	case "ERROR" :
		select.disabled = false;
		btnscan.disabled = false;
		btnconn.disabled = false;
		btnconn.value="接続";
		wicon.src="img/close03-001-24.png";
		break;

	case "WAITING" :
		select.disabled = true;
		btnscan.disabled = true;
		btnconn.disabled = true;
		wicon.src="img/loading02_r2_c4.gif";
		break;

	case "PAUSE" :
		select.disabled = true;
		btnscan.disabled = true;
		btnconn.disabled = true;
		break;

	case "RESTART" :
		btnconn.disabled = false;
		if (!onConnect) {
			select.disabled = false;
			btnscan.disabled = false;
		}
		break;

	default :
		if (!onConnect) {
			btnconn.value = "接続";
			rescanport();
		}
		break;
	}
}


// ドロップエリアの有効化・無効化 
function droparea_set(flag) {
	var droparea = document.getElementById('droparea');
	var dropicon = document.getElementById('icicon');

	switch(flag) {
	case "ON" :
		// ドロップエリアを有効化 
		droparea.style.background = "#ffffff";
		dropicon.style.opacity = "1.0";
		dropmes.style.color = "#000";
		btnfile.disabled = false;
		break;

	case "LOADING" :
		// ファイル処理中 
		dropicon.src = "img/ic_loading_80x80.gif";
		btnfile.disabled = true;
		portarea_set("PAUSE");
		break;

	case "DONE" :
		// 処理完了 
		dropicon.src = "img/ic_full_80x80.png";
		btnfile.disabled = false;
		btnfile.value = "";
		portarea_set("RESTART");
		break;

	case "ERROR" :
		// 処理エラー 
		dropicon.src = "img/ic_error_80x80.png";
		btnfile.disabled = false;
		btnfile.value = "";
		portarea_set("RESTART");
		progress_set();
		break;

	default :
		// ドロップエリア初期状態 
		droparea.style.background = "#eeeeee";
		dropicon.src = "img/ic_empty_80x80.png";
		dropicon.style.opacity = "0.2";
		dropmes.style.color = "#ccc";
		btnfile.disabled = true;
		btnfile.value = "";
		progress_set();
		break;
	}
}


// プログレスバーの状態表示 
function progress_set(flag) {
	var pbase  = document.getElementById('pbase');
	var pgauge = document.getElementById('pgauge');


	if (flag === undefined) {
		pgauge.style.width = "0%";
		pbase.style.opacity = "0.2";

	} else {
		var pcent = flag*100;
		if (pcent > 100) pcent = 100; else if(pcent < 0) pcent = 0;

		pgauge.style.width = pcent.toString() + "%";
		pbase.style.opacity = "1.0";
	}
}


// RBFファイルの書き込み 
function writeepcs(rbfdata, callback) {
	var dev = testps;

	var rbfdata_arr = new Uint8Array(rbfdata);

	var writedata = new ArrayBuffer(512*1024+256);
	var writedata_arr = new Uint8Array(writedata);

	var status_base_addr  = 0x00000000;
	var rbfdata_base_addr = 0x00000100;
	var nios2_resetrequest_address	= (0x0fff0000 >>> 0);

	var _waitstart = function(callback) {
		dev.avm.iord(status_base_addr, 0, function(result, status) {
			if (result) {
				if ((status & (1<<31)) != 0) {
					setTimeout(function() { _waitstart(callback); }, 100);
				} else {
					callback(true);
				}
			} else {
				callback(false);
			}
		});
	};

	var _waitdone = function(callback) {
		dev.avm.iord(status_base_addr, 0, function(result, status) {
			if (result) {
				var loop = true;
				var res = false;

				switch(status & 0x70000000) {
				case 0x70000000 :		// 正常終了 
					progress_set(1);
					loop = false;
					res = true;
					dropmes.innerHTML = "書き込み完了しました";
					console.log("epcs : data write done.");
					break;

				case 0x20000000 :		// 書き込みエラー発生 
					loop = false;
					res = false;
					dropmes.innerHTML = "書き込みエラーが発生しました (error 60)";
					console.log("epcs : [!] data write failed.");
					break;

				case 0x30000000 :		// ベリファイエラー発生 
					loop = false;
					res = false;
					dropmes.innerHTML = "ベリファイエラーが発生しました (error 61)";
					console.log("epcs : [!] data verify failed.");
					break;

				case 0x00000000 :		// 書き込み中 
					var prog = (status &(0x0fffffff>>>0)) / writedata.byteLength;
					progress_set(0 + (prog * 0.75));
					break;

				case 0x10000000 :		// ベリファイ中 
					var prog = (status &(0x0fffffff>>>0)) / writedata.byteLength;
					progress_set(0.75 + (prog * 0.25));
					break;

				default:
					break;
				}

				if (loop) {
					setTimeout(function() { _waitdone(callback); }, 100);	// 0.1秒毎に更新 
				} else {
					callback(res);
				}
			} else {
				dropmes.innerHTML = "I/Oエラーが発生しました (error 62)";
				callback(false);
			}
		});
	};

	var _abort = function(errorcode) {
		dropmes.innerHTML = "書き込みに失敗しました (error " + errorcode.toString() + ")";
		_exit(false);
	};
	var _exit = function(result) {
		dev.avm.iowr(nios2_resetrequest_address, 0, 1, function(res) {		// NiosIIを停止 
			if (res) {
				console.log("qsys : nios2_resetrequest = enable");
				callback(result);
			} else {
				callback(false);
			}
		});
	};


	// 転送データ作成 
	for(var i=0 ; i<256 ; i++) writedata_arr[i] = 0xff;
	for(var i=0 ; i<rbfdata.byteLength ; i++) writedata_arr[256+i] = rbfdata_arr[i];
	for(var i=256+rbfdata.byteLength ; i<writedata.byteLength ; i++) writedata_arr[i] = 0xff;

	var sum = 0>>>0;	// uint
	for(var i=256 ; i<writedata.byteLength ; i++) sum += writedata_arr[i];
	console.log("epcs : write data sum = 0x" + ("00000000" + sum.toString(16)).slice(-8));


	// データを転送 
	dev.avm.write(status_base_addr, writedata, function(result) { if (result) {
	console.log("epcs : write data " + writedata.byteLength + "bytes sent.");

	// NiosIIの動作を開始 
	dev.avm.iowr(nios2_resetrequest_address, 0, 0, function(result) { if (result) {
	console.log("qsys : nios2_resetrequest = disable");

	progress_set(0);
	dropmes.innerHTML = "コンフィギュレーションを更新しています...";

	// 計算開始待ち 
	_waitstart(function(result) { if (result) {

	// ステータスを読み出す 
	dev.avm.iord(status_base_addr, 1, function(result, epcsid) { if (result) {
	dev.avm.iord(status_base_addr, 2, function(result, datasum) { if (result) {
	console.log("epcs : device id = 0x" + ("00000000" + epcsid.toString(16)).slice(-8));
	console.log("epcs : rbf data sum = 0x" + ("00000000" + datasum.toString(16)).slice(-8));

	// チェックサム照合 
	if (sum == datasum) {

	// 書き込み終了待ち 
	_waitdone(function(result) {
		_exit(result);
	});

	// まとめて例外終了 
	} else { _abort(5); }

	} else { _abort(41); } });
	} else { _abort(40); } });

	} else { _abort(3); } });

	} else { _abort(2); } });

	} else { _abort(1); } });
}


// ファイル読み込み 
function handleFileSelect(evt) {
	var romdata;
	var rbf = evt.target.files[0];

	if (rbf == null) {
		console.log("romdata : [!] rbf file not selected.");
		return;
	}

	var fext = rbf.name.slice(-3).toLowerCase();
	if ( !(fext == "rbf" || fext == "rpd") ) {
		console.log("romdata : [!] choose rbf or rpd file.");

		droparea_set("ERROR");
		dropmes.innerHTML = "RBFまたはRPDファイルを指定してください";
		return;
	}

	droparea_set("LOADING");

	var rbfreader = new FileReader();
	rbfreader.onload = function(e) {
		romdata = e.target.result;
		console.log("romdata : rbffile = " + rbf.name + ", " + e.loaded + "bytes loaded.");

		writeepcs(romdata, function(result) {
			if (result) {
				droparea_set("DONE");
			} else {
				droparea_set("ERROR");
			}
		});
	}

	dropmes.innerHTML = "データをチェックしています...";

	rbfreader.readAsArrayBuffer(rbf);		// ファイルの読み込みを開始 
}


// Qsysシステムの初期化 
function qsys_init(canarium_obj, callback) {
	var dev = canarium_obj;

	// ボードIDの読み出し 
//	dev.getinfo( function() {

	// ファーストアクノリッジ設定 
	dev.avm.option({fastAcknowledge:true}, function() {

	// sysIDを読み出す 
	var qsys_systemid_address = (0x10000000 >>> 0);
	dev.avm.iord(qsys_systemid_address, 0, function(result, iddata) { if (result) {
	dev.avm.iord(qsys_systemid_address, 1, function(result, tmdata) { if (result) {

	var sysid_str = "";
	sysid_str = sysid_str + " 0x" + ("00000000" + iddata.toString(16)).slice(-8);
	sysid_str = sysid_str + ", 0x" + ("00000000" + tmdata.toString(16)).slice(-8);
	console.log("qsys : sysid =" + sysid_str);

	callback(true);
	} else { callback(false); } });
	} else { callback(false); } });

	});
//	});
}



// ------------------------------------------------------------------- //
//  PERIDOT Chrome Package Apps Driver - 'Canarium.js'                 //
// ------------------------------------------------------------------- //
//
//  ver 0.9.1
//		2014/06/04	s.osafune@gmail.com
//
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

// API
//	.open(port portname, function callback(bool result));
//	.close(function callback(bool result));
//	.config(obj boardInfo, arraybuffer rbfdata[], function callback(bool result));
//	.reset(function callback(bool result));
//	.avm.read(uint address, int bytenum, function callback(bool result, arraybuffer readdata[]));
//	.avm.write(uint address, arraybuffer writedata[], function callback(bool result));
//	.avm.iord(uint address, int offset, function callback(bool result, uint readdata));
//	.avm.iowr(uint address, int offset, uint writedata, function callback(bool result));
//	.avm.option(object option, function callback(bool result));

var Canarium = function() {
	var self = this;

	//////////////////////////////////////////////////
	//  公開オブジェクト 
	//////////////////////////////////////////////////

	// 接続しているボードの情報 
	// Information of the board that this object is connected
	self.boardInfo = null;
//	{
//		version : 1,
//		manufacturerId : uint16,
//		productId : uint16,
//		serialnumber : uint32
//	};

	// デフォルトのビットレート 
	// The default bitrate
	self.serialBitrate = 115200;


	// API 
	self.open	= function(portname, callback){ devopen(portname, callback); };
	self.close	= function(callback){ devclose(callback); };
	self.config	= function(boardInfo, rbfarraybuf, callback){ devconfig(boardInfo, rbfarraybuf, callback); };
	self.reset	= function(callback){ devreset(callback); };

	self.avm = {
		read	: function(address, readbytenum, callback){ avmread(address, readbytenum, callback); },
		write	: function(address, writedata, callback){ avmwrite(address, writedata, callback); },
		iord	: function(address, offset, callback){ avmiord(address, offset, callback); },
		iowr	: function(address, offset, writedata, callback){ avmiowr(address, offset, writedata, callback); },
		option	: function(option, callback){ avmoption(option, callback); }
	};

	self.i2c = {
		start	: function(callback){ i2cstart(callback); },
		stop	: function(callback){ i2cstop(callback); },
		read	: function(ack, callback){ i2cread(ack, callback); },
		write	: function(writebyte, callback){ i2cwrite(writebyte, callback); }
	};



	//////////////////////////////////////////////////
	//  内部変数およびパラメータ 
	//////////////////////////////////////////////////

	// このオブジェクトが使用する通信オブジェクト 
	// The communication object which this object uses
	var comm = null;

	// このオブジェクトがボードに接続していればtrue 
	// True this object if connected to the board
	var onConnect = false;

	// このオブジェクトが接続しているボードが実行可能状態であればtrue 
	// True board of this object if it is ready to run
	var confrun = false;

	// AvalonMMトランザクションの即時応答オプション 
	// Send Immediate option of the Avalon-MM Transaction
	var avmSendImmediate = false;


	// I2Cバスがタイムアウトしたと判定するまでの試行回数 
	// Number of attempts to determine I2C has timed out
	var i2cTimeoutCycle = 100;

	// FPGAコンフィグレーションがタイムアウトしたと判定するまでの試行回数 
	// Number of attempts to determine FPGA-Configuration has timed out
	var configTimeoutCycle = 100;

	// AvalonMMトランザクションパケットの最大長 
	// The maximum length of the Avalon-MM Transaction packets
	var avmTransactionMaxLength = 32768;



	//////////////////////////////////////////////////
	//  内部メソッド (シリアル入出力群)
	//////////////////////////////////////////////////

	var serialReadbufferMaxLength = 4096;
	var serialReadbufferTimeoutms = 100;

	var serialio = function() {
		var self = this;
		var connectionId = null;


		// シリアル受信リスナ 

		var readbuff = new ringbuffer(serialReadbufferMaxLength);

		var onReceiveCallback = function(info) {
			if (info.connectionId == connectionId) {
				var data_arr = new Uint8Array(info.data);

				for(var i=0 ; i<data_arr.byteLength ; i++) {
					if ( !readbuff.add(data_arr[i]) ) break;
				}
			}
		};


		// シリアルポート接続 

		self.open = function(portname, options, callback) {
			if (connectionId != null) {
				console.log("serial : [!] Serial port is already opened.");
				callback(false);
				return;
			}

			chrome.serial.connect(portname, options, function (openInfo) {
				if (openInfo.connectionId > 0) {
					connectionId = openInfo.connectionId;
					console.log("serial : Open connectionId = " + connectionId + " (" + portname + ", " + options.bitrate + "bps)");

					chrome.serial.onReceive.addListener(onReceiveCallback);
					console.log("serial : Receive listener is started.");

					callback(true);

				} else {
					console.log("serial : [!] " + portname + " is not connectable.");

					callback(false);
				}
			});
		};


		// シリアルポート切断 

		self.close = function(callback) {
			if (connectionId == null) {
				console.log("serial : [!] Serial port is not open.");
				callback(false);
				return;
			}

		    chrome.serial.disconnect(connectionId, function () {
				console.log("serial : Close connectionId = " + connectionId);
				connectionId = null;

				callback(true);
		    });
		};


		// シリアルデータ送信 

		self.write = function(wirtearraybuf, callback) {
			if (connectionId == null) {
				console.log("serial : [!] Serial write port is not open.");
				callback(false);
				return;
			}

		    chrome.serial.send(connectionId, wirtearraybuf, function (writeInfo){
				var leftbytes = wirtearraybuf.byteLength - writeInfo.bytesSent;
				var bool_witten = true;

				if (leftbytes == 0) {
//					console.log("serial : write " + writeInfo.bytesSent + "bytes success.");
				} else {
					bool_witten = false;
					console.log("serial : [!] write " + writeInfo.bytesSent + "bytes written, " + leftbytes + "bytes left.");
				}

				chrome.serial.flush(connectionId, function(){
					callback(bool_witten, writeInfo.bytesSent);
				});
			});
		};


		// シリアルデータ受信 

		self.read = function(bytenum, callback) {
			if (connectionId == null) {
				console.log("serial : [!] Serial read port is not open.");
				callback(false);
				return;
			}

			var readarraybuf = new ArrayBuffer(bytenum);
			var readarraybuf_arr = new Uint8Array(readarraybuf);
			var readarraybuf_num = 0;

			var blobread = function(leftbytes, callback) {
				var datacount = readbuff.getcount();

				if (datacount == 0) {			// バッファが空の場合は次を待つ 
					setTimeout(function(){
						if (readbuff.getcount() == 0) {
							console.log("serial : [!] read is timeout.");
							callback(false, readarraybuf_num, readarraybuf);	// タイムアウト 
						} else {
							blobread(leftbytes, callback);						// リトライ 
						}
					}, serialReadbufferTimeoutms);

				} else {
					if (datacount >= leftbytes) datacount = leftbytes;

					for(var i=0 ; i<datacount ; i++) readarraybuf_arr[readarraybuf_num++] = readbuff.get();
					leftbytes -= datacount;

					if (leftbytes > 0) {
						blobread(leftbytes, callback);
					} else {
//						console.log("serial : read " + readarraybuf_num + "bytes");
						callback(true, readarraybuf_num, readarraybuf);
					}

				}
			};

			blobread(bytenum, callback);
		};
	};


	// リングバッファ 
	// bool rb.add(byte indata)
	// int rb.get()
	// int rb.getcount()

	var ringbuffer = function(bufferlength) {
		var self = this;

		self.overrun = false;		// バッファオーバーランエラー 

		var buffer = new ArrayBuffer(bufferlength);
		var writeindex = 0;
		var readindex = 0;


		// データ書き込み 

		self.add = function(indata) {
			var buff_arr = new Uint8Array(buffer);

			// バッファオーバーランのチェック 
			var nextindex = writeindex + 1;
			if (nextindex >= buff_arr.byteLength) nextindex = 0;

			if (nextindex == readindex) {
				self.overrun = true;
				cosnole.log("serial : [!] Readbuffer overrun.");
				return false;
			}

			// バッファへ書き込み 
			buff_arr[writeindex] = indata;
			writeindex = nextindex;
//			console.log("serial : inqueue 0x" + ("0"+indata.toString(16)).slice(-2));

			return true;
		};


		// データ読み出し 

		self.get = function() {
			if (readindex == writeindex) return null;

			var buff_arr = new Uint8Array(buffer);
			var data = buff_arr[readindex];

			readindex++;
			if (readindex >= buff_arr.byteLength) readindex = 0;

			return data;
		};


		// キューされているデータ数の取得 

		self.getcount = function() {
			var buff_arr = new Uint8Array(buffer);
			var len = writeindex - readindex;

			if (len < 0) len += buff_arr.byteLength;

			return len;
		};
	};



	//////////////////////////////////////////////////
	//  基本メソッド 
	//////////////////////////////////////////////////

	// PERIDOTデバイスポートのオープン 
	//	devopen(port portname, function callback(bool result));

	var devopen = function(portname, callback) {
		if (onConnect) {
			callback(false);		// 既に接続が確立している場合 
			return;
		}

		self.boardInfo = null;
		avmSendImmediate = false;

		comm = new serialio();		// 通信オブジェクトをインスタンス 

		// シリアルポート接続 
		var connect = function() {
			var options = {bitrate:self.serialBitrate};

			comm.open(portname, options, function(result) {
				if (result) {
					onConnect = true;
					confrun = false;
					psconfcheck();
				} else {
					open_exit(false);
				}
			});
		};

		// PERIDOTコンフィグレータ応答のテスト 
		var psconfcheck = function() {
			commandtrans(0x39, function(result, respbyte) {
				if (result) {
					console.log("board : Confirm acknowledge.");
					getboardinfo();					// コマンドに応答があった 
				} else {
					console.log("board : [!] No response.");
					open_exit(false);				// コマンドに応答がなかった 
				}
			});
		};

		// ボード情報の取得 
		var getboardinfo = function() {
			eepromread(function(result, readdata) {
				if (result) {
					var readdata_arr = new Uint8Array(readdata);
					var header = (readdata_arr[0] << 16) | (readdata_arr[1] << 8) | (readdata_arr[2] << 0);

					if (header == 0x4a3757) {		// J7Wのヘッダがある 
						self.boardInfo = {
							version : (readdata_arr[3]),
							manufacturerId : (((readdata_arr[4] << 8) | (readdata_arr[5] << 0))>>> 0),
							productId : (((readdata_arr[6] << 8) | (readdata_arr[7] << 0))>>> 0),
							serialnumber : (((readdata_arr[8] << 24) | (readdata_arr[9] << 16) |
											(readdata_arr[10] << 8)|(readdata_arr[11] << 0))>>> 0)
						};
					} else {
						self.boardInfo = {			// J7Wのヘッダが見つからない 
							version : 1,
							manufacturerId : (0xffff >>> 0),
							productId : (0xffff >>> 0),
							serialnumber : (0xffffffff >>> 0)
						};
					}

					open_exit(true);
				} else {
					self.boardInfo = {				// EEPROMが見つからない 
						version : 1,
						manufacturerId : 0x0000,
						productId : 0x0000,
						serialnumber : 0x00000000
					};

					open_exit(true);
				}
			});
		};

		connect();

		var open_exit = function(result) {
			if (result) {
				console.log("board : version = " + self.boardInfo.version + "\n" + 
							"        manufacturer ID = 0x" + ("0000"+self.boardInfo.manufacturerId.toString(16)).slice(-4) + "\n" +
							"        product ID = 0x" + ("0000"+self.boardInfo.productId.toString(16)).slice(-4) + "\n" +
							"        serial number = 0x" + ("00000000"+self.boardInfo.serialnumber.toString(16)).slice(-8)
				);

				callback(true);
			} else {
				if (onConnect) {
					self.close(function() {
						callback(false);
					});
				} else {
					callback(false);
				}
			}
		};
	};


	// PERIDOTデバイスポートのクローズ 
	//	devclose(function callback(bool result));

	var devclose = function(callback) {
		if (!onConnect) {
			callback(false);		// 接続が確立していない場合 
			return;
		}

		comm.close(function(result) {
			onConnect = false;
			confrun = false;
			self.boardInfo = null;
			comm = null;

			callback(true);
		});
	};


	// ボードのFPGAコンフィグレーション 
	//	devconfig(obj boardInfo, arraybuffer rbfdata[],
	//						function callback(bool result));

	var configBarrier = false;
	var devconfig = function(boardInfo, rbfarraybuf, callback) {

		///// コンフィグシーケンス完了まで再実行を阻止する /////

		if (!onConnect || !rbfarraybuf || configBarrier || mresetBarrier) {
			callback(false);
			return;
		}

		configBarrier = true;


		///// バイトエスケープ処理 /////

		var rbfescape = new Array();
		var rbfarraybuf_arr = new Uint8Array(rbfarraybuf);
		var escape_num = 0;

		for(var i=0 ; i<rbfarraybuf.byteLength ; i++) {
			if (rbfarraybuf_arr[i] == 0x3a || rbfarraybuf_arr[i] == 0x3d) {
				rbfescape.push(0x3d);
				rbfescape.push(rbfarraybuf_arr[i] ^ 0x20);
				escape_num++;
			} else {
				rbfescape.push(rbfarraybuf_arr[i]);
			}
		}

		var rbfescapebuf = new ArrayBuffer(rbfescape.length);
		var rbfescapebuf_arr = new Uint8Array(rbfescapebuf);
		var checksum = 0;

		for(var i=0 ; i<rbfescape.length ; i++) {
			rbfescapebuf_arr[i] = rbfescape[i];
			checksum = (checksum + rbfescapebuf_arr[i]) & 0xff;
		}

		console.log("config : " + escape_num + " places were escaped. config data size = " + rbfescapebuf.byteLength + "bytes");


		///// FPGAコンフィグレーションシーケンサ /////

		var sendretry = 0;		// タイムアウトカウンタ 

		// FPGAのコンフィグレーション開始処理 
		var setup = function() {
			commandtrans(0x39, function (result, respbyte) {
				if (result) {
					if ((respbyte & 0x01)== 0x00) {		// PSモード 
						console.log("config : configuration is started.");
						sendretry = 0;
						sendinit();
					} else {
						console.log("config : [!] Setting is not in the PS mode.");
						errorabort();
					}
				} else {
					errorabort();
				}
			});
		};

		// コンフィグレーション開始リクエスト発行 
		var sendinit = function() {
			commandtrans(0x30, function (result, respbyte) {	// コンフィグモード、nCONFIGアサート 
				if (result || sendretry < configTimeoutCycle) {
					if ((respbyte & 0x06)== 0x00) {		// nSTATUS = L, CONF_DONE = L
						sendretry = 0;
						sendready();
					} else {
						sendretry++;
						sendinit();
					}
				} else {
					console.log("config : [!] nCONFIG request is timeout.");
					errorabort();
				}
			});
		};

		// FPGAからの応答を待つ 
		var sendready = function() {
			commandtrans(0x31, function (result, respbyte) {	// コンフィグモード、nCONFIGネゲート 
				if (result || sendretry < configTimeoutCycle) {
					if ((respbyte & 0x06)== 0x02) {		// nSTATUS = H, CONF_DONE = L
						sendretry = 0;
						sendrbf();
					} else {
						sendretry++;
						sendready();
					}
				} else {
					console.log("config : [!] nSTATUS response is timeout.");
					errorabort();
				}
			});
		};

		// コンフィグファイル送信 
		var sendrbf = function() {
			comm.write(rbfescapebuf, function (result, bytewritten) {
				if (result) {
					console.log("config : " + bytewritten + "bytes of configuration data was sent.");
					checkstatus();
				} else {
					errorabort();
				}
			});
		};

		// コンフィグ完了チェック 
		var checkstatus = function() {
			commandtrans(0x31, function (result, respbyte) {	// コンフィグモード、ステータスチェック 
				if (result) {
					if ((respbyte & 0x06)== 0x06) {		// nSTATUS = H, CONF_DONE = H
						switchuser();
					} else {
						errordone();
					}
				} else {
					errorabort();
				}
			});
		};

		// コンフィグ完了 
		var switchuser = function() {
			commandtrans(0x39, function (result, respbyte) {	// ユーザーモード 
				if (result) {
					console.log("config : configuration completion.");
					confrun = true;
					config_exit(true);
				} else {
					errorabort();
				}
			});
		};

		// 通信エラー 
		var errorabort = function() {
			console.log("config : [!] communication error abort.");
			config_exit(false);
		};

		// コンフィグエラー 
		var errordone = function() {
			console.log("config : [!] configuration error.");
			config_exit(false);
		};


		///// コンフィグレーションの実行 /////

		confrun = false;
		setup();

		var config_exit = function(result) {
			configBarrier = false;
			callback(result);
		};
	};


	// ボードのマニュアルリセット 
	//	devreset(function callback(bool result));

	var mresetBarrier = false;
	var devreset = function(callback) {
		if (!onConnect || !confrun || mresetBarrier) {
			callback(false);
			return;
		}

		mresetBarrier = true;

		var resetassert = function() {
			commandtrans(0x31, function (result, respbyte) {
				if (result) {
					setTimeout(function(){ resetnegate(); }, 100);	// 100ms後にリセットを解除する 
				} else {
					mreset_exit(false);
				}
			});
		};

		var resetnegate = function() {
			commandtrans(0x39, function (result, respbyte) {
				if (result) {
					console.log("mreset : The issue complete.");
					avmSendImmediate = false;
					reset_exit(true);
				} else {
					reset_exit(false);
				}
			});
		};

		resetassert();

		var reset_exit = function(result) {
			mresetBarrier = false;
			callback(result);
		};
	};



	//////////////////////////////////////////////////
	//  Avalon-MMトランザクションメソッド 
	//////////////////////////////////////////////////

	// AvalonMMオプション設定 
	//	avmoption(object option,
	//					function callback(bool result);

	var avmoption = function(option, callback) {
//		if (!onConnect || !confrun || mresetBarrier) {
		if (!onConnect || mresetBarrier) {
			callback(false);
			return;
		}

		if (option.fastAcknowledge != null) {
			if (option.fastAcknowledge) {
				avmSendImmediate = true;
			} else {
				avmSendImmediate = false;
			}

			var com = 0x39;
			if (avmSendImmediate) com |= 0x02;	// 即時応答モードビット 

			commandtrans(com, function (result, respbyte) {
				if (result) {
					console.log("avm : Set option send immediate is " + avmSendImmediate);
					callback(true);
				} else {
					callback(false);
				}
			});
		}
	};


	// AvalonMMペリフェラルリード(IORD)
	//	avmiord(uint address, int offset,
	//					function callback(bool result, uint readdata));

	var avmiord = function(address, offset, callback) {
		if (!onConnect || !confrun || mresetBarrier) {
			callback(false, null);
			return;
		}

		var regaddr = ((address & 0xfffffffc)>>> 0) + (offset << 2);
		var writepacket = new avmPacket(0x10, 4, regaddr, 0);	// シングルリードパケットを生成 

		avmtrans(writepacket, function (result, readpacket) {
			var res = false;
			var readdata = null;

			if (result) {
				if (readpacket.byteLength == 4) {
					var readpacket_arr = new Uint8Array(readpacket);
					readdata = (
						(readpacket_arr[3] << 24) |
						(readpacket_arr[2] << 16) |
						(readpacket_arr[1] <<  8) |
						(readpacket_arr[0] <<  0) )>>> 0;		// 符号なし32bit整数 
					res = true;

					console.log("avm : iord(0x" + ("00000000"+address.toString(16)).slice(-8) + ", " + offset + ") = 0x" + ("00000000"+readdata.toString(16)).slice(-8));
				}
			}

			callback(res, readdata);
		});
	};


	// AvalonMMペリフェラルライト(IOWR)
	//	avmiowr(uint address, int offset, uint writedata,
	//					function callback(bool result));

	var avmiowr = function(address, offset, writedata, callback) {
		if (!onConnect || !confrun || mresetBarrier) {
			callback(false);
			return;
		}

		var regaddr = ((address & 0xfffffffc)>>> 0) + (offset << 2);
		var writepacket = new avmPacket(0x00, 4, regaddr, 4);	// シングルライトパケットを生成 
		var writepacket_arr = new Uint8Array(writepacket);

		writepacket_arr[8]  = (writedata >>>  0) & 0xff;		// 符号なし32bit整数 
		writepacket_arr[9]  = (writedata >>>  8) & 0xff;
		writepacket_arr[10] = (writedata >>> 16) & 0xff;
		writepacket_arr[11] = (writedata >>> 24) & 0xff;

		avmtrans(writepacket, function (result, readpacket) {
			var res = false;

			if (result) {
				var readpacket_arr = new Uint8Array(readpacket);
				var size = (readpacket_arr[2] << 8) | (readpacket_arr[3] << 0);

				if (readpacket_arr[0] == 0x80 && size == 4) {
					res = true;

					console.log("avm : iowr(0x" + ("00000000"+address.toString(16)).slice(-8) + ", " + offset + ", 0x" + ("00000000"+writedata.toString(16)).slice(-8) + ")");
				}
			}

			callback(res);
		});
	};


	// AvalonMMメモリリード(IORD_DIRECT)
	//	avmread(uint address, int bytenum,
	//					function callback(bool result, arraybuffer readdata[]));

	var avmread = function(address, readbytenum, callback) {
		if (!onConnect || !confrun || mresetBarrier) {
			callback(false, null);
			return;
		}

		var readdata = new ArrayBuffer(readbytenum);
		var readdata_arr = new Uint8Array(readdata);
		var byteoffset = 0;

		var avmread_partial = function(leftbytenum) {
			var bytenum = leftbytenum;
			if (bytenum > avmTransactionMaxLength) bytenum = avmTransactionMaxLength;

			var writepacket = new avmPacket(0x14, bytenum, address+byteoffset, 0);		// インクリメンタルリードパケットを生成 

			avmtrans(writepacket, function (result, readpacket) {
				if (result) {
					if (readpacket.byteLength == bytenum) {
						var readpacket_arr = new Uint8Array(readpacket);

						for(var i=0 ; i<bytenum ; i++) readdata_arr[byteoffset++] = readpacket_arr[i];
						leftbytenum -= bytenum;

						console.log("avm : read " + bytenum + "bytes from address 0x" + ("00000000"+address.toString(16)).slice(-8));

						if (leftbytenum > 0) {
							avmread_partial(leftbytenum);
						} else {
							callback(true, readdata);
						}
					} else {
						callback(false, null);
					}
				} else {
					callback(false, null);
				}
			});
		};

		avmread_partial(readbytenum);
	};


	// AvalonMMメモリライト(IOWR_DIRECT)
	//	avmwrite(uint address, arraybuffer writedata[],
	//					function callback(bool result));

	var avmwrite = function(address, writedata, callback) {
		if (!onConnect || !confrun || mresetBarrier) {
			callback(false, null);
			return;
		}

		var writedata_arr = new Uint8Array(writedata);
		var byteoffset = 0;

		var avmwrite_partial = function(leftbytenum) {
			var bytenum = leftbytenum;
			if (bytenum > avmTransactionMaxLength) bytenum = avmTransactionMaxLength;

			var writepacket = new avmPacket(0x04, bytenum, address+byteoffset, bytenum);	// インクリメンタルライトパケットを生成 
			var writepacket_arr = new Uint8Array(writepacket);

			for(var i=0 ; i<bytenum ; i++) writepacket_arr[8+i] = writedata_arr[byteoffset++];

			avmtrans(writepacket, function (result, readpacket) {
				if (result) {
					var readpacket_arr = new Uint8Array(readpacket);
					var size = (readpacket_arr[2] << 8) | (readpacket_arr[3] << 0);

					if (readpacket_arr[0] == 0x84 && size == bytenum) {
						leftbytenum -= bytenum;

						console.log("avm : written " + bytenum + "bytes to address 0x" + ("00000000"+address.toString(16)).slice(-8));

						if (leftbytenum > 0) {
							avmwrite_partial(leftbytenum);
						} else {
							callback(true);
						}
					} else {
						callback(false);
					}
				} else {
					callback(false);
				}
			});
		};

		avmwrite_partial(writedata.byteLength);
	};



	//////////////////////////////////////////////////
	//  内部メソッド (トランザクションコマンド群)
	//////////////////////////////////////////////////

	// コンフィグレーションコマンドの送受信 
	//	commandtrans(int command, function callback(bool result, int response);
	var commandBarrier = false;
	var commandtrans = function(command, callback) {

		///// コマンド送受信完了まで再実行を阻止する /////

		if (commandBarrier) {
			callback(false, null);
			return;
		}

		commandBarrier = true;


		///// コマンドの生成と送受信 /////

		var send_data = new ArrayBuffer(2);
		var send_data_arr = new Uint8Array(send_data);

		send_data_arr[0] = 0x3a;
		send_data_arr[1] = command & 0xff;
//		console.log("config : send config command = 0x" + ("0"+send_data_arr[1].toString(16)).slice(-2));

		comm.write(send_data, function (result, bytes){
			if (result) {
				comm.read(1, function(result, readnum, readarraybuf) {
					if (result) {
						var resp_data_arr = new Uint8Array(readarraybuf);
						var respbyte = resp_data_arr[0];
//						console.log("config : recieve config response = 0x" + ("0"+respbyte.toString(16)).slice(-2));
						commandtrans_exit(true, respbyte);
					} else {
						commandtrans_exit(false, null);
					}
				});
			} else {
				commandtrans_exit(false, null);
			}
		});

		var commandtrans_exit = function(result, respbyte) {
			commandBarrier = false;
			callback(result, respbyte);
		};
	};


	// AvalonMMトランザクションパケットを作成 
	// arraybuffer avmPacket(int command, uint size, uint address, int datasize);
	var avmPacket = function(command, size, address, datasize) {
		var packet = new ArrayBuffer(8 + datasize);
		var packet_arr = new Uint8Array(packet);

		packet_arr[0] = command & 0xff;
		packet_arr[1] = 0x00;
		packet_arr[2] = (size >>> 8) & 0xff;
		packet_arr[3] = (size >>> 0) & 0xff;
		packet_arr[4] = (address >>> 24) & 0xff;
		packet_arr[5] = (address >>> 16) & 0xff;
		packet_arr[6] = (address >>>  8) & 0xff;
		packet_arr[7] = (address >>>  0) & 0xff;

		return packet;
	};


	// トランザクションパケットの送受信 
	//	avmtrans(arraybuffer writepacket[],
	//						function callback(bool result, arraybuffer readpacket[]));
	var avmBarrier = false;
	var avmtrans = function(writepacket, callback) {

		///// パケット送受信完了まで再実行を阻止する /////

		if (avmBarrier) {
			callback(false, null);
			return;
		}

		avmBarrier = true;


		///// 送信パケット前処理 /////

		var writepacket_arr = new Uint8Array(writepacket);
		var sendarray = new Array();

		sendarray.push(0x7a);		// SOP
		sendarray.push(0x7c);		// CNI
		sendarray.push(0x00);		// Ch.0 (ダミー)

		for(var i=0 ; i<writepacket.byteLength ; i++) {
			// EOPの挿入 
			if (i == writepacket.byteLength-1) sendarray.push(0x7b);	// EOP 

			// Byte to Packet Converter部のバイトエスケープ 
			if (writepacket_arr[i] == 0x7a || writepacket_arr[i] == 0x7b || writepacket_arr[i] == 0x7c || writepacket_arr[i] == 0x7d) {
				sendarray.push(0x7d);
				sendarray.push(writepacket_arr[i] ^ 0x20);

			// PERIDOT Configrator部のバイトエスケープ 
			} else if (writepacket_arr[i] == 0x3a || writepacket_arr[i] == 0x3d) {
				sendarray.push(0x3d);
				sendarray.push(writepacket_arr[i] ^ 0x20);

			// それ以外 
			} else {
				sendarray.push(writepacket_arr[i]);
			}
		}

		var send_data = new ArrayBuffer(sendarray.length);
		var send_data_arr = new Uint8Array(send_data);

		for(var i=0 ; i<sendarray.length ; i++) send_data_arr[i] = sendarray[i];

//		var sendstr = "";
//		for(var i=0 ; i<send_data.byteLength ; i++) sendstr = sendstr + ("0"+send_data_arr[i].toString(16)).slice(-2) + " ";
//		console.log("avm : sending data = " + sendstr);


		///// パケット受信処理 /////

		var resparray = new Array();
		var recvlogarray = new Array();		// ログ用 
		var recvSOP = false;
		var recvEOP = false;
		var recvCNI = false;
		var recvESC = false;

		var avmtrans_recv = function() {
			comm.read(1, function (result, readnum, recvdata) {
				if (result) {
					var recvexit = false;
					var recvdata_arr = new Uint8Array(recvdata);
					var recvbyte = recvdata_arr[0];

					recvlogarray.push(recvbyte);		// 受信データを全てログ(テスト用) 

					// パケットフレームの外側の処理 
					if (!recvSOP) {
						if (recvCNI) {				// CNIの２バイト目の場合は読み捨てる 
							recvCNI = false;
						} else {
							switch(recvbyte) {
							case 0x7a:				// SOPを受信 
								recvSOP = true;
								break;

							case 0x7c:				// CNIを受信 
								recvCNI = true;
								break;
							}
						}

					// パケットフレームの内側の処理 
					} else {
						if (recvCNI) {				// CNIの２バイト目の場合は読み捨てる 
							recvCNI = false;

						} else if (recvESC) {		// ESCの２バイト目の場合はバイト復元して追加 
							recvESC = false;
							resparray.push(recvbyte ^ 0x20);

							if (recvEOP) {			// ESCがEOPの２バイト目だった場合はここで終了 
								recvEOP = false;
								recvSOP = false;
								recvexit = true;
							}

						} else if (recvEOP) {		// EOPの２バイト目の場合の処理 
							if (recvbyte == 0x7d) {		// 後続がバイトエスケープされている場合は続行 
								recvESC = true;
							} else {					// エスケープでなければバイト追加して終了 
								resparray.push(recvbyte);
								recvEOP = false;
								recvSOP = false;
								recvexit = true;
							}

						} else {					// 先行バイトがパケット指示子ではない場合 
							switch(recvbyte) {
							case 0x7a:				// SOP受信 
								break;				// パケット中にはSOPは出現しないのでエラーにすべき？ 

							case 0x7b:				// EOP受信 
								recvEOP = true;
								break;

							case 0x7c:				// CNI受信 
								recvCNI = true;
								break;

							case 0x7d:				// ESC受信 
								recvESC = true;
								break;

							default:				// それ以外はバイト追加  
								resparray.push(recvbyte);
							}
						}
					}

					if (recvexit) {
						// レスポンスパケットの成形 
						var readpacket = new ArrayBuffer(resparray.length);
						var readpacket_arr = new Uint8Array(readpacket);

						for(var i=0 ; i<resparray.length ; i++) readpacket_arr[i] = resparray[i];

//						var recvstr = "";
//						for(var i=0 ; i<recvlogarray.length ; i++) recvstr = recvstr + ("0"+recvlogarray[i].toString(16)).slice(-2) + " ";
//						console.log("avm : received data = " + recvstr);

						avmtrans_exit(true, readpacket);
					} else {
						avmtrans_recv();
					}

				} else {
					// バイトデータの受信に失敗した場合 
					avmtrans_exit(false, null);
				}
			});
		};


		///// パケットの送受信 /////

		comm.write(send_data, function (result, bytes) {
			if (result) {
				avmtrans_recv();
			} else {
				avmtrans_exit(false, null);
			}
		});

		var avmtrans_exit = function(result, readpacket) {
			avmBarrier = false;
			callback(result, readpacket);
		};
	};



	//////////////////////////////////////////////////
	//  内部メソッド (I2Cコマンド群)
	//////////////////////////////////////////////////

	var i2cBarrier = false;

	// 1bitデータを読むサブファンクション (必ずSCL='L'が先行しているものとする) 
	// i2cbitread(function callback(bool result, int readbit));
	var i2cbitread = function(callback) {
		var readbit = 0;
		var timeout = 0;
		var setup = function() {
			commandtrans(0x3b, function(result, respbyte) {		// SDA='Z',SCL='H',即時応答 
				if (result) {
					if ((respbyte & 0x10)== 0x10) {				// SCLが立ち上がったらSDAを読む 
						if ((respbyte & 0x20)== 0x20) readbit = 1;
						change();
					} else {
						if (timeout < i2cTimeoutCycle) {
							timeout++;
							setup();
						} else {
							console.log("i2c : [!] Read condition is timeout.");
							callback(false, null);
						}
					}
				} else {
					callback(false, null);
				}
			});
		};

		var change = function() {
			commandtrans(0x2b, function(result, respbyte) {		// SDA='Z',SCL='L',即時応答 
				if (result) {
					callback(true, readbit);
				} else {
					callback(false, null);
				}
			});
		};

		setup();
	};

	// 1bitデータを書くサブファンクション (必ずSCL='L'が先行しているものとする) 
	// i2cbitwrite(int writebit, function callback(bool result));
	var i2cbitwrite = function(writebit, callback) {
		var setup = function() {
			var com = (writebit << 5) | 0x0b;
			commandtrans(com, function(result, respbyte) {		// SDA=writebit,SCL='L',即時応答 
				if (result) {
					hold();
				} else {
					callback(false);
				}
			});
		};

		var timeout = 0;
		var hold = function() {
			var com = (writebit << 5) | 0x1b;
			commandtrans(com, function(result, respbyte) {		// SDA=writebit,SCL='H',即時応答 
				if (result) {
					if ((respbyte & 0x30) == (com & 0x30)) {	// SCLが立ち上がったら次へ 
						change();
					} else {
						if (timeout < i2cTimeoutCycle) {
							timeout++;
							hold();
						} else {
							console.log("i2c : [!] Write condition is timeout.");
							callback(false);
						}
					}
				} else {
					callback(false);
				}
			});
		};

		var change = function() {
			var com = (writebit << 5) | 0x0b;
			commandtrans(com, function(result, respbyte) {		// SDA=writebit,SCL='L',即時応答 
				if (result) {
					callback(true);
				} else {
					callback(false);
				}
			});
		};

		setup();
	};

	// スタートコンディションの送信 
	// i2cstart(function callback(bool result));
	var i2cstart = function(callback) {
		if (i2cBarrier) {
			callback(false);
			return;
		}

		i2cBarrier = true;

		var timeout = 0;
		var setup = function() {
			commandtrans(0x3b, function(result, respbyte) {		// SDA='H',SCL='H',即時応答 
				if (result) {
					if ((respbyte & 0x30)== 0x30) {
						sendstart();
					} else {
						if (timeout < i2cTimeoutCycle) {
							timeout++;
							setup();
						} else {
							console.log("i2c : [!] Start condition is timeout.");
							i2cstart_exit(false);
						}
					}
				} else {
					i2cstart_exit(false);
				}
			});
		};

		var sendstart = function() {
			commandtrans(0x1b, function(result, respbyte) {		// SDA='L',SCL='H',即時応答 
				if (result) {
					sclassert();
				} else {
					i2cstart_exit(false);
				}
			});
		};

		var sclassert = function() {
			commandtrans(0x0b, function(result, respbyte) {		// SDA='L',SCL='L',即時応答 
				if (result) {
//					console.log("i2c : Start condition.");
					i2cstart_exit(true);
				} else {
					i2cstart_exit(false);
				}
			});
		};

		setup();

		var i2cstart_exit = function(result) {
			i2cBarrier = false;
			callback(result);
		};
	};

	// ストップコンディションの送信 (必ずSCL='L'が先行しているものとする) 
	// i2cstop(function callback(bool result));
	var i2cstop = function(callback) {
		if (i2cBarrier) {
			callback(false);
			return;
		}

		i2cBarrier = true;

		var timeout = 0;
		var setup = function() {
			commandtrans(0x0b, function(result, respbyte) {		// SDA='L',SCL='L',即時応答 
				if (result) {
					sclrelease();
				} else {
					i2cstop_exit(false);
				}
			});
		};

		var sclrelease = function() {
			commandtrans(0x1b, function(result, respbyte) {		// SDA='L',SCL='H',即時応答 
				if (result) {
					if ((respbyte & 0x30)== 0x10) {
						timeout = 0;
						sendstop();
					} else {
						if (timeout < i2cTimeoutCycle) {
							timeout++;
							setup();
						} else {
							console.log("i2c : [!] Stop condition is timeout.");
							i2cstop_exit(false);
						}
					}
				} else {
					i2cstop_exit(false);
				}
			});
		};

		var sendstop = function() {
			var com = 0x39;
			if (avmSendImmediate) com |= 0x02;					// 即時応答モードビット 

			commandtrans(com, function(result, respbyte) {		// SDA='H',SCL='H' 
				if (result) {
					if ((respbyte & 0x30)== 0x30) {
//						console.log("i2c : Stop condition.");
						i2cstop_exit(true);
					} else {
						if (timeout < i2cTimeoutCycle) {
							timeout++;
							sendstop();
						} else {
							console.log("i2c : [!] Stop condition is timeout.");
							i2cstop_exit(false);
						}
					}
				} else {
					i2cstop_exit(false);
				}
			});
		};

		setup();

		var i2cstop_exit = function(result) {
			i2cBarrier = false;
			callback(result);
		};
	};

	// バイトリード (必ずSCL='L'が先行しているものとする) 
	// i2cread(bool ack, function callback(bool result, int readbyte));
	var i2cread = function(ack, callback) {
		if (i2cBarrier) {
			callback(false, null);
			return;
		}

		i2cBarrier = true;

		var bitnum = 0;
		var readbyte = 0x00;

		var byteread = function() {
			i2cbitread(function(result, readbit) {
				if (result) {
					readbyte |= readbit;
	
					if (bitnum < 7) {
						bitnum++;
						readbyte <<= 1;
						byteread();
					} else {
						sendack();
					}
				} else {
					i2cread_exit(false, null);
				}
			});
		};

		var sendack = function() {
			var ackbit = 0;
			if (!ack) ackbit = 1;	// NACK

			i2cbitwrite(ackbit, function(result) {
				if (result) {
//					var str = " ACK";
//					if (!ack) str = " NACK";
//					console.log("i2c : read 0x" + ("0"+readbyte.toString(16)).slice(-2) + str);

					i2cread_exit(true, readbyte);
				} else {
					i2cread_exit(false, null);
				}
			});

		};

		byteread();

		var i2cread_exit = function(result, respbyte) {
			i2cBarrier = false;
			callback(result, respbyte);
		};
	};

	// バイトライト (必ずSCL='L'が先行しているものとする) 
	// i2cwrite(int writebyte, function callback(bool result, bool ack));
	var i2cwrite = function(writebyte, callback) {
		if (i2cBarrier) {
			callback(false);
			return;
		}

		i2cBarrier = true;

		var bitnum = 0;
		var senddata = writebyte;
		var bytewrite = function() {
			var writebit = 0;
			if ((senddata & 0x80)!= 0x00) writebit = 1;

			i2cbitwrite(writebit, function(result) {
				if (result) {
					if (bitnum < 7) {
						bitnum++;
						senddata <<= 1;
						bytewrite();
					} else {
						recvack();
					}
				} else {
					i2cwrite_exit(false, null);
				}
			});
		};

		var recvack = function() {
			i2cbitread(function(result, readbit) {
				if (result) {
					var ack = true;
					if (readbit != 0) ack = false;

//					var str = " ACK";
//					if (!ack) str = " NACK";
//					console.log("i2c : write 0x" + ("0"+writebyte.toString(16)).slice(-2) + str);

					i2cwrite_exit(true, ack);
				} else {
					i2cwrite_exit(false, null);
				}
			});
		};

		bytewrite();

		var i2cwrite_exit = function(result, ack) {
			i2cBarrier = false;
			callback(result, ack);
		};
	};


	// ボードのEEPROMを読み出す 
	// eepromread(function callback(bool result, arraybuffer readdata[]));
	var eepromBarrier = false;
	var eepromread = function(callback) {
		if (eepromBarrier) {
			callback(false, null);
			return;
		}

		eepromBarrier = true;
		var si_backup = avmSendImmediate;
		avmSendImmediate = true;

		var deviceaddr = 0xa0;
		var readdata = new ArrayBuffer(12);
		var readdata_arr = new Uint8Array(readdata);

		var byteread = function(byteaddr, callback) {
			var data = null;

			var start = function() {
				i2cstart(function(result) {
					if (result) {
						devwriteopen();
					} else {
						exit();
					}
				});
			};

			var devwriteopen = function() {
				i2cwrite((deviceaddr | 0), function(result, ack) {
					if (result && ack) {
						setaddr();
					} else {
						console.log("i2c : [!] Device 0x" + ("0"+deviceaddr.toString(16)).slice(-2) + " is not found.");
						devclose();
					}
				});
			};

			var setaddr = function() {
				i2cwrite((byteaddr | 0), function(result, ack) {
					if (result && ack) {
						repstart();
					} else {
						devclose();
					}
				});
			};

			var repstart = function() {
				i2cstart(function(result) {
					if (result) {
						devreadopen();
					} else {
						devclose();
					}
				});
			};

			var devreadopen = function() {
				i2cwrite((deviceaddr | 1), function(result, ack) {
					if (result && ack) {
						readdata();
					} else {
						devclose();
					}
				});
			};

			var readdata = function() {
				i2cread(false, function(result, readbyte) {
					if (result) {
						data = readbyte;
					}
					devclose();
				});
			};

			var devclose = function() {
				i2cstop(function(res) {
					exit();
				});
			};

			var exit = function() {
				if (data != null) {
					callback(true, data);
				} else {
					callback(false, data);
				}
			};

			start();
		};

		var bytenum = 0;
		var idread = function() {
			byteread(bytenum, function(result, data) {
				if (result) {
					readdata_arr[bytenum++] = data;

					if (bytenum < readdata.byteLength) {
						idread();
					} else {
						eepromread_exit(true, readdata);
					}
				} else {
					eepromread_exit(false, null);
				}
			});
		};

		idread();

		var eepromread_exit = function(result, databuf) {
			eepromBarrier = false;
			avmSendImmediate = si_backup;
			callback(result, databuf);
		};
	}
}


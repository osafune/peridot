// ***************************************************************************** //
// PERIDOT Chrome Apps driver - 'Canarium' (version 0.9.8)                       //
// Copyright (C) 2016 @kimu_shu and @s_osafune                                   //
// ----------------------------------------------------------------------------- //
// Additional part of Canarium (since version 0.9.7) is distributed under the    //
// following license:                                                            //
//                                                                               //
// The MIT License (MIT)                                                         //
//                                                                               //
// Copyright (c) 2016 Shuta Kimura (@kimu_shu)                                   //
//                                                                               //
// Permission is hereby granted, free of charge, to any person obtaining a copy  //
// of this software and associated documentation files (the "Software"), to deal //
// in the Software without restriction, including without limitation the rights  //
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell     //
// copies of the Software, and to permit persons to whom the Software is         //
// furnished to do so, subject to the following conditions:                      //
//                                                                               //
// The above copyright notice and this permission notice shall be included in    //
// all copies or substantial portions of the Software.                           //
//                                                                               //
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    //
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,      //
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE   //
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        //
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, //
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN     //
// THE SOFTWARE.                                                                 //
// ----------------------------------------------------------------------------- //
// The original version of Canarium (below version 0.9.6) is written by          //
// @s_osafune and distributed under the following license:                       //
//                                                                               //
//     Copyright (C) 2014, J-7SYSTEM Works.  All rights Reserved.                //
//                                                                               //
// * This module is a free sourcecode and there is NO WARRANTY.                  //
// * No restriction on use. You can use, modify and redistribute it for          //
//   personal, non-profit or commercial products UNDER YOUR RESPONSIBILITY.      //
// * Redistributions of source code must retain the above copyright notice.      //
//                                                                               //
//         PERIDOT Project - https://github.com/osafune/peridot                  //
// ***************************************************************************** //
/*
canarium.jsの先頭に配置されるスクリプト。
共通関数定義を行う。
 */

(function() {
  var Canarium, IS_CHROME, IS_NODEJS, Promise, TimeLimit, finallyPromise, getCurrentTime, hexDump, invokeCallback, oldProperty, tryPromise, waitPromise;

  if (false) {
    Uint8Array.prototype.hexDump = function() {
      return hexDump(this);
    };
  }


  /*
  @private
  @property {boolean}
    Chromeかどうかの判定
   */

  IS_CHROME = ((typeof chrome !== "undefined" && chrome !== null ? chrome.runtime : void 0) != null);


  /*
  @private
  @property {boolean}
    Node.jsかどうかの判定
   */

  IS_NODEJS = !IS_CHROME && (typeof process !== "undefined" && process !== null) && (typeof require !== "undefined" && require !== null);


  /*
  @private
  @property {Function}
    Promiseクラス
   */

  if (IS_CHROME) {
    Promise = window.Promise;
  } else if (IS_NODEJS) {
    Promise = require("es6-promise").Promise;
  }

  oldProperty = Function.prototype.property;


  /*
  @private
  @method
    Object.definePropertyによるプロパティ定義メソッド
  @param {string} prop
    プロパティの名前
  @param {Object} desc
    プロパティのディスクリプタ
   */

  Function.prototype.property = function(prop, desc) {
    return Object.defineProperty(this.prototype, prop, desc);
  };


  /**
  @private
  @method
    16進ダンプ表示の文字列に変換
  @param {number/number[]/ArrayBuffer/Uint8Array} data
    変換するデータ
  @param {number} [maxBytes]
    最長バイト数(省略時無制限)
  @return {string}
    変換後の文字列
   */

  hexDump = function(data, maxBytes) {
    var brace, hex, i, len, r;
    brace = true;
    if (typeof data === "number") {
      brace = false;
      data = [data];
    } else if (data instanceof ArrayBuffer) {
      data = new Uint8Array(data);
    } else if (data instanceof Uint8Array) {
      null;
    } else if (data instanceof Array) {
      null;
    } else {
      throw Error("Unsupported data type: " + data);
    }
    len = data.length;
    if (maxBytes != null) {
      len = Math.min(len, maxBytes);
    }
    hex = function(v) {
      return "0x" + (v < 16 ? "0" : "") + ((v != null ? typeof v.toString === "function" ? v.toString(16) : void 0 : void 0) || "??");
    };
    r = ((function() {
      var j, ref, results;
      results = [];
      for (i = j = 0, ref = len; 0 <= ref ? j < ref : j > ref; i = 0 <= ref ? ++j : --j) {
        results.push(hex(data[i]));
      }
      return results;
    })()).join(",");
    if (data.length > len) {
      r += "...";
    }
    if (brace) {
      r = "[" + r + "]";
    }
    return r;
  };


  /**
  @private
  @method
    Promiseオブジェクトからcallbackを呼び出し
  @param {function(boolean,Object)/undefined} callback
    呼び出し先コールバック関数。省略時は引数promiseをそのまま返すだけの動作となる。
    第1引数はPromiseオブジェクトの実行成否(true/false)を示す。
    第2引数はthen節/catch節の引数をそのまま渡す。
  @param {Promise} promise
    実行するPromiseオブジェクト
  @return {undefined/Promise}
    Promiseオブジェクト(callbackがundefinedの場合のみ)
   */

  invokeCallback = function(callback, promise) {
    if (!callback) {
      return promise;
    }
    promise.then(function(value) {
      callback(true, value);
    })["catch"](function(reason) {
      callback(false, reason);
    });
  };


  /**
  @private
  @method
    指定時間待機するPromiseオブジェクトを生成
  @param {number} dulation
    待機時間(ミリ秒単位)
  @param {Object} [value]
    成功時にPromiseValueとして渡されるオブジェクト
  @return {Promise}
    Promiseオブジェクト
   */

  waitPromise = function(dulation, value) {
    return new Promise(function(resolve) {
      return setTimeout((function() {
        return resolve(value);
      }), dulation);
    });
  };


  /**
  @private
  @method
    成功するまで繰り返すPromiseオブジェクトを生成
  @param {number} timeout
    最大待機時間(ミリ秒単位)
  @param {function():Promise} promiser
    繰り返す動作のPromiseを生成する関数
  @param {number} [maxTries]
    最大繰り返し回数(省略時：無制限)
  @return {Promise}
    生成されたPromiseオブジェクト
   */

  tryPromise = function(timeout, promiser, maxTries) {
    var count;
    count = 0;
    return new Promise(function(resolve, reject) {
      var lastReason, next;
      lastReason = void 0;
      next = function() {
        return promiser().then(function(value) {
          return resolve(value);
        }, function(reason) {
          lastReason = reason;
          count++;
          if ((maxTries != null) && count >= maxTries) {
            return reject(lastReason);
          }
          return setTimeout(function() {
            return typeof next === "function" ? next() : void 0;
          }, 0);
        });
      };
      setTimeout(function() {
        next = null;
        return reject(lastReason || Error("Operation timed out after " + count + " tries"));
      }, timeout);
      return next();
    });
  };


  /**
  @private
  @method
    Promiseの成功失敗にかかわらず実行する関数のペアを生成
  @return {Function[]}
    成功(fulfilled)と失敗(rejected)の関数ペア。
    promise.then(finallyPromise(-> 中身)...) として用いる。...を忘れないこと。
   */

  finallyPromise = function(action) {
    return [
      function(value) {
        action();
        return value;
      }, function(error) {
        action();
        return Promise.reject(error);
      }
    ];
  };


  /**
  @private
  @method
    パフォーマンス計測用の現在時刻取得(ミリ秒単位)
  @return {number}
    時刻情報
   */

  getCurrentTime = IS_CHROME ? (function() {
    return window.performance.now();
  }) : IS_NODEJS ? (function() {
    var t;
    t = process.hrtime();
    return Math.round(t[0] * 1000000 + t[1] / 1000) / 1000;
  }) : void 0;


  /**
  @private
  @class TimeLimit
    タイムアウト検出クラス
   */

  TimeLimit = (function() {

    /**
    @method constructor
      コンストラクタ
    @param {number} timeout
      タイムアウト時間(ms)
     */
    function TimeLimit(timeout1) {
      this.timeout = timeout1;
      this.start = this.now;
      return;
    }


    /**
    @property {number} now
      現在時刻(残り時間ではない)
    @readonly
     */

    TimeLimit.property("now", {
      get: getCurrentTime
    });


    /**
    @property {number} left
      残り時間(ms)
    @readonly
     */

    TimeLimit.property("left", {
      get: function() {
        return Math.max(0, this.timeout - parseInt(this.now - this.start));
      }
    });

    return TimeLimit;

  })();


  /**
  @class Canarium
    PERIDOTボードドライバ
   */

  Canarium = (function() {
    var AVM_CHANNEL, CONFIG_TIMEOUT_MS, EEPROM_SLAVE_ADDR, SPLIT_EEPROM_BURST;

    null;


    /**
    @property {string} version
      ライブラリのバージョン
     */

    Canarium.property("version", {
      value: "0.9.8"
    });


    /**
    @property {Object}  boardInfo
      接続しているボードの情報
    
    @property {string}  boardInfo.id
      'J72A' (J-7SYSTEM Works / PERIDOT board)
    
    @property {string}  boardInfo.serialcode
      'xxxxxx-yyyyyy-zzzzzz'
     */

    Canarium.property("boardInfo", {
      get: function() {
        return this._boardInfo;
      }
    });


    /**
    @property {number} serialBitrate
      デフォルトのビットレート({@link Canarium.BaseComm#bitrate}のアクセサとして定義)
     */

    Canarium.property("serialBitrate", {
      get: function() {
        return this._base.bitrate;
      },
      set: function(v) {
        return this._base.bitrate = v;
      }
    });


    /**
    @property {boolean} connected
      接続状態({@link Canarium.BaseComm#connected}のアクセサとして定義)
    
      - true: 接続済み
      - false: 未接続
    @readonly
     */

    Canarium.property("connected", {
      get: function() {
        return this._base.connected;
      }
    });


    /*
    @property {Canarium.Channel[]} channels
      チャネル[0～255]
    @readonly
     */

    Canarium.property("channels", {
      get: function() {
        return this._channels;
      }
    });


    /**
    @property {Canarium.I2CComm} i2c
      I2C通信制御クラスのインスタンス
    @readonly
     */

    Canarium.property("i2c", {
      get: function() {
        return this._i2c;
      }
    });


    /**
    @property {Canarium.AvsPackets} avs
      Avalon-STパケット層通信クラスのインスタンス
    @readonly
     */

    Canarium.property("avs", {
      get: function() {
        return this._avs;
      }
    });


    /**
    @property {Canarium.AvmTransactions} avm
      Avalon-MMトランザクション層通信クラスのインスタンス
    @readonly
     */

    Canarium.property("avm", {
      get: function() {
        return this._avm;
      }
    });


    /**
    @property {function()} onClosed
    @inheritdoc Canarium.BaseComm#onClosed
     */

    Canarium.property("onClosed", {
      get: function() {
        return this._base.onClosed;
      },
      set: function(v) {
        return this._base.onClosed = v;
      }
    });


    /**
    @static
    @property {number}
      デバッグ出力の細かさ(0で出力無し)
     */

    Canarium.verbosity = 0;


    /**
    @private
    @property {Canarium.BaseComm} _base
      下位層通信クラスのインスタンス
     */


    /**
    @private
    @property {boolean} _configBarrier
      コンフィグレーション中を示すフラグ(再帰実行禁止用)
     */


    /**
    @private
    @property {boolean} _resetBarrier
      リセット中を示すフラグ(再帰実行禁止用)
     */


    /**
    @private
    @static
    @cfg {number}
      EEPROMのスレーブアドレス(7-bit表記)
    @readonly
     */

    EEPROM_SLAVE_ADDR = 0x50;


    /**
    @private
    @static
    @cfg {number}
      EEPROMの最大バーストリード長(バイト数)
    @readonly
     */

    SPLIT_EEPROM_BURST = 6;


    /**
    @private
    @static
    @cfg {number}
      コンフィグレーション開始のタイムアウト時間(ms)
    @readonly
     */

    CONFIG_TIMEOUT_MS = 3000;


    /**
    @private
    @static
    @cfg {number}
      Avalon-MM 通信レイヤのチャネル番号
    @readonly
     */

    AVM_CHANNEL = 0;


    /**
    @static
    @method
      接続対象デバイスを列挙する
      (PERIDOTでないデバイスも列挙される可能性があることに注意)
    @param {function(boolean,Object[]/Error)} [callback]
      コールバック関数(省略時は戻り値としてPromiseオブジェクトを返す)
    @return {undefined/Promise}
      戻り値なし(callback指定時)、または、Promiseオブジェクト
    @return {Object[]} return.PromiseValue
      デバイスの配列(各要素は次のメンバを持つ)
    
      - name : UI向け名称(COMxxなど)
      - path : 内部管理向けパス
     */

    Canarium.enumerate = function(callback) {
      if (callback != null) {
        return invokeCallback(callback, this.enumerate());
      }
      return Canarium.BaseComm.enumerate();
    };


    /**
    @method constructor
      コンストラクタ
     */

    function Canarium() {
      this._boardInfo = null;
      this._channels = null;
      this._base = new Canarium.BaseComm();
      this._i2c = new Canarium.I2CComm(this._base);
      this._avs = new Canarium.AvsPackets(this._base);
      this._avm = new Canarium.AvmTransactions(this._avs, AVM_CHANNEL);
      this._configBarrier = false;
      this._resetBarrier = false;
      return;
    }


    /**
    @method
      ボードに接続する
    @param {string} path
      接続先パス(enumerateが返すpath)
    @param {function(boolean,Error=)} [callback]
      コールバック関数(省略時は戻り値としてPromiseオブジェクトを返す)
    @return {undefined/Promise}
      戻り値なし(callback指定時)、または、Promiseオブジェクト(callback省略時)
     */

    Canarium.prototype.open = function(portname, callback) {
      if (callback != null) {
        return invokeCallback(callback, this.open(portname));
      }
      return Promise.resolve().then((function(_this) {
        return function() {
          return _this._base.connect(portname);
        };
      })(this)).then((function(_this) {
        return function() {
          return Promise.resolve().then(function() {
            _this._boardInfo = null;
            return _this._eepromRead(0x00, 4);
          }).then(function(readData) {
            var header;
            header = new Uint8Array(readData);
            if (!(header[0] === 0x4a && header[1] === 0x37 && header[2] === 0x57)) {
              return Promise.reject(Error("EEPROM header is invalid"));
            }
            _this._log(1, "open", "done(version=" + (hexDump(header[3])) + ")");
            _this._boardInfo = {
              version: header[3]
            };
            return _this._base.transCommand(0x39);
          }).then(function(response) {
            return _this._base.option({
              forceConfigured: (response & 0x01) !== 0
            });
          }).then(function() {})["catch"](function(error) {
            return _this._base.disconnect()["catch"](function() {}).then(function() {
              return Promise.reject(error);
            });
          });
        };
      })(this));
    };


    /**
    @method
      PERIDOTデバイスポートのクローズ
    @param {function(boolean,Error=)} [callback]
      コールバック関数(省略時は戻り値としてPromiseオブジェクトを返す)
    @return {undefined/Promise}
      戻り値なし(callback指定時)、または、Promiseオブジェクト(callback省略時)
     */

    Canarium.prototype.close = function(callback) {
      if (callback != null) {
        return invokeCallback(callback, this.close());
      }
      return Promise.resolve().then((function(_this) {
        return function() {
          return _this._base.disconnect();
        };
      })(this)).then((function(_this) {
        return function() {
          _this._boardInfo = null;
        };
      })(this));
    };


    /**
    @method
      ボードのFPGAコンフィグレーション
    @param {Object/null}  boardInfo
      ボード情報(ボードIDやシリアル番号を限定したい場合)
    @param {string/null}  boardInfo.id
      ボードID
    @param {string/null}  boardInfo.serialCode
      シリアル番号
    @param {ArrayBuffer}  rbfdata
      rbfまたはrpdのデータ
    @param {function(boolean,Error=)} [callback]
      コールバック関数(省略時は戻り値としてPromiseオブジェクトを返す)
    @return {undefined/Promise}
      戻り値なし(callback指定時)、または、Promiseオブジェクト(callback省略時)
     */

    Canarium.prototype.config = function(boardInfo, rbfdata, callback) {
      var ref, timeLimit;
      if (callback != null) {
        return invokeCallback(callback, this.config(boardInfo, rbfdata));
      }
      if (this._configBarrier) {
        return Promise.reject(Error("Configuration is now in progress"));
      }
      this._configBarrier = true;
      timeLimit = void 0;
      return (ref = Promise.resolve().then((function(_this) {
        return function() {
          return _this._base.assertConnection();
        };
      })(this)).then((function(_this) {
        return function() {
          var ref1, ref2;
          if (!boardInfo || (((ref1 = _this.boardInfo) != null ? ref1.id : void 0) && ((ref2 = _this.boardInfo) != null ? ref2.serialcode : void 0))) {
            return;
          }
          return _this.getinfo();
        };
      })(this)).then((function(_this) {
        return function() {
          var mismatch;
          mismatch = function(a, b) {
            return a && a !== b;
          };
          if (mismatch(boardInfo != null ? boardInfo.id : void 0, _this.boardInfo.id)) {
            return Promise.reject(Error("Board ID mismatch"));
          }
          if (mismatch(boardInfo != null ? boardInfo.serialcode : void 0, _this.boardInfo.serialcode)) {
            return Promise.reject(Error("Board serial code mismatch"));
          }
        };
      })(this)).then((function(_this) {
        return function() {
          return _this._base.transCommand(0x3b);
        };
      })(this)).then((function(_this) {
        return function(response) {
          if ((response & 0x01) !== 0x00) {
            return Promise.reject(Error("Not PS mode"));
          }
        };
      })(this)).then((function(_this) {
        return function() {
          return timeLimit = new TimeLimit(CONFIG_TIMEOUT_MS);
        };
      })(this)).then((function(_this) {
        return function() {
          return tryPromise(timeLimit.left, function() {
            return _this._base.transCommand(0x32).then(function(response) {
              if ((response & 0x06) !== 0x00) {
                return Promise.reject();
              }
            });
          });
        };
      })(this)).then((function(_this) {
        return function() {
          return tryPromise(timeLimit.left, function() {
            return _this._base.transCommand(0x33).then(function(response) {
              if ((response & 0x06) !== 0x02) {
                return Promise.reject();
              }
            });
          });
        };
      })(this)).then((function(_this) {
        return function() {
          return _this._base.transData(rbfdata);
        };
      })(this)).then((function(_this) {
        return function() {
          return _this._base.transCommand(0x33);
        };
      })(this)).then((function(_this) {
        return function(response) {
          if ((response & 0x06) !== 0x06) {
            return Promise.reject(Error("FPGA configuration failed"));
          }
        };
      })(this)).then((function(_this) {
        return function() {
          return _this._base.transCommand(0x39);
        };
      })(this)).then((function(_this) {
        return function() {
          return _this._base.option({
            forceConfigured: true
          });
        };
      })(this)).then((function(_this) {
        return function() {};
      })(this))).then.apply(ref, finallyPromise((function(_this) {
        return function() {
          return _this._configBarrier = false;
        };
      })(this)));
    };


    /**
    @method
      ボードのマニュアルリセット
    @param {function(boolean,number/Error=)} [callback]
      コールバック関数(省略時は戻り値としてPromiseオブジェクトを返す)
    @return {undefined/Promise}
      戻り値なし(callback指定時)、または、Promiseオブジェクト(callback省略時)
    @return {number} return.PromiseValue
      レスポンスコマンド
     */

    Canarium.prototype.reset = function(callback) {
      var ref;
      if (callback != null) {
        return invokeCallback(callback, this.reset());
      }
      if (this._resetBarrier) {
        return Promise.reject(Error("Reset is now in progress"));
      }
      this._resetBarrier = true;
      return (ref = Promise.resolve().then((function(_this) {
        return function() {
          return _this._base.transCommand(0x31);
        };
      })(this)).then((function(_this) {
        return function() {
          return waitPromise(100);
        };
      })(this)).then((function(_this) {
        return function() {
          return _this._base.transCommand(0x39);
        };
      })(this)).then((function(_this) {
        return function(response) {
          return response;
        };
      })(this))).then.apply(ref, finallyPromise((function(_this) {
        return function() {
          return _this._resetBarrier = false;
        };
      })(this)));
    };


    /**
    @method
      ボード情報の取得
    @param {function(boolean,Object/Error=)} [callback]
      コールバック関数(省略時は戻り値としてPromiseオブジェクトを返す)
    @return {undefined/Promise}
      戻り値なし(callback指定時)、または、Promiseオブジェクト(callback省略時)
    @return {Object} return.PromiseValue
      ボード情報
    @return {string} return.PromiseValue.id
      ボードID
    @return {string} return.PromiseValue.serialCode
      シリアル番号
     */

    Canarium.prototype.getinfo = function(callback) {
      if (callback != null) {
        return invokeCallback(callback, this.getinfo());
      }
      return Promise.resolve().then((function(_this) {
        return function() {
          return _this._base.assertConnection();
        };
      })(this)).then((function(_this) {
        return function() {
          var ref;
          switch ((ref = _this._boardInfo) != null ? ref.version : void 0) {
            case void 0:
              return Promise.reject(Error("Boardinfo not loaded"));
            case 1:
              return _this._eepromRead(0x04, 8).then(function(readData) {
                var info, mid, pid, s, sid;
                info = new Uint8Array(readData);
                _this._log(1, "getinfo", "ver1", info);
                mid = (info[0] << 8) | (info[1] << 0);
                pid = (info[2] << 8) | (info[3] << 0);
                sid = (info[4] << 24) | (info[5] << 16) | (info[6] << 8) | (info[7] << 0);
                if (mid === 0x0072) {
                  s = "" + (pid.hex(4)) + (sid.hex(8));
                  _this._boardInfo.id = "J72A";
                  return _this._boardInfo.serialcode = (s.substr(0, 6)) + "-" + (s.substr(6, 6)) + "-000000";
                }
              });
            case 2:
              return _this._eepromRead(0x04, 22).then(function(readData) {
                var bid, i, info, j, l, s;
                info = new Uint8Array(readData);
                _this._log(1, "getinfo", "ver2", info);
                bid = "";
                for (i = j = 0; j < 4; i = ++j) {
                  bid += String.fromCharCode(info[i]);
                }
                s = "";
                for (i = l = 4; l < 22; i = ++l) {
                  s += String.fromCharCode(info[i]);
                }
                _this._boardInfo.id = "" + bid;
                return _this._boardInfo.serialcode = (s.substr(0, 6)) + "-" + (s.substr(6, 6)) + "-" + (s.substr(12, 6));
              });
            default:
              return Promise.reject(Error("Unknown boardinfo version"));
          }
        };
      })(this)).then((function(_this) {
        return function() {
          return _this.boardInfo;
        };
      })(this));
    };


    /**
    @private
    @method
      EEPROMの読み出し
    @param {number} startaddr
      読み出し開始アドレス
    @param {number} readbytes
      読み出しバイト数
    @return {Promise}
      Promiseオブジェクト
    @return {ArrayBuffer} return.PromiseValue
      読み出し結果
     */

    Canarium.prototype._eepromRead = function(startaddr, readbytes) {
      var array, lastError, x;
      array = new Uint8Array(readbytes);
      if ((SPLIT_EEPROM_BURST != null) && readbytes > SPLIT_EEPROM_BURST) {
        return ((function() {
          var j, ref, ref1, results;
          results = [];
          for (x = j = 0, ref = readbytes, ref1 = SPLIT_EEPROM_BURST; ref1 > 0 ? j < ref : j > ref; x = j += ref1) {
            results.push(x);
          }
          return results;
        })()).reduce((function(_this) {
          return function(sequence, offset) {
            return sequence.then(function() {
              return _this._eepromRead(startaddr + offset, Math.min(SPLIT_EEPROM_BURST, readbytes - offset));
            }).then(function(partialData) {
              array.set(new Uint8Array(partialData), offset);
            });
          };
        })(this), Promise.resolve()).then((function(_this) {
          return function() {
            return array.buffer;
          };
        })(this));
      }
      lastError = null;
      return Promise.resolve().then((function(_this) {
        return function() {
          _this._log(1, "_eepromRead", "begin(addr=" + (hexDump(startaddr)) + ",bytes=" + (hexDump(readbytes)) + ")");
          return _this.i2c.start();
        };
      })(this)).then((function(_this) {
        return function() {
          return _this.i2c.write(EEPROM_SLAVE_ADDR << 1).then(function(ack) {
            if (!ack) {
              return Promise.reject(Error("EEPROM is not found."));
            }
          });
        };
      })(this)).then((function(_this) {
        return function() {
          return _this.i2c.write(startaddr & 0xff).then(function(ack) {
            if (!ack) {
              return Promise.reject(Error("Cannot write address in EEPROM"));
            }
          });
        };
      })(this)).then((function(_this) {
        return function() {
          return _this.i2c.start();
        };
      })(this)).then((function(_this) {
        return function() {
          return _this.i2c.write((EEPROM_SLAVE_ADDR << 1) + 1).then(function(ack) {
            if (!ack) {
              return Promise.reject(Error("EEPROM is not found."));
            }
          });
        };
      })(this)).then((function(_this) {
        return function() {
          var j, lastIndex, results;
          lastIndex = readbytes - 1;
          return (function() {
            results = [];
            for (var j = 0; 0 <= lastIndex ? j <= lastIndex : j >= lastIndex; 0 <= lastIndex ? j++ : j--){ results.push(j); }
            return results;
          }).apply(this).reduce(function(promise, index) {
            return promise.then(function() {
              return _this.i2c.read(index !== lastIndex);
            }).then(function(byte) {
              return array[index] = byte;
            });
          }, Promise.resolve());
        };
      })(this))["catch"]((function(_this) {
        return function(error) {
          lastError = error;
        };
      })(this)).then((function(_this) {
        return function() {
          return _this.i2c.stop();
        };
      })(this)).then((function(_this) {
        return function() {
          if (lastError) {
            return Promise.reject(lastError);
          }
          _this._log(1, "_eepromRead", "end", array);
          return array.buffer;
        };
      })(this));
    };


    /**
    @private
    @static
    @method
      ログの出力(全クラス共通)
    @param {string} cls
      クラス名
    @param {string} func
      関数名
    @param {string} msg
      メッセージ
    @param {Object} [data]
      任意のデータ
    @return {undefined}
     */

    Canarium._log = function(cls, func, msg, data) {
      var obj, out, time;
      if ((typeof SUPPRESS_ALL_LOGS !== "undefined" && SUPPRESS_ALL_LOGS !== null) && SUPPRESS_ALL_LOGS) {
        return;
      }
      time = getCurrentTime().toFixed(3);
      out = (
        obj = {
          time: time
        },
        obj[cls + "#" + func] = msg,
        obj.stack = new Error().stack.split("\n    ").slice(1),
        obj
      );
      if (data) {
        out.data = data;
      }
      console.log(out);
    };


    /**
    @private
    @method
      ログの出力
    @param {number} lvl
      詳細度(0で常に出力。値が大きいほど詳細なメッセージを指す)
    @param {string} func
      関数名
    @param {string} msg
      メッセージ
    @param {Object} [data]
      任意のデータ
    @return {undefined}
     */

    Canarium.prototype._log = function(lvl, func, msg, data) {
      if (this.constructor.verbosity >= lvl) {
        Canarium._log("Canarium", func, msg, data);
      }
    };

    return Canarium;

  })();


  /**
  @class Canarium.BaseComm
    PERIDOTボード下位層通信クラス
  @uses Canarium.BaseComm.SerialWrapper
   */

  Canarium.BaseComm = (function() {
    var SERIAL_TX_MAX_LENGTH, SUCCESSIVE_TX_WAIT_MS;

    null;


    /**
    @property {boolean} connected
      接続状態
    
      - true: 接続済み
      - false: 未接続
    @readonly
     */

    BaseComm.property("connected", {
      get: function() {
        return this._connection != null;
      }
    });


    /**
    @property {string} path
      接続しているシリアル通信デバイスのパス
    @readonly
     */

    BaseComm.property("path", {
      get: function() {
        return "" + this._path;
      }
    });


    /**
    @property {number} bitrate
      ビットレート(bps)
     */

    BaseComm.property("bitrate", {
      get: function() {
        return this._bitrate;
      },
      set: function(v) {
        return this._bitrate = parseInt(v);
      }
    });


    /**
    @property {boolean} sendImmediate
      即時応答ビットを立てるかどうか
    @readonly
     */

    BaseComm.property("sendImmediate", {
      get: function() {
        return this._sendImmediate;
      }
    });


    /**
    @property {boolean} configured
      コンフィグレーション済みかどうか
    @readonly
     */

    BaseComm.property("configured", {
      get: function() {
        return this._configured;
      }
    });


    /**
    @property {function()} onClosed
      クローズされた時に呼び出されるコールバック関数
      (明示的にclose()した場合と、ボードが強制切断された場合の両方で呼び出される)
     */

    BaseComm.property("onClosed", {
      get: function() {
        return this._onClosed;
      },
      set: function(v) {
        return this._onClosed = v;
      }
    });


    /**
    @static
    @property {number}
      デバッグ出力の細かさ(0で出力無し)
     */

    BaseComm.verbosity = 0;


    /**
    @private
    @property {Canarium.BaseComm.SerialWrapper} _connection
      シリアル接続クラスのインスタンス
     */


    /**
    @private
    @property {number} _bitrate
    @inheritdoc #bitrate
     */


    /**
    @private
    @property {boolean} _sendImmediate
    @inheritdoc #sendImmediate
     */


    /**
    @private
    @property {boolean} _configured
    @inheritdoc #configured
     */


    /**
    @private
    @property {ArrayBuffer} _rxBuffer
      受信中データ
     */


    /**
    @private
    @property {function(ArrayBuffer=,Error=)} _receiver
      受信処理を行う関数
     */


    /**
    @private
    @static
    @cfg {number}
      1回のシリアル送信の最大バイト数
    @readonly
     */

    SERIAL_TX_MAX_LENGTH = 1024;


    /**
    @private
    @static
    @cfg {number}
      連続シリアル送信の間隔(ミリ秒)
    @readonly
     */

    SUCCESSIVE_TX_WAIT_MS = null;


    /**
    @static
    @method
      接続対象デバイスを列挙する
      (PERIDOTでないデバイスも列挙される可能性があることに注意)
    @return {Promise}
      Promiseオブジェクト
    @return {Object[]} return.PromiseValue
      デバイスの配列(各要素は次のメンバを持つ)
    
      - name : UI向け名称(COMxxなど)
      - path : 内部管理向けパス
     */

    BaseComm.enumerate = function() {
      var getFriendlyName;
      getFriendlyName = function(port) {
        var name, path;
        name = port.manufacturer;
        path = port.path;
        if (name && name !== "") {
          return name + " (" + path + ")";
        }
        return "" + path;
      };
      return BaseComm.SerialWrapper.list().then(function(ports) {
        var devices, j, len1, port;
        devices = [];
        for (j = 0, len1 = ports.length; j < len1; j++) {
          port = ports[j];
          devices.push({
            path: "" + port.path,
            name: getFriendlyName(port)
          });
        }
        return devices;
      });
    };


    /**
    @method constructor
      コンストラクタ
     */

    function BaseComm() {
      this._connection = null;
      this._bitrate = 115200;
      this._sendImmediate = false;
      this._configured = false;
      return;
    }


    /**
    @method
      ボードに接続する
    @param {string} path
      接続先パス(enumerateが返すpath)
    @return {Promise}
      Promiseオブジェクト
     */

    BaseComm.prototype.connect = function(path) {
      if (this._connection != null) {
        return Promise.reject(Error("Already connected"));
      }
      this._connection = new BaseComm.SerialWrapper(path, {
        baudRate: this._bitrate
      });
      this._receiver = null;
      return this._connection.open().then((function(_this) {
        return function() {
          _this._connection.onClosed = function() {
            var base;
            _this._connection = null;
            if (typeof (base = _this._onClosed) === "function") {
              base();
            }
          };
          _this._connection.onReceived = function(data) {
            if (typeof _this._receiver === "function") {
              _this._receiver(data);
            }
          };
        };
      })(this))["catch"]((function(_this) {
        return function(error) {
          _this._connection = null;
          _this._receiver = null;
          return Promise.reject(error);
        };
      })(this));
    };


    /**
    @method
      オプション設定
    @param {Object} option
      オプション
    @param {boolean} option.sendImmediate
      即時応答ビットを有効にするかどうか
    @param {boolean} option.forceConfigured
      コンフィグレーション済みとして扱うかどうか
    @return {Promise}
      Promiseオブジェクト
     */

    BaseComm.prototype.option = function(option) {
      if (this._connection == null) {
        return Promise.reject(Error("Not connected"));
      }
      return Promise.resolve().then((function(_this) {
        return function() {
          var value;
          if ((value = option.fastAcknowledge) == null) {
            return;
          }
          _this._sendImmediate = !!value;
          return _this.transCommand(0x39 | (value ? 0x02 : 0x00));
        };
      })(this)).then((function(_this) {
        return function() {
          var value;
          if ((value = option.forceConfigured) == null) {
            return;
          }
          _this._configured = !!value;
        };
      })(this)).then((function(_this) {
        return function() {};
      })(this));
    };


    /**
    @method
      ボードから切断する
    @return {Promise}
      Promiseオブジェクト
     */

    BaseComm.prototype.disconnect = function() {
      return this.assertConnection().then((function(_this) {
        return function() {
          _this._receiver = null;
          return _this._connection.close();
        };
      })(this));
    };


    /**
    @method
      接続されていることを確認する
    @return {Promise}
      Promiseオブジェクト
     */

    BaseComm.prototype.assertConnection = function() {
      if (this._connection == null) {
        return Promise.reject(Error("Not connected"));
      }
      return Promise.resolve();
    };


    /**
    @method
      制御コマンドの送受信を行う
    @param {number} command
      コマンドバイト
    @return {Promise}
      Promiseオブジェクト
    @return {number} return.PromiseValue
      受信コマンド
     */

    BaseComm.prototype.transCommand = function(command) {
      var txarray;
      txarray = new Uint8Array(2);
      txarray[0] = 0x3a;
      txarray[1] = command;
      return this._transSerial(txarray.buffer, (function(_this) {
        return function(rxdata) {
          if (!(rxdata.byteLength >= 1)) {
            return;
          }
          return 1;
        };
      })(this)).then((function(_this) {
        return function(rxdata) {
          return (new Uint8Array(rxdata))[0];
        };
      })(this));
    };


    /**
    @method
      データの送受信を行う
    @param {ArrayBuffer/null} txdata
      送信するデータ(制御バイトは自動的にエスケープされる。nullの場合は受信のみ)
    @param {function(ArrayBuffer,number):number/undefined/Error} [estimator]
      受信完了まで繰り返し呼び出される受信処理関数。
      引数は受信データ全体と、今回の呼び出しで追加されたデータのオフセット。
      省略時は送信のみで完了とする。戻り値の解釈は以下の通り。
    
      - number : 指定バイト数を受信して受信完了
      - undefined : 追加データを要求
      - Error : エラー発生時のエラー情報
    @return {Promise}
      Promiseオブジェクト
    @return {ArrayBuffer} return.PromiseValue
      受信データ
     */

    BaseComm.prototype.transData = function(txdata, estimator) {
      var byte, dst, j, len, len1, src;
      if (txdata) {
        src = new Uint8Array(txdata);
        dst = new Uint8Array(txdata.byteLength * 2);
        len = 0;
        for (j = 0, len1 = src.length; j < len1; j++) {
          byte = src[j];
          if (byte === 0x3a || byte === 0x3d) {
            dst[len] = 0x3d;
            len += 1;
            byte ^= 0x20;
          }
          dst[len] = byte;
          len += 1;
        }
        txdata = dst.buffer.slice(0, len);
      }
      return this._transSerial(txdata, estimator);
    };


    /**
    @private
    @method
      ログの出力
    @param {number} lvl
      詳細度(0で常に出力。値が大きいほど詳細なメッセージを指す)
    @param {string} func
      関数名
    @param {string} msg
      メッセージ
    @param {Object} [data]
      任意のデータ
    @return {undefined}
     */

    BaseComm.prototype._log = function(lvl, func, msg, data) {
      if (this.constructor.verbosity >= lvl) {
        Canarium._log("BaseComm", func, msg, data);
      }
    };


    /**
    @private
    @method
      シリアル通信の送受信を行う
    @param {ArrayBuffer/null} txdata
      送信するデータ(nullの場合は受信のみ)
    @param {function(ArrayBuffer,number):number/undefined/Error} [estimator]
      受信完了まで繰り返し呼び出される受信処理関数。
      引数は受信データ全体と、今回の呼び出しで追加されたデータのオフセット。
      省略時は送信のみで完了とする。戻り値の解釈は以下の通り。
    
      - number : 指定バイト数を受信して受信完了
      - undefined : 追加データを要求
      - Error : エラー発生時のエラー情報
    @return {Promise}
      Promiseオブジェクト
    @return {ArrayBuffer} return.PromiseValue
      受信したデータ(指定バイト数分)
     */

    BaseComm.prototype._transSerial = function(txdata, estimator) {
      var promise, txsize, x;
      if (this._connection == null) {
        return Promise.reject(Error("Not connected"));
      }
      if (this._receiver != null) {
        return Promise.reject(Error("Operation is in progress"));
      }
      promise = new Promise((function(_this) {
        return function(resolve, reject) {
          return _this._receiver = function(rxdata, error) {
            var newArray, offset, ref, result;
            if (rxdata != null) {
              offset = ((ref = _this._rxBuffer) != null ? ref.byteLength : void 0) || 0;
              newArray = new Uint8Array(offset + rxdata.byteLength);
              if (_this._rxBuffer != null) {
                newArray.set(new Uint8Array(_this._rxBuffer));
              }
              newArray.set(new Uint8Array(rxdata), offset);
              _this._rxBuffer = newArray.buffer;
              result = estimator(_this._rxBuffer, offset);
            } else {
              result = error;
            }
            if (result instanceof Error) {
              _this._rxBuffer = null;
              _this._receiver = null;
              return reject(result);
            }
            if (result != null) {
              rxdata = _this._rxBuffer.slice(0, result);
              _this._rxBuffer = _this._rxBuffer.slice(result);
              _this._receiver = null;
              return resolve(rxdata);
            }
          };
        };
      })(this));
      txsize = (txdata != null ? txdata.byteLength : void 0) || 0;
      return ((function() {
        var j, ref, ref1, results;
        results = [];
        for (x = j = 0, ref = txsize, ref1 = SERIAL_TX_MAX_LENGTH; ref1 > 0 ? j < ref : j > ref; x = j += ref1) {
          results.push(x);
        }
        return results;
      })()).reduce((function(_this) {
        return function(sequence, pos) {
          return sequence.then(function() {
            var data, size;
            data = txdata.slice(pos, pos + SERIAL_TX_MAX_LENGTH);
            size = data.byteLength;
            return _this._connection.write(data).then(function() {
              return _this._log(1, "_transSerial", "sent", new Uint8Array(data));
            }).then(function() {
              if (!(SUCCESSIVE_TX_WAIT_MS > 0)) {
                return;
              }
              return waitPromise(SUCCESSIVE_TX_WAIT_MS);
            });
          });
        };
      })(this), Promise.resolve()).then((function(_this) {
        return function() {
          if (estimator == null) {
            _this._receiver = null;
            return new ArrayBuffer(0);
          }
          _this._log(1, "_transSerial", "wait", promise);
          return promise;
        };
      })(this));
    };

    return BaseComm;

  })();


  /**
  @class Canarium.BaseComm.SerialWrapper
    シリアル通信のラッパ(Chrome/NodeJS両対応用)
  @uses chrome.serial
  @uses SerialPort
   */

  Canarium.BaseComm.SerialWrapper = (function() {
    var cidMap, nodeModule;

    null;


    /**
    @property {function():undefined} onClosed
      ポートが閉じられたときに呼び出されるコールバック関数
      (不意の切断とclose()呼び出しのどちらで閉じても呼び出される)
     */


    /**
    @property {function(ArrayBuffer):undefined} onReceived
      データを受信したときに呼び出されるコールバック関数
      (もし登録されていない場合、受信したデータは破棄される)
     */

    if (IS_NODEJS) {
      nodeModule = require("serialport");
    }

    if (IS_CHROME) {
      cidMap = {};
    }


    /**
    @static
    @method
      ポートを列挙する
    @return {Promise}
      Promiseオブジェクト
    @return {Object[]} return.PromiseValue
      ポート情報の配列
    @return {string} return.PromiseValue.path
      パス (必ず格納される)
    @return {string} return.PromiseValue.manufacturer
      製造者 (環境によってはundefinedになりうる)
    @return {string} return.PromiseValue.serialNumber
      シリアル番号 (環境によってはundefinedになりうる)
    @return {string} return.PromiseValue.vendorId
      Vendor ID (環境によってはundefinedになりうる)
    @return {string} return.PromiseValue.productId
      Product ID (環境によってはundefinedになりうる)
     */

    SerialWrapper.list = IS_CHROME ? (function() {
      return new Promise((function(_this) {
        return function(resolve, reject) {
          return chrome.serial.getDevices(function(ports) {
            var port;
            return resolve((function() {
              var j, len1, results;
              results = [];
              for (j = 0, len1 = ports.length; j < len1; j++) {
                port = ports[j];
                results.push({
                  path: "" + port.path,
                  manufacturer: "" + port.displayName,
                  serialNumber: void 0,
                  vendorId: "" + port.vendorId,
                  productId: "" + port.productId
                });
              }
              return results;
            })());
          });
        };
      })(this));
    }) : IS_NODEJS ? (function() {
      return new Promise((function(_this) {
        return function(resolve, reject) {
          return nodeModule.list(function(error, ports) {
            var port;
            if (error != null) {
              return reject(Error(error));
            }
            return resolve((function() {
              var j, len1, results;
              results = [];
              for (j = 0, len1 = ports.length; j < len1; j++) {
                port = ports[j];
                if (port.pnpId != null) {
                  results.push({
                    path: "" + port.comName,
                    manufacturer: "" + port.manufacturer,
                    serialNumber: "" + port.serialNumber,
                    vendorId: "" + port.vendorId,
                    productId: "" + port.productId
                  });
                }
              }
              return results;
            })());
          });
        };
      })(this));
    }) : void 0;


    /**
    @method constructor
      コンストラクタ
    @param {string} _path
      接続先ポートのパス
    @param {Object} _options
      接続時のオプション
    @param {number} [_options.baudRate=115200]
      ボーレート
    @param {number} [_options.dataBits=8]
      データのビット幅
    @param {number} [_options.stopBits=1]
      ストップビット幅
     */

    function SerialWrapper(_path, _options) {
      var base, base1, base2;
      this._path = _path;
      this._options = _options;
      this._options || (this._options = {});
      (base = this._options).baudRate || (base.baudRate = 115200);
      (base1 = this._options).dataBits || (base1.dataBits = 8);
      (base2 = this._options).stopBits || (base2.stopBits = 1);
      this.onClosed = void 0;
      this.onReceived = void 0;
      return;
    }


    /**
    @method
      接続する
    @return {Promise}
      Promiseオブジェクト
    @return {undefined} return.PromiseValue
     */

    SerialWrapper.prototype.open = IS_CHROME ? (function() {
      return new Promise((function(_this) {
        return function(resolve, reject) {
          var opts;
          opts = {
            bitrate: _this._options.baudRate,
            receiveTimeout: 500
          };
          return chrome.serial.connect(_this._path, opts, function(connectionInfo) {
            if (connectionInfo == null) {
              return reject(Error(chrome.runtime.lastError.message));
            }
            _this._cid = connectionInfo.connectionId;
            cidMap[_this._cid] = _this;
            return resolve();
          });
        };
      })(this));
    }) : IS_NODEJS ? (function() {
      return new Promise((function(_this) {
        return function(resolve, reject) {
          var k, opts, ref, v;
          if (_this._sp == null) {
            opts = {
              dataCallback: function(data) {
                return _this._dataHandler(data);
              },
              disconnectedCallback: function() {
                return _this._closeHandler();
              }
            };
            ref = _this._options;
            for (k in ref) {
              v = ref[k];
              opts[k] = v;
            }
            _this._sp = new nodeModule.SerialPort(_this._path, opts, false, function() {});
          }
          return _this._sp.open(function(error) {
            if (error != null) {
              return reject(Error(error));
            }
            return resolve();
          });
        };
      })(this));
    }) : void 0;


    /**
    @method
      データの書き込み(送信)
    @param {ArrayBuffer} data
      送信するデータ
    @return {Promise}
      Promiseオブジェクト
    @return {undefined} return.PromiseValue
     */

    SerialWrapper.prototype.write = IS_CHROME ? (function(data) {
      return new Promise((function(_this) {
        return function(resolve, reject) {
          if (_this._cid == null) {
            return reject(Error("disconnected"));
          }
          return chrome.serial.send(_this._cid, data, function(sendInfo) {
            if (sendInfo.error != null) {
              return reject(Error(sendInfo.error));
            }
            if (sendInfo.bytesSent < data.byteLength) {
              return reject(Error("pending"));
            }
            return resolve();
          });
        };
      })(this));
    }) : IS_NODEJS ? (function(data) {
      return new Promise((function(_this) {
        return function(resolve, reject) {
          if (_this._sp == null) {
            return reject(Error("disconnected"));
          }
          return _this._sp.write(new Buffer(new Uint8Array(data)), function(error) {
            if (error != null) {
              return reject(error);
            }
            return resolve();
          });
        };
      })(this));
    }) : void 0;


    /**
    @method
      接続を一時停止状態にする
    @return {Promise}
      Promiseオブジェクト
    @return {undefined} return.PromiseValue
     */

    SerialWrapper.prototype.pause = IS_CHROME ? (function() {
      return new Promise((function(_this) {
        return function(resolve, reject) {
          if (_this._cid == null) {
            return reject(Error("disconnected"));
          }
          return chrome.serial.setPaused(_this._cid, true, function() {
            return resolve();
          });
        };
      })(this));
    }) : IS_NODEJS ? (function() {
      return new Promise((function(_this) {
        return function(resolve, reject) {
          if (_this._sp == null) {
            return reject(Error("disconnected"));
          }
          _this._sp.pause();
          return resolve();
        };
      })(this));
    }) : void 0;


    /**
    @method
      接続の一時停止を解除する
    @return {Promise}
      Promiseオブジェクト
    @return {undefined} return.PromiseValue
     */

    SerialWrapper.prototype.resume = IS_CHROME ? (function() {
      return new Promise((function(_this) {
        return function(resolve, reject) {
          if (_this._cid == null) {
            return reject(Error("disconnected"));
          }
          return chrome.serial.setPaused(_this._cid, false, function() {
            return resolve();
          });
        };
      })(this));
    }) : IS_NODEJS ? (function() {
      return new Promise((function(_this) {
        return function(resolve, reject) {
          if (_this._sp == null) {
            return reject(Error("disconnected"));
          }
          _this._sp.resume();
          return resolve();
        };
      })(this));
    }) : void 0;


    /**
    @method
      送受信待ちのバッファを破棄する(送受信データが欠落する可能性がある)
    @return {Promise}
      Promiseオブジェクト
    @return {undefined} return.PromiseValue
     */

    SerialWrapper.prototype.flush = IS_CHROME ? (function() {
      return new Promise((function(_this) {
        return function(resolve, reject) {
          if (_this._cid == null) {
            return reject(Error("disconnected"));
          }
          return chrome.serial.flush(_this._cid, function(result) {
            if (!result) {
              return reject(Error("unknown_error"));
            }
            return resolve();
          });
        };
      })(this));
    }) : IS_NODEJS ? (function() {
      return new Promise((function(_this) {
        return function(resolve, reject) {
          if (_this._sp == null) {
            return reject(Error("disconnected"));
          }
          return _this._sp.flush(function(error) {
            if (error != null) {
              return reject(error);
            }
            return resolve();
          });
        };
      })(this));
    }) : void 0;


    /**
    @method
      送受信待ちのバッファを強制的に吐き出す(送受信データは欠落しない)
    @return {Promise}
      Promiseオブジェクト
    @return {undefined} return.PromiseValue
     */

    SerialWrapper.prototype.drain = IS_CHROME ? (function() {
      return new Promise((function(_this) {
        return function(resolve, reject) {
          if (_this._cid == null) {
            return reject(Error("disconnected"));
          }
          return resolve();
        };
      })(this));
    }) : IS_NODEJS ? (function() {
      return new Promise((function(_this) {
        return function(resolve, reject) {
          if (_this._sp == null) {
            return reject(Error("disconnected"));
          }
          return _this._sp.drain(function(error) {
            if (error != null) {
              return reject(error);
            }
            return resolve();
          });
        };
      })(this));
    }) : void 0;


    /**
    @method
      切断する
    @return {Promise}
      Promiseオブジェクト
    @return {undefined} return.PromiseValue
     */

    SerialWrapper.prototype.close = IS_CHROME ? (function() {
      return new Promise((function(_this) {
        return function(resolve, reject) {
          if (_this._cid == null) {
            return reject(Error("disconnected"));
          }
          return chrome.serial.disconnect(_this._cid, function(result) {
            var base;
            if (!result) {
              return reject(Error("unknown_error"));
            }
            delete cidMap[_this._cid];
            _this._cid = null;
            if (typeof (base = _this.onClosed) === "function") {
              base();
            }
            return resolve();
          });
        };
      })(this));
    }) : IS_NODEJS ? (function() {
      return new Promise((function(_this) {
        return function(resolve, reject) {
          if (_this._sp == null) {
            return reject(Error("disconnected"));
          }
          return _this._sp.close(function(error) {
            var base;
            if (error != null) {
              return reject(error);
            }
            _this._sp.fd = void 0;
            _this._sp = null;
            if (typeof (base = _this.onClosed) === "function") {
              base();
            }
            return resolve();
          });
        };
      })(this));
    }) : void 0;


    /**
    @private
    @method
      データ受信ハンドラ(NodeJSのみ)
    @param {Buffer} data
      受信したデータ
    @return {undefined}
     */

    SerialWrapper.prototype._dataHandler = IS_NODEJS ? (function(data) {
      var base;
      if (typeof (base = this.onReceived) === "function") {
        base(new Uint8Array(data).buffer);
      }
    }) : void 0;


    /**
    @private
    @method
      切断検知ハンドラ(NodeJSのみ)
    @return {undefined}
     */

    SerialWrapper.prototype._closeHandler = IS_NODEJS ? (function() {
      this.close()["catch"]((function(_this) {
        return function() {};
      })(this));
    }) : void 0;


    /**
    @private
    @static
    @method
      データ受信ハンドラ(chromeのみ)
    @param {Object} info
      受信情報
    @param {number} info.connectionId
      受信したコネクションの番号
    @param {ArrayBuffer} info.data
      受信したデータ
    @return {undefined}
     */

    SerialWrapper._receiveHandler = IS_CHROME ? (function(info) {
      var base, self;
      self = cidMap[info.connectionId];
      if (self == null) {
        return;
      }
      if (typeof (base = self.onReceived) === "function") {
        base(info.data);
      }
    }) : void 0;


    /**
    @private
    @static
    @method
      エラー受信ハンドラ(chromeのみ)
    @param {Object} info
      受信情報
    @param {number} info.connectionId
      エラーが発生したコネクションの番号
    @param {string} info.error
      発生したエラーの種類
    @return {undefined}
     */

    SerialWrapper._receiveErrorHandler = IS_CHROME ? (function(info) {
      var self;
      self = cidMap[info.connectionId];
      if (self == null) {
        return;
      }
      switch (info.error) {
        case "timeout":
          null;
          break;
        case "disconnected":
        case "device_lost":
        case "break":
        case "frame_error":
          self.close();
      }
    }) : void 0;

    if (IS_CHROME) {
      chrome.serial.onReceive.addListener(SerialWrapper._receiveHandler);
    }

    if (IS_CHROME) {
      chrome.serial.onReceiveError.addListener(SerialWrapper._receiveErrorHandler);
    }

    return SerialWrapper;

  })();


  /**
  @class Canarium.I2CComm
    PERIDOTボードI2C通信クラス
  @uses Canarium.BaseComm
   */

  Canarium.I2CComm = (function() {
    var I2C_TIMEOUT_MS;

    null;


    /**
    @static
    @property {number}
      デバッグ出力の細かさ(0で出力無し)
     */

    I2CComm.verbosity = 0;


    /**
    @private
    @property {Canarium.BaseComm} _base
      下位層通信クラスのインスタンス
     */


    /**
    @private
    @static
    @cfg {number}
      I2C通信のタイムアウト時間
    @readonly
     */

    I2C_TIMEOUT_MS = 1000;


    /**
    @method constructor
      コンストラクタ
    @param {Canarium.BaseComm} _base
      下位層通信クラスのインスタンス
     */

    function I2CComm(_base) {
      this._base = _base;
      return;
    }


    /**
    @method
      スタートコンディションの送信
    @param {function(boolean,Error=)} [callback]
      コールバック関数(省略時は戻り値としてPromiseオブジェクトを返す)
    @return {undefined/Promise}
      戻り値なし(callback指定時)、または、Promiseオブジェクト(callback省略時)
     */

    I2CComm.prototype.start = function(callback) {
      var timeLimit;
      if (callback != null) {
        return invokeCallback(callback, this.start());
      }
      timeLimit = void 0;
      return Promise.resolve().then((function(_this) {
        return function() {
          _this._log(1, "start", "(start condition)");
          timeLimit = new TimeLimit(I2C_TIMEOUT_MS);
          return tryPromise(timeLimit.left, function() {
            return _this._base.transCommand(0x3b).then(function(response) {
              if ((response & 0x30) !== 0x30) {
                return Promise.reject();
              }
            });
          });
        };
      })(this)).then((function(_this) {
        return function() {
          return _this._base.transCommand(0x1b);
        };
      })(this)).then((function(_this) {
        return function() {
          return _this._base.transCommand(0x0b);
        };
      })(this)).then((function(_this) {
        return function() {};
      })(this));
    };


    /**
    @method
      ストップコンディションの送信
      (必ずSCL='L'が先行しているものとする)
    @param {function(boolean,Error=)} [callback]
      コールバック関数(省略時は戻り値としてPromiseオブジェクトを返す)
    @return {undefined/Promise}
      戻り値なし(callback指定時)、または、Promiseオブジェクト(callback省略時)
     */

    I2CComm.prototype.stop = function(callback) {
      var timeLimit;
      if (callback != null) {
        return invokeCallback(callback, this.stop());
      }
      timeLimit = void 0;
      return Promise.resolve().then((function(_this) {
        return function() {
          _this._log(1, "stop", "(stop condition)");
          timeLimit = new TimeLimit(I2C_TIMEOUT_MS);
          return _this._base.transCommand(0x0b);
        };
      })(this)).then((function(_this) {
        return function() {
          return tryPromise(timeLimit.left, function() {
            return _this._base.transCommand(0x1b).then(function(response) {
              if ((response & 0x30) !== 0x10) {
                return Promise.reject();
              }
            });
          });
        };
      })(this)).then((function(_this) {
        return function() {
          return tryPromise(timeLimit.left, function() {
            return _this._base.transCommand(0x3b).then(function(response) {
              if ((response & 0x30) !== 0x30) {
                return Promise.reject();
              }
            });
          });
        };
      })(this)).then((function(_this) {
        return function() {
          if (_this._base.sendImmediate) {
            return;
          }
          return _this._base.transCommand(0x39);
        };
      })(this)).then((function(_this) {
        return function() {};
      })(this));
    };


    /**
    @method
      バイトリード
      (必ずSCL='L'が先行しているものとする)
    @param {boolean} ack
      ACK返却の有無(true:ACK, false:NAK)
    @param {function(boolean,number/Error=)} [callback]
      コールバック関数(省略時は戻り値としてPromiseオブジェクトを返す)
    @return {undefined/Promise}
      戻り値なし(callback指定時)、または、Promiseオブジェクト(callback省略時)
    @return {number} return.PromiseValue
      読み込みデータ(0～255)
     */

    I2CComm.prototype.read = function(ack, callback) {
      var readData, timeLimit;
      if (callback != null) {
        return invokeCallback(callback, this.read(ack));
      }
      ack = !!ack;
      timeLimit = void 0;
      readData = 0x00;
      return Promise.resolve().then((function(_this) {
        return function() {
          timeLimit = new TimeLimit(I2C_TIMEOUT_MS);
          return [7, 6, 5, 4, 3, 2, 1, 0].reduce(function(promise, bitNum) {
            return promise.then(function() {
              return tryPromise(timeLimit.left, function() {
                return _this._readBit();
              }, 1);
            }).then(function(bit) {
              _this._log(2, "read", "bit#" + bitNum + "=" + bit);
              return readData |= bit << bitNum;
            });
          }, Promise.resolve());
        };
      })(this)).then((function(_this) {
        return function() {
          return tryPromise(timeLimit.left, function() {
            _this._log(2, "read", ack ? "ACK" : "NAK");
            return _this._writeBit(ack ? 0 : 1);
          }, 1);
        };
      })(this)).then((function(_this) {
        return function() {
          _this._log(1, "read", "data=0x" + (readData.toString(16)));
          return readData;
        };
      })(this));
    };


    /**
    @method
      バイトライト
      (必ずSCL='L'が先行しているものとする)
    @param {number} writebyte
      書き込むデータ(0～255)
    @param {function(boolean,number/Error=)} [callback]
      コールバック関数(省略時は戻り値としてPromiseオブジェクトを返す)
    @return {undefined/Promise}
      戻り値なし(callback指定時)、または、Promiseオブジェクト(callback省略時)
    @return {boolean} return.PromiseValue
      ACK受信の有無(true:ACK, false:NAK)
     */

    I2CComm.prototype.write = function(writebyte, callback) {
      var timeLimit;
      if (callback != null) {
        return invokeCallback(callback, this.write(writebyte));
      }
      writebyte = parseInt(writebyte);
      timeLimit = void 0;
      return Promise.resolve().then((function(_this) {
        return function() {
          _this._log(1, "write", "data=0x" + (writebyte.toString(16)));
          timeLimit = new TimeLimit(I2C_TIMEOUT_MS);
          return [7, 6, 5, 4, 3, 2, 1, 0].reduce(function(sequence, bitNum) {
            var bit;
            bit = (writebyte >>> bitNum) & 1;
            return sequence.then(function() {
              _this._log(2, "write", "bit#" + bitNum + "=" + bit);
              return tryPromise(timeLimit.left, function() {
                return _this._writeBit(bit);
              }, 1);
            });
          }, Promise.resolve());
        };
      })(this)).then((function(_this) {
        return function() {
          return tryPromise(timeLimit.left, function() {
            return _this._readBit();
          }, 1);
        };
      })(this)).then((function(_this) {
        return function(bit) {
          var ack;
          ack = bit === 0;
          _this._log(2, "write", ack ? "ACK" : "NAK");
          return ack;
        };
      })(this));
    };


    /**
    @private
    @method
      ログの出力
    @param {number} lvl
      詳細度(0で常に出力。値が大きいほど詳細なメッセージを指す)
    @param {string} func
      関数名
    @param {string} msg
      メッセージ
    @param {Object} [data]
      任意のデータ
    @return {void}
     */

    I2CComm.prototype._log = function(lvl, func, msg, data) {
      if (this.constructor.verbosity >= lvl) {
        Canarium._log("I2CComm", func, msg, data);
      }
    };


    /**
    @private
    @method
      1ビットリード
      (必ずSCL='L'が先行しているものとする)
    @return {Promise}
      Promiseオブジェクト
    @return {0/1} return.PromiseValue
      読み出しビット値
     */

    I2CComm.prototype._readBit = function() {
      var bit, timeLimit;
      timeLimit = void 0;
      bit = 0;
      return Promise.resolve().then((function(_this) {
        return function() {
          timeLimit = new TimeLimit(I2C_TIMEOUT_MS);
          _this._log(3, "_readBit", "setup,SCL->HiZ");
          return tryPromise(timeLimit.left, function() {
            return _this._base.transCommand(0x3b).then(function(response) {
              if ((response & 0x10) !== 0x10) {
                return Promise.reject();
              }
              if ((response & 0x20) === 0x20) {
                return bit = 1;
              }
            });
          });
        };
      })(this)).then((function(_this) {
        return function() {
          _this._log(3, "_readBit", "SCL->L");
          return _this._base.transCommand(0x2b);
        };
      })(this)).then((function(_this) {
        return function() {
          return bit;
        };
      })(this));
    };


    /**
    @private
    @method
      1ビットライト
      (必ずSCL='L'が先行しているものとする)
    @return {0/1} bit
      書き込みビット値
    @return {Promise}
      Promiseオブジェクト
     */

    I2CComm.prototype._writeBit = function(bit) {
      var timeLimit;
      timeLimit = void 0;
      bit = (bit !== 0 ? 1 : 0) << 5;
      return Promise.resolve().then((function(_this) {
        return function() {
          timeLimit = new TimeLimit(I2C_TIMEOUT_MS);
          _this._log(3, "_writeBit", "setup");
          return _this._base.transCommand(0x0b | bit);
        };
      })(this)).then((function(_this) {
        return function() {
          _this._log(3, "_writeBit", "SCL->HiZ");
          return tryPromise(timeLimit.left, function() {
            return _this._base.transCommand(0x1b | bit).then(function(response) {
              if ((response & 0x10) !== 0x10) {
                return Promise.reject();
              }
            });
          });
        };
      })(this)).then((function(_this) {
        return function() {
          _this._log(3, "_writeBit", "SCL->L");
          return _this._base.transCommand(0x2b);
        };
      })(this)).then((function(_this) {
        return function() {};
      })(this));
    };

    return I2CComm;

  })();


  /**
  @class Canarium.AvsPackets
    PERIDOTボードAvalon-STパケット層通信クラス
  @uses Canarium.BaseComm
   */

  Canarium.AvsPackets = (function() {
    null;


    /**
    @property base
    @inheritdoc #_base
    @readonly
     */

    AvsPackets.property("base", {
      get: function() {
        return this._base;
      }
    });


    /**
    @static
    @property {number}
      デバッグ出力の細かさ(0で出力無し)
     */

    AvsPackets.verbosity = 0;


    /**
    @private
    @property {Canarium.BaseComm} _base
      下位層通信クラスのインスタンス
     */


    /**
    @method constructor
      コンストラクタ
    @param {Canarium.BaseComm} _base
      下位層通信クラスのインスタンス
     */

    function AvsPackets(_base) {
      this._base = _base;
      return;
    }


    /**
    @method
      Avalon-STパケットを送受信する。
      チャネル選択およびSOP/EOPは自動的に付加される。
      現時点では、受信データに複数のチャネルがインタリーブすることは認めない。
    @param {number} channel
      チャネル番号(0～255)
    @param {ArrayBuffer}  txdata
      送信するパケットデータ
    @param {number} rxsize
      受信するパケットのバイト数
    @return {Promise}
      Promiseオブジェクト
    @return {ArrayBuffer} return.PromiseValue
      受信したデータ
     */

    AvsPackets.prototype.transPacket = function(channel, txdata, rxsize) {
      var byte, dst, eopFinder, header, j, len, len1, pushWithEscape, ref, src, totalRxLen;
      pushWithEscape = function(array, pos, byte) {
        if ((0x7a <= byte && byte <= 0x7d)) {
          array[pos++] = 0x7d;
          array[pos++] = byte ^ 0x20;
          return pos;
        }
        array[pos++] = byte;
        return pos;
      };
      channel &= 0xff;
      src = new Uint8Array(txdata);
      dst = new Uint8Array(txdata.byteLength * 2 + 5);
      len = 0;
      dst[len++] = 0x7c;
      len = pushWithEscape(dst, len, channel);
      dst[len++] = 0x7a;
      header = dst.subarray(0, len);
      ref = src.subarray(0, src.length - 1);
      for (j = 0, len1 = ref.length; j < len1; j++) {
        byte = ref[j];
        len = pushWithEscape(dst, len, byte);
      }
      dst[len++] = 0x7b;
      len = pushWithEscape(dst, len, src[src.length - 1]);
      txdata = dst.buffer.slice(0, len);
      totalRxLen = rxsize + header.length + 1;
      this._log(1, "transPacket", "begin", {
        source: src,
        encoded: new Uint8Array(txdata)
      });
      eopFinder = (function(_this) {
        return function(rxdata, offset) {
          var array, l, pos, ref1, ref2;
          array = new Uint8Array(rxdata);
          for (pos = l = ref1 = offset, ref2 = array.length; ref1 <= ref2 ? l < ref2 : l > ref2; pos = ref1 <= ref2 ? ++l : --l) {
            if ((array[pos - 1] === 0x7b && array[pos - 0] !== 0x7d) || (array[pos - 2] === 0x7b && array[pos - 1] === 0x7d)) {
              return pos + 1;
            }
          }
        };
      })(this);
      return this._base.transData(txdata, eopFinder).then((function(_this) {
        return function(rxdata) {
          var i, l, len2, m, pos, ref1, xor;
          src = new Uint8Array(rxdata);
          _this._log(1, "transPacket", "recv", {
            encoded: src
          });
          for (i = l = 0, ref1 = header.length; 0 <= ref1 ? l < ref1 : l > ref1; i = 0 <= ref1 ? ++l : --l) {
            if (src[i] !== header[i]) {
              return Promise.reject(Error("Illegal packetize control bytes"));
            }
          }
          src = src.subarray(header.length);
          dst = new Uint8Array(rxsize);
          pos = 0;
          xor = 0x00;
          for (m = 0, len2 = src.length; m < len2; m++) {
            byte = src[m];
            if (pos === rxsize) {
              return Promise.reject(Error("Received data is too large"));
            }
            if (byte === 0x7b) {
              continue;
            }
            if (byte === 0x7d) {
              xor = 0x20;
            } else {
              dst[pos++] = byte ^ xor;
              xor = 0x00;
            }
          }
          if (pos < rxsize) {
            return Promise.reject(Error("Received data is too small"));
          }
          _this._log(1, "transPacket", "end", {
            decoded: dst
          });
          return dst.buffer;
        };
      })(this));
    };


    /**
    @private
    @method
      ログの出力
    @param {number} lvl
      詳細度(0で常に出力。値が大きいほど詳細なメッセージを指す)
    @param {string} func
      関数名
    @param {string} msg
      メッセージ
    @param {Object} [data]
      任意のデータ
    @return {undefined}
     */

    AvsPackets.prototype._log = function(lvl, func, msg, data) {
      if (this.constructor.verbosity >= lvl) {
        Canarium._log("AvsPackets", func, msg, data);
      }
    };

    return AvsPackets;

  })();


  /**
  @class Canarium.AvmTransactions
    PERIDOTボードAvalon-MMトランザクション層通信クラス
  @uses Canarium.AvsPackets
   */

  Canarium.AvmTransactions = (function() {
    var AVM_TRANS_MAX_BYTES;

    null;


    /**
    @static
    @property {number}
      デバッグ出力の細かさ(0で出力無し)
     */

    AvmTransactions.verbosity = 0;


    /**
    @private
    @property {Canarium.AvsPackets} _avs
      Avalon-STパケット層通信クラスのインスタンス
     */


    /**
    @private
    @property {number} _channel
      Avalon Packets to Transactions Converterのチャネル番号
     */


    /**
    @private
    @property {Promise} _lastAction
      キューされている動作の最後尾を示すPromiseオブジェクト
     */


    /**
    @private
    @static
    @cfg {number}
      1回のトランザクションで読み書きできる最大バイト数
    @readonly
     */

    AVM_TRANS_MAX_BYTES = 32768;


    /**
    @method constructor
      コンストラクタ
    @param {Canarium.AvsPackets} _avs
      Avalon-STパケット層通信クラスのインスタンス
    @param {number} _channel
      パケットのチャネル番号
     */

    function AvmTransactions(_avs, _channel) {
      this._avs = _avs;
      this._channel = _channel;
      this._lastAction = Promise.resolve();
      return;
    }


    /**
    @method
      AvalonMMメモリリード(IORD_DIRECT)
    @param {number} address
      読み込み元アドレス(バイト単位)
    @param {number} bytenum
      読み込むバイト数
    @param {function(boolean,ArrayBuffer)} [callback]
      コールバック関数(省略時は戻り値としてPromiseオブジェクトを返す)
    @return {undefined/Promise}
      戻り値なし(callback指定時)、または、Promiseオブジェクト
    @return {ArrayBuffer} return.PromiseValue
      受信したデータ
     */

    AvmTransactions.prototype.read = function(address, bytenum, callback) {
      if (callback != null) {
        return invokeCallback(callback, this.read(address, bytenum));
      }
      return this._avs.base.assertConnection().then((function(_this) {
        return function() {
          return _this._queue(function() {
            var dest, x;
            _this._log(1, "read", "begin(address=" + (hexDump(address)) + ")");
            if (!_this._avs.base.configured) {
              return Promise.reject(Error("Device is not configured"));
            }
            dest = new Uint8Array(bytenum);
            return ((function() {
              var j, ref, ref1, results;
              results = [];
              for (x = j = 0, ref = bytenum, ref1 = AVM_TRANS_MAX_BYTES; ref1 > 0 ? j < ref : j > ref; x = j += ref1) {
                results.push(x);
              }
              return results;
            })()).reduce(function(sequence, pos) {
              return sequence.then(function() {
                var partialSize;
                partialSize = Math.min(bytenum - pos, AVM_TRANS_MAX_BYTES);
                _this._log(2, "read", "partial(offset=" + (hexDump(pos)) + ",size=" + (hexDump(partialSize)) + ")");
                return _this._trans(0x14, address + pos, void 0, partialSize).then(function(partialData) {
                  return dest.set(new Uint8Array(partialData), pos);
                });
              });
            }, Promise.resolve()).then(function() {
              _this._log(1, "read", "end", dest);
              return dest.buffer;
            });
          });
        };
      })(this));
    };


    /**
    @method
      AvalonMMメモリライト(IOWR_DIRECT)
    @param {number} address
      書き込み先アドレス(バイト単位)
    @param {ArrayBuffer} writedata
      書き込むデータ
    @param {function(boolean,Error=)} [callback]
      コールバック関数(省略時は戻り値としてPromiseオブジェクトを返す)
    @return {undefined/Promise}
      戻り値なし(callback指定時)、または、Promiseオブジェクト
     */

    AvmTransactions.prototype.write = function(address, writedata, callback) {
      var src;
      if (callback != null) {
        return invokeCallback(callback, this.write(address, writedata));
      }
      src = new Uint8Array(writedata.slice(0));
      return this._avs.base.assertConnection().then((function(_this) {
        return function() {
          return _this._queue(function() {
            var x;
            _this._log(1, "write", "begin(address=" + (hexDump(address)) + ")", src);
            if (!_this._avs.base.configured) {
              return Promise.reject(Error("Device is not configured"));
            }
            return ((function() {
              var j, ref, ref1, results;
              results = [];
              for (x = j = 0, ref = src.byteLength, ref1 = AVM_TRANS_MAX_BYTES; ref1 > 0 ? j < ref : j > ref; x = j += ref1) {
                results.push(x);
              }
              return results;
            })()).reduce(function(sequence, pos) {
              return sequence.then(function() {
                var partialData;
                partialData = src.subarray(pos, pos + AVM_TRANS_MAX_BYTES);
                _this._log(2, "write", "partial(offset=" + (hexDump(pos)) + ")", partialData);
                return _this._trans(0x04, address + pos, partialData, void 0);
              });
            }, Promise.resolve()).then(function() {
              _this._log(1, "write", "end");
            });
          });
        };
      })(this));
    };


    /**
    @method
      AvalonMMペリフェラルリード(IORD)
    @param {number} address
      読み込み元ベースアドレス(バイト単位。ただし自動的に4バイトの倍数に切り捨てられる)
    @param {number} offset
      オフセット(4バイトワード単位)
    @param {function(boolean,number/Error)} [callback]
      コールバック関数(省略時は戻り値としてPromiseオブジェクトを返す)
    @return {undefined/Promise}
      戻り値なし(callback指定時)、または、Promiseオブジェクト
    @return {ArrayBuffer} return.PromiseValue
      受信したデータ(リトルエンディアンの32-bit符号有り整数)
     */

    AvmTransactions.prototype.iord = function(address, offset, callback) {
      if (callback != null) {
        return invokeCallback(callback, this.iord(address, offset));
      }
      return this._avs.base.assertConnection().then((function(_this) {
        return function() {
          return _this._queue(function() {
            _this._log(1, "iord", "begin(address=" + (hexDump(address)) + "+" + offset + ")");
            if (!_this._avs.base.configured) {
              return Promise.reject(Error("Device is not configured"));
            }
            return _this._trans(0x10, (address & 0xfffffffc) + (offset << 2), void 0, 4).then(function(rxdata) {
              var readData, src;
              src = new Uint8Array(rxdata);
              readData = (src[3] << 24) | (src[2] << 16) | (src[1] << 8) | (src[0] << 0);
              _this._log(1, "iord", "end", readData);
              return readData;
            });
          });
        };
      })(this));
    };


    /**
    @method
      AvalonMMペリフェラルライト(IOWR)
    @param {number} address
      書き込み先ベースアドレス(バイト単位。ただし自動的に4バイトの倍数に切り捨てられる)
    @param {number} offset
      オフセット(4バイトワード単位)
    @param {number} writedata
      書き込むデータ(リトルエンディアン)
    @param {function(boolean,Error=)} [callback]
      コールバック関数(省略時は戻り値としてPromiseオブジェクトを返す)
    @return {undefined/Promise}
      戻り値なし(callback指定時)、または、Promiseオブジェクト
     */

    AvmTransactions.prototype.iowr = function(address, offset, writedata, callback) {
      if (callback != null) {
        return invokeCallback(callback, this.iowr(address, offset, writedata));
      }
      return this._avs.base.assertConnection().then((function(_this) {
        return function() {
          return _this._queue(function() {
            var src;
            _this._log(1, "iowr", "begin(address=" + (hexDump(address)) + "+" + offset + ")", writedata);
            if (!_this._avs.base.configured) {
              return Promise.reject(Error("Device is not configured"));
            }
            src = new Uint8Array(4);
            src[0] = (writedata >>> 0) & 0xff;
            src[1] = (writedata >>> 8) & 0xff;
            src[2] = (writedata >>> 16) & 0xff;
            src[3] = (writedata >>> 24) & 0xff;
            return _this._trans(0x00, (address & 0xfffffffc) + (offset << 2), src, void 0).then(function() {
              _this._log(1, "iowr", "end");
            });
          });
        };
      })(this));
    };


    /**
    @method
      AvalonMMオプション設定
    @param {Object} option
      オプション
    @param {boolean} option.fastAcknowledge
      即時応答ビットを立てるかどうか
    @param {boolean} option.forceConfigured
      コンフィグレーション済みとして扱うかどうか
    @param {function(boolean,Error=)} [callback]
      コールバック関数(省略時は戻り値としてPromiseオブジェクトを返す)
    @return {undefined/Promise}
      戻り値なし(callback指定時)、または、Promiseオブジェクト
     */

    AvmTransactions.prototype.option = function(option, callback) {
      if (callback != null) {
        return invokeCallback(callback, this.option(option));
      }
      return this._avs.base.assertConnection().then((function(_this) {
        return function() {
          return _this._queue(function() {
            return _this._avs.base.option(option);
          });
        };
      })(this));
    };


    /**
    @private
    @method
      非同期実行キューに追加する
    @param {function():Promise} action
      Promiseオブジェクトを返却する関数
    @return {Promise}
      Promiseオブジェクト
     */

    AvmTransactions.prototype._queue = function(action) {
      return new Promise((function(_this) {
        return function(resolve, reject) {
          return _this._lastAction = _this._lastAction.then(action).then(resolve, reject);
        };
      })(this));
    };


    /**
    @private
    @method
      ログの出力
    @param {number} lvl
      詳細度(0で常に出力。値が大きいほど詳細なメッセージを指す)
    @param {string} func
      関数名
    @param {string} msg
      メッセージ
    @param {Object} [data]
      任意のデータ
    @return {undefined}
     */

    AvmTransactions.prototype._log = function(lvl, func, msg, data) {
      if (this.constructor.verbosity >= lvl) {
        Canarium._log("AvmTransactions", func, msg, data);
      }
    };


    /**
    @private
    @method
      トランザクションの発行
    @param {number} transCode
      トランザクションコード
    @param {number} address
      アドレス
    @param {Uint8Array/undefined} txdata
      送信パケットに付加するデータ(受信時はundefined)
    @param {undefined/number}  rxsize
      受信するバイト数(送信時はundefined)
    @return {Promise}
      Promiseオブジェクト
    @return {ArrayBuffer} return.PromiseValue
      受信したデータ
     */

    AvmTransactions.prototype._trans = function(transCode, address, txdata, rxsize) {
      var len, pkt;
      len = (txdata != null ? txdata.byteLength : void 0) || rxsize;
      pkt = new Uint8Array(8 + ((txdata != null ? txdata.byteLength : void 0) || 0));
      pkt[0] = transCode;
      pkt[1] = 0x00;
      pkt[2] = (len >>> 8) & 0xff;
      pkt[3] = (len >>> 0) & 0xff;
      pkt[4] = (address >>> 24) & 0xff;
      pkt[5] = (address >>> 16) & 0xff;
      pkt[6] = (address >>> 8) & 0xff;
      pkt[7] = (address >>> 0) & 0xff;
      if (txdata) {
        pkt.set(txdata, 8);
      }
      this._log(2, "_trans", "send", pkt);
      return this._avs.transPacket(this._channel, pkt.buffer, rxsize || 4).then((function(_this) {
        return function(rxdata) {
          var res;
          _this._log(2, "_trans", "recv", new Uint8Array(rxdata));
          if (rxsize) {
            if (rxdata.byteLength !== rxsize) {
              return Promise.reject(Error("Received data length does not match"));
            }
            return rxdata;
          }
          res = new Uint8Array(rxdata);
          if (!(res[0] === pkt[0] ^ 0x80 && res[2] === pkt[2] && res[3] === pkt[3])) {
            return Promise.reject(Error("Illegal write response"));
          }
        };
      })(this));
    };

    return AvmTransactions;

  })();


  /*
  canarium.jsの末端に配置されるスクリプト。
  ロードの最終処理や後始末などを記述する。
   */

  if (oldProperty != null) {
    Function.prototype.property = oldProperty;
  } else {
    delete Function.prototype.property;
  }

  this.Canarium = Canarium;

}).call(this);

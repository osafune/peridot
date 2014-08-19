Canarium.js
==============
Google Chrome Package Apps用のJavaScriptライブラリです。  


利用環境
========
Windows/Linux/MacOS上のGoogle Chrome 33以上で動作します。  


サンプルの使い方
================

Chrome Package Appsの登録
-------------------------
1. sample_appsフォルダをローカルに保存します。
2. Chromeの設定→拡張機能でデベロッパーモードにチェックを入れます。
3. 'パッケージ化されてない拡張機能を読み込む'をクリックして保存したフォルダを指定します。
4. Chromeのアドレスバーに'chrome://apps/'を入力（またはChromeのブックマークバーを右クリック→アプリのショートカットを表示）
5. アプリウィンドウに追加したアプリが表示されているのでクリックして起動。

PERIDOTの接続
-------------
1. USBでホストPCに接続します。
2. Windowsの場合は、デバイスマネージャから該当ドライバのVCPロードするにチェックを入れ、再度接続し直します。
3. アプリを起動して、Serial Portの中からPERIDOTが接続されているポートを選択してConnectボタンを押します。
4. 正しく認識されればチェックアイコンが出て、ボタン表示がDisconnectに切り替わります。
5. 'ファイルを選択'から、RBF形式のコンフィグレーションデータを選択し、Configurationボタンをクリックします。正常にコンフィグされればチェックアイコンが出て、接続状態になります。
6. I/O AcceessとMemory DumpでQsysペリフェラルにアクセスすることができます。Qsysコンポーネントの存在しないコンフィグでは動作しません。


簡単なAPIの説明
===============

Canariumオブジェクトの生成
-----------------------------
`var myps = new Canarium();`


PERIDOTデバイスのオープン
-----------------------------
`myps.open(port portname, function callback(bool result));`

    portname : chrome.serialで返されるポート名を指定
    result : 成功＝true / 失敗＝false


PERIDOTデバイスのクローズ
-----------------------------
`myps.close(function callback(bool result));`

    result : 成功＝true / 失敗＝false


PERIDOTデバイスのコンフィグレーション
-----------------------------------------
`myps.config(obj boardInfo, arraybuffer rbfdata[], function callback(bool result));`

    boardInfo : コンフィグレーション対象のボード情報オブジェクト（普通はnullを指定する）
    rbfdata[] : コンフィグデータが格納された ArrayBufferオブジェクト
    result : 成功＝true / 失敗＝false


AvalonMMペリフェラルの読み書き
------------------------------
`myps.avm.iord(uint address, int offset, function callback(bool result, uint readdata));`
`myps.avm.iowr(uint address, int offset, uint writedata, function callback(bool result));`

    address : AvalonMMベースアドレス
    offset : レジスタオフセット
    writedata : 書き込むレジスタ値
    readdata : 読み出したレジスタ値
    result : 成功＝true / 失敗＝false


AvalonMMメモリの読み書き
------------------------
`myps.avm.read(uint address, int bytenum, function callback(bool result, arraybuffer readdata[]));`
`myps.avm.write(uint address, arraybuffer writedata[], function callback(bool result));`

    address : AvalonMMメモリ先頭アドレス
    bytenum : リードするバイト数
    readdata[] : 読み出したデータバイト列
    writedata[] : 書き込むデータバイト列
    result : 成功＝true / 失敗＝false


既知の問題
==========

v0.9.5
------
* canarium.avm.readメソッドでメモリから大量のデータをリードする場合に、高確率で失敗（シリアルポートのタイムアウトあるいはデッドロック）します。
* Mac OS X上で、コンフィグレーションまたはcanarium.avm.writeメソッドにて送信データが先頭から1024バイトで打ち切られる場合があります。


ライセンス
==========

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)

RBF-WRITER
==============
PERIDOT用のコンフィグROM書き込みツールです。  


利用環境
========
Google Chrome 35以上で動作します。  


使い方
======

Chromeウェブストアからのインストールの場合
------------------------------------------
1. [Chromeウェブストア](https://chrome.google.com/webstore/detail/peridot-rbf-writer/lchhhfhfikpnikljdaefcllbfblabibg)へアクセスします。
2. 右上のインストールボタンをクリック。
3. シリアルポートの使用の確認ウィンドウが出現するので、承認をクリックします。  
4. アプリウィンドウにRBF-WRITERのアイコンが追加されているので、クリックして起動。

Chromeアプリを手動で登録する場合
--------------------------------
1. Chromeの設定→拡張機能でデベロッパーモードにチェックを入れます。
2. peridot_rbfwriterフォルダのperidot_rbfwriter_v0.2.crxをChromeにドラッグ＆ドロップします。  
3. シリアルポートの使用の確認ウィンドウが出現するので、承認をクリックします。  
4. アプリウィンドウにRBF-WRITERのアイコンが追加されているので、クリックして起動。


RBF-WRITERの使い方
------------------
1. PERIDOTボードをUSBでホストPCに接続します。
2. アプリを起動して、Serial Portの中からPERIDOTが接続されているポートを選択して接続ボタンを押します。  
3. 正しく認識されればチェックアイコンが出て、下側のファイルドラッグ＆ドロップエリアが有効になります。  
4. ドラッグ＆ドロップエリアにQuartusIIで生成したRBF(Raw Binary File)ファイルまたはRPD(Raw Programming Data)ファイルをドラッグ＆ドロップします。  
5. ファイルがPERIDOTボード上のコンフィグROMへ書き込まれます。  
6. 切断ボタンをクリックしてPERIDOTとの接続を切り、USBケーブルを抜きます。  
7. PERIDOTのモードスイッチをAS側(Stand aloneモード)に切り替え、USBケーブルを接続するとPERIDOTはボード上のコンフィグROMから起動します。  
再びコンフィグROMにデータを書き込む場合はモードスイッチをPS側に切り替えてから接続してください。


既知の問題
==========

Windows7
--------
* 一部のUSB3.0ホストではホストドライバの問題で、FTDIドライバの動作が著しく不安定になります。USB3.0ポートではなくUSB2.0ポートに接続してください。  


v0.2
----
* Mac OS X 10.8/10.9では標準のFTDI VCPの問題により、PERIDOTボードとの接続が失敗します。


ライセンス
==========

[Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)

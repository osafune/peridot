PERIDOT Tools
==============
PERIDOT環境用のツール群です。

利用環境
========
Google Chrome 35以上で動作します。  


RBF-WRITER
==========
PERIDOT用のコンフィグROM書き込みツールです。  


●使い方
--------

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


RBF-WRITERの操作
----------------
1. PERIDOTボードをUSBでホストPCに接続します。
2. アプリを起動して、Serial Portの中からPERIDOTが接続されているポートを選択して接続ボタンを押します。  
3. 正しく認識されればチェックアイコンが出て、下側のファイルドラッグ＆ドロップエリアが有効になります。  
4. ドラッグ＆ドロップエリアにQuartusIIで生成したRBF(Raw Binary File)ファイルまたはRPD(Raw Programming Data)ファイルをドラッグ＆ドロップします。  
5. ファイルがPERIDOTボード上のコンフィグROMへ書き込まれます。  
6. 切断ボタンをクリックしてPERIDOTとの接続を切り、USBケーブルを抜きます。  
7. PERIDOTのモードスイッチをAS側(Stand aloneモード)に切り替え、USBケーブルを接続するとPERIDOTはボード上のコンフィグROMから起動します。  
再びコンフィグROMにデータを書き込む場合はモードスイッチをPS側に切り替えてから接続してください。


●既知の問題
------------

Windows7
--------
* 一部のUSB3.0ホストではホストドライバの問題で、FTDIドライバの動作が著しく不安定になります。USB3.0ポートではなくUSB2.0ポートに接続してください。  


v0.2
----
* Mac OS X 10.8/10.9では標準のFTDI VCPの問題により、PERIDOTボードとの接続が失敗します。



PERIDOT Moniter
===============
PERIDOT環境用のモニターツールです。  
RBFファイルのコンフィグレーション、I/Oリード、メモリリード、およびメモリへのファイル転送が可能です。  
パッケージ化されていないので、Chromeの拡張機能ページ→「パッケージ化されていない拡張機能を読み込む」ボタンでアプリを追加してください。  


●対応コンフィグレーション
--------------------------
1.PERIDOT AvalonMM BridgeペリフェラルでQsysのAvalonMMバスにマッピングされているコンフィグレーションを対象とします。  
2.アドレス0x10000000にSystemIDあるいはPERIDOT SWIペリフェラルが配置されていることを想定しています。  


●PERIDOT Moniterの使い方
-------------------------
1. PERIDOTボードをUSBでホストPCに接続します。
2. アプリを起動して、Serial Portの中からPERIDOTが接続されているポートを選択してConnectボタンを押します。  
3. 正しく認識されればチェックアイコンが出て、Configurationのファイル選択が可能になります。ASモードの場合は既にアクセス可能なコンフィグレーションが行われていると想定し、I/O Accessをアクティブにします。  
4. Memory Dumpウィンドウにファイルをドロップすると、ADDRESSに設定したアドレスへバイナリ転送を行います。  
5. 終了する場合はDisconnectボタンをクリックしてPERIDOTとの接続を切り、USBケーブルを抜きます。  



ライセンス
==========

[MIT License](https://opensource.org/licenses/mit-license.php)

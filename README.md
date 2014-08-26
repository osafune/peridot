'PERIDOT' - Simple & Compact FPGA board
=======================================

Overview
--------
![Welcome to PERIDOT](https://lh3.googleusercontent.com/-yCNcTx9NGoA/U-LL8LLfGTI/AAAAAAAAHC4/eYjyNouEk0w/w600-h316-no/DSC02498_3.jpg)

PERIDOT(ペリドット)プロジェクトとは、シンプル＆コンパクトをコンセプトに開発中の新しいFPGAボードと、その統合開発環境です。  
開発環境はWebベースのクラウドコンパイラとChromeアプリケーションで構築されており、OSを問わない新しい開発スタイルを提供します（現在開発作業中）。  
また、PERIDOTボードには標準で通信ブロックも組み込まれています。オープン・ソースで公開されているライブラリを利用して、ChromeアプリケーションやAndroidアプリケーションから簡単にアクセスすることができます。  


Features
--------
![Use to PERIDOT](https://lh4.googleusercontent.com/-w47r5-Wg1KY/U-LL8LEMTKI/AAAAAAAAHC8/dp4UBKBEsj4/w600-h316-no/DSC02730_2.jpg)

* Android/Chromeからのコンフィグレーション
* USBインターフェース経由でのFPGA内部へのアクセス
* ALTERA CycloneIV E (EP4CE6E22C8N)搭載
* 64Mbit SDRAM搭載
* 28本のユーザーI/O
* スタンドアロン動作をサポート
* USB給電のみで動作OK (過電流保護回路搭載)
* Arduinoシールドの流用可能(動作条件あり)
* オープンソース (クリエイティブコモンズ・CC BY 2.1)


Pinout diagram
--------------

![PERIDOT Pinout diagram](https://lh3.googleusercontent.com/-XxlwNOIA3iY/U6i-dM-9mwI/AAAAAAAAHAc/RHRm6UER750/w700-h565-no/PERIDOT_PINOUT.png)
[Large size](https://github.com/osafune/peridot/blob/master/pcb/PERIDOT_PINOUT.png)


Interface
---------
![PERIDOT Board Connector](https://lh3.googleusercontent.com/-mjnC-a-mvtM/UnhcuaqQL0I/AAAAAAAAFso/zZeyUkh4efw/w600-h468-no/peridot_board_connector.png)

* Manual RESET Key  
システム全体のマニュアルリセットを行います。

* JTAG Connector  
FPGAのJTAGピンが配置されています。  
※v1.1ではJTAG経由のjicファイル書き込みには対応していません。EPCS FlashROMへの書き込みはChromeアプリケーションで行います。

* Config MODE Selector  
ボードのコンフィグモードを切り替えます。スタンドアロンで動作させる場合はAS側に、ホストからCanariumライブラリでコンフィグを行う場合はPS側にセットします。

* Power supply and RESET  
シールドへの電源供給とリセット信号が出力されます。電源は3.3V/100mA、USB 5V/100mAが使用できます。最大電流はUSBホストで制限されます。

* Digital I/O  
FPGAのI/Oピンが配置されています。3.3Vを超える電圧を加えないで下さい。


Board block diagram and schematic
---------------------------------
![PERIDOT Block diagram](https://lh3.googleusercontent.com/-XpoVXE45BRU/UnhcutSOYOI/AAAAAAAAFss/-6QsIh6Is40/w700-h327-no/peridot_block.png)

(\*1) ASDIはスタンドアロンモードでのみ有効になります。  
(\*2) スタンドアロンモードではリコンフィグキーになります。  

[Board schematic](https://github.com/osafune/peridot/blob/master/pcb/peridot_pcb_ver1.0.pdf)


Tools
-----
PERIDOT用コンフィグレーションROM書き込みツール(Chromeパッケージアプリ)  
[RBF-WRITER (Chromeウェブストア)](https://chrome.google.com/webstore/detail/peridot-rbf-writer/lchhhfhfikpnikljdaefcllbfblabibg)  
[Source](https://github.com/osafune/peridot/tree/master/tools)


Library
-------
Chromeパッケージアプリ用のJavascriptライブラリ  
[Canarium.js](https://github.com/osafune/peridot/tree/master/sample_apps)


License
-------
PERIDOT Hardware is released under the [Creative Commons,CC BY 2.1 JP](http://creativecommons.org/licenses/by/2.1/jp/legalcode)  
![CC BY](http://creativecommons.jp/wp/wp-content/uploads/2009/10/by.png)  


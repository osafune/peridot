'PERIDOT' - Simple & Compact FPGA board
============================

Overview
-----------------
PERIDOT(ペリドット)プロジェクトとは、シンプル＆コンパクトをコンセプトに開発中の新しいFPGAボードと、その統合開発環境です。
このFPGAボードはArduinoフォームファクタで、Arduino向けに作られたシールドと互換製があります。  
開発環境はWebベースのクラウドコンパイラとChromeアプリケーションで構築されており、OSを問わない新しい開発スタイルを提供します。
また、PERIDOTボードには標準で通信ブロックも組み込まれています。オープン・ソースで公開されているライブラリを利用して、ChromeアプリケーションやAndroidアプリケーションから簡単にアクセスすることができます。

![Welcome to PERIDOT](https://lh6.googleusercontent.com/-dpi_AESyN_w/U5TCeTNYXiI/AAAAAAAAG3E/FCWlJFilgqQ/w600-h316-no/DSC02480.jpg)


Features
-----------------
* Android/Chromeからのコンフィグレーション
* USBシリアルインターフェース経由でのFPGA内部へのアクセス
* ALTERA CycloneIV E (EP4CE6E22C8N)搭載
* 64Mbit SDRAM (up to 133MHz)搭載
* 28本のユーザーI/O
* スタンドアロン動作をサポート
* USB給電のみで動作OK (過電流保護回路搭載)
* Arduinoシールドの流用可能(動作条件あり)
* オープンソース (クリエイティブコモンズ・CC BY 2.1)


Interface
-----------------
![PERIDOT Board Connector](https://lh3.googleusercontent.com/-mjnC-a-mvtM/UnhcuaqQL0I/AAAAAAAAFso/zZeyUkh4efw/w600-h468-no/peridot_board_connector.png)

* Manual RESET Key  
システム全体のマニュアルリセットを行います。

* JTAG Connector  
FPGAのJTAGピンが配置されています。

* Config MODE Selector  
ボードのコンフィグモードを切り替えます。スタンドアロンで動作させる場合はAS側に、ホストからPhysicaloidライブラリでコンフィグを行う場合はPS側にセットします。

* Power supply and RESET  
シールドへの電源供給とリセット信号が出力されます。電源は3.3V/100mA、USB 5V/100mAが使用できます。最大電流はUSBホストで制限されます。

* Digital I/O  
FPGAのI/Oピンが配置されています。3.3Vを超える電圧を印加しないで下さい。


Board block diagram and schematic
---------------------------------
![PERIDOT Block diagram](https://lh3.googleusercontent.com/-XpoVXE45BRU/UnhcutSOYOI/AAAAAAAAFss/-6QsIh6Is40/w700-h327-no/peridot_block.png)

(\*1) ASDIはスタンドアロンモードでのみ有効になります。  
(\*2) スタンドアロンモードではリコンフィグキーになります。  

[Board schematic](https://github.com/osafune/peridot/blob/master/pcb/peridot_pcb_ver1.0.pdf)


Pinout diagram
---------------------------------

![PERIDOT Pinout diagram](https://lh3.googleusercontent.com/-XxlwNOIA3iY/U6i-dM-9mwI/AAAAAAAAHAc/RHRm6UER750/w700-h565-no/PERIDOT_PINOUT.png)
[Large size](https://github.com/osafune/peridot/blob/master/pcb/PERIDOT_PINOUT.png)


License
-----------------
PERIDOT Hardware is released under the [Creative Commons,CC BY 2.1 JP](http://creativecommons.org/licenses/by/2.1/jp/legalcode)  
![CC BY](http://creativecommons.jp/wp/wp-content/uploads/2009/10/by.png)  


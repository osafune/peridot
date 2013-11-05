Physicaloid FPGA - 'PERIDOT'
============================

Overview
-----------------
PERIDOT(ペリドット)はPhysicaloidに対応したArduinoフォームファクタのFPGA基板です。
Physicaloidライブラリを利用することで、AndroidやGoogle Chromeからのフィジカルコンピューティングを可能にします。

'PERIDOT' is a FPGA board Arduino form factor corresponding to the Physicaloid.
By taking advantage of Physicaloid library, allowing you to physical computing from Google Chrome and Android.

![Welcome to Physicaloid](https://lh6.googleusercontent.com/-RWdnQPTTfdc/UnhUNfMT-sI/AAAAAAAAFr4/ZsmrO3t93lI/w668-h376-no/physicaloid_wp2_1920x1080.jpg)


Features
-----------------
- Android/Chromeからのコンフィグレーション
- USBシリアルインターフェース経由でのFPGA内部へのアクセス
- ALTERA CycloneIV E (EP4CE6E22C8N)搭載
- 64Mbit SDRAM (up to 133MHz)搭載
- 28本のユーザーI/O
- スタンドアロン動作をサポート
- USB給電のみで動作OK (過電流保護回路搭載)
- Arduinoシールドの流用可能(動作条件あり)
- オープンソース (クリエイティブコモンズ・CC BY 2.1)
  
- Configuration from the Android / Chrome.
- Provides access to the FPGA inside of a USB serial interface via.
- ALTERA CycloneIV E(EP4CE6E22C8N)
- 64Mbit SDRAM (up to 133MHz)
- User I/O of the 28 pins
- Support a stand-alone operation.
- Only USB power supply (On-board overcurrent protection).
- Possible diversion of Arduino shield (Due or later).
- Open-source (Creative Commons, CC BY 2.1)


Interface
-----------------
![PERIDOT Board Connector](https://lh3.googleusercontent.com/-mjnC-a-mvtM/UnhcuaqQL0I/AAAAAAAAFso/zZeyUkh4efw/w600-h468-no/peridot_board_connector.png)
- Manual RESET Key
システム全体のマニュアルリセットを行います。
- JTAG Connector
FPGAのJTAGピンが配置されています。
- Config MODE Selector
ボードのコンフィグモードを切り替えます。スタンドアロンで動作させる場合はAS側に、ホストからPhysicaloidライブラリでコンフィグを行う場合はPS側にセットします。
- Power supply and RESET
シールドへの電源供給とリセット信号が出力されます。電源は3.3V/100mA、USB 5V/100mAが使用できます。最大電流はUSBホストで制限されます。
- Digital I/O
FPGAのI/Oピンが配置されています。3.3Vを超える電圧を印加しないで下さい。
  
- Manual RESET Key
Manual reset of the entire system.
- JTAG Connector
JTAG pins of the FPGA are located.
- Config MODE Selector
Switching configuration mode of the board.
Set the AS side when operating in a stand-alone. Set PS side when performing configuration in Physicaloid library from the host.
- Power supply and RESET
It outputs a reset signal and power supply to the shield.
Power can be used 3.3V/100mA, USB 5V/100mA. Maximum current is limited by the USB host.
- Digital I/O
I/O pins of the FPGA are located. Do not apply a voltage of more than 3.3V.


Board block diagram and schematic
---------------------------------
![PERIDOT Block diagram](https://lh3.googleusercontent.com/-XpoVXE45BRU/UnhcutSOYOI/AAAAAAAAFss/-6QsIh6Is40/w700-h327-no/peridot_block.png)

(\*1) ASDIはスタンドアロンモードでのみ有効になります。
(\*2) スタンドアロンモードではリコンフィグキーになります。

(\*1) ASDI is only available in stand-alone mode.
(\*2) It becomes the reconfiguration key in stand-alone mode.


[Board schematic](https://github.com/osafune/peridot/blob/master/pcb/peridot_pcb_ver1.0.pdf)


License
-----------------
PERIDOT Hardware is released under the [Creative Commons,CC BY 2.1 JP](http://creativecommons.org/licenses/by/2.1/jp/legalcode)
![CC BY](http://creativecommons.jp/wp/wp-content/uploads/2009/10/by.png)

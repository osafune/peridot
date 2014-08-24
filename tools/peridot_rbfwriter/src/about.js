// ------------------------------------------------------------------- //
//  PERIDOT - RBF data writer                                          //
// ------------------------------------------------------------------- //
//
//  ver 0.1
//		2014/08/11	s.osafune@gmail.com
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


//  パネルの初期化 

window.onload = function() {
	var mainobj = window.opener;

	// パネルサイズの再セット(id付きオープンだとウィンドウサイズが無視されるため) 
	chrome.app.window.current().innerBounds.width  = 350;
	chrome.app.window.current().innerBounds.height = 360;

	// closeボタン 
	document.getElementById('closewin').addEventListener('click', function() {
			window.close();
		}, false);

	// アプリケーションタイトルを取得 
	document.getElementById('apps_title').innerHTML = mainobj.apps_title;

	// Versionを取得 
	document.getElementById('apps_ver').innerHTML = mainobj.apps_version;
	document.getElementById('lib_ver').innerHTML = mainobj.testps.version;
}


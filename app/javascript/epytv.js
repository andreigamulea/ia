
console.log('Script 1 din fisierul epytv.js');
  // Alte funcții sau logica fișierului aici

/**
 * Version: 2.0.4 - Pro
 */

"use strict";                           /** DO NOT EDIT !!! */

var defaultPlayerParameters = {
    "vq" : "hd1080",                    /** DEFAULT VIDEO QUALITY. POSSIBLE OPTIONS: highres, hd1080, hd720, large, medium and small */
    "loop" : "1",                       /** LOOP VIDEO */
    "controls" : "1",                   /** SHOW PLAYER CONTROLS */
    "showinfo" : "1",                   /** SHOW VIDEO DETAILS */
    "autohide" : "1",                   /** AUTOHIDE PLAYER COMMANDS AND VIDEO DETAILS */
    "modestbranding" : "1",             /** SHOW ONLY MINIMAL YOUTUBE BRANDING */
    "rel" : "1",                        /** SHOW RELATED VIDEOS AT THE END OF PLAYED VIDEO */
    "cc_load_policy" : "1",             /** Setting the parameter"s value to 1 causes closed captions to be shown by default, even if the user has turned captions off. */
    "color" : "red",                    /** This parameter specifies the color that will be used in the player"s video progress bar to highlight the amount of the video that the viewer has already seen. Valid parameter values are red and white. */
    "disablekb" : "1",                  /** Setting the parameter"s value to 1 causes the player to not respond to keyboard controls. */
    "fs" : "1",                         /** Setting this parameter to 0 prevents the fullscreen button from displaying in the player. */
    "hl" : "en",                        /** Sets the player"s interface language. See http://www.loc.gov/standards/iso639-2/php/code_list.php for full language code list. */
    "iv_load_policy" : "1",             /** Setting the parameter"s value to 1 causes video annotations to be shown by default, whereas setting to 3 causes video annotations to not be shown by default. */
    "playsinline" : "1",                /** This parameter controls whether videos play inline or fullscreen in an HTML5 player on iOS. */
    "mute" : "1",                       /** Prevents autoplay issue - https://www.reddit.com/r/youtube/comments/8ksool/embedded_autoplay_youtube_videos_stopped_playing/ */
    "allow" : "autoplay"
    };

/**
 * Define error messages
 * in your language here.
 */
var errorMessages = {
    0:"Service unavailable",
    1:"Unregistered video",  
    2:"Unregistered client",  
    3:"No client ID",  
    4:"Video unavailable",
    5:"OK",
    6:"Processing video"
};
/**
 * Version: 2.0.4 - Pro
 */

"use strict";                           /** DO NOT EDIT !!! */

var defaultPlayerParameters = {
    "vq" : "hd1080",                    /** DEFAULT VIDEO QUALITY. POSSIBLE OPTIONS: highres, hd1080, hd720, large, medium and small */
    "loop" : "1",                       /** LOOP VIDEO */
    "controls" : "1",                   /** SHOW PLAYER CONTROLS */
    "showinfo" : "1",                   /** SHOW VIDEO DETAILS */
    "autohide" : "1",                   /** AUTOHIDE PLAYER COMMANDS AND VIDEO DETAILS */
    "modestbranding" : "1",             /** SHOW ONLY MINIMAL YOUTUBE BRANDING */
    "rel" : "1",                        /** SHOW RELATED VIDEOS AT THE END OF PLAYED VIDEO */
    "cc_load_policy" : "1",             /** Setting the parameter"s value to 1 causes closed captions to be shown by default, even if the user has turned captions off. */
    "color" : "red",                    /** This parameter specifies the color that will be used in the player"s video progress bar to highlight the amount of the video that the viewer has already seen. Valid parameter values are red and white. */
    "disablekb" : "1",                  /** Setting the parameter"s value to 1 causes the player to not respond to keyboard controls. */
    "fs" : "1",                         /** Setting this parameter to 0 prevents the fullscreen button from displaying in the player. */
    "hl" : "en",                        /** Sets the player"s interface language. See http://www.loc.gov/standards/iso639-2/php/code_list.php for full language code list. */
    "iv_load_policy" : "1",             /** Setting the parameter"s value to 1 causes video annotations to be shown by default, whereas setting to 3 causes video annotations to not be shown by default. */
    "playsinline" : "1",                /** This parameter controls whether videos play inline or fullscreen in an HTML5 player on iOS. */
    "mute" : "1",                       /** Prevents autoplay issue - https://www.reddit.com/r/youtube/comments/8ksool/embedded_autoplay_youtube_videos_stopped_playing/ */
    "allow" : "autoplay"
    };

/**
 * Define error messages
 * in your language here.
 */
var errorMessages = {
    0:"Service unavailable",
    1:"Unregistered video",  
    2:"Unregistered client",  
    3:"No client ID",  
    4:"Video unavailable",
    5:"OK",
    6:"Processing video"
};
console.log('Script 2 din fisierul epytv.js');


/** --------------------------------------------------------------------- DON NOT EDIT ANYTHING BELLOW ---------------------------------------------------------------------- */

var _0x4c86=['opacity','playButton[','visibility','getElementById','=([^&#]*)','privacyStatus','image[','json','&etag=','epytvImage[','constructor','split','hidden','target','epytvPlayButton[','none','test','visible','style','getVideoData','innerHTML','exception','hostname','etag','playVideo','undefined','apply','epytvPlayerCounter[','replace','userAgent','(^|\x20)','href','ajax','videos','toString','[?&]','Player','<div\x20class=\x22errorMessageDiv\x22>','small','console','__proto__','body','responseCode','className','unMute','#FFFFFF\x200.02em\x200.02em\x200.2em;','display','data-params','getElementsByClassName','left','getAttribute','autoplay','data-privacy','info','trace','log','https://api.embedprivatevideo.com/loaded.php?video=%s','return\x20(function()\x20','readyState','exec','epyv-video-player','</div>','length','push','(\x20|$)','46%','textShadow','error','bind','data','https://api.embedprivatevideo.com/embed.php?v=6&videos=%s&client='];(function(_0x2cc0cb,_0x4fd349){var _0x4c869b=function(_0x586dad){while(--_0x586dad){_0x2cc0cb['push'](_0x2cc0cb['shift']());}};_0x4c869b(++_0x4fd349);}(_0x4c86,0xd2));var _0x586d=function(_0x2cc0cb,_0x4fd349){_0x2cc0cb=_0x2cc0cb-0x110;var _0x4c869b=_0x4c86[_0x2cc0cb];return _0x4c869b;};var _0x2b7a4a=_0x586d,isMobile=/iPhone|iPad|iPod|Android/i['test'](navigator[_0x2b7a4a(0x130)]),embedURL=_0x2b7a4a(0x112)+location['hostname'],loadedURL=_0x2b7a4a(0x14b),lockedVideos=[],players=[],autoPlayVideos=[],embedabble=[],releaseAttemptsLimit=0x3,statusChecksLimit=0x14,releaseAttempts=[],initialPrivacyStatus=[],playerParameters=[],videoDurationChecks=[],playerCounter=[],statusChecks=[],videoStatusTimeOutInterval=0x7d0,createPlayerTimeOutInterval=0x3e8,currentCounterValue=[],countdownIntervals=[],bufferTime=[];function r(_0x475903){var _0xba2ecb=_0x2b7a4a,_0x23c611=function(){var _0x27f407=!![];return function(_0x981b02,_0x1d795a){var _0x342310=_0x27f407?function(){var _0x4d0c74=_0x586d;if(_0x1d795a){var _0x1cf996=_0x1d795a[_0x4d0c74(0x12d)](_0x981b02,arguments);return _0x1d795a=null,_0x1cf996;}}:function(){};return _0x27f407=![],_0x342310;};}(),_0x16e278=_0x23c611(this,function(){var _0x5c215f=_0x586d,_0x2eed20=function(){var _0x5a2e9e=_0x586d,_0x4d8b37;try{_0x4d8b37=Function(_0x5a2e9e(0x14c)+'{}.constructor(\x22return\x20this\x22)(\x20)'+');')();}catch(_0x599bc5){_0x4d8b37=window;}return _0x4d8b37;},_0x169705=_0x2eed20(),_0xed15c2=_0x169705['console']=_0x169705[_0x5c215f(0x13a)]||{},_0x22a32d=[_0x5c215f(0x14a),'warn',_0x5c215f(0x148),_0x5c215f(0x156),_0x5c215f(0x128),'table',_0x5c215f(0x149)];for(var _0x140f46=0x0;_0x140f46<_0x22a32d[_0x5c215f(0x151)];_0x140f46++){var _0x2a8244=_0x23c611[_0x5c215f(0x11d)]['prototype'][_0x5c215f(0x110)](_0x23c611),_0x402ba7=_0x22a32d[_0x140f46],_0x10218a=_0xed15c2[_0x402ba7]||_0x2a8244;_0x2a8244[_0x5c215f(0x13b)]=_0x23c611[_0x5c215f(0x110)](_0x23c611),_0x2a8244['toString']=_0x10218a[_0x5c215f(0x135)][_0x5c215f(0x110)](_0x10218a),_0xed15c2[_0x402ba7]=_0x2a8244;}});_0x16e278(),/in/[_0xba2ecb(0x123)](document[_0xba2ecb(0x14d)])?setTimeout('r('+_0x475903+')',0x9):_0x475903();}r(function(){var _0x57f257=_0x2b7a4a;if(!document[_0x57f257(0x143)])var _0x463fa4=function(_0x1ee7a7,_0x251c83){var _0x3e6f10=_0x57f257,_0x3672a0=[],_0x45c351=new RegExp(_0x3e6f10(0x131)+_0x251c83+_0x3e6f10(0x153)),_0x37c6c6=_0x1ee7a7['getElementsByTagName']('*');for(var _0x202027=0x0,_0x35a578=_0x37c6c6[_0x3e6f10(0x151)];_0x202027<_0x35a578;_0x202027++)if(_0x45c351[_0x3e6f10(0x123)](_0x37c6c6[_0x202027][_0x3e6f10(0x13e)]))_0x3672a0[_0x3e6f10(0x152)](_0x37c6c6[_0x202027]);return _0x3672a0;},_0x1eb490=_0x463fa4(document[_0x57f257(0x13c)],_0x57f257(0x14f));else var _0x1eb490=document['getElementsByClassName'](_0x57f257(0x14f));var _0x300177=_0x1eb490[_0x57f257(0x151)],_0x5b3770={'origin':location['hostname'],'widget_referrer':location[_0x57f257(0x129)]};/iPhone|iPad|iPod|Android/i[_0x57f257(0x123)](navigator['userAgent'])===!![]&&(defaultPlayerParameters['vq']=_0x57f257(0x139));for(var _0x3e9fb2=0x0;_0x3e9fb2<_0x300177;_0x3e9fb2++){var _0x2b9577=document[_0x57f257(0x116)](_0x1eb490[_0x3e9fb2]['id']),_0x5e56c0={};_0x2b9577[_0x57f257(0x145)](_0x57f257(0x142))&&(_0x5e56c0=stringToJSON(_0x2b9577[_0x57f257(0x145)](_0x57f257(0x142)))),_0x2b9577['getAttribute'](_0x57f257(0x147))&&(initialPrivacyStatus[_0x1eb490[_0x3e9fb2]['id']]=_0x2b9577[_0x57f257(0x145)](_0x57f257(0x147))),playerParameters[_0x1eb490[_0x3e9fb2]['id']]=jsonConcat(defaultPlayerParameters,_0x5e56c0,_0x5b3770),_0x5e56c0[_0x57f257(0x146)]==0x1&&autoPlayVideos['push'](_0x1eb490[_0x3e9fb2]['id']);}autoPlayVideos[_0x57f257(0x151)]>0x0&&getVideoStatus(autoPlayVideos);});function createPlayer(_0x71b3d8){var _0x5dbad3=_0x2b7a4a;players[_0x71b3d8]=new YT[(_0x5dbad3(0x137))](_0x71b3d8,{'videoId':_0x71b3d8,'playerVars':playerParameters[_0x71b3d8],'events':{'onReady':onPlayerReady,'onStateChange':onPlayerStateChange}});}function onPlayerReady(_0x362c6d){var _0x5b7864=_0x2b7a4a,_0x5f5d4c=_0x362c6d['target'][_0x5b7864(0x126)](),_0x29cd01=_0x5f5d4c['video_id'],_0x15ffc3=_0x5b7864(0x121)+_0x29cd01+']',_0x5058b2='epytvImage['+_0x29cd01+']',_0x5a78ae=_0x5b7864(0x12e)+_0x29cd01+']';document['getElementById'](_0x29cd01)[_0x5b7864(0x125)]['visibility']=_0x5b7864(0x124),document['getElementById'](_0x29cd01)[_0x5b7864(0x125)][_0x5b7864(0x113)]=0x1,clearInterval(countdownIntervals[_0x29cd01]),document[_0x5b7864(0x116)](_0x5058b2)[_0x5b7864(0x125)][_0x5b7864(0x115)]=_0x5b7864(0x11f),document[_0x5b7864(0x116)](_0x5a78ae)[_0x5b7864(0x125)][_0x5b7864(0x141)]='none',players[_0x29cd01][_0x5b7864(0x13f)](),players[_0x29cd01]['playVideo']();}function getVideoStatus(_0x12d833,_0x469466=''){var _0xae112f=_0x2b7a4a,_0x3c1c9d=[],_0x1fee6c=encodeURI(embedURL[_0xae112f(0x12f)]('%s',_0x12d833['join'](','))+_0xae112f(0x11b)+_0x469466);jQuery[_0xae112f(0x133)]({'url':_0x1fee6c,'cache':![],'dataType':'json','crossDomain':!![],'success':function(_0xab6431){var _0x15e7d7=_0xae112f;for(var _0x5a026f in _0xab6431[_0x15e7d7(0x134)]){var _0x367d58=_0x15e7d7(0x121)+_0x5a026f+']',_0xfa591d=_0x15e7d7(0x11c)+_0x5a026f+']',_0x58b207='epytvPlayerCounter['+_0x5a026f+']';typeof statusChecks[_0x5a026f]==_0x15e7d7(0x12c)?statusChecks[_0x5a026f]=0x1:statusChecks[_0x5a026f]++;typeof currentCounterValue[_0x5a026f]==_0x15e7d7(0x12c)?currentCounterValue[_0x5a026f]=0xa:currentCounterValue[_0x5a026f]++;initialPrivacyStatus[_0x5a026f]=_0xab6431[_0x15e7d7(0x134)][_0x5a026f][_0x15e7d7(0x118)];if(_0xab6431[_0x15e7d7(0x134)][_0x5a026f][_0x15e7d7(0x13d)]==0x6)_0x3c1c9d[_0x15e7d7(0x152)](_0x5a026f);else _0xab6431[_0x15e7d7(0x134)][_0x5a026f][_0x15e7d7(0x13d)]==0x5?(embedabble[_0x5a026f]=!![],countdownIntervals[_0x5a026f]=setInterval(countdown,videoStatusTimeOutInterval,_0x58b207,_0x5a026f),typeof players[_0x5a026f]==_0x15e7d7(0x12c)&&createPlayer(_0x5a026f),document[_0x15e7d7(0x116)](_0x58b207)[_0x15e7d7(0x125)][_0x15e7d7(0x155)]=_0x15e7d7(0x140)):displayErrorMSG(_0x5a026f,_0xab6431[_0x15e7d7(0x134)][_0x5a026f][_0x15e7d7(0x13d)]);_0x3c1c9d[_0x15e7d7(0x151)]>0x0&&setTimeout(getVideoStatus,videoStatusTimeOutInterval,_0x3c1c9d,_0xab6431[_0x15e7d7(0x12a)]),document[_0x15e7d7(0x116)](_0x58b207)['style'][_0x15e7d7(0x144)]=_0x15e7d7(0x154),currentCounterValue[_0x5a026f]=currentCounterValue[_0x5a026f]-statusChecks[_0x5a026f],document[_0x15e7d7(0x116)](_0x58b207)[_0x15e7d7(0x127)]=currentCounterValue[_0x5a026f];}},'error':function(_0x226c17){var _0x48fa53=_0xae112f;statusChecks[_0x353a60]<statusChecksLimit&&getVideoStatus(_0x12d833,_0x469466);for(var _0x353a60 in data[_0x48fa53(0x134)]){displayErrorMSG(_0x353a60,0x0);}}});}function onPlayerStateChange(_0x32b847){var _0x4f3cfa=_0x2b7a4a,_0x146769=_0x32b847[_0x4f3cfa(0x120)][_0x4f3cfa(0x126)](),_0x5e0db6=_0x146769['video_id'],_0x402c12='epytvPlayButton['+_0x5e0db6+']',_0x4672b6=_0x4f3cfa(0x11c)+_0x5e0db6+']',_0x973f27=_0x4f3cfa(0x12e)+_0x5e0db6+']';if(_0x32b847[_0x4f3cfa(0x111)]==0x1&&typeof lockedVideos[_0x5e0db6]=='undefined'){var _0x23f838=loadedURL[_0x4f3cfa(0x12f)]('%s',_0x5e0db6);jQuery[_0x4f3cfa(0x133)]({'url':_0x23f838,'cache':![],'dataType':_0x4f3cfa(0x11a),'crossDomain':!![],'success':function(_0x33d7ea){bufferTime[_0x5e0db6]=0x0,countdownIntervals[_0x5e0db6]=setInterval(countdown,videoStatusTimeOutInterval,_0x973f27,_0x5e0db6);},'error':function(_0x433ff4){}}),lockedVideos[_0x5e0db6]=0x1;}_0x32b847[_0x4f3cfa(0x111)]==0x0&&(document[_0x4f3cfa(0x116)](_0x402c12)[_0x4f3cfa(0x125)][_0x4f3cfa(0x115)]=_0x4f3cfa(0x124),document[_0x4f3cfa(0x116)](_0x4672b6)['style'][_0x4f3cfa(0x115)]=_0x4f3cfa(0x124),document[_0x4f3cfa(0x116)](_0x5e0db6)[_0x4f3cfa(0x125)][_0x4f3cfa(0x115)]='hidden');}function stringToJSON(_0x511cd5){var _0xd84d68=_0x2b7a4a,_0x52cd52={},_0xc32bbd=_0x511cd5[_0xd84d68(0x11e)](',');for(var _0x5302d1=0x0;_0x5302d1<_0xc32bbd[_0xd84d68(0x151)];_0x5302d1++){var _0x3710ad=_0xc32bbd[_0x5302d1][_0xd84d68(0x11e)]('=');_0x52cd52[_0x3710ad[0x0]]=_0x3710ad[0x1];}return _0x52cd52;}function jsonConcat(_0x304bcb,_0x56b6da,_0x31ad52){var _0x4fd64a=Object['assign'](_0x304bcb,_0x56b6da,_0x31ad52);return _0x4fd64a;}function clickToPlay(_0x849d84){var _0x1ff32d=_0x2b7a4a,_0x3c3d63='epytvPlayButton['+_0x849d84+']',_0x40bbe8='epytvImage['+_0x849d84+']',_0x184303='epytvPlayerCounter['+_0x849d84+']';embedabble[_0x849d84]!==!![]?(getVideoStatus([_0x849d84]),document['getElementById'](_0x3c3d63)[_0x1ff32d(0x125)][_0x1ff32d(0x115)]='hidden',document[_0x1ff32d(0x116)](_0x184303)[_0x1ff32d(0x125)][_0x1ff32d(0x115)]=_0x1ff32d(0x124)):(document[_0x1ff32d(0x116)](_0x3c3d63)[_0x1ff32d(0x125)][_0x1ff32d(0x115)]='hidden',document['getElementById'](_0x40bbe8)[_0x1ff32d(0x125)][_0x1ff32d(0x115)]=_0x1ff32d(0x11f),document[_0x1ff32d(0x116)](_0x849d84)['style']['position']=null,document[_0x1ff32d(0x116)](_0x849d84)[_0x1ff32d(0x125)]['visibility']=_0x1ff32d(0x124),document[_0x1ff32d(0x116)](_0x849d84)['style'][_0x1ff32d(0x113)]=0x1,players[_0x849d84][_0x1ff32d(0x13f)](),players[_0x849d84]['playVideo']());}function playVideo(_0x1b76be){var _0xe2f805=_0x2b7a4a,_0x2776d6=_0xe2f805(0x121)+_0x1b76be+']',_0x34a72c=_0xe2f805(0x11c)+_0x1b76be+']',_0x5c25bc=_0xe2f805(0x12e)+_0x1b76be+']';clearInterval(countdownIntervals[_0x1b76be]),document[_0xe2f805(0x116)](_0x5c25bc)[_0xe2f805(0x125)][_0xe2f805(0x141)]=_0xe2f805(0x122),document[_0xe2f805(0x116)](_0x2776d6)['style']['visibility']='hidden',document[_0xe2f805(0x116)](_0x34a72c)['style'][_0xe2f805(0x115)]=_0xe2f805(0x11f),document[_0xe2f805(0x116)](_0x1b76be)[_0xe2f805(0x125)]['position']=null,document[_0xe2f805(0x116)](_0x1b76be)[_0xe2f805(0x125)][_0xe2f805(0x115)]=_0xe2f805(0x124),document[_0xe2f805(0x116)](_0x1b76be)[_0xe2f805(0x125)]['opacity']=0x1,players[_0x1b76be][_0xe2f805(0x12b)]();}function getQueryString(_0x13c371){var _0x5db9fc=_0x2b7a4a,_0x38a37b=window['location'][_0x5db9fc(0x132)],_0x224154=new RegExp(_0x5db9fc(0x136)+_0x13c371+_0x5db9fc(0x117),'i'),_0x42bd03=_0x224154[_0x5db9fc(0x14e)](_0x38a37b);return _0x42bd03?_0x42bd03[0x1]:null;};function displayErrorMSG(_0x4cca78,_0x515c01){var _0x561609=_0x2b7a4a;embedabble[_0x4cca78]=![];var _0x4158c9=_0x561609(0x114)+_0x4cca78+']',_0x50f960=_0x561609(0x119)+_0x4cca78+']',_0x530c08='epyv-container['+_0x4cca78+']',_0x1a99a4=document[_0x561609(0x116)](_0x530c08);_0x1a99a4[_0x561609(0x127)]=_0x561609(0x138)+errorMessages[_0x515c01]+_0x561609(0x150);}function countdown(_0x44062e,_0x494c3f){var _0x4d1022=_0x2b7a4a;currentCounterValue[_0x494c3f]>0x0?(currentCounterValue[_0x494c3f]=currentCounterValue[_0x494c3f]-0x1,document[_0x4d1022(0x116)](_0x44062e)[_0x4d1022(0x125)][_0x4d1022(0x115)]=_0x4d1022(0x124),document[_0x4d1022(0x116)](_0x44062e)[_0x4d1022(0x127)]=currentCounterValue[_0x494c3f],bufferTime[_0x494c3f]=bufferTime[_0x494c3f]+0x1,currentCounterValue[_0x494c3f]==0x0&&(clearInterval(countdownIntervals[_0x494c3f]),document[_0x4d1022(0x116)](_0x44062e)[_0x4d1022(0x125)][_0x4d1022(0x115)]='hidden')):clearInterval(countdownIntervals[_0x494c3f]);}



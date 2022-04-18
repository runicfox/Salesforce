﻿/*!
 * WalkMe
 * http://www.walkme.com/
 *
 * Copyright 2012, WalkMe ltd
 */
function WalkmeSnippet(){window._walkmeInternals=window._walkmeInternals||{},function(e){try{if(e.timing){e.timing.perf={};for(var n=0;n<e.timing.list.length;n++)e.timing.perf[e.timing.list[n].name]=W()-(Date.now()-e.timing.list[n].time)}}catch(e){}}(window._walkmeInternals),U("snippetStartInit",{mark:!0});var e,r,a,o,s,l,n,u=this,t=!1,i="40",w=0,d={publish:0,preview:1},c=d.publish,m="3",f="abbef7c6bb864b5f8c906df84ce43a9a";function g(e){l.snippetLog.push(e)}function _(){window["walkme_custom_settings_data"]?(g("lso"),p(walkme_custom_settings_data)):(g("lsp"),U("settingsFileStartLoad",{mark:!0}),F(o,null,l.isSelfHosted,"fixedCallback",p))}function p(e){if(U("settingsFileEndLoad",{mark:!0,measureName:"SettingsFile",startMark:"settingsFileStartLoad"}),!C()&&window.document.dontLoadTriangle)return window["walkme_snippet_blocked"]=!0,l.blocked=!0,void(l.continueLoad=function(){k(e)});g("cls"),k(e)}function k(n){r=T(n),window.walkme&&window.walkme.prepCdnFormat&&(n.PublicPath=window.walkme.prepCdnFormat(n.PublicPath),Object.keys(n.Components||{}).forEach(function(e){n.Components[e]=window.walkme.prepCdnFormat(n.Components[e])}));var e=window.walkme_settings_callback||window.walkme&&window.walkme.walkme_settings_callback||window._walkmeConfig&&window._walkmeConfig.walkme_settings_callback;e&&e(r);var t=x("walkme_is_enabled_override");if(void 0!==t){if("0"===t)return}else if(!n.IsEnabled)return;!function(e){if(window.walkme_custom_jquery)window.mtjQuery=walkme_custom_jquery,v();else{var n=O("walkmeCustomjQueryUrl");if(0!=n&&(e=n),l.localjQueryUrlPath){var t=e.lastIndexOf("/"),r=e.substring(t+1);e=l.localjQueryUrlPath+r}F(e,v)}}(n.jQueryFile),function(e){if(!function(){var e=document.createElement("link").relList;return!!(e&&e.supports&&e.supports("preload"))}()||O("wm_skipPreload"))return g("spls");g("pls"),D(y(e)),D(b(e)),D(e.WalkMeConfigFile);try{0!==e.DataFiles[0].languages.length||function(e){return/json($|\?)/.test(function(e){return e.split(".").pop()}(e))}(e.DataFiles[0].url)||D(e.DataFiles[0].url)}catch(e){}g("prc"),M(e.PlayerApiServer),function(e){var n=e.Storage;return!!n&&1===n["ss"]}(e)&&M(e.PlayerServer)}(n)}function v(){if(U("jQueryScriptLoaded",{mark:!0,measureName:"jQueryLoaded",startMark:"settingsFileEndLoad"}),null==window["mtjQuery"])return;if(t)return;t=!0,window.walkme_custom_jquery||mtjQuery.noConflict(),r.WaitDocumentReady?(g("wdr"),mtjQuery(document).ready(function(){U("jQueryDocumentReadyEvent",{measureName:"jQueryDocumentReady",startMark:"jQueryScriptLoaded"}),h(r)})):(g("ndr"),h(r))}function h(e){U("jQueryDocumentReady");try{(t=y(n=e))&&""!=t?(U("preLibStartLoad",{mark:!0}),window["walkme_pre_lib_loaded"]=function(){window["walkme_pre_lib_loaded"]=function(){try{console.log("walkme_pre_lib_loaded was called twice.")}catch(e){}},E(n)},F(t)):E(n)}catch(e){}var n,t}function S(e){try{var n=x("wm_load_test_"+f+"_"+m),t=parseInt(n);if(t)return U("startLoadingTest"),_walkmeInternals.loadingTestDone=function(){U("endLoadingTest"),_walkmeInternals.loadingTestDone=void 0,e&&e()},void setTimeout(_walkmeInternals.loadingTestDone,1e3*t)}catch(e){}e&&e()}function b(e){var n;l.localLibUrl&&(n=l.localLibUrl);var t=O("walkmeCustomeLibUrl");if(0!=t)return t;return n||e.LibFile}function y(e){return O("wm-prelibjs")||e.PreLibJsFile}function E(e){U("libStartLoad",{mark:!0,measureName:"Prelib",startMark:"preLibStartLoad"}),F(b(e))}function L(){return C()?"wmPreviewSnippet":"wmSnippet"}function C(){return c==d.preview}function I(){this.recorderServer="###RECORDER_SERVER_NAME###",this.cdnServerName="###AUTO_DETECT###",this.storage="proxy",this.userGuids=["abbef7c6bb864b5f8c906df84ce43a9a"],window.walkme_custom_cdn_server&&(this.cdnServerName=walkme_custom_cdn_server),window.walkme_custom_app_server&&(this.recorderServer=walkme_custom_app_server),window.walkme_custom_data_url?this.triangleUrl=walkme_custom_data_url:this.triangleUrl=this.cdnServerName+"###SPECIAL_TRIANGLE_FILE###",window.walkme_custom_datafile_url?this.datafilesArray=walkme_custom_datafile_url:this.datafilesArray="###SPECIAL_DATA_FILE###",window.walkme_custom_widget_url?this.widgetUrl=walkme_custom_widget_url:this.widgetUrl="###SPECIAL_WIDGET_FILE###"}function T(e){if(null==s)return e;return function e(n,t){{if("string"==typeof n)return t(n);if("[object Array]"===Object.prototype.toString.call(n)){for(var r=0;r<n.length;r++)n[r]=e(n[r],t);return n}if("object"==typeof n){for(var r in n)Object.hasOwnProperty.call(n,r)&&(n[r]=e(n[r],t));return n}}return n}(e,function(e){return e.replace("###AUTO_DETECT###",s)})}function O(e){try{var n=window.localStorage.getItem(e);if(null!=n)return n}catch(e){}return!1}function A(e){return new RegExp(e,"i").test(navigator.userAgent||navigator.vendor||window.opera)}function D(e){P(e,"preload","script")}function M(e){P(e,"preconnect")}function P(e,n,t){if(!e)return;try{var r=document.createElement("link");r.href=e,window&&window.walkme&&window.walkme.prepCdnFormat&&(r.href=window.walkme.prepCdnFormat(r.href)),r.rel=n,t&&(r.as=t),r.id="wm_link"+w++,N().appendChild(r)}catch(e){}}function F(e,n,t,r,i){var a=document.createElement("script");a.async=!0,window._walkmeConfig=window._walkmeConfig||{},t&&!0!==window._walkmeConfig.disableWMTS&&(e+=(-1==e.indexOf("?")?"?":"&")+"_wmts="+(new Date).getTime()),a.src=e,window&&window.walkme&&window.walkme.prepCdnFormat&&(a.src=window.walkme.prepCdnFormat(a.src)),a.id="mt_script",n&&(a.onload=n,a.onreadystatechange=n),function(n,t){if(n&&t){var r=window[n];window[n]=function(e){window[n]=r,t(e)}}}(r,i),N().appendChild(a)}function N(){return e=e||document.getElementsByTagName("head")[0]}function j(e){return e.replace(/^\s+|\s+$/g,"")}function x(e,n){var t=n?O(e):function(e){var n,t,r,i=document.cookie.split(";");for(n=0;n<i.length;n++)if(t=i[n].substr(0,i[n].indexOf("=")),r=i[n].substr(i[n].indexOf("=")+1),(t=t.replace(/^\s+|\s+$/g,""))==e)return r;return!1}(e);if(!1!==t)return t;var r=window[e]||window.walkme&&window.walkme[e]||window._walkmeConfig&&window._walkmeConfig[e];if(null!=r)return r;return}function R(e){if(void 0===n&&(n=O("wmAddPerfMeasures")),n)return!e||e<=n;return!1}function U(e,n){try{var t,r,i=W(),a=Date.now();if(r=_walkmeInternals.timing?a-(t=_walkmeInternals.timing).list[t.list.length-1].time:((t=_walkmeInternals.timing={}).map={},t.perf={},t.list=[],t.delta=[],0),n&&n.level&&!R(n.level))return;t.map[e]=a,t.perf[e]=i,t.list.push({name:e,time:a}),t.delta.push({name:e,delta:r}),function(e,n){if(!n||!R(n.level))return;var t="wm-",r=t+e;if(n.mark&&performance.mark(r),n.measureName){var i=n.startMark&&t+n.startMark,a=n.endMark&&t+n.endMark;performance.measure(t+n.measureName,i,a)}}(e,n)}catch(e){}}function W(){if(window.performance&&window.performance.now)return parseInt(window.performance.now())}function Q(e,n){try{g(e),console.log(n)}catch(e){}}if(this.getSnippetVersion=function(){return i},this.getSettingsFile=function(){return r},this.getServerSettings=function(){return a},this.fixAutoDetectPaths=T,!_walkmeInternals.__tti&&"PerformanceObserver"in window){var G=[];if("PerformanceResourceTiming"in window&&G.push("resource"),"PerformancePaintTiming"in window&&G.push("paint"),"PerformanceLongTaskTiming"in window&&G.push("longtask"),"LargestContentfulPaint"in window&&G.push("largest-contentful-paint"),0<G.length){var V=_walkmeInternals.__tti={e:[]};V.o=new PerformanceObserver(function(e){V.e=V.e.concat(e.getEntries())}),V.o.observe({entryTypes:G})}}setTimeout(function(){if(window._walkmeConfig=window._walkmeConfig||{},(l=_walkmeInternals).snippetLog=[],l.addTimeStamp=U,window.doNotLoadWalkMe)return g("dlw"),void(l.removeWalkMeReason="doNotLoadWalkMe variable on the window");if(_walkmeInternals.loadingTestDone)return void Q("ltt","WalkMe Loading Test is already running - aborting snippet");var e;g("ish"),l.isSelfHosted="true"=="true",g("ssm"),"###IS_PREVIEW_MODE###"=="true"&&(c=d.preview),a=new I,g("lsu");var n=false==1||false&&A("android|blackberry|iemobile|ip(ad|hone|od)|phone|symbian|windows (ce|phone)");if(n?(g("lsm"),e="###GET_MOBILE_SETTINGS_URL###",_walkmeConfig.platform=3):(g("lsw"),e="###AUTO_DETECT###/settings.txt"),-1<a.cdnServerName.indexOf("###AUTO_DETECT###")&&(g("lad"),s=function(e,n){for(var t=document.getElementsByTagName("script"),r="###MOBILE_WEB_USER_GUID###",i=0;i<t.length;i++){var a=t[i].src;if(a&&0<a.indexOf("walkme_")){if(e){i=a.indexOf(e);var o=j(a.substr(0,i));g("dst")}else{i=a.indexOf("walkme_"),o=j(a.substr(0,i-1));g("dso")}return n&&l.isSelfHosted&&(o=o.split(f).join(r),g("dsm")),o}}return""}(a.cdnServerName.replace("###AUTO_DETECT###",""),n),a=T(a)),e=function(e){var n=x("walkme_segmented_settings_"+f+"_"+m,!0);if(n)return g("seg"),n;return e}(e),o=function(e){var n="walkme_custom_user_settings_",t=x(n+"url",!0),r=x(n+"guid",!0),i=x(n+"env",!0),a=function(){var e=O("walkMe_wm-settings-cache-bust");if(e){var n=/{"val":"(true|false)","exp":(\d+)}/.exec(e);if(n&&"true"==n[1]&&(new Date).getTime()<parseInt(n[2]))return!0}return window.walkme&&window.walkme.walkme_settings_cache_bust||window._walkmeConfig.walkme_settings_cache_bust||!1}();t&&(e=t);r&&(e=e.replace(/(users\/)([^\/]*)(\/)/,"$1"+r+"$3"));!i&&""!==i||(i&&(i+="/"),e=e.replace(/(users\/[^\/]*\/)(.*)(sett)/,"$1"+i+"$3"));e=T(e),l.settingsUrl=e,g(a?"cb":"ncb"),a&&(e+="?forceUpdate="+(new Date).getTime());return e}(e),a=a,g("cli"),_walkmeConfig.smartLoad){if(top!=window&&!function(){try{if(parent.location.href)return!1}catch(e){}return!0}()&&function(){try{var e=window;do{if((e=e.parent.window)._walkmeConfig)return!0}while(e!=top)}catch(e){}return!1}())return}else if(1!=window["walkme_load_in_iframe"]&&top!=window)return;if(g("cuc"),!n&&!function(){if("1"===x("walkme_dont_check_browser")||C())return!0;var e=function(){var e={init:function(){this.browser=this.searchString(this.dataBrowser)||"An unknown browser",this.version=this.searchVersion(navigator.userAgent)||this.searchVersion(navigator.appVersion)||"an unknown version",this.OS=this.searchString(this.dataOS)||"an unknown OS"},searchString:function(e){for(var n=0;n<e.length;n++){var t=e[n].string,r=e[n].prop;if(this.versionSearchString=e[n].versionSearch||e[n].identity,t){if(-1!=t.indexOf(e[n].subString))return e[n].identity}else if(r)return e[n].identity}},searchVersion:function(e){var n=e.indexOf(this.versionSearchString);if(-1==n)return;return parseFloat(e.substring(n+this.versionSearchString.length+1))},dataBrowser:[{string:navigator.userAgent,subString:"Chrome",identity:"Chrome"},{string:navigator.userAgent,subString:"OmniWeb",versionSearch:"OmniWeb/",identity:"OmniWeb"},{string:navigator.vendor,subString:"Apple",identity:"Safari",versionSearch:"Version"},{prop:window.opera,identity:"Opera",versionSearch:"Version"},{string:navigator.vendor,subString:"iCab",identity:"iCab"},{string:navigator.vendor,subString:"KDE",identity:"Konqueror"},{string:navigator.userAgent,subString:"Firefox",identity:"Firefox"},{string:navigator.vendor,subString:"Camino",identity:"Camino"},{string:navigator.userAgent,subString:"Netscape",identity:"Netscape"},{string:navigator.userAgent,subString:"MSIE",identity:"Explorer",versionSearch:"MSIE"},{string:navigator.userAgent,subString:"Trident",identity:"Explorer",versionSearch:" rv"},{string:navigator.userAgent,subString:"Edge",identity:"Edge"},{string:navigator.userAgent,subString:"Gecko",identity:"Mozilla",versionSearch:"rv"},{string:navigator.userAgent,subString:"Mozilla",identity:"Netscape",versionSearch:"Mozilla"}],dataOS:[{string:navigator.platform,subString:"Win",identity:"Windows"},{string:navigator.platform,subString:"Mac",identity:"Mac"},{string:navigator.userAgent,subString:"iPhone",identity:"iPhone/iPod"},{string:navigator.platform,subString:"Linux",identity:"Linux"}]};if(e.init(),"Chrome"==e.browser||"Firefox"==e.browser||"Safari"==e.browser&&"Windows"!=e.OS)return!0;if("Explorer"==e.browser&&7<=e.version)return!0;return Q("icb","WalkMe: Incompatible browser."),!1}(),n=!A("android.+mobile|blackberry|iemobile|ip(hone|od)|phone|symbian|windows (ce|phone)")&&!function(){var e=Math.max(screen.width,screen.height),n=Math.min(screen.width,screen.height);return e<800||n<600}();return e&&n}()){try{g("bns"),walkme_browser_not_supported()}catch(e){}return}g("exl");var t,r=window[L()],i=l.blocked;if(g("lsl"),t=L(),window[t]=u,g("ipm"),!C()&&(g("clt"),window.document.dontLoadTriangle))return g("bsl"),window["walkme_snippet_blocked"]=!0,l.blocked=!0,void(l.continueLoad=function(){S(_)});g("slb"),r&&!i&&Q("slt","WalkMe Snippet was loaded twice"),g("lss"),S(_),g("eok")},0)}new WalkmeSnippet;
!function(e){function t(t){for(var r,a,c=t[0],i=t[1],f=t[2],l=0,p=[];l<c.length;l++)a=c[l],Object.prototype.hasOwnProperty.call(o,a)&&o[a]&&p.push(o[a][0]),o[a]=0;for(r in i)Object.prototype.hasOwnProperty.call(i,r)&&(e[r]=i[r]);for(s&&s(t);p.length;)p.shift()();return u.push.apply(u,f||[]),n()}function n(){for(var e,t=0;t<u.length;t++){for(var n=u[t],r=!0,c=1;c<n.length;c++){var i=n[c];0!==o[i]&&(r=!1)}r&&(u.splice(t--,1),e=a(a.s=n[0]))}return e}var r={},o={6:0,14:0},u=[];function a(t){if(r[t])return r[t].exports;var n=r[t]={i:t,l:!1,exports:{}};return e[t].call(n.exports,n,n.exports,a),n.l=!0,n.exports}a.m=e,a.c=r,a.d=function(e,t,n){a.o(e,t)||Object.defineProperty(e,t,{enumerable:!0,get:n})},a.r=function(e){"undefined"!=typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(e,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(e,"__esModule",{value:!0})},a.t=function(e,t){if(1&t&&(e=a(e)),8&t)return e;if(4&t&&"object"==typeof e&&e&&e.__esModule)return e;var n=Object.create(null);if(a.r(n),Object.defineProperty(n,"default",{enumerable:!0,value:e}),2&t&&"string"!=typeof e)for(var r in e)a.d(n,r,function(t){return e[t]}.bind(null,r));return n},a.n=function(e){var t=e&&e.__esModule?function(){return e.default}:function(){return e};return a.d(t,"a",t),t},a.o=function(e,t){return Object.prototype.hasOwnProperty.call(e,t)},a.p="dist/js/";var c=window.webpackJsonp=window.webpackJsonp||[],i=c.push.bind(c);c.push=t,c=c.slice();for(var f=0;f<c.length;f++)t(c[f]);var s=i;u.push([15,0]),n()}({15:function(e,t,n){"use strict";n.r(t);var r=n(3);document.addEventListener("DOMContentLoaded",(function(){Object(r.redirect)();for(var e=document.querySelectorAll("[data-href]"),t=function(t){e[t].addEventListener("click",(function(){!function(e){window.location.href=e}(e[t].dataset.href)}))},n=0;n<e.length;n++)t(n)}))},3:function(e,t,n){"use strict";n.r(t),n.d(t,"redirect",(function(){return i}));var r=n(0),o=n.n(r),u=n(1),a=n.n(u),c=n(2);function i(){return f.apply(this,arguments)}function f(){return(f=a()(o.a.mark((function e(){var t,n,r,u,i;return o.a.wrap((function(e){for(;;)switch(e.prev=e.next){case 0:return t=document.getElementById("logout"),n=document.getElementById("user-name"),e.next=4,Object(c.authenticate)();case 4:if(null===(r=e.sent)||!r.id||"admin"!==r.userRole){e.next=16;break}return e.next=8,Object(c.getUser)(r.id);case 8:if(e.t0=e.sent,e.t0){e.next=11;break}e.t0={firstName:"User"};case 11:u=e.t0,i=u.user,n.textContent="".concat(i.firstName," ").concat(i.lastName||""),e.next=16;break;case 16:t.addEventListener("click",function(){var e=a()(o.a.mark((function e(t){return o.a.wrap((function(e){for(;;)switch(e.prev=e.next){case 0:return t.preventDefault(),e.next=3,Object(c.logout)();case 3:case"end":return e.stop()}}),e)})));return function(t){return e.apply(this,arguments)}}());case 17:case"end":return e.stop()}}),e)})))).apply(this,arguments)}}});
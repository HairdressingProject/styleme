!function(e){function t(t){for(var a,c,o=t[0],l=t[1],i=t[2],u=0,f=[];u<o.length;u++)c=o[u],Object.prototype.hasOwnProperty.call(r,c)&&r[c]&&f.push(r[c][0]),r[c]=0;for(a in l)Object.prototype.hasOwnProperty.call(l,a)&&(e[a]=l[a]);for(s&&s(t);f.length;)f.shift()();return d.push.apply(d,i||[]),n()}function n(){for(var e,t=0;t<d.length;t++){for(var n=d[t],a=!0,o=1;o<n.length;o++){var l=n[o];0!==r[l]&&(a=!1)}a&&(d.splice(t--,1),e=c(c.s=n[0]))}return e}var a={},r={8:0,14:0},d=[];function c(t){if(a[t])return a[t].exports;var n=a[t]={i:t,l:!1,exports:{}};return e[t].call(n.exports,n,n.exports,c),n.l=!0,n.exports}c.m=e,c.c=a,c.d=function(e,t,n){c.o(e,t)||Object.defineProperty(e,t,{enumerable:!0,get:n})},c.r=function(e){"undefined"!=typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(e,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(e,"__esModule",{value:!0})},c.t=function(e,t){if(1&t&&(e=c(e)),8&t)return e;if(4&t&&"object"==typeof e&&e&&e.__esModule)return e;var n=Object.create(null);if(c.r(n),Object.defineProperty(n,"default",{enumerable:!0,value:e}),2&t&&"string"!=typeof e)for(var a in e)c.d(n,a,function(t){return e[t]}.bind(null,a));return n},c.n=function(e){var t=e&&e.__esModule?function(){return e.default}:function(){return e};return c.d(t,"a",t),t},c.o=function(e,t){return Object.prototype.hasOwnProperty.call(e,t)},c.p="dist/";var o=window.webpackJsonp=window.webpackJsonp||[],l=o.push.bind(o);o.push=t,o=o.slice();for(var i=0;i<o.length;i++)t(o[i]);var s=l;d.push([17,0]),n()}({17:function(e,t,n){"use strict";n.r(t);var a=n(3);Object(a.redirect)();var r,d=document.getElementsByClassName("_tables-row"),c=document.getElementById("btn-clear"),o=document.getElementById("btn-restore"),l=document.getElementById("btn-cancel"),i=(document.getElementById("edit-form"),document.getElementsByClassName("_table-btn")),s=document.querySelector('[data-open="edit-modal"]'),u=document.querySelector('[data-open="delete-modal"]'),f={id:"",shapeName:"",dateCreated:"",dateModified:""};function m(e){e.classList.remove("_row-selected");for(var t=0;t<i.length;t++)i[t].classList.contains("_table-btn-add")||(i[t].classList.add("_table-btn-disabled"),i[t].disabled=!0)}function p(){b(),document.getElementById("selected-id-edit").value=f.id,document.getElementById("selected-shapeName-edit").value=f.shapeName}function b(){var e=f.id||r.cells[0].textContent,t=f.shapeName||r.cells[1].textContent,n=f.dateCreated||r.cells[2].textContent,a=f.dateModified||r.cells[3].textContent;f={id:e,shapeName:t,dateCreated:n,dateModified:a}}document.addEventListener("click",(function(e){e.target.classList.contains("_tables-cell")?function(e){for(var t=0;t<d.length;t++)m(d[t]);e.classList.add("_row-selected"),f={},b();for(var n=0;n<i.length;n++)i[n].classList.contains("_table-btn-add")||(i[n].classList.remove("_table-btn-disabled"),i[n].disabled=!1)}(r=e.target.parentElement):r&&!e.target.classList.contains("_table-btn")&&(m(r),r=null)})),s.addEventListener("click",(function(){r&&p()})),u.addEventListener("click",(function(){r&&(b(),document.getElementById("selected-id-delete").textContent=f.id,document.getElementById("delete_id").value=f.id,document.getElementById("selected-shapeName-delete").textContent=f.shapeName,document.getElementById("selected-date_created-delete").textContent=f.dateCreated,document.getElementById("selected-date_modified-delete").textContent=f.dateModified)})),o.addEventListener("click",(function(e){e.preventDefault(),p()})),c.addEventListener("click",(function(e){e.preventDefault(),document.getElementById("selected-shapeName-add").value=""})),l.addEventListener("click",(function(e){e.preventDefault(),document.getElementById("close-delete-modal").click()}))},3:function(e,t,n){"use strict";n.r(t),n.d(t,"redirect",(function(){return l}));var a=n(0),r=n.n(a),d=n(1),c=n.n(d),o=n(2);function l(){return i.apply(this,arguments)}function i(){return(i=c()(r.a.mark((function e(){var t,n,a,d,l;return r.a.wrap((function(e){for(;;)switch(e.prev=e.next){case 0:return t=document.getElementById("logout"),n=document.getElementById("user-name"),e.next=4,Object(o.authenticate)();case 4:if(!(a=e.sent)){e.next=16;break}return e.next=8,Object(o.getUser)(a);case 8:if(e.t0=e.sent,e.t0){e.next=11;break}e.t0={firstName:"User"};case 11:d=e.t0,l=d.user,n.textContent="".concat(l.firstName," ").concat(l.lastName||""),e.next=17;break;case 16:window.location.replace("/sign_in.php");case 17:t.addEventListener("click",function(){var e=c()(r.a.mark((function e(t){return r.a.wrap((function(e){for(;;)switch(e.prev=e.next){case 0:return t.preventDefault(),e.next=3,Object(o.logout)();case 3:case"end":return e.stop()}}),e)})));return function(t){return e.apply(this,arguments)}}());case 18:case"end":return e.stop()}}),e)})))).apply(this,arguments)}}});
!function(e){function t(t){for(var r,l,d=t[0],i=t[1],c=t[2],s=0,f=[];s<d.length;s++)l=d[s],Object.prototype.hasOwnProperty.call(a,l)&&a[l]&&f.push(a[l][0]),a[l]=0;for(r in i)Object.prototype.hasOwnProperty.call(i,r)&&(e[r]=i[r]);for(u&&u(t);f.length;)f.shift()();return o.push.apply(o,c||[]),n()}function n(){for(var e,t=0;t<o.length;t++){for(var n=o[t],r=!0,d=1;d<n.length;d++){var i=n[d];0!==a[i]&&(r=!1)}r&&(o.splice(t--,1),e=l(l.s=n[0]))}return e}var r={},a={9:0,14:0},o=[];function l(t){if(r[t])return r[t].exports;var n=r[t]={i:t,l:!1,exports:{}};return e[t].call(n.exports,n,n.exports,l),n.l=!0,n.exports}l.m=e,l.c=r,l.d=function(e,t,n){l.o(e,t)||Object.defineProperty(e,t,{enumerable:!0,get:n})},l.r=function(e){"undefined"!=typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(e,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(e,"__esModule",{value:!0})},l.t=function(e,t){if(1&t&&(e=l(e)),8&t)return e;if(4&t&&"object"==typeof e&&e&&e.__esModule)return e;var n=Object.create(null);if(l.r(n),Object.defineProperty(n,"default",{enumerable:!0,value:e}),2&t&&"string"!=typeof e)for(var r in e)l.d(n,r,function(t){return e[t]}.bind(null,r));return n},l.n=function(e){var t=e&&e.__esModule?function(){return e.default}:function(){return e};return l.d(t,"a",t),t},l.o=function(e,t){return Object.prototype.hasOwnProperty.call(e,t)},l.p="dist/";var d=window.webpackJsonp=window.webpackJsonp||[],i=d.push.bind(d);d.push=t,d=d.slice();for(var c=0;c<d.length;c++)t(d[c]);var u=i;o.push([18,0]),n()}([,,,function(e,t,n){"use strict";n.r(t),n.d(t,"redirect",(function(){return i}));var r=n(0),a=n.n(r),o=n(1),l=n.n(o),d=n(2);function i(){return c.apply(this,arguments)}function c(){return(c=l()(a.a.mark((function e(){var t,n,r,o,i;return a.a.wrap((function(e){for(;;)switch(e.prev=e.next){case 0:return t=document.getElementById("logout"),n=document.getElementById("user-name"),e.next=4,Object(d.authenticate)();case 4:if(!(r=e.sent)){e.next=16;break}return e.next=8,Object(d.getUser)(r);case 8:if(e.t0=e.sent,e.t0){e.next=11;break}e.t0={firstName:"User"};case 11:o=e.t0,i=o.user,n.textContent="".concat(i.firstName," ").concat(i.lastName||""),e.next=17;break;case 16:window.location.replace("/sign_in.php");case 17:t.addEventListener("click",function(){var e=l()(a.a.mark((function e(t){return a.a.wrap((function(e){for(;;)switch(e.prev=e.next){case 0:return t.preventDefault(),e.next=3,Object(d.logout)();case 3:case"end":return e.stop()}}),e)})));return function(t){return e.apply(this,arguments)}}());case 18:case"end":return e.stop()}}),e)})))).apply(this,arguments)}},function(e,t,n){var r=n(6),a=n(7),o=n(8),l=n(9);e.exports=function(e){return r(e)||a(e)||o(e)||l()}},function(e,t){e.exports=function(e,t){(null==t||t>e.length)&&(t=e.length);for(var n=0,r=new Array(t);n<t;n++)r[n]=e[n];return r}},function(e,t,n){var r=n(5);e.exports=function(e){if(Array.isArray(e))return r(e)}},function(e,t){e.exports=function(e){if("undefined"!=typeof Symbol&&Symbol.iterator in Object(e))return Array.from(e)}},function(e,t,n){var r=n(5);e.exports=function(e,t){if(e){if("string"==typeof e)return r(e,t);var n=Object.prototype.toString.call(e).slice(8,-1);return"Object"===n&&e.constructor&&(n=e.constructor.name),"Map"===n||"Set"===n?Array.from(e):"Arguments"===n||/^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)?r(e,t):void 0}}},function(e,t){e.exports=function(){throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method.")}},,,,,,,,,function(e,t,n){"use strict";n.r(t);var r=n(4),a=n.n(r),o=n(3);Object(o.redirect)();var l,d=document.getElementsByClassName("_tables-row"),i=document.getElementById("btn-clear"),c=document.getElementById("btn-restore"),u=document.getElementById("btn-cancel"),s=(document.getElementById("edit-form"),document.getElementsByClassName("_table-btn")),f=document.querySelector('[data-open="edit-modal"]'),m=document.querySelector('[data-open="delete-modal"]'),p={id:"",hairLengthId:"",hairLengthName:"",linkName:"",linkUrl:"",dateCreated:"",dateModified:""};function g(e){e.classList.remove("_row-selected");for(var t=0;t<s.length;t++)s[t].classList.contains("_table-btn-add")||(s[t].classList.add("_table-btn-disabled"),s[t].disabled=!0)}function y(){h(),document.getElementById("selected-id-edit").value=p.id,document.getElementById("selected-hairLength-edit").value=p.hairLengthId,document.getElementById("selected-linkName-edit").value=p.linkName,document.getElementById("selected-linkUrl-edit").value=p.linkUrl}function b(){l&&(h(),document.getElementById("selected-id-delete").textContent=p.id,document.getElementById("delete_id").value=p.id,document.getElementById("selected-hairLength-delete").textContent=p.hairLengthName,document.getElementById("selected-linkName-delete").textContent=p.linkName,document.getElementById("selected-linkUrl-delete").textContent=p.linkUrl,document.getElementById("selected-date_created-delete").textContent=p.dateCreated,document.getElementById("selected-date_modified-delete").textContent=p.dateModified)}function h(){var e=p.id||l.cells[0].textContent,t=p.hairLengthId||l.cells[1].dataset.hairLengthId,n=document.querySelectorAll("[data-hair-length-id]"),r=a()(n).filter((function(e){return e.dataset.hairLengthId===t}))[0],o=p.hairLengthName||r.textContent,d=p.linkName||l.cells[2].textContent,i=p.linkUrl||l.cells[3].textContent,c=p.dateCreated||l.cells[4].textContent,u=p.dateModified||l.cells[5].textContent;p={id:e,hairLengthId:t,hairLengthName:o,linkName:d,linkUrl:i,dateCreated:c,dateModified:u}}function v(e){e.preventDefault(),y()}function x(e){e.preventDefault(),document.getElementById("selected-linkName-add").value="",document.getElementById("selected-linkUrl-add").value=""}function E(e){e.preventDefault(),document.getElementById("close-delete-modal").click()}document.addEventListener("DOMContentLoaded",(function(){document.addEventListener("click",(function(e){e.target.classList.contains("_tables-cell")?function(e){for(var t=0;t<d.length;t++)g(d[t]);e.classList.add("_row-selected"),p={},h();for(var n=0;n<s.length;n++)s[n].classList.contains("_table-btn-add")||(s[n].classList.remove("_table-btn-disabled"),s[n].disabled=!1)}(l=e.target.parentElement):l&&!e.target.classList.contains("_table-btn")&&(g(l),l=null)})),f.addEventListener("click",(function(){l&&y()})),m.addEventListener("click",b),c.addEventListener("click",v),i.addEventListener("click",x),u.addEventListener("click",E)}))}]);
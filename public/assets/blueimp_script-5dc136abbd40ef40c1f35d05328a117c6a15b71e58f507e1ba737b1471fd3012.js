window.onload=function(){var e=document.getElementById("links");e&&(e.onclick=function(e){e=e||window.event;var n=e.target||e.srcElement,t=n.src?n.parentNode:n,a={index:t,event:e},i=this.getElementsByTagName("a");blueimp.Gallery(i,a)})};
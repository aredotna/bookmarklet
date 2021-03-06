(function () {
  var host = "https://marklet.are.na";
  //var host = "http://localhost:3333"
  var arena_frame;
  var arena_div;

  if (!document.getElementById("arena")) {
    initialize()
  }

  function initialize(){
    createFrame();
    createTarget();
    createStyle();

    setHostEvents();
    setTargetEvents();          
  }


  function createFrame(){
    arena_frame = document.createElement("iframe");
    arena_frame.name = arena_frame.id = "arena_frame";
    arena_frame.src = host;
    document.body.appendChild(arena_frame);
  }

  function createTarget(){
    arena_div = document.createElement("div");
    arena_div.id = "arena_div";
    document.body.appendChild(arena_div);         
  }

  function createStyle(){
    marklet_style = document.createElement("style");
    marklet_style.type = "text/css";          
    marklet_css = "#arena_frame,#arena_div{overflow:hidden;width:270px;height:366px;position:fixed;top:20px;right:20px;border:none}#arena_frame{z-index:9999999998;background:rgba(255,255,255,0.75);box-shadow: 3px 4px 10px rgba(0, 0, 0, .4);}#arena_frame:hover{background:rgba(255,255,255,0.9); box-shadow: 3px 4px 10px rgba(0, 0, 0, .5);}#arena_div{z-index:9999999999;display:none;opacity:0}"; 

    if (marklet_style.styleSheet) {
      marklet_style.styleSheet.cssText = marklet_css;
    } else {
      marklet_style.appendChild(document.createTextNode(marklet_css));
    }
    document.body.appendChild(marklet_style); 
  }


  function setHostEvents(){
    document.addEventListener('dragstart', startDrag, true);
    document.addEventListener('dragend', stopDrag, true);
    document.addEventListener('mousedown', sendClick, true)
    document.onkeyup = checkForClose;
    window.addEventListener("message", getMessage);
  }

  function setTargetEvents(){
    arena_div.addEventListener("dragover", dragOver, true)
    arena_div.addEventListener("dragenter", dragEnter, false)
    arena_div.addEventListener("dragleave", dragLeave, false)
    arena_div.addEventListener("drop", drop, false)
  }


  // Document drag events

  function startDrag (e) {
    var targetParent;
    
    if (typeof e.dataTransfer.getData("text/html") == "undefined" 
      || e.target.tagName == "IMG") {

      targetParent = closest(e.target, "A") || document.createElement('A')

      parentHTML = targetParent.cloneNode(false); 
      parentHTML.href = parentHTML.href;

      targetImage = e.target.cloneNode(false);
      targetImage.src = targetImage.src;
      parentHTML.appendChild(targetImage);
      e.dataTransfer.setData("text/html", parentHTML.outerHTML);
    } 

    arena_div.style.display = "block";
  };

  function stopDrag (e) {
    arena_div.style.display = "none";
  }


  // Target drag events

  function dragOver(e) {
    e.stopPropagation();
    e.preventDefault();
    return false;
  }

  function dragEnter(e) {
    sendMessage({
      action: "dragenter"
    })
    return false
  }

  function dragLeave(e) {
    sendMessage({
      action: "dragleave"
    })
    return false
  }

  function drop(e) {
    var data = {
      source: location.href,
      title: document.title
    }

    for (var i in e.dataTransfer.types) {
      data[e.dataTransfer.types[i]] = e.dataTransfer.getData(e.dataTransfer.types[i]);
    }

    sendMessage({
      action: "drop",
      value: data
    });

    e.stopPropagation();
    e.preventDefault();
    return false
  }



  // Close Arena
  
  function checkForClose(e){
    if (e || window.event) {
      e = window.event;
      if (e.keyCode == 27) arena_close()
    }
  }

  function arena_close() {
    if (window.removeEventListener) window.removeEventListener("message", getMessage, false)
    if (arena_frame) document.body.removeChild(arena_frame)
    if (arena_div) document.body.removeNode(arena_div)
    if (marklet_style) document.body.removeNode(marklet_style)
  }



  // Message exchange

  function getMessage(e) {
    switch (e.data.action) {
      case "issidebar":
        sendMessage({
          action: "issidebar",
          value: true
        })
        break;

      case "close":
        arena_close();
        break;

      case "bookmarklet:ready":
        sendLocation();
        break;

      case "getselection":
        var text = getSelectedText();
        sendMessage({
          action: "selectedtext",
          value: text
        })
        break;
    }
  }

  function sendMessage(data) {
    arena_frame.contentWindow.postMessage(data, "*")
  }

  function sendLocation(){
    sendMessage({
      action:"location",
      value: {
        url: window.location.href,
        title: document.title
      }
    });
  }

  function sendClick(){
    sendMessage({
      action: "click"
    })
  }

  function getSelection(){
    var text;
    if (window.getSelection){
      text = window.getSelection().toString();
    } else if (document.getSelection) {
      text = document.getSelection().toString()
    } else if (document.selection) {
      text = document.selection.createRange().text;
    }
    return text;
  }

  // Utility

  function closest(that, tagname) {
    while (that.parentNode) {
      that = that.parentNode;
      if (that.tagName == tagname) return that
    }
    return false;
  }
})();
(function () {
  if (!document.getElementById("arena")) {

    var arena_frame;
    var arena_div;



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
      arena_frame.src = "http://localhost:3333";
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
      marklet_css = "#arena_frame,#arena_div{width:100%;height:137px;position:fixed;bottom:0;left:0;right:0;border:none}#arena_frame{border-top:1px solid rgba(0,0,0,0.1);z-index:9999999998;background:rgba(255,255,255,0.75)}#arena_frame:hover{background:rgba(255,255,255,0.9)}#arena_div{z-index:9999999999;display:none;opacity:0}"; 

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
      document.onkeyup(checkForClose)
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
        && e.target.tagName == "IMG") {
        targetParent = aBtransverse(e.target, "A");
      }

      if (targetParent) {
        parentHTML = targetParent.cloneNode(false); 
        parentHTML.href = parentHTML.href;

        targetImage = e.target.cloneNode(false);
        targetImage.src = targetImage.src;
        parentHTML.appendChild(targetImage);
        e.dataTransfer.setData("text/html", parentHTML.outerHTML);
      } else {
        targetImage = e.target.cloneNode(false);
        targetImage.src = targetImage.src;
        e.dataTransfer.setData("text/html", targetImage.outerHTML);
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

    function checkForClose(){
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
      if (e.data.action == "issidebar"){
        sendMessage({
          action: "issidebar",
          value: true
        })
      } else {
        if (e.data.action == "close") arena_close()
      }
    }

    function sendMessage(data) {
      arena_frame.contentWindow.postMessage(data, "*")
    }



    // Utility

    function aBtransverse(that, tagname) {
      while (that.parentNode) {
        that = that.parentNode;
        if (that.tagName == tagname) return that
      }
    }



  }
})();
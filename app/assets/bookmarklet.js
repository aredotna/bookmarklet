(function () {
    if (!document.getElementById("arena")) {
        arena_frame = document.createElement("iframe"), 
        arena_div = document.createElement("div"), 
        marklet_style = document.createElement("style"), 
        marklet_style.type = "text/css", 
        marklet_css = "#arena_frame,#arena_div{width:100%;height:137px;position:fixed;bottom:0;left:0;right:0;border:none}#arena_frame{border-top:1px solid rgba(0,0,0,0.1);z-index:9999999998;background:rgba(255,255,255,0.75)}#arena_frame:hover{background:rgba(255,255,255,0.9)}#arena_div{z-index:9999999999;display:none;opacity:0}", 
        arena_frame.name = arena_frame.id = "arena_frame", 
        arena_frame.src = "http://localhost:3333",
        arena_div.id = "arena_div", 
        document.body.appendChild(arena_frame), 
        document.body.appendChild(arena_div), 
        marklet_style.styleSheet ? marklet_style.styleSheet.cssText = marklet_css : marklet_style.appendChild(document.createTextNode(marklet_css)), 
        document.body.appendChild(marklet_style), 

        document.addEventListener("dragstart", function (e) {
            typeof e.dataTransfer.getData("text/html") == "undefined" 
            && e.target.tagName == "IMG" 
            && (targetParent = aBtransverse(e.target, "A"), targetParent ? (parentHTML = targetParent.cloneNode(!1), parentHTML.href = parentHTML.href, targetImage = e.target.cloneNode(!1), targetImage.src = targetImage.src, parentHTML.appendChild(targetImage), e.dataTransfer.setData("text/html", parentHTML.outerHTML)) : (targetImage = e.target.cloneNode(!1), targetImage.src = targetImage.src, e.dataTransfer.setData("text/html", targetImage.outerHTML))), arena_div.style.display = "block"
        }, !0), document.addEventListener("dragend", function (e) {
            arena_div.style.display = "none"
        }, !0), arena_div.addEventListener("dragover", function (e) {
            return e.stopPropagation(), e.preventDefault(), !1
        }, !1), arena_div.addEventListener("dragenter", function (e) {
            return sendMessage({
                action: "dragenter"
            }), !1
        }, !1), arena_div.addEventListener("dragleave", function (e) {
            return sendMessage({
                action: "dragleave"
            }), !1
        }, !1), arena_div.addEventListener("drop", function (e) {
            var data = new Object;
            data.source = location.href;
            data.title = document.title;
            for (var i in e.dataTransfer.types) 
                data[e.dataTransfer.types[i]] = e.dataTransfer.getData(e.dataTransfer.types[i]);
            return sendMessage({
                action: "drop",
                value: data
            }), e.stopPropagation(), e.preventDefault(), !1
        }, !1), document.onkeyup = function (e) {
            e || window.event && (e = window.event), e && e.keyCode == 27 && arena_close()
        };

        function getMessage(e) {
            e.data.action == "issidebar" ? sendMessage({
                action: "issidebar",
                value: !0
            }) : e.data.action == "close" && arena_close()
        }

        window.addEventListener("message", getMessage);

        function arena_close() {
            window.removeEventListener && window.removeEventListener("message", getMessage, !1), arena_frame && document.body.removeChild(arena_frame), arena_div && document.body.removeNode(arena_div), marklet_style && document.body.removeNode(marklet_style)
        }
        function aBtransverse(that, tagname) {
            while (that.parentNode) {
                that = that.parentNode;
                if (that.tagName == tagname) return that
            }
        }
        function sendMessage(data) {
            arena_frame.contentWindow.postMessage(data, "*")
        }
    }
})();
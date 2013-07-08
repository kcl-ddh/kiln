function toggle(id, showText, hideText) {
    var element = document.getElementById(id);
    with (element.style) {
        if ( display == "none" ){
            display = ""
        } else{
            display = "none"
        }
    }
    var text = document.getElementById(id + "-switch").firstChild;
    if (text.nodeValue == showText) {
        text.nodeValue = hideText;
    } else {
        text.nodeValue = showText;
    }
}

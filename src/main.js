window.onload = function() {

    var editor = document.querySelector('.editor');

    editor.addEventListener("keypress", function(e) {
        if(e.key != "$") { return;}

        let contents = editor.innerHTML;
        let splitContents = contents.split("$");
        for(let i = 0; i < splitContents.length; i++) {
            if( i%2 === 1 ) {
                splitContents[i] = katex.renderToString(splitContents[i]);
            }
        }

        editor.innerHTML = splitContents.join("");
        window.getSelection().collapseToEnd();
    });

    function moveCursorToEnd(el) {
        if (typeof el.selectionStart == "number") {
            el.selectionStart = el.selectionEnd = el.value.length;
        } else if (typeof el.createTextRange != "undefined") {
            el.focus();
            var range = el.createTextRange();
            range.collapse(false);
            range.select();
        }
    }
}

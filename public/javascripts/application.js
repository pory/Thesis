var codeMirrors = new Array();

$(document).ready(function() {
  $(".example-code").each(function(){
    var codeMirror = CodeMirror.fromTextArea(this, {
      readOnly: true
    });
  });  
  $(".show-try-code").click(function(){
    this.style.display = "none";
    var textAreaId = this.getAttribute("data-textarea");
    document.getElementById(textAreaId+'_button').style.display = '';
    document.getElementById('cancel_'+textAreaId+'_button').style.display = '';
    var codeMirror = CodeMirror.fromTextArea(document.getElementById(textAreaId), {
      lineNumbers: true,
      tabMode: "indent"
    });
    codeMirrors[textAreaId] = codeMirror;
    return false;
  });
  $(".cancel-try-code").click(function(){
    this.style.display = "none";
    var textAreaId = this.getAttribute("data-textarea");
    document.getElementById(textAreaId+'_button').style.display = 'none';
    document.getElementById('show_'+textAreaId+'_button').style.display = '';
    document.getElementById(textAreaId+'_output').style.display = 'none';
    codeMirror = document.getElementById(textAreaId).nextElementSibling;
    codeMirror.parentNode.removeChild(codeMirror);
    return false;
  });
  $(".try-code").click(function(){
    var button = this;
    var textAreaId = this.getAttribute("data-textarea");
    var codeMirror = codeMirrors[textAreaId];
    $.get('/interpret', { code: codeMirror.getValue() }, function(data){
      var codeResult = document.getElementById(textAreaId+'_output');
      codeResult.innerHTML = data;
      codeResult.style.display = '';
    });
    return false;
  });
});
  
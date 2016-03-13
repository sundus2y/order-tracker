//# Place all the behaviors and hooks related to the matching controller here.
//# All this logic will automatically be available in application.js.
//# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready(function (){
    $('#file').fileinput({'showPreview':false});
    $("form[data-readOnly='true']").find('input').attr('readOnly',true);
    $("form[data-readOnly='true']").find('textarea').attr('readOnly',true);
});
$(document).ready(function (){
    $("form[data-readOnly='true']").find('input').attr('readOnly',true);
    $("form[data-readOnly='true']").find('textarea').attr('readOnly',true);
});
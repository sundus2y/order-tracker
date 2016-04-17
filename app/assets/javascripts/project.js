$(document).ready(function (){
    $("form[data-readOnly='true']").find('input').attr('readOnly',true);
    $("form[data-readOnly='true']").find('select').attr('disabled',true);
    $("form[data-readOnly='true']").find('textarea').attr('readOnly',true);
});
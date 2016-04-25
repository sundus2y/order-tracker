var titilize = function(str){
    return str.toLowerCase().replace(/(?:^|\s|-|_)\S/g, function (m) {
        return m.toUpperCase();
    });
}
$(document).ready(function (){
    $("form[data-readOnly='true']").find('input').attr('readOnly',true);
    $("form[data-readOnly='true']").find('select').attr('disabled',true);
    $("form[data-readOnly='true']").find('textarea').attr('readOnly',true);
});
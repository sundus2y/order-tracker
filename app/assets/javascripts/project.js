var titilize = function(str){
    return str.toLowerCase().replace(/(?:^|\s|-|_)\S/g, function (m) {
        return m.toUpperCase();
    });
}
$(document).ready(function (){
    $("form[data-readOnly='true']").find('input').attr('readOnly',true);
    $("form[data-readOnly='true']").find('select').attr('disabled',true);
    $("form[data-readOnly='true']").find('textarea').attr('readOnly',true);
    $( "#date_from" ).datepicker({
        defaultDate: "+1w",
        changeMonth: true,
        numberOfMonths: 2,
        onClose: function( selectedDate ) {
            $( "#date_to" ).datepicker( {
                minDate: selectedDate,
                dateFormat: 'yy-mm-dd'
            });
        }
    });
    $( "#date_to" ).datepicker({
        defaultDate: "+1w",
        changeMonth: true,
        numberOfMonths: 2,
        onClose: function( selectedDate ) {
            $( "#date_from" ).datepicker({
                maxDate: selectedDate,
                dateFormat: 'yy-mm-dd'
            });
        }
    });

    $('a.btn-group-toggle').click(function(e){
        $(this).parent().find('.dd-menu').toggleClass('hidden');
        e.preventDefault();
    });

    $('ul.dd-menu li a').click(function(e){
        $(this).parent().parent().find('.dd-menu').toggleClass('hidden');
    });
});
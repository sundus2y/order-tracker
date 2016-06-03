var titilize = function(str){
    return str.toLowerCase().replace(/(?:^|\s|-|_)\S/g, function (m) {
        return m.toUpperCase();
    });
}

var renderAutocompleteResults = function(results, indices, widths) {
    results.each(function (index, elem) {
        var node = elem.childNodes[0].nodeValue;
        var node_element = $.parseHTML(node);
        $(node_element).find('div').each(function (index, col) {
            if (indices.includes($(col).data('index'))) {
                var i = $(col).data('index');
                var widthClass = widths[indices.indexOf(i)];
                $(col).addClass(widthClass);
            } else {
                $(col).remove();
            }
        });
        elem.innerHTML = "";
        $(elem).append(node_element);
    });
}

var makeFormReadOnly = function makeFormReadOnly() {
    $("form[data-readOnly='true']").find('input').attr('readOnly', true);
    $("form[data-readOnly='true']").find('select').attr('disabled', true);
    $("form[data-readOnly='true']").find('textarea').attr('readOnly', true);
}

$(document).ready(function (){
    makeFormReadOnly();
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

    $('body').on('click', 'a.btn-group-toggle', function(e){
        $(this).parent().find('.dd-menu').toggleClass('hidden');
        e.preventDefault();
    });

    $('body').on('click','a.pop_up',function(e){
        $.get($(this).attr('href'), function(data) {
            $('div#pop_up').remove();
            $('body').append(data);
            $('div#pop_up').modal('show');
            makeFormReadOnly();
        });
        e.preventDefault();
    });

    $('ul.dd-menu li a').click(function(e){
        $(this).parent().parent().find('.dd-menu').toggleClass('hidden');
    });

    // Open the parent menu for current page.
    setTimeout(function(){
        $('#'+$("a[href='"+window.location.pathname+"']").parent().data('parent')).click();
    },0.5);
});
window.printCurrency = function(number){
    if(typeof(number) === 'string') {
        number = parseFloat(number);
    }
    else if(typeof(number) === 'undefined' || number === null){
        number = 0.0;
    }
    return parseFloat(number.toFixed(2)).toLocaleString();
};

var renderAutoCompleteResults = function(results, indices, widths) {
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

var makeFormReadOnly = function() {
    $("form[data-readOnly='true']").find('input').attr('readOnly', true);
    $("form[data-readOnly='true']").find('select').attr('disabled', true);
    $("form[data-readOnly='true']").find('textarea').attr('readOnly', true);
}

var updateFormAction = function() {
    $('body').on('click',"button[type='submit']", function(){
        var action = $(this).data('action');
       if (typeof(action) !== "undefined") {
           $(this).closest('form').attr('action',action);
       }
    });
}

var submitFormWithLink = function() {
    $('body').on('click','a.form-submit',function (e) {
        var action = $(this).data('action');
        if (typeof(action) !== "undefined") {
            $(this).closest('form').attr('action',action);
        }
        $(this).closest('form').submit();
        e.preventDefault();
    })
}

$(document).ready(function (){
    makeFormReadOnly();
    updateFormAction();
    submitFormWithLink();
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
    $( "#date_from" ).datepicker('setDate', 'today');
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
    $( "#date_to" ).datepicker('setDate', '+1d');

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
        var link = ''
        if (window.location.pathname.match(/\/.*\//)) {
            link = window.location.pathname.match(/\/.*\//)[0]
        } else {
            link = window.location.pathname.match(/\/.*$/)[0]
        }

        $('#'+$("a[href*='"+link+"']").parent().data('parent')).click();
    },0.5);
});
var printCurrency = function(number){
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
};

var makeFormReadOnly = function() {
    $("form[data-readOnly='true']").find('input').attr('readOnly', true);
    $("form[data-readOnly='true']").find('select').attr('disabled', true);
    $("form[data-readOnly='true']").find('textarea').attr('readOnly', true);
};

var updateFormAction = function() {
    $('body').on('click',"button[type='submit']", function(){
        var action = $(this).data('action');
       if (typeof(action) !== "undefined") {
           $(this).closest('form').attr('action',action);
       }
    });
};

var submitFormWithLink = function() {
    $('body').on('click','a.form-submit',function (e) {
        var action = $(this).data('action');
        if (typeof(action) !== "undefined") {
            $(this).closest('form').attr('action',action);
        }
        $(this).closest('form').submit();
        e.preventDefault();
    })
};

var bindSearchSelectEvent = function() {
    $('#search_item_field').on('railsAutocomplete.select', function (event, object) {
        $('#search_item_id').val(object.item.id);
        $(this).val('');
    });
    $('#search_item_field').on('autocompleteopen', function (event, object) {
        var results = $('ul.ui-autocomplete').find('li');
        $('ul.ui-autocomplete').prepend("" +
            "<li class='autocomplete-header'>" +
            "<div class='row'>" +
            "<div class='col-sm-3'>Item Number</div>" +
            "<div class='col-sm-5'>Name</div>" +
            "<div class='col-sm-2'>Inventory</div>" +
            "<div class='col-sm-1'>Brand</div>" +
            "<div class='col-sm-1'>Origin</div>" +
            "</div>" +
            "</li>").css('width','80%');
        var indices = [0,1,2,3,4];
        var widths = ['col-sm-3','col-sm-5','col-sm-2','col-sm-1','col-sm-1'];
        renderAutoCompleteResults(results, indices, widths);
    });
};

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

    $( "#sale_delivery_date" ).datepicker({
        changeMonth: true,
        numberOfMonths: 2,
        dateFormat: 'yy-mm-dd'
    });
    $( "#sale_delivery_date" ).datepicker('setDate', 'today');

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

    $(document).ajaxStart(function(event, request, settings) {
        if(globalSearchSaleApp.callback && $.pause_searching_for_fs_num === false) {
            globalSearchSaleApp.callback({searching: true});
        } else if(SearchProformaApp.callback) {
            SearchProformaApp.callback({searching: true});
        }
        $.pause_searching_for_fs_num = false;
    });

    $('#query_customer').on('railsAutocomplete.select', function (event, object) {
        $(this).trigger('submit.rails');
        $('span#selected-customer input').val(object.item.value);
        $('span#selected-customer').show();
        $('span#customer-autocomplete').hide();
    });

    $('#sale_customer,#proforma_customer,#query_customer').on('autocompleteopen', function (event, object) {
        var results = $('ul.ui-autocomplete').find('li');
        var indices = [0,1,2,3,4];
        var widths = ['col-sm-3','col-sm-3','col-sm-2','col-sm-2','col-sm-2'];
        renderAutoCompleteResults(results, indices, widths);
        $('ul.ui-autocomplete').prepend("" +
            "<li class='autocomplete-header'>" +
            "<div class='row'>" +
            "<div class='col-sm-3'>Name</div>" +
            "<div class='col-sm-3'>Company</div>" +
            "<div class='col-sm-2'>Phone</div>" +
            "<div class='col-sm-2'>Tin No</div>" +
            "<div class='col-sm-2'>Category</div>" +
            "</div>" +
            "</li>").css('width','60%');
    });

    $('#search_item_field').on('railsAutocomplete.select', function (event, object) {
        $(this).trigger('submit.rails');
        $('span#selected-item input').val(object.item.value);
        $('span#selected-item').show();
        $('span#item-autocomplete').hide();
    });

    $('span#selected-customer-close').click(function(){
        $('span#selected-customer').hide();
        $('span#customer-autocomplete').show();
        $('input#customer_id').val('');
        $('span#customer-autocomplete input').val('').trigger('submit.rails');
    });

    $('span#selected-item-close').click(function(){
        $('span#selected-item').hide();
        $('span#item-autocomplete').show();
        $('input#item_id').val('');
        $('span#item-autocomplete input').val('').trigger('submit.rails');
    });

    $('span#selected-customer, span#selected-item').hide();
});
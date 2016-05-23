window.globalSearchSaleApp = window.globalSearchSaleApp || {};
$(document).ready(function () {
    $('#query_customer').on('railsAutocomplete.select', function (event, object) {
        $(this).trigger('submit.rails');
        $('span#selected-customer input').val(object.item.label);
        $('span#selected-customer').show();
        $('span#customer-autocomplete').hide();
    });

    $('#sale_customer').on('railsAutocomplete.select', function (event, object) {
        $(this).val('');
    });

    $('#sale_customer,#query_customer').on('autocompleteopen', function (event, object) {
        var results = $('ul.ui-autocomplete').find('li');
        var indices = [0,1,2,3,4];
        var widths = ['col-md-3','col-md-3','col-md-2','col-md-2','col-md-2'];
        renderAutocompleteResults(results, indices, widths);
        $('ul.ui-autocomplete').prepend("" +
            "<li class='autocomplete-header'>" +
            "<div class='row'>" +
            "<div class='col-md-3'>Name</div>" +
            "<div class='col-md-3'>Company</div>" +
            "<div class='col-md-2'>Phone</div>" +
            "<div class='col-md-2'>Tin No</div>" +
            "<div class='col-md-2'>Category</div>" +
            "</div>" +
            "</li>").css('width','60%');
    });

    $('#sales_search_form').on('ajax:success', function(e, data, status, xhr){
        window.globalSearchSaleApp.callback(data);
    }).on('ajax:error',function(e, xhr, status, error){
        alert('Sales Search Failed'+error)
    });

    $('span#selected-customer-close').click(function(){
        $('span#selected-customer').hide();
        $('span#customer-autocomplete').show();
        $('input#customer_id').val('');
        $('span#customer-autocomplete input').val('').trigger('submit.rails');
    });

    $('span#selected-customer').hide();
});
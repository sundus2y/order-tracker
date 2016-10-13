window.globalSearchSaleApp = window.globalSearchSaleApp || {};
window.globalSalesIndexApp = window.globalSalesIndexApp || {};
$(document).ready(function () {
    $('#query_customer').on('railsAutocomplete.select', function (event, object) {
        $(this).trigger('submit.rails');
        $('span#selected-customer input').val(object.item.value);
        $('span#selected-customer').show();
        $('span#customer-autocomplete').hide();
    });

    $('#search_item_field').on('railsAutocomplete.select', function (event, object) {
        $(this).trigger('submit.rails');
        $('span#selected-item input').val(object.item.value);
        $('span#selected-item').show();
        $('span#item-autocomplete').hide();
    });

    $('#sale_customer').on('railsAutocomplete.select', function (event, object) {
        $(this).val('');
    });

    $('#sale_customer,#query_customer').on('autocompleteopen', function (event, object) {
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

    $('#sales_search_form').on('ajax:success', function(e, data, status, xhr){
        window.globalSearchSaleApp.callback(data);
    }).on('ajax:error',function(e, xhr, status, error){
        alert('Sales Search Failed'+error)
    });

    $('#sales_index_form').on('ajax:success', function(e, data, status, xhr){
        window.globalSalesIndexApp.callback(data);
    }).on('ajax:error',function(e, xhr, status, error){
        alert('Sales Search Failed'+error)
    });

    $('select#store_id').change(function(event){
        $.get( "stores/"+$(this).val()+"/sales.json", function(data) {
            window.globalSalesIndexApp.callback(data);
        });
    }).trigger('change');

    $('#print_sales').click(function(){
        var newTab = window.open(window.location.href,'_blank');
        $(newTab.document).ready(function () {
            setTimeout(function(){
                var newTabDom = $(newTab.document).contents();
                var print_area = newTabDom.find('.page-content');
                print_area.addClass('printable');
                print_area.find('*').addClass('printable');
                newTabDom.find('body *').toggleClass('no-print');
                newTabDom.find('body').append(print_area);
                newTabDom.find('.printable').toggleClass('no-print');
                newTabDom.find('#customer_search_row, #item_search_row, #sales_actions, #print_sales, .fa-trash').toggleClass('no-print');
                newTab.print();
            },2000);
        });
    })

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
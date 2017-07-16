window.globalSearchSaleApp = window.globalSearchSaleApp || {};
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

    $(document).ajaxStart(function(event, request, settings) {
        if(window.globalSearchSaleApp.callback && $.pause_searching === false) {
            window.globalSearchSaleApp.callback({searching: true});
        }
        $.pause_searching = false;
    });

    $('#sales_search_form').on('ajax:success', function(e, data, status, xhr){
        window.globalSearchSaleApp.callback(data);
    }).on('ajax:error',function(e, xhr, status, error){
        alert('Sales Search Failed'+error)
    });

    $('#sales_search_form').trigger('submit.rails');

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

    $('table').on('click', 'a.edit_fs_num',function(){
        $.pause_searching = true;
    });

    $('body').on('click', 'button.save_fs_num', function () {
        $.pause_searching = true;
    })
});
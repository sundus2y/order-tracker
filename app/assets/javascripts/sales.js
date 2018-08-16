window.globalSearchSaleApp = window.globalSearchSaleApp || {};
$(document).ready(function () {
    $('#sale_customer').on('railsAutocomplete.select', function (event, object) {
        $(this).val('');
        CustomerCarApp.callback({customerId: $('#sale_customer_id').val(), clear: true});
    });

    if($('#sale_customer_id').val() && CustomerCarApp.callback){
        CustomerCarApp.callback({customerId: $('#sale_customer_id').val(), clear: false});
    }

    $('#sales_search_form').on('ajax:success', function(e, data, status, xhr){
        window.globalSearchSaleApp.callback(data);
    }).on('ajax:error',function(e, xhr, status, error){
        alert('Sales Search Failed'+error)
    });

    $('#sales_search_form').trigger('submit.rails');

    $('table').on('click', 'a.edit_fs_num',function(){
        $.pause_searching_for_fs_num = true;
    });

    $('body').on('click', 'button.save_fs_num', function () {
        $.pause_searching_for_fs_num = true;
    });

    $('.edit_sale').on('keyup keypress', function(e) {
        var keyCode = e.keyCode || e.which;
        if (keyCode === 13) {
            e.preventDefault();
            return false;
        }
    });

    $('button.order').on('click',function(e){
        if($('#sale_down_payment').val() == '' || $('#sale_delivery_date').val() == ''){
            alert('Make sure Down Payment is set and/or Delivery Date is set to a future date');
            e.preventDefault();
        }
    });
});
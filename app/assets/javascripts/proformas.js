$(document).ready(function () {
    $('#proforma_customer').on('railsAutocomplete.select', function (event, object) {
        $(this).val('');
        CustomerCarApp.callback({customerId: $('#proforma_customer_id').val(), clear: true});
    });

    if($('#proforma_customer_id').val() && CustomerCarApp.callback){
        CustomerCarApp.callback({customerId: $('#proforma_customer_id').val(), clear: false});
    }

    $('#proformas_search_form').on('ajax:success', function(e, data, status, xhr){
        SearchProformaApp.callback(data);
    }).on('ajax:error',function(e, xhr, status, error){
        alert('Proforma Search Failed'+error)
    });

    $('#proformas_search_form').trigger('submit.rails');

    $('.edit_proforma').on('keyup keypress', function(e) {
        var keyCode = e.keyCode || e.which;
        if (keyCode === 13) {
            e.preventDefault();
            return false;
        }
    });
});
window.globalSearchItemApp = window.globalSearchItemApp || {};
window.globalSearchCustomerApp = window.globalSearchCustomerApp || {};
$(document).ready(function () {
    $('#search_item_form').on('ajax:success', function (e, data, status, xhr) {
        window.globalSearchItemApp.callback(JSON.parse(data));
    }).on('ajax:error', function (e, xhr, status, error) {
        alert('Sales Search Failed' + error)
    });

    $('#search_customer_form').on('ajax:success', function (e, data, status, xhr) {
        window.globalSearchCustomerApp.callback(JSON.parse(data));
    }).on('ajax:error', function (e, xhr, status, error) {
        alert('Customer Search Failed' + error)
    });
});
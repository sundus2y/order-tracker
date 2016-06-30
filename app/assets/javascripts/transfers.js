window.globalSearchTransferApp = window.globalSearchTransferApp || {};
$(document).ready(function () {
    $('#transfers_search_form').on('ajax:success', function(e, data, status, xhr){
        window.globalSearchTransferApp.callback(data);
    }).on('ajax:error',function(e, xhr, status, error){
        alert('Sales Search Failed'+error)
    });
});
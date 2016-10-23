window.globalSearchTransferApp = window.globalSearchTransferApp || {};
$(document).ready(function () {
    $('#transfers_search_form').on('ajax:success', function(e, data, status, xhr){
        window.globalSearchTransferApp.callback(data);
    }).on('ajax:error',function(e, xhr, status, error){
        alert('Sales Search Failed'+error)
    });
    $('#transfers_search_form').trigger('submit.rails');
    $('.edit_transfer').on('keyup keypress', function(e) {
        var keyCode = e.keyCode || e.which;
        if (keyCode === 13) {
            e.preventDefault();
            return false;
        }
    });
});
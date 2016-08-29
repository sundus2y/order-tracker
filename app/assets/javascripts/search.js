window.globalSearchItemApp = window.globalSearchItemApp || {};
$(document).ready(function () {
    $('#search_item_form').on('ajax:success', function (e, data, status, xhr) {
        window.globalSearchItemApp.callback(JSON.parse(data));
    }).on('ajax:error', function (e, xhr, status, error) {
        alert('Sales Search Failed' + error)
    });
});
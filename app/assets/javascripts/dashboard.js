$('document').ready(function(){
    $('#sales_dash_btn, #admin_dash_btn').on('click',function(){
        $('#sales_dash_btn').toggleClass('hidden');
        $('#admin_dash_btn').toggleClass('hidden');
        $('#sales_dash_container').toggleClass('hidden');
        $('#admin_dash_container').toggleClass('hidden');
    });
});
$(document).ready(function () {
    $('body').on('click','.remove-item',function(){
        $(this).parent().parent().remove();
    })
});
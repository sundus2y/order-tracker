$(document).ready(function () {
    $('li.parent-menu').click(function(){
        var self = this;
        var sub_menus = $("li[data-parent='"+self.id+"']");
        $(self).find('i').last().toggleClass('fa-minus','fa-plus');
        show_hide_sub_menus(sub_menus);
    });
});

var show_hide_sub_menus = function show_hide_sub_menus(sub_menus){
    $.each(sub_menus,function(index,elem){
        if ($(elem).is(":visible")) {
            $(elem).velocity("slideUp", { duration: 500 }).velocity(
                "fadeOut", { queue: false, duration: 500});
        } else {
            $(elem).velocity("slideDown", { duration: 500 }).velocity(
                "fadeIn", { queue: false, duration: 500});
        }
    });
};
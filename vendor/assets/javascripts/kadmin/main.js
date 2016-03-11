$(function () {
    //BEGIN MENU SIDEBAR
    $('#sidebar').css('min-height', '100%');
    $('#side-menu').metisMenu();

    $(window).bind("load resize", function () {
        if ($(this).width() < 768) {
            $('div.sidebar-collapse').addClass('collapse');
        } else {
            $('div.sidebar-collapse').removeClass('collapse');
            $('div.sidebar-collapse').css('height', 'auto');
        }
        if($('body').hasClass('sidebar-icons')){
            $('#menu-toggle').hide();
        } else{
            $('#menu-toggle').show();
        }
    });
    //END MENU SIDEBAR

    //BEGIN TOPBAR DROPDOWN
    $('.dropdown-slimscroll').slimScroll({
        "height": '250px',
        "wheelStep": 5
    });
    //END TOPBAR DROPDOWN

    //BEGIN CHECKBOX & RADIO
    //if($('#demo-checkbox-radio').length <= 0){
    //    $('input[type="checkbox"]:not(".switch")').iCheck({
    //        checkboxClass: 'icheckbox_minimal-grey',
    //        increaseArea: '20%' // optional
    //    });
    //    $('input[type="radio"]:not(".switch")').iCheck({
    //        radioClass: 'iradio_minimal-grey',
    //        increaseArea: '20%' // optional
    //    });
    //}
    //END CHECKBOX & RADIO

    //BEGIN TOOTLIP
    $("[data-toggle='tooltip'], [data-hover='tooltip']").tooltip();
    //END TOOLTIP

    //BEGIN POPOVER
    $("[data-toggle='popover'], [data-hover='popover']").popover();
    //END POPOVER

    //BEGIN FULL SCREEN
    $('.btn-fullscreen').click(function() {

        if (!document.fullscreenElement &&    // alternative standard method
            !document.mozFullScreenElement && !document.webkitFullscreenElement && !document.msFullscreenElement ) {  // current working methods
            if (document.documentElement.requestFullscreen) {
                document.documentElement.requestFullscreen();
            } else if (document.documentElement.msRequestFullscreen) {
                document.documentElement.msRequestFullscreen();
            } else if (document.documentElement.mozRequestFullScreen) {
                document.documentElement.mozRequestFullScreen();
            } else if (document.documentElement.webkitRequestFullscreen) {
                document.documentElement.webkitRequestFullscreen(Element.ALLOW_KEYBOARD_INPUT);
            }
        } else {
            if (document.exitFullscreen) {
                document.exitFullscreen();
            } else if (document.msExitFullscreen) {
                document.msExitFullscreen();
            } else if (document.mozCancelFullScreen) {
                document.mozCancelFullScreen();
            } else if (document.webkitExitFullscreen) {
                document.webkitExitFullscreen();
            }
        }
    });
    //END FULL SCREEN

    //BEGIN PORTLET
    $(".portlet").each(function(index, element) {
        var me = $(this);
        $(">.portlet-header>.tools>i", me).click(function(e){
            if($(this).hasClass('fa-chevron-up')){
                $(">.portlet-body", me).slideUp('fast');
                $(this).removeClass('fa-chevron-up').addClass('fa-chevron-down');
            }
            else if($(this).hasClass('fa-chevron-down')){
                $(">.portlet-body", me).slideDown('fast');
                $(this).removeClass('fa-chevron-down').addClass('fa-chevron-up');
            }
            else if($(this).hasClass('fa-cog')){
                //Show modal
            }
            else if($(this).hasClass('fa-refresh')){
                //$(">.portlet-body", me).hide();
                $(">.portlet-body", me).addClass('wait');

                setTimeout(function(){
                    //$(">.portlet-body>div", me).show();
                    $(">.portlet-body", me).removeClass('wait');
                }, 1000);
            }
            else if($(this).hasClass('fa-times')){
                me.remove();
            }
        });
    });
    //END PORTLET

    //BEGIN BACK TO TOP
    $(window).scroll(function(){
        if ($(this).scrollTop() < 200) {
            $('#totop') .fadeOut();
        } else {
            $('#totop') .fadeIn();
        }
    });
    $('#totop').on('click', function(){
        $('html, body').animate({scrollTop:0}, 'fast');
        return false;
    });
    //END BACK TO TOP

    //BEGIN CHECKBOX TABLE
    $('.checkall').on('ifChecked ifUnchecked', function(event) {
        if (event.type == 'ifChecked') {
            $(this).closest('table').find('input[type=checkbox]').iCheck('check');
        } else {
            $(this).closest('table').find('input[type=checkbox]').iCheck('uncheck');
        }
    });
    //END CHECKBOX TABLE

    $('.option-demo').hover(function() {
        $(this).append("<div class='demo-layout animated fadeInUp'><i class='fa fa-magic mrs'></i>Demo</div>");
    }, function() {
        $('.demo-layout').remove();
    });
    // CALL FUNCTION RESPONSIVE TABS
    fakewaffle.responsiveTabs(['xs', 'sm']);

});




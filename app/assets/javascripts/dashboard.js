var itemDataTable = null;

(function (){
    $(document).ready(function () {
        var changeTimer = false;
        itemDataTable = $('#item-results-table').DataTable({
            data: [],
            columns: [
                { data: "actions" },
                { data: "name" },
                { data: "original_number" },
                { data: "item_number" },
                { data: "description" },
                { data: "car" },
                { data: "model" },
                { data: "sale_price" },
                { data: "inventories_display" },
                { data: "brand" },
                { data: "made" }
            ]
        });
        $('#dashboard_search').on('keyup',function(){
            var self = this
            if (changeTimer !== false) clearTimeout(changeTimer);
            changeTimer = setTimeout(function(){
                if ($(self).val() == ""){
                    $('div.search-result').hide();
                    $('div.main-content').show();
                } else {
                    $('div.search-result').show();
                    $('div.main-content').hide();
                    search($(self).val());
                }
                changeTimer = false;
            },500);
        });
    });

    var search = function search(term){
        $.get('/search/items',{search_term:term})
            .done(function(result){
                //React.render(React.createElement(SearchTransferApp, null), $('#search-items-result')[0]);
                itemDataTable.clear().draw();
                itemDataTable.rows.add(result).draw();
            })
    };
})();

var returnSalesApp = returnSalesApp || {};

(function () {

    returnSalesApp.Item = createReactClass({

        handleItemSelect: function(){
            var itemId = $('#search_item_id').val();
            if (itemId != '') {
                this.props.onItemSelect(itemId);
            }
        },

        componentDidMount: function(){
            $('#search_item_field').on('railsAutocomplete.select', function (event, object) {
                $('#search_item_id').val(object.item.id);
                $(this).val('');
            });

            $('#search_item_field').on('autocompleteopen', function (event, object) {
                var results = $('ul.ui-autocomplete').find('li');
                $('ul.ui-autocomplete').prepend("" +
                    "<li class='autocomplete-header'>" +
                    "<div class='row'>" +
                    "<div class='col-sm-4'>Origninal Number</div>" +
                    "<div class='col-sm-6'>Name</div>" +
                    "<div class='col-sm-1'>Brand</div>" +
                    "</div>" +
                    "</li>").css('width','45%');
                var indices = [0,1,3];
                var widths = ['col-sm-4','col-sm-6','col-sm-1'];
                renderAutoCompleteResults(results, indices, widths);
            });
        },

        render: function() {
            return (
                <div className="col-sm-9">
                    <div className="field form-group">
                        <label>Item</label>
                        <span id="item-autocomplete">
                            <input className="form-control" id="search_item_field"
                                   type="text"
                                   data-autocomplete="/items/autocomplete_item_sale_price"
                                   data-name-element="#search_item_id"
                                   placeholder="Enter item to return. . ."
                                   disabled={this.props.disabled}
                                   onSelect={this.handleItemSelect}/>
                            <div className="form-group hidden">
                                <input type="text" id="search_item_id" />
                            </div>
                        </span>
                        <span className="input-group" id="selected-item">
                            <input className="form-control" readOnly="true"/>
                        <span id="selected-item-close" className="selected-ac-close input-group-addon">X</span>
                    </span>
                    </div>
                </div>
            );
        }
    });
})();
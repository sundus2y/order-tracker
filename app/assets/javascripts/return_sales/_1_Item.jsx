var returnSalesApp = returnSalesApp || {};

(function () {

    returnSalesApp.Item = React.createClass({

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
        },

        render: function() {
            return (
                <div className="col-md-6">
                    <div className="field form-group">
                        <label>Item</label>
                        <input className="form-control" id="search_item_field"
                               type="text"
                               className="form-control"
                               data-autocomplete="/items/autocomplete_item_sale_price"
                               data-name-element="#search_item_id"
                               placeholder="Enter item to return. . ."
                               disabled={this.props.disabled}
                               onSelect={this.handleItemSelect}/>
                        <div className="form-group hidden">
                            <input type="text" id="search_item_id" />
                        </div>
                    </div>
                </div>
            );
        }
    });
})();
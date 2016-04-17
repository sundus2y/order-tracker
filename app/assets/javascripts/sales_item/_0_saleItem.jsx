//noinspection JSUnresolvedFunction

var app = app || {};

(function () {

    app.SaleItem = React.createClass({

        handleQtyChange: function(event){
            var updatedSaleItem = this.props.saleItemData;
            var qty = parseInt(event.target.value);
            updatedSaleItem.qty = qty ? qty : 0;
            this.props.onItemUpdate(updatedSaleItem);
        },

        handleUnitPriceChange: function(event){
            var updatedSaleItem = this.props.saleItemData;
            var unitPirce = parseFloat(event.target.value);
            updatedSaleItem.unit_price = unitPirce ? unitPirce : 0.0;
            this.props.onItemUpdate(updatedSaleItem);
        },

        handleSaleItemRemove: function(event){
            this.props.onSaleItemRemove(this.props.saleItemData);
        },

        render: function(){
            var qty = (isNaN(this.props.saleItemData.qty))? 0 : this.props.saleItemData.qty;
            var price = (isNaN(this.props.saleItemData.unit_price))? 0 : this.props.saleItemData.unit_price;
            var totalPrice = (qty * price);

            return(
                <tr>
                    <td>
                        <div className="field form-group">
                            <span className="fa fa-trash btn btn-danger"
                                  onClick={this.handleSaleItemRemove}/>
                            <span className="line_number">{this.props.lineNumber}</span>
                        </div>
                    </td>
                    <td>
                        <div className="field form-group">
                            {this.props.saleItemData.item.name}
                        </div>
                    </td>
                    <td>
                        <div className="field form-group">
                            {this.props.saleItemData.item.item_number}
                        </div>
                    </td>
                    <td>
                        <div className="field form-group">
                            {this.props.saleItemData.item.original_number}
                        </div>
                    </td>
                    <td>
                        <div className="field form-group">
                            {this.props.saleItemData.item.description}
                        </div>
                    </td>
                    <td>
                        <div className="field form-group">
                            <input className="form-control right-align"
                                   defaultValue={this.props.saleItemData.qty}
                                   onBlur={this.handleQtyChange}
                                   required
                                   type="number"
                                   step="any"
                                   min="1"/>
                        </div>
                    </td>
                    <td>
                        <div className="field form-group">
                            <input className="form-control right-align"
                                   defaultValue={this.props.saleItemData.unit_price}
                                   onBlur={this.handleUnitPriceChange}
                                   required
                                   type="number"
                                   step="any"
                                   min="1"/>
                        </div>
                    </td>
                    <td>
                        <div className="field form-group right-align">
                            {totalPrice.toFixed(2)}
                        </div>
                    </td>
                </tr>
            );
       }
    });

})();
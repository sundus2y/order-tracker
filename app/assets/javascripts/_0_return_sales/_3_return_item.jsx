var returnSalesApp = returnSalesApp || {};

(function () {

    var ReturnDialog = returnSalesApp.ReturnDialog;

    returnSalesApp.ReturnItem = React.createClass({

        handleReturnSaleItem: function(returnItem){
            this.props.onReturn(returnItem);
        },

        render: function(){
            return (
                <tr>
                    <td>
                        {this.props.index}
                    </td>
                    <td>
                        <b>Name:</b> {this.props.saleItem.sale.customer.name} <br/>
                        <b>Phone:</b> {this.props.saleItem.sale.customer.phone}
                    </td>
                    <td>
                        <b>Item Name:</b> {this.props.saleItem.item.name} <br/>
                        <b>Original Number:</b> {this.props.saleItem.item.original_number}
                    </td>
                    <td>
                        {this.props.saleItem.sale.transaction_num}
                    </td>
                    <td>
                        {this.props.saleItem.sale.created_at}
                    </td>
                    <td>
                        <b>Qty:</b> {this.props.saleItem.qty} <br/>
                        <b>Returned Qty:</b> {this.props.saleItem.total_returned_qty} <br/>
                        <b>Unit Price:</b> {this.props.saleItem.unit_price}
                    </td>
                    <td>
                        <ReturnDialog onReturn={this.handleReturnSaleItem} data={
                            {
                                saleItemId:this.props.saleItem.id,
                                saleId:this.props.saleItem.sale.id,
                                itemName:this.props.saleItem.item.name,
                                customerName:this.props.saleItem.sale.customer.name,
                                qty:this.props.saleItem.qty,
                                totalReturnedQty:this.props.saleItem.total_returned_qty,
                                unitPrice:this.props.saleItem.unit_price,
                                returnedItems:this.props.saleItem.return_items
                            }
                        }/>
                    </td>
                </tr>
            )
        }
    });
})();
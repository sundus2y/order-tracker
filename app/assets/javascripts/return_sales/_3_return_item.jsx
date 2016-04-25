var returnSalesApp = returnSalesApp || {};

(function () {

    var ReturnDialog = returnSalesApp.ReturnDialog;

    returnSalesApp.ReturnItem = React.createClass({

        handleReturnItem: function(){
            this.setState({showReturnDialog: true});
        },

        render: function(){
            return (
                <tr>
                    <td>
                        {0}
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
                        {this.props.saleItem.sale.id}
                    </td>
                    <td>
                        {this.props.saleItem.sale.created_at}
                    </td>
                    <td>
                        <b>Qty:</b> {this.props.saleItem.qty} <br/>
                        <b>Unit Price:</b> {this.props.saleItem.unit_price}
                    </td>
                    <td>
                        <ReturnDialog data={
                            {
                                sale_id:this.props.saleItem.sale.id,
                                item_name:this.props.saleItem.item.name,
                                customer_name:this.props.saleItem.sale.customer.name,
                                qty:this.props.saleItem.qty,
                                unit_price:this.props.saleItem.unit_price
                            }
                        }/>
                    </td>
                </tr>
            )
        }
    });
})();
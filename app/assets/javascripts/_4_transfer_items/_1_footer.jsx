var app = app || {};

(function () {

    app.TransferItemFooter = React.createClass({

        render: function(){
            return (
                <tr>
                    <td className="grand_total" colSpan='6'>
                        <span><b>Grand Total</b></span>
                    </td>
                    <td className="grand_total">
                        <strong>{this.props.grandTotalQty}</strong>
                    </td>
                    <td className="grand_total" colSpan="2">
                        <strong>{this.props.grandTotalPrice.toFixed(2)}</strong>
                    </td>
                </tr>
            );
        }

    });
})();
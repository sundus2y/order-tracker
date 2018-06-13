var app = app || {};

(function () {

    app.SaleItemFooter = React.createClass({

        render: function(){
            return (
                <tr>
                    <td className="total" colSpan='7'>
                        <span><b>{this.props.label}:</b></span>
                    </td>
                    <td className="total">
                        <strong>{printCurrency(this.props.value)}</strong>
                    </td>
                </tr>
            );
        }

    });
})();
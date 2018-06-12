var ProformaItemApp = ProformaItemApp || {};

(function () {

    ProformaItemApp.ProformaItemFooter = React.createClass({

        render: function(){
            return (
                <tr>
                    <td className="total" colSpan={this.props.hideItemNumber ? '5' : '6'}>
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
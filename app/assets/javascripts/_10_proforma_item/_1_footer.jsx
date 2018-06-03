var ProformaItemApp = ProformaItemApp || {};

(function () {

    ProformaItemApp.ProformaItemFooter = React.createClass({

        render: function(){
            return (
                <tr>
                    <td className="total" colSpan='5'>
                        <span><b>{this.props.label}:</b></span>
                    </td>
                    <td className="total" colSpan="2">
                        <strong>{printCurrency(this.props.value)}</strong>
                    </td>
                </tr>

            );
        }

    });
})();
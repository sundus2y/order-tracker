var searchSaleApp = searchSaleApp || {};

(function () {

    searchSaleApp.Sale = React.createClass({

        render: function() {
            return (
                <tr data-id={this.props.data.id}>
                    <td>{this.props.data.id}</td>
                    <td>{this.props.data.customer.name}</td>
                    <td>{this.props.data.created_at}</td>
                    <td><span className="badge">{this.props.data.status_upcase}</span></td>
                    <td className="right-align">{this.props.data.grand_total}</td>
                </tr>
            );
        }
    });
})();
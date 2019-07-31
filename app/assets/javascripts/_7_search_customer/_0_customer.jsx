var searchCustomerApp = searchCustomerApp || {};

(function () {

    searchCustomerApp.Customer = createReactClass({

        render: function() {
            return (
                <tr>
                    <td>{this.props.lineNumber}</td>
                    <td>{this.props.data.name}</td>
                    <td>{this.props.data.company}</td>
                    <td>{this.props.data.phone}</td>
                    <td>{this.props.data.tin_no}</td>
                    <td dangerouslySetInnerHTML={{__html: this.props.data.actions}}/>
                </tr>
            );
        }
    });
})();
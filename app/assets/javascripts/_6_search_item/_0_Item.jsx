var searchItemApp = searchItemApp || {};

(function () {

    searchItemApp.Item = React.createClass({

        render: function() {
            return (
                <tr>
                    <th>{this.props.lineNumber}</th>
                    <th>{this.props.data.name}</th>
                    <th>{this.props.data.description}</th>
                    <th>{this.props.data.original_number}</th>
                    <th>{this.props.data.item_number}</th>
                    <th>{this.props.data.prev_number}</th>
                    <th>{this.props.data.next_number}</th>
                    <th>{this.props.data.car}</th>
                    <th>{this.props.data.sale_price}</th>
                    <th dangerouslySetInnerHTML={{__html: this.props.data.inventories_display}}/>
                    <th>{this.props.data.brand}</th>
                    <th >{this.props.data.made}</th>
                    <th dangerouslySetInnerHTML={{__html: this.props.data.actions}}/>
                </tr>
            );
        }
    });
})();
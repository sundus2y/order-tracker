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
                    <th className="item_number_focus">{this.props.data.item_number}</th>
                    <th>{this.props.data.prev_number}</th>
                    <th>{this.props.data.next_number}</th>
                    <th>{this.props.data.car}</th>
                    <th className={this.props.data.default_sale_price ? "right-align default_sale_price" : "right-align"}>{Math.round(this.props.data.sale_price).toLocaleString()}</th>
                    <th className="right-align">{Math.round((this.props.data.dubai_price * this.props.config.dubai_rate)).toLocaleString()}</th>
                    <th className="right-align">{Math.round((this.props.data.korea_price * this.props.config.korea_rate)).toLocaleString()}</th>
                    <th className="right-align">{Math.round(this.props.data.cost_price).toLocaleString()}</th>
                    <th dangerouslySetInnerHTML={{__html: this.props.data.inventories_display}}/>
                    <th>{this.props.data.brand}</th>
                    <th >{this.props.data.made}</th>
                    <th dangerouslySetInnerHTML={{__html: this.props.data.actions}}/>
                </tr>
            );
        }
    });
})();
var searchItemApp = searchItemApp || {};

(function () {

    searchItemApp.Item = createReactClass({

        cal_dubai_price: function(){
            if (this.props.data.dubai_price) {
                return this.props.data.dubai_price * this.props.config.dubai_rate;
            } else {
                return 0;
            }
        },

        cal_korea_price: function(){
            if (this.props.data.korea_price) {
                return this.props.data.korea_price * this.props.config.korea_rate;
            } else {
                return 0;
            }
        },

        cal_cost_price: function() {
            if (this.props.data.cost_price) {
                return this.props.data.cost_price;
            } else {
                return 0;
            }
        },

        render: function() {
            return (
                <tr>
                    <td>{this.props.lineNumber}</td>
                    <td>{this.props.data.name}</td>
                    <td>{this.props.data.description}</td>
                    <td>{this.props.data.original_number}</td>
                    <td className="item_number_focus">{this.props.data.item_number}</td>
                    <td>{this.props.data.prev_number}</td>
                    <td>{this.props.data.next_number}</td>
                    <td>{this.props.data.car}</td>
                    <td className={this.props.data.default_sale_price ? "right-align default_sale_price" : "right-align"}>{Math.round(this.props.data.sale_price).toLocaleString()}</td>
                    <td className="right-align">{printCurrency(this.cal_dubai_price())}</td>
                    <td className="right-align">{printCurrency(this.cal_korea_price())}</td>
                    <td className="right-align">{printCurrency(this.cal_cost_price())}</td>
                    <td dangerouslySetInnerHTML={{__html: this.props.data.inventories_display}}/>
                    <td dangerouslySetInnerHTML={{__html: this.props.data.proforma_display}}/>
                    <td dangerouslySetInnerHTML={{__html: this.props.data.order_display}}/>
                    <td>{this.props.data.brand}</td>
                    <td >{this.props.data.made}</td>
                    <td dangerouslySetInnerHTML={{__html: this.props.data.actions}}/>
                </tr>
            );
        }
    });
})();
var searchSaleApp = searchSaleApp || {};

(function () {

    searchSaleApp.Sale = React.createClass({

        render: function() {
            var edit_action = (
                <a className="btn btn-sm btn-primary fa fa-edit draft_actions" href={'/sales/'+this.props.data.id+'/edit'}><span className="link-btn">Edit</span></a>
            )

            var credit_action = (
                <li><a className="btn btn-sm btn-primary btn-block" data-remote="true" href={'/sales/'+this.props.data.id+'/submit_to_credited'}><span className="link-btn">Credit</span></a></li>
            )

            var sample_action = (
                <li><a className="btn btn-sm btn-primary btn-block" data-remote="true" href={'/sales/'+this.props.data.id+'/submit_to_sampled'}><span className="link-btn">Sample</span></a></li>
            )

            var sale_action = (
                <li><a className="btn btn-sm btn-primary btn-block" data-remote="true" href={'/sales/'+this.props.data.id+'/submit_to_sold'}><span className="link-btn">Submit</span></a></li>
            )

            var mark_as_sold_action = (
                <li><a className="btn btn-sm btn-primary btn-block" data-remote="true" href={'/sales/'+this.props.data.id+'/mark_as_sold'}><span className="link-btn">Mark as Sold</span></a></li>
            )

            var submit_actions = (
                <div className="btn-group draft_actions">
                    <a className="btn btn-sm btn-primary fa fa-chevron-down btn-group-toggle" href="#"> More</a>
                    <ul className="dd-menu hidden">
                        {this.props.data.can_submit ? sale_action : ''}
                        {this.props.data.can_mark_as_sold ? mark_as_sold_action : ''}
                        {this.props.data.can_credit ? credit_action : ''}
                        {this.props.data.can_sample ? sample_action : ''}
                    </ul>
                </div>
            )

            var delete_action = (
                <span>
                    <div className="modal fade" data-duplicate="true" id={'confirm_sale_delete_'+this.props.data.id+''}>
                        <div className="modal-dialog">
                            <div className="modal-content">
                                <div className="modal-header">
                                    <button type="button" className="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                                    <h4 className="modal-title">Warning</h4>
                                </div>
                                <div className="modal-body">
                                    This sale contains <b>{this.props.data.sale_items_count}</b> sale items.<br/>
                                    Are you sure you want to delete <b>Sale #{this.props.data.id}</b>?
                                </div>
                                <div className="modal-footer">
                                    <a className="btn btn-info" data-dismiss="modal" data-remote="true" rel="nofollow" data-method="delete" href={'/sales/'+this.props.data.id+''}>Yes</a>
                                    <button type="button" className="btn btn-info" data-dismiss="modal">No</button>
                                </div>
                            </div>
                        </div>
                    </div>
                        <button type="button" className="btn btn-sm btn-danger fa fa-trash draft_actions" data-toggle="modal" data-target={'#confirm_sale_delete_'+this.props.data.id+''}><span className="link-btn">Delete</span></button>
                </span>
            )

            return (
                <tr data-id={this.props.data.id}>
                    <td>{this.props.data.id}</td>
                    <td>{this.props.data.customer.name}</td>
                    <td>{this.props.data.created_at}</td>
                    <td><span className="badge">{this.props.data.status_upcase}</span></td>
                    <td className="right-align">{this.props.data.grand_total}</td>
                    <td>
                        <a className="btn btn-sm btn-primary fa fa-folder-open" href={'/sales/'+this.props.data.id+''}><span className="link-btn">Open</span></a>
                        {this.props.data.can_edit ? edit_action : ''}
                        {this.props.data.can_delete ? delete_action : ''}
                        {(this.props.data.can_submit || this.props.data.can_mark_as_sold)? submit_actions : ''}
                    </td>
                </tr>
            );
        }
    });
})();
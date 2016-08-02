var searchSaleApp = searchSaleApp || {};

(function () {

    searchSaleApp.Sale = React.createClass({

        render: function() {
            var edit_action = (
                <a type="button" className="btn btn-sm btn-block btn-primary fa fa-edit" href={'/sales/'+this.props.data.id+'/edit'}> Edit</a>
            )

            var credit_action = (
                <a className="btn btn-sm btn-primary btn-block" data-remote="true" href={'/sales/'+this.props.data.id+'/submit_to_credited'}> Credit</a>
            )

            var sample_action = (
                <a className="btn btn-sm btn-primary btn-block" data-remote="true" href={'/sales/'+this.props.data.id+'/submit_to_sampled'}> Sample</a>
            )

            var sale_action = (
                <a className="btn btn-sm btn-primary btn-block" data-remote="true" href={'/sales/'+this.props.data.id+'/submit_to_sold'}> Submit</a>
            )

            var mark_as_sold_action = (
                <a className="btn btn-sm btn-primary btn-block" data-remote="true" href={'/sales/'+this.props.data.id+'/mark_as_sold'}> Mark as Sold</a>
            )

            var delete_action = (
                <a type="button" className="btn btn-sm btn-block btn-danger fa fa-trash" data-toggle="modal" data-target={'#confirm_sale_delete_'+this.props.data.id+''}> Delete</a>
            )

            var delete_action_confirm = (
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
            )

            return (
                <tr data-id={this.props.data.id}>
                    <td>{this.props.data.id}</td>
                    <td>{this.props.data.customer.name}</td>
                    <td>{this.props.data.created_at}</td>
                    <td><span className="badge">{this.props.data.status_upcase}</span></td>
                    <td className="right-align">{this.props.data.grand_total}</td>
                    <td>
                        <div className="btn-group btn-block">
                            <button type="button" className="btn btn-sm  btn-primary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                Actions <span className="caret"></span>
                            </button>
                            <ul className="dropdown-menu">
                                <a className="btn btn-sm btn-block btn-primary fa fa-folder-open" href={'/sales/'+this.props.data.id+''}> Open</a>
                                {this.props.data.can_edit ? edit_action : ''}
                                {this.props.data.can_delete ? delete_action : ''}
                                {this.props.data.can_submit ? sale_action : ''}
                                {this.props.data.can_mark_as_sold ? mark_as_sold_action : ''}
                                {this.props.data.can_credit ? credit_action : ''}
                                {this.props.data.can_sample ? sample_action : ''}
                            </ul>
                        </div>
                        {this.props.data.can_delete ? delete_action_confirm : ''}
                    </td>
                </tr>
            );
        }
    });
})();
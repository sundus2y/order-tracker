var searchSaleApp = searchSaleApp || {};

(function () {

    searchSaleApp.Sale = React.createClass({

        render: function() {
            var edit_action = (
                <li><a className="btn btn-primary item-pop-up-menu" href={'/sales/'+this.props.data.id+'/edit'}><i className="fa fa-edit"/> Edit</a></li>
            );

            var print_action = (
                <li><a className="btn btn-primary item-pop-up-menu" href={'/sales/'+this.props.data.id+'/print'} target="_blank"><i className="fa fa-print"/> Print</a></li>
            );

            var credit_action = (
                <li><a className="btn btn-success item-pop-up-menu" href={'/sales/'+this.props.data.id+'/submit_to_credited'}><i className="fa fa-exchange"/> Credit</a></li>
            );

            var sample_action = (
                <li><a className="btn btn-success item-pop-up-menu" href={'/sales/'+this.props.data.id+'/submit_to_sampled'}><i className="fa fa-exchange"/> Sample</a></li>
            );

            var sale_action = (
                <li><a className="btn btn-success item-pop-up-menu" href={'/sales/'+this.props.data.id+'/submit_to_sold'}><i className="fa fa-send"/> Submit</a></li>
            );

            var mark_as_sold_action = (
                <li><a className="btn btn-success item-pop-up-menu" href={'/sales/'+this.props.data.id+'/mark_as_sold'}><i className="fa fa-send"/> Mark as Sold</a></li>
            );

            var delete_action = (
                <li><a className="btn btn-danger item-pop-up-menu" data-toggle="modal" data-target={'#confirm_sale_delete_'+this.props.data.id+''}><i className="fa fa-trash"/> Delete</a></li>
            );

            var edit_fs_num = (
                <li><a className='btn btn-primary pop_up item-pop-up-menu edit_fs_num' href={'/sales/'+this.props.data.id+'/pop_up_fs_num_edit'}><i className='fa fa-barcode'/> Add/Edit FS</a></li>
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
            );

            return (
                <tr data-id={this.props.data.id} className={this.props.data.status_upcase}>
                    <td>{this.props.data.transaction_num}</td>
                    <td>{this.props.data.fs_num}</td>
                    <td>{this.props.data.customer.name}</td>
                    <td>{this.props.data.store.name}</td>
                    <td>{this.props.data.formatted_created_at}</td>
                    <td>{this.props.data.formatted_updated_at}</td>
                    <td><span className="badge">{this.props.data.status_upcase}</span></td>
                    <td className="right-align">{printCurrency(this.props.data.grand_total)}</td>
                    <td>
                        <div className="btn-group">
                            <a className="btn btn-sm btn-primary dropdown-toggle" data-toggle="dropdown" href="#">
                                Actions <span className="fa fa-caret-down"></span>
                            </a>
                            <ul className="dropdown-menu context-menu">
                                <li>
                                    <a className="btn btn-primary item-pop-up-menu" href={'/sales/'+this.props.data.id+''}><i className="fa fa-folder-open"></i> Open</a>
                                </li>
                                {this.props.data.can_edit ? edit_action : ''}
                                {this.props.data.can_submit ? sale_action : ''}
                                {this.props.data.can_mark_as_sold ? mark_as_sold_action : ''}
                                {this.props.data.can_credit ? credit_action : ''}
                                {this.props.data.can_sample ? sample_action : ''}
                                {this.props.data.can_print ? print_action : ''}
                                {this.props.data.can_edit_fs_num ? edit_fs_num : ''}
                                {this.props.data.can_delete ? delete_action : ''}
                            </ul>
                        </div>
                        {this.props.data.can_delete ? delete_action_confirm : ''}
                    </td>
                </tr>
            );
        }
    });
})();
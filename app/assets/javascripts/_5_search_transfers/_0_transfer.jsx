var searchTransferApp = searchTransferApp || {};

(function () {

    searchTransferApp.Transfer = React.createClass({

        render: function() {
            var edit_action = (
                <li><a className="btn-primary item-pop-up-menu" href={'/transfers/'+this.props.data.id+'/edit'}><i className="fa fa-edit"/> Edit</a></li>
            )

            var transfer_action = (
                <li><a className="btn-primary item-pop-up-menu" href={'/transfers/'+this.props.data.id+'/submit'}><i className="fa fa-exchange"/> Transfer</a></li>
            )

            var receive_action = (
                <li><a className="btn-primary item-pop-up-menu" href={'/transfers/'+this.props.data.id+'/receive'}><i className="fa fa-exchange"/> Receive</a></li>
            )

            var delete_action = (
                <li><a className="btn-danger item-pop-up-menu" data-toggle="modal" href="#" data-target={'#confirm_transfer_delete_'+this.props.data.id+''}><i className="fa fa-trash"/> Delete</a></li>
            )
            
            var delete_action_confirm = (
                <div className="modal fade" data-duplicate="true" id={'confirm_transfer_delete_'+this.props.data.id+''}>
                    <div className="modal-dialog">
                        <div className="modal-content">
                            <div className="modal-header">
                                <button type="button" className="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                                <h4 className="modal-title">Warning</h4>
                            </div>
                            <div className="modal-body">
                                This transfer contains <b>{this.props.data.transfer_items_count}</b> transfer items.<br/>
                                Are you sure you want to delete <b>Transfer #{this.props.data.id}</b>?
                            </div>
                            <div className="modal-footer">
                                <a className="btn btn-info" data-dismiss="modal" data-remote="true" rel="nofollow" data-method="delete" href={'/transfers/'+this.props.data.id}>Yes</a>
                                <button type="button" className="btn btn-info" data-dismiss="modal">No</button>
                            </div>
                        </div>
                    </div>
                </div>
            )

            return (
                <tr data-id={this.props.data.id}>
                    <td>{this.props.data.id}</td>
                    <td>{this.props.data.from_store.name}</td>
                    <td>{this.props.data.sender ? this.props.data.sender.name : 'NA'}</td>
                    <td>{this.props.data.to_store.name}</td>
                    <td>{this.props.data.receiver ? this.props.data.receiver.name : 'NA'}</td>
                    <td><span className="badge">{this.props.data.status_upcase}</span></td>
                    <td className="right-align">{this.props.data.transfer_items_count}</td>
                    <td className="right-align">{this.props.data.transfer_total_items_count}</td>
                    <td>
                        <div className="btn-group">
                            <a className="btn btn-sm btn-primary dropdown-toggle" data-toggle="dropdown" href="#">
                                Actions <span className="fa fa-caret-down"></span>
                            </a>
                            <ul className="dropdown-menu context-menu">
                                <li>
                                    <a className="btn-primary item-pop-up-menu" href={'/transfers/'+this.props.data.id+''}><i className="fa fa-folder-open"></i> Open</a>
                                </li>
                                {this.props.data.can_edit ? edit_action : ''}
                                {this.props.data.can_transfer ? transfer_action : ''}
                                {this.props.data.can_receive ? receive_action : ''}
                                {this.props.data.can_delete ? '' : ''}
                            </ul>
                        </div>
                        {this.props.data.can_delete ? delete_action_confirm : ''}
                    </td>
                </tr>
            );
        }
    });
})();
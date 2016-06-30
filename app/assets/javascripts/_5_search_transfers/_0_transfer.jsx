var searchTransferApp = searchTransferApp || {};

(function () {

    searchTransferApp.Transfer = React.createClass({

        render: function() {
            var edit_action = (
                <a className="btn btn-sm btn-primary fa fa-edit draft_actions" href={'/transfers/'+this.props.data.id+'/edit'}><span className="link-btn">Edit</span></a>
            )

            var transfer_action = (
                <a className="btn btn-sm btn-primary btn-block" data-remote="true" href={'/transfers/'+this.props.data.id+'/transfer'}><span className="link-btn">Transfer</span></a>
            )

            var receive_action = (
                <a className="btn btn-sm btn-primary btn-block" data-remote="true" href={'/transfers/'+this.props.data.id+'/receive'}><span className="link-btn">Receive</span></a>
            )

            var delete_action = (
                <span>
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
                                    <a className="btn btn-info" data-dismiss="modal" data-remote="true" rel="nofollow" data-method="delete" href={'/transfers/'+this.props.data.id+''}>Yes</a>
                                    <button type="button" className="btn btn-info" data-dismiss="modal">No</button>
                                </div>
                            </div>
                        </div>
                    </div>
                        <button type="button" className="btn btn-sm btn-danger fa fa-trash draft_actions" data-toggle="modal" data-target={'#confirm_transfer_delete_'+this.props.data.id+''}><span className="link-btn">Delete</span></button>
                </span>
            )

            return (
                <tr data-id={this.props.data.id}>
                    <td>{this.props.data.id}</td>
                    <td>{this.props.data.from_store.name}</td>
                    <td>{this.props.data.to_store.name}</td>
                    <td><span className="badge">{this.props.data.status_upcase}</span></td>
                    <td className="right-align">{this.props.data.transfer_items_count}</td>
                    <td>
                        <a className="btn btn-sm btn-primary fa fa-folder-open" href={'/transfers/'+this.props.data.id+''}><span className="link-btn">Open</span></a>
                        <div className="dropdown">
                            <button type="button" className="dropbtn" data-target={'myDropdown_'+this.props.data.id}>Actions <i className="fa fa-chevron-down"></i></button>
                            <div id={'myDropdown_'+this.props.data.id} className="dropdown-content" style={{display: 'block'}}>
                                {this.props.data.can_edit ? edit_action : ''}
                                {this.props.data.can_transfer ? transfer_action : ''}
                                {this.props.data.can_receive ? receive_action : ''}
                                {this.props.data.can_delete ? delete_action : ''}
                                <button name="button" type="submit">Save</button>
                                <button name="button" type="submit" data-action="/transfers/9/submit">Transfer</button>
                            </div>
                        </div>
                    </td>
                </tr>
            );
        }
    });
})();
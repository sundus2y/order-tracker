//var converter = new Showdown.converter();
//
//var Item = React.createClass({
//   render: function(){
//       return (
//         <tr>
//
//         </tr>
//       );
//   }
//});
//
//var Comment = React.createClass({
//    handleRemoveComment: function(){
//        this.props.onCommentDelete(this.props.key+1);
//    },
//    render: function() {
//        var rawMarkup = converter.makeHtml(this.props.children.toString());
//        return (
//            <div className="comment panel panel-default">
//                <div className="panel-heading">
//                    <h3 className="panel-title">
//                        {this.props.author}
//                        <span className="close" onClick={this.handleRemoveComment}>X</span>
//                    </h3>
//                </div>
//                <div className="panel-body">
//                    <span dangerouslySetInnerHTML={{__html: rawMarkup}} />
//                </div>
//            </div>
//        );
//    }
//});
//
//var CommentBox = React.createClass({
//    loadCommentsFromServer: function() {
//        $.ajax({
//            url: this.props.url,
//            dataType: 'json',
//            success: function(data) {
//                this.setState({data: data});
//            }.bind(this),
//            error: function(xhr, status, err) {
//                console.error(this.props.url, status, err.toString());
//            }.bind(this)
//        });
//    },
//    handleCommentDelete: function(comment_id) {
//        var comments = this.state.data;
//        var deleted_comment = null;
//        var new_comments = comments.filter(function(comment){
//            if (comment.id === comment_id){
//                deleted_comment = comment;
//                return false;
//            } else {
//                return true;
//            }
//        })
//
//        this.setState({data: new_comments }, function(){
//            $.ajax({
//                url: 'comments/1.json',
//                dataType: 'json',
//                type: 'DELETE',
//                data: {comment: deleted_comment},
//                success: function(data){
//                }.bind(this),
//                error: function(xhr,status,err){
//                    new_comments.push(deleted_comment);
//                    this.setState({data: new_comments});
//                    console.error(status,err.toString());
//                }.bind(this)
//            });
//        });
//    },
//    handleCommentSubmit: function(comment) {
//        var comments = this.state.data;
//        comments.push(comment);
//        this.setState({data: comments}, function() {
//            // `setState` accepts a callback. To avoid (improbable) race condition,
//            // `we'll send the ajax request right after we optimistically set the new
//            // `state.
//            $.ajax({
//                url: this.props.url,
//                dataType: 'json',
//                type: 'POST',
//                data: { comment: comment },
//                success: function(data) {
//                }.bind(this),
//                error: function(xhr, status, err) {
//                    comments.pop();
//                    this.setState({data: comments});
//                    console.error(this.props.url, status, err.toString());
//                }.bind(this)
//            });
//        });
//    },
//    getInitialState: function() {
//        return {data: []};
//    },
//    componentDidMount: function() {
//        this.loadCommentsFromServer();
//        setInterval(this.loadCommentsFromServer, this.props.pollInterval);
//    },
//    render: function() {
//        return (
//            <div className="commentBox">
//                <h1>Comments</h1>
//                <CommentList data={this.state.data} onCommentDelete={this.handleCommentDelete} />
//                <CommentForm onCommentSubmit={this.handleCommentSubmit} />
//            </div>
//        );
//    }
//});
//
//var CommentList = React.createClass({
//    render: function() {
//        var self = this;
//        var func = this.props.onCommentDelete;
//        var commentNodes = this.props.data.map(function(comment, index) {
//            return (
//                // `key` is a React-specific concept and is not mandatory for the
//                // purpose of this tutorial. if you're curious, see more here:
//                // http://facebook.github.io/react/docs/multiple-components.html#dynamic-children
//                <Comment author={comment.author} key={index} onCommentDelete={func}>
//                    {comment.text}
//                </Comment>
//            );
//        });
//        return (
//            <div className="commentList">
//                {commentNodes}
//            </div>
//        );
//    }
//});
//
//var CommentForm = React.createClass({
//    handleSubmit: function(e) {
//        e.preventDefault();
//        var author = this.refs.author.getDOMNode().value.trim();
//        var text = this.refs.text.getDOMNode().value.trim();
//        if (!text || !author) {
//            return;
//        }
//        this.props.onCommentSubmit({author: author, text: text});
//        this.refs.author.getDOMNode().value = '';
//        this.refs.text.getDOMNode().value = '';
//        return;
//    },
//    render: function() {
//        return (
//            <div className="panel panel-default">
//                <div className="panel-heading">Add a Note</div>
//                <div className="panel-body">
//                    <form className="commentForm " onSubmit={this.handleSubmit}>
//                        <div className="form-group">
//                            <label className="control-label" forName="authorInput">Author</label>
//                            <input type="text" id="authorInput" className="form-control" placeholder="Your name" ref="author" />
//                        </div>
//                        <div className="form-group">
//                            <label className="control-label" forName="commentInput">Comment</label>
//                            <textarea className="form-control" id="commentInput" rows="3" placeholder="Say something..." ref="text" />
//                        </div>
//                        <input type="submit" className="btn btn-primary" value="Post" />
//                    </form>
//                </div>
//            </div>
//        );
//    }
//});
//
//$(document).ready(function() {
//    var $content = $("#react_content");
//    if ($content.length > 0) {
//        React.render(
//            <CommentBox url="comments.json" pollInterval={20000} />,
//            document.getElementById('react_content')
//        );
//    }
//})
//

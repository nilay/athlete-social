// requires LoDash

class ReactionChain extends React.Component {
  constructor(props) {
    super(props);

    // cache methods
    this._getOrigClass   = this._getOrigClass.bind(this);
    this._selectOrigPost = this._selectOrigPost.bind(this);
    this._selectReaction = this._selectReaction.bind(this);
    this._setVideo = this._setVideo.bind(this);
  }

  render() {
    let avatar = this.props.origPost.athlete.avatar.thumbnail_url;
    let reactions = this.props.reactions;
    let reactionsAmnt = _.isEmpty(reactions);
    let origClass = this._getOrigClass(reactionsAmnt);
    let content = reactionsAmnt ?
      <li className="username-item">{ this.props.username }</li> :
      reactions.map((item, index) => {
        return (
          <li data-index={ index } className="reaction-item" key={ item.id }>
            <img onClick={ this._selectReaction } className="avatar" src={ item.athlete.avatar.thumbnail_url } title="user avatar" />
          </li>
        );
      });

    return (
      <div id="reactionContainer" className="reaction-chain-wrapper">
        <ul id="reactionList" className="reaction-list">
          <li className={ origClass }>
            <img onClick={ this._selectOrigPost } className="avatar" src={ avatar } title="user avatar" />
          </li>

          { content }
        </ul>
      </div>
    );
  }

  // PRIVATE

  _getOrigClass(count) {
    let classes;

    if (count) {
      classes = 'reaction-item orig-post no-reactions';
    } else {
      classes = 'reaction-item orig-post active';
    }

    return classes;
  }


  _selectOrigPost(e) {
    let oldEl   = document.querySelector('.reaction-item.active'),
        el = e.target.parentNode,
        classes = el.className,
        origPost = this.props.origPost.urls;

    if (classes == 'reaction-item orig-post no-reactions') {
      return;
    } else {
      oldEl.className = 'reaction-item';
      el.className = 'reaction-item orig-post active';
    }

    this.props.handleChange(origPost);
  }


  _selectReaction(e) {
    let oldEl = document.querySelector('.reaction-item.active'),
        newEl = e.target.parentNode,
        index = newEl.dataset.index;

    if (oldEl.className == 'reaction-item orig-post active') {
      oldEl.className = 'reaction-item orig-post';
      newEl.className = 'reaction-item active';
    } else {
      oldEl.className = 'reaction-item';
      newEl.className = 'reaction-item active';
    }

    this._setVideo(index);
  }


  _setVideo(eq) {
    let reaction = this.props.reactions[eq],
        share = reaction.urls;
    this.props.handleChange(share);
  }
}

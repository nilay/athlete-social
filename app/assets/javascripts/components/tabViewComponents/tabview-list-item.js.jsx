class TabViewListItem extends React.Component {
  constructor(props) {
    super(props);
    this.modal = ModalAction;

    // cache methods
    this._getImage = this._getImage.bind(this);
    this._showImage = this._showImage.bind(this);
    this._showPostDetails = this._showPostDetails.bind(this);
  }

  render() {
    let listClasses = this._getImage() !== '' ? 'list-item' : 'list-item no-cursor';
    let preview = this._getImage();
    let classes = this._showImage();

    return (
      <li className={ listClasses } data-id={ this.props.id }
          onClick={ this._getImage() !== '' ? this._showPostDetails : '' }>
        <img src={ preview } className={ classes } />
      </li>
    );
  }

  // PRIVATE

  _getImage() {
    let props = this.props.urls ? this.props.urls : '';
    if (props !== '') {
      return props.thumbnail_url;
    } else {
      return '';
    }
  }

  _showImage() {
    let img = this._getImage();
    if (img === '') {
      return 'none';
    } else {
      return;
    }
  }

  _showPostDetails() {
    let athleteContainer = document.querySelector('.athlete-profile-content'),
        modalData;

    modalData = {
      modalType: 'post.showDetail',
      props: {
        athleteName: this.props.athleteInfo.athleteName,
        avatar: this.props.athleteInfo.avatar,
        post: this.props.urls.share_url,
        postImg: this.props.urls.thumbnail_url,
        postId: this.props.id,
        userId: this.props.athlete_id,
        timestamp: typeof this.props.timestamp !== 'undefined' ? this.props.timestamp : null,
        total_comments: typeof this.props.comments !== 'undefined' ? this.props.comments : 0,
        total_reactions: typeof this.props.reactions !== 'undefined' ? this.props.reactions : 0
      }
    };
    this.modal.showModal('postDetail', modalData);
  }
}

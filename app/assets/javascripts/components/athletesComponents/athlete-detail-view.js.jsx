// requires LoDash

class AthleteDetailView extends React.Component {
  constructor(props) {
    super(props);

    // set initial states
    this.state = {
      athlete: {},
      avatar: '',
      posts: '',
      reactions: '',
      show: ''
    };

    // cache methods
    this._getStatus = this._getStatus.bind(this);
    this._goBack = this._goBack.bind(this);
    this._onChange = this._onChange.bind(this);
  }

  componentWillReceiveProps(nextProps) {
    if (_.isEmpty(nextProps) || _.isEmpty(nextProps.athlete)) {
      return;
    } else {
      this.setState({
        athlete: nextProps.athlete,
        avatar: nextProps.athlete.avatar.thumbnail_url,
        posts: nextProps.athlete.posts,
        reactions: nextProps.athlete.reactions,
        show: nextProps.showView,
      });
    }
  }

  render() {
    let classes = this.state.show + ' admin-athlete-profile-container view details-view';
    let state   = this.state.athlete;
    let stateClass = this._getStatus() + ' player-status';
    let status = this._getStatus();

    let tabInfo = [
      { title: 'posts',
        content: this.state.posts
      },
      { title: 'reactions',
        content: this.state.reactions
      },
    ];

    return (
      <div className={ classes }>
        <div className="athlete-details-header">
          <button type="button" className="simple-btn athlete-details-back-btn"
            onClick={ this._goBack }></button>
          <div className="filler"></div>
          <button type="button" className="simple-btn athlete-settings-btn"></button>
        </div>

        <div className="athlete-profile-content">
          <div className="img-container">
            <image src={ this.state.avatar || '' } alt="" title="user avatar" />
          </div>
          <h2 className="username">{ state.first_name + ' ' +  state.last_name }</h2>
          <p className="player-status">{ state.email }</p>
          <p className={ stateClass }>{ status }</p>
        </div>

        <TabView { ... state } tabData={ tabInfo } />
      </div>
    );
  }

  // PRIVATE

  _getStatus() {
    if (this.state.athlete.active) {
      return 'active';
    } else {
      return 'inactive';
    }
  }

  _goBack() {
    this.setState({
      show: ''
    });
    this.props.handleChange();
  }

  _onChange() {
    this.forceUpdate();
  }
}

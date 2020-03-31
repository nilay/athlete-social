// requires Hammer
// requires jQuery

class ExportView extends React.Component {
  constructor(props) {
    super(props);
    this.hammertime = null;
    this.post = JSON.parse(props.post);

    // init state
    this.state = {
      currentVid: this.post.urls.share_url,
      currentPoster: this.post.urls.thumbnail_url,
      progress: 0
    };

    // cache methods
    this._getName     = this._getName.bind(this);
    this._scrollPage  = this._scrollPage.bind(this);
    this._setProgress = this._setProgress.bind(this);
    this._setVideo    = this._setVideo.bind(this);
    this._swipeLeft   = this._swipeLeft.bind(this);
    this._swipeRight  = this._swipeRight.bind(this);
    this._swipeReactions = this._swipeReactions.bind(this);
  }

  componentDidMount() {
    let el = document.getElementById('reactionContainer');
    this.hammertime = new Hammer(el);
    this.hammertime.on('swipe', this._swipeReactions, false);
    this._scrollPage();
  }

  componentWillUnmount() {
    this.hammertime.off('swipe', this._swipeReactions, false);
  }

  render() {
    let post = this.post;
    let name   = _.isEmpty(post.reactions) ? '' : this._getName();
    let reactions = post.reactions ? post.reactions : {};

    return(
      <div className="export-view-container">
        <div className="export-main-header">
          <div className="logo-container">
            <a href="/">
              <img src={ this.props.logo } title="pros logo" />
            </a>
          </div>

          <div className="promo-btn-container">
            <a className="btn" href="https://itunes.apple.com/us/app/pros-made-by-athletes-enjoyed/id1093857485?ls=1&mt=8">
              get the app
            </a>
          </div>
        </div>

        <div className="video-wrapper">
          <ProgressBar progress={ this.state.progress } />
          <VideoView
            content={ this.state.currentVid }
            poster={ this.state.currentPoster }
            handleChange={ this._setProgress } />

          <div className="video-header">
            <TimeHeader time={ post.created_at } logo={ this.props.logo } />
          </div>

          <div className="video-footer">
            <div className="username">{ name }</div>
            <ReactionChain
              handleChange={ this._setVideo }
              origPost={ post }
              reactions={ reactions }
              username={ this._getName() } />
          </div>
        </div>

        <div className="export-promo-feature">
          <div className="logo-container">
            <img src={ this.props.logo } title="pros logo" />
          </div>
          <div className="feature-description">
            <p className="promo-text">
              The Pros App is a platform bringing fans closer to the athletes they
              love. We put you directly in the locker room and behind the scenes
              with professional athletes around the world. Unfiltered and
              unscripted.<br />
              Made by Athletes, &hearts; by you.
            </p>

            <div className="two-btn-container">
              <div className="promo-btn-container">
                <a className="btn" href="https://itunes.apple.com/us/app/pros-made-by-athletes-enjoyed/id1093857485?ls=1&mt=8">
                  get the app
                </a>
              </div>

              <div className="promo-btn-container">
                <a className="btn" href="/">site</a>
              </div>
            </div>

            <div className="promo-footer">
              <a className="link" href="./tos">terms of service</a>
              <a className="link" href="mailto:hello@theprosapp.com">contact</a>
            </div>
          </div>
        </div>
      </div>
    );
  }

  // PRIVATE

  _getName() {
    let athlete = this.post.athlete,
        name;

    if (athlete) {
      name = athlete.first_name + ' ' + athlete.last_name;
    } else {
      name = 'Man of Mystery';
    }

    return name;
  }

  _scrollPage() {
    $(document).on('scroll', function() {
      let dist = $(document).scrollTop() / 2,
          $container = $('div[data-react-class="ExportView"]');
      $container.css('background-position','0 ' +  dist + 'px');
    });
  }

  _setProgress(progress) {
    this.setState({
      progress: progress
    });
  }

  _setVideo(selectedVid) {
    this.setState({
      currentVid: selectedVid.share_url,
      currentPoster: selectedVid.thumbnail_url
    });
  }

  _swipeReactions(e) {
    let direction = e.direction,
        distance  = 50;

    switch (direction) {
      case 2:
        this._swipeLeft(distance);
        distance += 50;
        break;
      case 4:
        this._swipeRight();
        break;
      default:
    }
  }

  _swipeLeft(dist) {
    let el = document.getElementById('reactionList');

    if (dist >= 100) {
      return;
    } else {
      el.style.transform = 'translateX(-' + dist + '%)';
    }
  }

  _swipeRight() {
    let el = document.getElementById('reactionList');
    el.style.transform = 'translateX(0)';
  }
}

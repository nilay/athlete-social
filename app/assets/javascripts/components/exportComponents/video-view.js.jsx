class VideoView extends React.Component {
  constructor(props) {
    super(props);

    // init state
    this.state = {
      content: this.props.content,
      playing: 'playing',
      poster: this.props.poster
    };

    // cache methods
    this._initProgressBar = this._initProgressBar.bind(this);
    this._playVideo  = this._playVideo.bind(this);
    this._pauseVideo = this._pauseVideo.bind(this);
    this._updatePlayingState = this._updatePlayingState.bind(this);
  }

  componentDidMount() {
    let video = document.getElementById('vid');
    video.addEventListener('timeupdate', this._initProgressBar, false);
  }

  componentWillReceiveProps(nextprops) {
    this.setState({
      content: nextprops.content,
      playing: 'playing',
      poster: nextprops.poster,
    });
  }

  componentWillUnmount() {
    let video = document.getElementById('vid');
    video.removeEventListener('timeupdate', this._initProgressBar, false);
  }

  render() {
    let content = this.state.content ? this.state.content : '';
    let poster = this.state.poster ? this.state.poster : '';
    let replayClass = this.state.playing + ' replay-btn';

    return (
      <div className="video-wrapper">
        <span id="playBtn" className="play-btn" onClick={ this._playVideo }></span>
        <span id="replayBtn" className={ replayClass } onClick={ this._playVideo }></span>
        <video id="vid"
          className="feature-video"
          data-status={ this.state.playing }
          poster={ poster }
          src={ content }
          onClick={ this._pauseVideo } />
      </div>
    );
  }

  // PRIVATE

  _initProgressBar() {
    let replayBtn  = document.getElementById('replayBtn'),
        video = document.getElementById('vid'),
        currentTime = isNaN(video.currentTime) ? false : video.currentTime,
        duration = isNaN(video.duration) ? false : video.duration,
        percentage = currentTime && duration ? Math.floor((100 / video.duration) * video.currentTime) : false;

    if (percentage) {
      this.props.handleChange(percentage);
      this._updatePlayingState(percentage);
    }
  }

  _playVideo() {
    let playBtn = document.getElementById('playBtn'),
        video   = document.getElementById('vid');

    this.setState({ playing: 'playing' });
    playBtn.className = 'play-btn playing';
    video.play();
  }

  _pauseVideo() {
    let playBtn = document.getElementById('playBtn'),
        video  = document.getElementById('vid'),
        status = video.dataset.status;

    this.setState({ playing: 'playing' });

    if (status === 'playing') {
      video.pause();
      playBtn.className = 'play-btn';
    } else {
      return;
    }
  }


  _updatePlayingState(amount) {
    if (amount <= 99) {
      this.setState({ playing: 'playing' });
      return;
    } else {
      this.setState({ playing: '' });
    }
  }
}

// requires moment

class TimeHeader extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    let rawTime   = this.props.time,
        convTime  = moment(rawTime),
        today     = moment().format('YYYY M DD'),
        serverDay = convTime.format('YYYY M DD'),
        time      = today === serverDay ? convTime.startOf('hour').fromNow() : convTime.fromNow();

    return (
      <div className="video-time-header">
        <span className="logo-container">
          <a className="link" href="https://www.theprosapp.com/">
            <img className="logo" src={ this.props.logo } title="pros logo" />
          </a>
        </span>
        <span className="time">{ time }</span>
      </div>
    );
  }
}

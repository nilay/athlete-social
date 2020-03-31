class ProgressBar extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    let style = {
      width: this.props.progress + '%'
    };

    return (
      <div className="progress-container">
        <div className="bar" style={ style }></div>
      </div>
    );
  }
}

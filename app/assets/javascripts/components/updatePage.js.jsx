class UpdatePage extends React.Component {
  constructor(props) {
    super(props);

    // cache methods
    this._refreshPage = this._refreshPage.bind(this);
  }

  render() {
    return (
      <div className="refresh-container">
        <span className="br-mobile">The { this.props.context } information is out of date</span>
        <a className="link" href="javascript:void(0)" onClick={ this._refreshPage }>refresh page.</a>
      </div>
    );
  }

  // PRIVATE

  _refreshPage() {
    let url = window.location.href;
    window.location.href = url;
  }
}

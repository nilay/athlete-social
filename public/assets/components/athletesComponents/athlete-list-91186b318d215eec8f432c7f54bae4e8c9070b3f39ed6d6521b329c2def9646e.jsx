class AthleteList extends React.Component {
  constructor(props) {
    super(props);
    this.action = Action;

    // cache methods
    this._handleFormClick  = this._handleFormClick.bind(this);
    this._handleSubmit  = this._handleSubmit.bind(this);
    this._selectAthlete = this._selectAthlete.bind(this);
  }

  render() {
    return (
      <li id="athleteItem" className="athlete-list-item list-item animated"
          onClick={ this._selectAthlete }>
        <div className="list-content">
          <AthleteAvatar avatar={ this.props.avatar.thumbnail_url } />
          <div className="text-container">
            <AthleteName firstname={ this.props.first_name } lastname={ this.props.last_name } />
            <AthleteStatus { ... this.props } />
          </div>
          <div className="card-footer">
            <form formAction="" formMethod=""
              onSubmit={ this._handleSubmit } onClick={ this._handleFormClick }>
              <button type="submit" className="delte-athlete trash-btn"></button>
            </form>
          </div>
        </div>
      </li>
    );
  }

  // PRIVATE

  _handleFormClick(e) {
    e.stopPropagation();
  }

  _handleSubmit(e) {
    let that = this,
        messages = [
          `${this.props.first_name} ${this.props.last_name} has been permanently ejected from the game.`,
          `${this.props.first_name} ${this.props.last_name} is outta here!`,
          `${this.props.first_name} ${this.props.last_name} has been retired!`
        ],
        message = messages[Math.floor(Math.random() * messages.length)],
        dataObj;

    dataObj = {
      url: './athletes/deactivate',
      method: 'POST',
      params: {
        id: this.props.id
      },
      errorMsg: 'Unable to deactivate athlete. :(',
      successMsg: message
    };

    e.preventDefault();
    events.fetch(dataObj, function() {
      that.action.archiveQuestion({
        id: that.props.id,
        first_name: that.props.first_name,
        last_name: that.props.last_name,
        active: false,
        avatar: that.props.avatar
      });
    });
  }

  _selectAthlete() {
    this.props.setAthlete(this.props);
  }
}

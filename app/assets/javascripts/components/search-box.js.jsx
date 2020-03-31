
class SearchBox extends React.Component {
  constructor(props) {
    super(props);
    this.modal = ModalAction;

    // cache methods
    this._onChange  = this._onChange.bind(this);
    this._showModal = this._showModal.bind(this);
    this._showCreateModal = this._showCreateModal.bind(this);
    this._showInviteModal = this._showInviteModal.bind(this);
  }

  render() {
    return (
      <div className="search-container">
        <input type="text"
          className="search-box"
          placeholder={ 'Search ' + this.props.context + '...' }
          value={ this.props.filterText }
          ref="filterTextInput"
          onChange={ this._onChange } />
        <button type="button" className="btn light-text" value="create question"
          onClick={ this._showModal }>{ this.props.btnValue }</button>
      </div>
    );
  }


  _onChange(e) {
    this.props.onUserInput(this.refs.filterTextInput.value);
    e.stopPropagation();
  }

  _showModal() {
    if (this.props.btnValue == 'create question') {
      this._showCreateModal();
    } else {
      this._showInviteModal();
    }
  }

  _showCreateModal() {
    let uid  = document.body.dataset.user,
        type = document.body.dataset.type;

    let modalData = {
      modalType: 'question.create',
      title: 'create new question',
      type: type,
      uid: uid
    };
    this.modal.showModal('create-question', modalData);
  }

  _showInviteModal() {
    let modalData = {
      title: 'invite new athlete',
      modalType: 'athlete.invite'
    };
    this.modal.showModal('inviteAthlete', modalData);
  }
}


SearchBox.propTypes = {
  btnValue: React.PropTypes.string.isRequired
};

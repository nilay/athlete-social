class AthleteStatus extends React.Component {
  constructor(props) {
    super(props);
    this.modal = ModalAction;

    // cache methods
    this._getStatus = this._getStatus.bind(this);
    this._showModal = this._showModal.bind(this);
  }

  render() {
    let status = this._getStatus(this.props.active);
    let classes = this._getStatus(this.props.active) + ' user-status';
    return <a href="javascript:void(0)" className={classes} onClick={this._showModal}>{ status }</a>
  }

  // PRIVATE

  _getStatus(status) {
    if (status) {
      return 'active';
    } else {
      return 'inactive';
    }
  }

  _showModal(e) {
    let modalData = {
      modalType: 'athlete.changeStatus',
      props: this.props
    };

    this.modal.showModal('athleteChangeStatus', modalData);
    e.stopPropagation();
  }
}

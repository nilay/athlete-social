class Modal extends React.Component {
  constructor(props) {
    super(props);

    // set initial state
    this.state = {
      modalOpen: false
    };

    // cache methods
    this._openModal = this._openModal.bind(this);
    this._closeModal = this._closeModal.bind(this);
  }

  render() {
    return (
      <div id="modalContainer" className="modal-container" dataTurbolinksPermanent="true">
        <div className="modal-overlay"></div>
        <div id="modalContentWrapper" className="modal-content-wrapper animated">
          <div className="title">{ this.props.title }</div>
          <div className="content">{ this.props.content }</div>
        </div>
      </div>
    );
  }

  // PRIVATE

  _openModal() {
    this.setState({ modalOpen: true });
  }

  _closeModal() {
    this.setState({ modalOpen: false });
  }
}

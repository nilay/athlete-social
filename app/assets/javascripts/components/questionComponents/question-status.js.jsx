class QuestionStatus extends React.Component {
  constructor(props) {
    super(props);
    this.modal = ModalAction;

    // cache methods
    this._showModal = this._showModal.bind(this);
  }

  render() {
    var classes = this.props.status + ' question-status';

    return (
      <a href="javascript:void(0)" className={classes} onClick={this._showModal}>
         { this.props.status }
       </a>
     );
  }

  _showModal() {
    let modalData = {
      id: this.props.id,
      modalType: 'question.changeStatus',
      status: this.props.status,
      text: this.props.text,
      title: 'change status',
      type: this.props.questioner_type
    }
    this.modal.showModal('changeStatusModal', modalData);
  }
};

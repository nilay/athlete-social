// requires Modal

class QuestionActions extends React.Component {
  constructor(props) {
    super(props);
    this.actions = Action;
    this.modal = ModalAction;

    // set initial state
    this.state = {
      isOpen: ''
    };

    // cache methods
    this._archiveQuestion = this._archiveQuestion.bind(this);
    this._editQuestion    = this._editQuestion.bind(this);
  }

  componentWillReceiveProps(nextProps) {
    this.setState({ isOpen: nextProps.isOpen });
  }

  render() {
    let editClasses = this.state.isOpen + ' edit-link text-link';
    let archiveClasses = this.state.isOpen + ' archive-link text-link js-archive-question';
    let contentToShow = this.props.status == 'archived' ?
      <div></div> :
      <div className="desktop-actions-container">
        <a href="javascript:void(0)" className={editClasses}
           data-question={this.props.text} data-uid={this.props.id}
           onClick={this._editQuestion}>edit</a>

        <form id="archiveQuestionForm" action="" method="post">
          <a href="javascript:void(0)" className={archiveClasses}
             onClick={this._archiveQuestion}>
            archive
          </a>
        </form>
      </div>;

    return <div className="question-actions">{ contentToShow }</div>;
  }

  // PRIVATE

  _archiveQuestion() {
    var actions    = this.actions,
        createdAt  = this.props.created_at,
        questionId = this.props.id,
        status  = this.props.status,
        text    = this.props.text,
        type    = this.props.questioner_type,
        url     = '/admin/questions/' + questionId,
        dataObj;

    dataObj = {
      method: 'PUT',
      url: url,
      params: {
        question: {
          id: questionId,
          status: 'archived',
          text: text
        }
      },
      successMsg: 'Question archived.',
      errorMsg: 'Unable to archive question. :(',
    };

    sessionStorage.clear();
    sessionStorage.setItem('questionId', questionId);
    sessionStorage.setItem('status', status);
    sessionStorage.setItem('action', url);

    events.fetch(dataObj, function() {
      actions.archiveQuestion({
        created_at: createdAt,
        id: questionId,
        questioner_type: type,
        status: 'archived',
        text: text,
      });
    });
  }

  _editQuestion() {
    let modalData = {
      id: this.props.id,
      modalType: 'question.edit',
      title: 'edit question',
      text: this.props.text
    };
    this.modal.showModal('edit-question', modalData);
  }
};

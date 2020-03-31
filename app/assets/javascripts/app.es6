// Flux state config for app

var AppDispatcher = new Flux.Dispatcher();


const Constants = {
  ADD_QUESTION: 'questions.add',
  ARCHIVE_QUESTION: 'questions.archive',
  CHANGE_EVENT: 'change',
  DELETE_QUESTION: 'questions.delete',
  EDIT_QUESTION: 'questions.edit',
  SET_QUESTIONS: 'questions.set'
};


class Actions {
  addQuestion(params) {
    AppDispatcher.dispatch({
      actionType: Constants.ADD_QUESTION,
      question: params
    });
  }

  archiveQuestion(params) {
    AppDispatcher.dispatch({
      actionType: Constants.ARCHIVE_QUESTION,
      question: params
    });
  }

  deleteQuestion(params) {
    AppDispatcher.dispatch({
      actionType: Constants.DELETE_QUESTION,
      question: params
    });
  }

  editQuestion(params) {
    AppDispatcher.dispatch({
      actionType: Constants.EDIT_QUESTION,
      question: params
    });
  }

  setQuestions(params) {
    AppDispatcher.dispatch({
      actionType: Constants.SET_QUESTIONS,
      questions: params
    });
  }
}
let Action = new Actions();



class Store extends EventEmitter {
  constructor() {
    super();
    this._questions = [];

    AppDispatcher.register((payload) => {
      switch (payload.actionType) {
        case Constants.ADD_QUESTION:
          this.addQuestion(payload.question);
          this.emitChange();
          break;
        case Constants.ARCHIVE_QUESTION:
          this.archiveQuestion(payload.question);
          this.emitChange();
          break;
        case Constants.DELETE_QUESTION:
          this.deleteQuestion(payload.question);
          this.emitChange();
          break;
        case Constants.EDIT_QUESTION:
          this.editQuestion(payload.question);
          this.emitChange();
          break;
        case Constants.SET_QUESTIONS:
          this.setQuestions(payload.questions);
          this.emitChange();
          break;
        default:
          // No op
      }
    });
  }

  addQuestion(question) {
    this._questions[question.id] = question;
  }

  archiveQuestion(question) {
    this.addQuestion(question);
  }

  deleteQuestion(question) {
    delete this._questions[question.id];
  }

  editQuestion(question) {
    this.addQuestion(question);
  }

  setQuestions(questions) {
    questions.forEach(question => {
      this.addQuestion(question);
    });
  }

  questions() {
    return this._questions;
  }

  addChangeListener(callback) {
    this.on(Constants.CHANGE_EVENT, callback);
  }

  removeChangeListener(callback) {
    this.removeListener(Constants.CHANGE_EVENT, callback);
  }

  emitChange() {
    this.emit(Constants.CHANGE_EVENT);
  }
}

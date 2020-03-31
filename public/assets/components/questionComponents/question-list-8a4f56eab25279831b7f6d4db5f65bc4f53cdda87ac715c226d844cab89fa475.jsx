// Requires HammerJS

class QuestionList extends React.Component {
  constructor(props) {
    super(props);
    this.hammertime = null;

    // set initial state
    this.state = {
      open: ''
    };

    // cache methods
    this._swipeLeft = this._swipeLeft.bind(this);
    this._swipeRight = this._swipeRight.bind(this);
    this._swipeQuestion = this._swipeQuestion.bind(this);
  }

  componentDidMount() {
    let el = document.getElementById('question-' + this.props.id);
    this.hammertime = new Hammer(el);
    this.hammertime.on('swipe', this._swipeQuestion, false);
  }

  componentWillUnmount() {
    this.hammertime.off('swipe', this._swipeQuestion, false);
  }

  render() {
    let questionId = 'question-' + this.props.id;
    let propsText = this.props.text !== null ? this.props.text : 'No question given';
    let title = window.innerWidth >= 700 ? propsText.trunc(90) : propsText.trunc(27);

    return (
      <li id={ questionId } className="question-item animated">
        <div className="question">
          <div className="question-wrapper">
            <div className="question-header">
              <QuestionTitle title={ title } />
              <QuestionTime time={ this.props.updated_at } />
            </div>

            <div className="question-body">
              <QuestionStatus { ... this.props } />
              <QuestionerName user={ this.props.questioner_name } />
              <QuestionActions { ... this.props } isOpen="" />
            </div>
          </div>

          <div className="mobile-question-actions">
            <QuestionActions { ... this.props } isOpen={ this.state.open } />
          </div>
        </div>
      </li>
    );
  }

  // PRIVATE

  _swipeQuestion(e) {
    let direction = e.direction;
    switch (direction) {
      case 2:
        this._swipeLeft(e.target);
        break;
      case 4:
        this._swipeRight(e.target);
        break;
      default:
    }
  }

  _swipeLeft(target) {
    let el = target.closest('.question-wrapper');
    el.className = 'question-wrapper open';
    this.setState({ open: 'open' });
  }

  _swipeRight(target) {
    let el = target.closest('.question-wrapper');
    el.className = 'question-wrapper';
    this.setState({ open: '' });
  }
};

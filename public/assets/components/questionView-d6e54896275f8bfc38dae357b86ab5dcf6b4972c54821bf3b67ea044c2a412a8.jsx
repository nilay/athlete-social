// The main-parent view for the "question" pages

class QuestionView extends React.Component {
  constructor(props) {
    super(props);
    this.store = new Store();
    this.actions = Action;
    this.toast = toast;
    this.questions = JSON.parse(props.questions);
    this.actions.setQuestions(this.questions.questions);
    this.state = {
      filter: 'active',
      filterText: ''
    };

    // default pagination
    this.page = 2;

    // cache methods
    this._addScrollWatch = this._addScrollWatch.bind(this);
    this._animateListIn  = this._animateListIn.bind(this);
    this._fetchQuestions = this._fetchQuestions.bind(this);
    this._handleUserInput = this._handleUserInput.bind(this);
    this._onChange = this._onChange.bind(this);
    this._removeScrollWatch = this._removeScrollWatch.bind(this);
    this._setActive = this._setActive.bind(this);
    this._setInactive = this._setInactive.bind(this);
    this._setArchived = this._setArchived.bind(this);
    this._sortQuestions = this._sortQuestions.bind(this);
    this._updatePill  = this._updatePill.bind(this);
  }

  componentDidMount() {
    let el_list = document.querySelectorAll('.question-item');

    this.store.addChangeListener(this._onChange);
    this._addScrollWatch();

    for (var i = 0; i < el_list.length; i++) {
      this._animateListIn(el_list[i], i);
    }
  }

  componentDidUpdate() {
    let el_list = document.querySelectorAll('.question-item');

    for (var i = 0; i < el_list.length; i++) {
      this._animateListIn(el_list[i], i);
    }
  }

  componentWillUnmount() {
    this.store.removeChangeListener(this._onChange);
    this._removeScrollWatch();
  }

  render() {
    let questions = this._sortQuestions();

    return (
      <div className="content-wrapper">
        <UpdatePage context="questions" />

        <SearchBox
          btnValue="create question"
          context="questions"
          filterText={ this.state.filterText }
          onUserInput={ this._handleUserInput } />

        <div className="state-btn-container">
          <button type="button" id="activePill" className="pill active-pill active" onClick={this._setActive}>active</button>
          <button type="button" id="inactivePill" className="pill inactive-pill" onClick={this._setInactive}>inactive</button>
          <button type="button" id="archivedPill" className="pill archived-pill" onClick={this._setArchived}>archived</button>
        </div>

        <ul className="question-container">
          { questions.map(function(question) {
              return <QuestionList key={ question.id } { ... question } />;
            })
          }
        </ul>
      </div>
    );
  }


  // PRIVATE

  _animateListIn(item, i) {
    if (item.className == 'question-item animated slideInLeft') {
      return;
    } else {
      window.setTimeout(() => {
        item.className = 'question-item animated slideInLeft';
      }, 70 * i);
    }
  }

  _addScrollWatch() {
    let $container   = $('.content-container'),
        $qContainer  = $container.find('.question-container'),
        $containerH  = $container.height(),
        $qContainerH = $qContainer.height(),
        $scrollAmnt  = $containerH >= $qContainerH ? $containerH - $qContainerH : $qContainerH - $containerH;

    $container.on('scroll', () => {
      if ($container.scrollTop() >= $scrollAmnt) {
        let page = this.page++;
        this._fetchQuestions(page);
      }
    });
  }


  _fetchQuestions(pageId) {
    let token = $('meta[name="csrf-token"]').attr('content');
    let that = this;

    $.ajax({
      dataType: 'JSON',
      headers: { 'X-CSRF-Token': token },
      method: 'GET',
      url: '/admin/questions.json?page=' + pageId,
    }).success(function(data, status, jqXHR) {
      let newQuestions = data.questions;

      if (newQuestions.length >= 1) {
        that.actions.setQuestions(newQuestions);
        that._removeScrollWatch();
        that._addScrollWatch();
        pageId++;
      } else {
        that._removeScrollWatch();
      }
    }).error(function(jqXHR, status, error) {
      this.toast.showBasicErrorToast('Unable to get more questions :(');
    });
  }

  _handleUserInput(filterText) {
    this.setState({
      filterText: filterText
    });
  }

  _removeScrollWatch() {
    let $container = $('.content-container');
    $container.off('scroll');
  }

  _setActive() {
    let pill = document.getElementById('activePill');
    this.setState({ filter: 'active'});
    this._updatePill(pill);
  }

  _setInactive() {
    let pill = document.getElementById('inactivePill');
    this.setState({ filter: 'inactive'});
    this._updatePill(pill);
  }

  _setArchived() {
    let pill = document.getElementById('archivedPill');
    this.setState({ filter: 'archived'});
    this._updatePill(pill);
  }

  _sortQuestions() {
    let questionArray = this.store.questions().slice(0);
    let filteredQuestions = questionArray.filter(q =>
      q.text ?
      q.text.toLowerCase().match(this.state.filterText) && q.status === this.state.filter :
      q.status === this.state.filter
    );

    let sortedQuestions = filteredQuestions.sort(function(a, b) {
      if (a.created_at > b.created_at) {
        return -1;
      } else if (a.created_at < b.created_at) {
        return 1;
      } else {
        return 0;
      }
    });

    return sortedQuestions;
  }

  _updatePill(selectedElement) {
    let oldPill = document.querySelector('.pill.active');
    oldPill.className = 'pill';
    selectedElement.className = 'pill active';
  }

  _onChange() {
    this.forceUpdate();
  }
}

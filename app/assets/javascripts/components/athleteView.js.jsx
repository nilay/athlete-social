// requires jQuery

class AthleteView extends React.Component {
  constructor(props) {
    super(props);
    this.store = new Store();
    this.actions = Action;
    this.athletesData = JSON.parse(props.athletes);
    this.actions.setQuestions(this.athletesData.athletes);
    this.page  = 2;
    this.toast = toast;

    // setup state
    this.state = {
      athlete: {},
      detailsView: '',
      filterText: '',
      filter: true,
      showPopover: '',
    };

    // cache methods
    this._addScrollWatch = this._addScrollWatch.bind(this);
    this._animateListIn  = this._animateListIn.bind(this);
    this._closeDetailsView  = this._closeDetailsView.bind(this);
    this._fetchQuestions = this._fetchQuestions.bind(this);
    this._handleUserInput   = this._handleUserInput.bind(this);
    this._onChange     = this._onChange.bind(this);
    this._removeScrollWatch = this._removeScrollWatch.bind(this);
    this._sortAthletes = this._sortAthletes.bind(this);
    this._setActive    = this._setActive.bind(this);
    this._setAthlete   = this._setAthlete.bind(this);
    this._setInactive  = this._setInactive.bind(this);
    this._showPopover  = this._showPopover.bind(this);
    this._updatePill   = this._updatePill.bind(this);
  }

  componentDidMount() {
    let el_list = document.querySelectorAll('.athlete-list-item');

    this.store.addChangeListener(this._onChange);
    this._addScrollWatch();

    for (var i = 0; i < el_list.length; i++) {
      this._animateListIn(el_list[i], i);
    }
  }

  componentDidUpdate() {
    let el_list = document.querySelectorAll('.athlete-list-item');

    for (var i = 0; i < el_list.length; i++) {
      this._animateListIn(el_list[i], i);
    }
  }

  componentWillUnmount() {
    this.store.removeChangeListener(this._onChange);
    this._removeScrollWatch();
  }

  render() {
    let athletes = this._sortAthletes();
    let popoverStatus = this.state.showPopover;
    let setAthlete = this._setAthlete;
    let listContent = athletes.length ?
        athletes.map(function(athlete) {
          return <AthleteList key={athlete.id} setAthlete={setAthlete} {... athlete} />;
        }) :
        <p className="empty-list">No athlete's available :(</p>;

    return(
      <div className="multi-view-container">
        <UpdatePage context="athlete" />

        <div className={ 'admin-athletes-container ' + this.state.detailsView }>
          <SearchBox
            btnValue="invite athlete"
            context="athletes"
            filterText={ this.state.filterText }
            onUserInput={ this._handleUserInput } />

          <div className="state-btn-container">
            <button type="button" id="activePill" className="pill active-pill active" onClick={this._setActive}>active</button>
            <button type="button" id="inactivePill" className="pill inactive-pill" onClick={this._setInactive}>inactive</button>
          </div>

          <div className="athlete-grid-container">
            <ul className="athlete-list list">
              { listContent }
            </ul>
          </div>
        </div>

        <AthleteDetailView
          athlete={ this.state.athlete }
          showView={ this.state.detailsView }
          handleChange={ this._closeDetailsView } />
        <AthletePopover active={ this.state.showPopover } />
      </div>
    );
  }


  // PRIVATE

  _addScrollWatch() {
    let $container  = $('.content-container'),
        $grid       = $container.find('.athlete-grid-container'),
        $containerH = $container.height(),
        $gridH      = $grid.height(),
        rawScrollAmnt  = $containerH >= $gridH ? $containerH - $gridH : $gridH - $containerH,
        scrollAmnt  = Math.floor(rawScrollAmnt),
        highScrollAmt  = scrollAmnt + 25;

    $container.on('scroll', () => {
      if ($container.scrollTop() >= scrollAmnt && $container.scrollTop() <= highScrollAmt) {
        let page = this.page++;
        this._fetchQuestions(page);
      } else {
        return;
      }
    });
  }


  _animateListIn(item, i) {
    if (item.className == 'athlete-list-item list-item animated zoomIn') {
      return;
    } else {
      window.setTimeout(() => {
        item.className = 'athlete-list-item list-item animated zoomIn';
      }, 50 * i);
    }
  }


  _closeDetailsView() {
    this.setState({
      detailsView: ''
    });
  }


  _fetchQuestions(pageId) {
    let token = $('meta[name="csrf-token"]').attr('content');
    let that = this;

    $.ajax({
      dataType: 'JSON',
      headers: { 'X-CSRF-Token': token },
      method: 'GET',
      url: '/admin/athletes.json?page=' + pageId,
    }).success(function(data, status, jqXHR) {
      let newQuestions = data.athletes;

      if (newQuestions.length >= 1) {
        that.actions.setQuestions(newQuestions);
        that._removeScrollWatch();
        that._addScrollWatch();
        pageId++;
      } else {
        that._removeScrollWatch();
        return;
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


  _setAthlete(athlete) {
    this.setState({
      athlete: athlete,
      detailsView: 'show-details-view'
    });
  }


  _showPopover(status) {
    this.setState({
      showPopover: status
    });
  }


  _setActive() {
    let pill = document.getElementById('activePill');

    this.setState({
      filter: true,
      detailsView: ''
    });

    this._updatePill(pill);
  }


  _setInactive() {
    let pill = document.getElementById('inactivePill');

    this.setState({
      filter: false,
      detailsView: ''
    });

    this._updatePill(pill);
  }


  _sortAthletes() {
    let athleteArray = this.store.questions().slice(0);
    let filteredAthletes = athleteArray.filter(a =>
      a.first_name.length ?
      a.first_name.toLowerCase().match(this.state.filterText) && a.active === this.state.filter :
      a.active === this.state.filter
    );

    let sortedAthletes = filteredAthletes.sort(function(a, b) {
      if (a.first_name > b.first_name) {
        return -1;
      } else if (a.first_name < b.first_name) {
        return 1;
      } else {
        return 0;
      }
    });

    return sortedAthletes.reverse();
  }


  _updatePill(selectedElement) {
    let oldPill = document.querySelector('.pill.active');
    oldPill.className = 'pill';
    selectedElement.className = 'pill active';
  }


  _onChange() {
    this.forceUpdate();
  }


  _removeScrollWatch() {
    let $container = $('.content-container');
    $container.off('scroll');
  }
}

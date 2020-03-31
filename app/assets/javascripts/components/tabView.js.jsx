// requires LoDash
// requires Hammer

class TabView extends React.Component {
  static propTypes() {
    let props = {
      tabData: React.PropTypes.object.isRequired
    };
    return props;
  }

  static defaultProps() {
    let props = {
      tabData: [
        { title: 'first' , content: {} },
        { title: 'second', content: {} }
      ]
    };
    return props;
  }

  constructor(props) {
    super(props);

    // set initial states
    this.state = {
      activeTab: 0,
      avatar: '',
      athleteName: '',
      showPreviousTab: false,
      showNextTab: false,
      tabData: props.tabData
    };

    // cache methods
    this._getAvatar   = this._getAvatar.bind(this);
    this._handleChange = this._handleChange.bind(this);
    this._moveBar  = this._moveBar.bind(this);
    this._showNext = this._showNext.bind(this);
    this._showPrev = this._showPrev.bind(this);
    this._swipeQuestion   = this._swipeQuestion.bind(this);
    this._updateActiveTab = this._updateActiveTab.bind(this);
    this._updateTab = this._updateTab.bind(this);
  }

  componentWillReceiveProps(nextProps) {
    if (_.isEmpty(nextProps)) {
      return;
    } else {
      this.setState({
        avatar: typeof nextProps.avatar !== 'undefined' ? nextProps.thumbnail_url : '',
        athleteName: nextProps.first_name + ' ' + nextProps.last_name,
        tabData: nextProps.tabData
      });
    }
  }

  componentDidMount() {
    let el = document.getElementById('tabViewContainer');
    this.hammertime = new Hammer(el);
    this.hammertime.on('swipe', this._swipeQuestion, false);
  }

  componentWillUnmount() {
    this.hammertime.off('swipe', this._swipeQuestion, false);
  }

  render() {
    let avatar = this._getAvatar();

    let globalData = {
      athleteName: this.state.athleteName,
      avatar: avatar
    };

    let tabData = this.state.tabData;

    return (
      <div id="tabViewContainer" className="tab-view-container">
        <TabViewHeader
          tabInfo={ tabData }
          onUserClick={ this._handleChange } />

        <TabViewContent
          contentInfo={ tabData }
          globalProps={ globalData }
          goToNext={ this.state.showNextTab }
          goToPrev={ this.state.showPreviousTab } />

        <button type="button" className="nav-btn btn tabview-prev-btn"
                onClick={ this._showPrev }>prev</button>
        <button type="button" className="nav-btn btn tabview-next-btn"
                onClick={ this._showNext }>next</button>
      </div>
    );
  }


  // PRIVATE

  _getAvatar() {
    if (this.state.avatar && this.state.avatar !== '') {
      return this.state.avatar;
    } else if (this.props.avatar) {
      return this.props.avatar;
    } else {
      return;
    }
  }

  _handleChange(e, newTab) {
    let tabId   = typeof newTab == 'number' ? 'tab-' + newTab : newTab,
        clickedTab = typeof e.target !== 'undefined' ? e.target.parentNode.id : false,
        tab     = clickedTab ? clickedTab : tabId,
        convTab = typeof tab == 'string' ? tab.split('-')[1] : tab,
        intTab  = parseInt(convTab);

    this._updateTab(tab);
    this._moveBar(intTab);
  }

  _moveBar(tab) {
    let bar = document.getElementById('tabViewBar'),
        pos = Math.round(tab * 100),
        oldPos;

    if (oldPos < pos) {
      bar.style.transform = 'translateX(-' + pos + '%)';
    } else {
      bar.style.transform = 'translateX(' + pos + '%)';
    }
  }

  _showNext() {
    let views     = document.querySelectorAll('.view:not(.admin-athlete-profile-container)'),
        activeTab = this.state.activeTab + 1,
        allViews  = views.length;

    if (activeTab >= allViews) {
      return;
    } else {
      this.setState({
        showPreviousTab: false,
        showNextTab: true
      });
      this.state.activeTab++;
      this._handleChange(false, this.state.activeTab);
    }
  }

  _showPrev() {
    let views = document.querySelectorAll('.view');

    if (this.state.activeTab <= 0) {
      return;
    } else {
      this.setState({
        showPreviousTab: true,
        showNextTab: false
      });
      this.state.activeTab--;
      this._handleChange(false, this.state.activeTab);
    }
  }

  _swipeQuestion(e) {
    let direction = e.direction;

    switch (direction) {
      case 2:
        this._showNext();
        break;
      case 4:
        this._showPrev();
        break;
      default:
    }
  }

  _updateActiveTab(newTab) {
    if (newTab > this.state.activeTab) {
      this.state.activeTab++;
    } else {
      this.state.activeTab--;
    }
  }

  _updateTab(tabId) {
    let tab = document.getElementById(tabId);
    let oldTab = document.querySelector('.tab-view-info.active');

    if (oldTab && tab) {
      oldTab.className = 'tab-view-info';
      tab.className = 'active tab-view-info';
    } else {
      return;
    }
  }
}

class NavDawer extends React.Component {
  constructor(props) {
    super(props);

    // set initial state
    this.state = {
      active: ''
    };

    // cache methods
    this._setSelected = this._setSelected.bind(this);
    this._toggleNav = this._toggleNav.bind(this);
    this._updateMenu = this._updateMenu.bind(this);
    this._updateNav = this._updateNav.bind(this);
  }

  componentDidMount() {
    let btn = document.getElementById(this.props.toggleBtn);
    btn.className = 'outro menu two';
    btn.addEventListener('click', this._toggleNav, false);
    this._setSelected();
  }

  componentWillUnmount() {
    let btn = document.getElementById(this.props.toggleBtn);
    btn.removeEventListener('click', this._toggleNav, false);
  }

  render() {
    let drawerClass = this.state.active + ' nav-drawer-container';
    let welcomeMsg = 'Welcome, ' + this.props.first_name;

    return <div id="navDrawerContainer" className={drawerClass}
      data-turbolinks-permanent="true">
      <div className="overlay" onClick={this._toggleNav}></div>
      <div className="nav-drawer">
        <div className="user-profile">
          <img className="profile-img" src={this.props.avatar} alt="user avatar" />
          <p className="welcome-text">{ welcomeMsg }</p>
        </div>
        <ul className="nav-list">
          { this.props.items.map(function(item, index) {
            return (
              <li key={index} className="filter-item question-list">
                <div className="filter-title">
                  <a id={item.text} href={ item.url} className="nav-link"
                     onClick={this._updateNav}>{item.text}</a>
                </div>
              </li>
            );
          })}
        </ul>
      </div>
    </div>;
  }

  // PRIVATE

  _setSelected() {
    let rURL = window.location.href;
    let url  = rURL.split('admin/');
    let current = url[1] || '';
    document.getElementById(current).className = 'active nav-link';
  }

  _toggleNav() {
    let menu   = document.getElementById(this.props.toggleBtn);

    if (menu.className !== 'active menu two') {
      this.setState({ active: 'active' }, function() {
        this._updateMenu();
      });
    } else {
      this.setState({ active: 'outro' }, function() {
        this._updateMenu();
      });
    }
  }

  _updateMenu() {
    let menu   = document.getElementById(this.props.toggleBtn);
    menu.className = this.state.active + ' menu two';
  }

  _updateNav() {
    let menu   = document.getElementById(this.props.toggleBtn);
    let oldSelected = document.querySelector('.nav-link.active') || null;
    this.setState({ active: '' });
    menu.className = this.state.active + ' menu two';
    oldSelected.className = 'nav-link';
  }
}

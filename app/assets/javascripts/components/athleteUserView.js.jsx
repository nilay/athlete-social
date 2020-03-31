class AthleteUserView extends React.Component {
  constructor(props) {
    super(props);
    this.modal = ModalAction;
    this.athlete = JSON.parse(props.athlete);
    enabled = this.athlete.account_status === 'enabled' ? true : false;

    // initial state
    this.state = {
      showMobileMenu: 'none',
      enabled: enabled
    };

    // cache methods
    this._sendInvite = this._sendInvite.bind(this);
    this._showMobileMenu = this._showMobileMenu.bind(this);
  }

  render() {
    let props = this.athlete;
    let formBtns = this.state.enabled ?
      <form action={'./' + props.id + '/disable'} method="post" id="athleteDeactivateForm">
        <button type="submit" className="btn deactivate-btn">retire</button>
      </form> :
      <form action={'./' + props.id + '/enable'} method="post" id="athleteActivateForm">
        <button type="submit" className="btn activate-btn">enable</button>
      </form>;

    let tabInfo = [
      { title: 'posts',
        content: props.reactions
      },
      {
        title: 'reactions',
        content: props.posts
      },
      {
        title: 'answers',
        content: props.answers
      },
      {
        title: 'followers',
        content: props.followers
      }
    ];

    return (
      <div className="admin-athlete-profile-container">
        <UpdatePage context="athlete" />

        <div className="athlete-details-header">
          <div className="filler"></div>
          <button type="button" className="simple-btn athlete-settings-btn" onClick={this._showMobileMenu}></button>
            <div id="settingMenu" className={ this.state.showMobileMenu + ' setting-btn-menu'}>
             <div className="form-container">
               { formBtns }
             </div>
           </div>
      </div>

        <div className="athlete-profile-content">
          <div className="img-container">
            <image src={ props.avatar.original_url || '' } alt="" title="user avatar" />
          </div>
          <h2 className="username">{ props.first_name + ' ' +  props.last_name }</h2>
          <button type="button" className="btn invite-btn" onClick={this._sendInvite}>invite athlete</button>
        </div>

        <TabView { ... props } tabData={ tabInfo } />
      </div>
    )
  }

  // PRIVATE

  _sendInvite() {
    let modalData = {
      title: 'invite new athlete',
      modalType: 'athlete.invite'
    };
    this.modal.showModal('inviteAthlete', modalData);
  }

  _showMobileMenu() {
    let state = this.state.showMobileMenu;

    if (state == '') {
      this.setState({
        showMobileMenu: 'none'
      });
    } else {
      this.setState({
        showMobileMenu: ''
      });
    }
  }
}

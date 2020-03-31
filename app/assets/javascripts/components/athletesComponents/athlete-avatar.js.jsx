class AthleteAvatar extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    let avatar = this.props.avatar !== null || typeof this.props.avatar !== 'undefined' ? this.props.avatar : '';
    let showAvatar = avatar == null || avatar === '' ? 'no-avatar' : '';

    return (
      <div className={ 'profile-img-container ' + showAvatar }>
        <div className="avatar-wrapper">
          <image className={ showAvatar } src={ avatar } title="athlete avatar" />
        </div>
      </div>
    );
  }
}

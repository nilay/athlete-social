class AthletePopover extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    let showclass = this.props.active + ' pop-modal';

    return <div className={showclass}>
      <div className="container">
        <form action="admin/athletes/deactivate" method="post" id="athleteDeactiveForm">
          <button type="submit" className="btn deactivate-btn">deactivate</button>
        </form>
        <form action="admin/athletes" method="delete" id="athleteDeleteForm">
          <button type="submit" className="btn delete-btn">delete</button>
        </form>
      </div>
    </div>;
  }
}

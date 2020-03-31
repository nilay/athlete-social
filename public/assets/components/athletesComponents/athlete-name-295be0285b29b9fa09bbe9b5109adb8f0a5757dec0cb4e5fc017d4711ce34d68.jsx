class AthleteName extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    let firstname = this.props.firstname || 'captain';
    let lastname  = this.props.lastname || 'unknown';
    return <div className="username">{firstname} {lastname}</div>
  }
}


AthleteName.propTypes = {
  firstname: React.PropTypes.string,
  lastname: React.PropTypes.string
};

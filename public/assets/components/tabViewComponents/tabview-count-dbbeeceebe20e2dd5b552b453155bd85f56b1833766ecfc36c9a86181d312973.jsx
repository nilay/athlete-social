class TabViewCount extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    let count = this.props.count || 0;
    return <p>{ count }</p>;
  }
}


TabViewCount.propTypes = { count: React.PropTypes.number };

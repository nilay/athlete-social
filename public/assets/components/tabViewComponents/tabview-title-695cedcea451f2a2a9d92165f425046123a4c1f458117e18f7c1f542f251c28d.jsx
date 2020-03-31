class TabViewTitle extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    let title = this.props.title || 'first';
    return <p className="post-name">{ title }</p>;
  }
}

TabViewTitle.propTypes = { title: React.PropTypes.string };

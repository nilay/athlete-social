class QuestionTitle extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    let title = this.props.title || 'No question given';
    return <div className="question-title">{ title }</div>;
  }
};


QuestionTitle.propTypes = { title: React.PropTypes.string };

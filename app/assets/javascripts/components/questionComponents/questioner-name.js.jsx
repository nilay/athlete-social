class QuestionerName extends React.Component {
  constructor(props) {
    super(props);
  }

  render() {
    let user = this.props.user !== null || this.props.user !== '' ? this.props.user : 'Man of Mystery';

    return (
      <div className="questioner-type">{ user }</div>
    );
  }
}

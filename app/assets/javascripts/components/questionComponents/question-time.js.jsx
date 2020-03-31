var QuestionTime = React.createClass({
  propTypes: {
    time: React.PropTypes.string
  },

  render: function() {
    var rawTime   = this.props.time,
        convTime  = moment(rawTime),
        today     = moment().format('YYYY M DD'),
        serverDay = convTime.format('YYYY M DD'),
        time      = today === serverDay ? convTime.startOf('hour').fromNow() : convTime.format('MMM Do YYYY');

    return (
      <span className="question-time">{ time }</span>
    );
  }
});

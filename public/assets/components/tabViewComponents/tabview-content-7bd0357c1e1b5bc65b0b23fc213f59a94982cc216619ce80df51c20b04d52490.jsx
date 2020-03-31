// requires hammer

class TabViewContent extends React.Component {
  constructor(props) {
    super(props);

    // set initial state
    this.state = {
      athleteInfo: {},
      goToNext: false,
      goToPrev: false,
      currentView: 2
    };

    // cache methods
    this._showNext = this._showNext.bind(this);
    this._showPrevious = this._showPrevious.bind(this);
  }

  componentDidMount() {
    let last = document.querySelectorAll('.view');
    this.setState({
      lastItem: last.length
    });
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      athleteInfo: nextProps.globalProps,
      goToNext: nextProps.goToNext,
      goToPrev: nextProps.goToPrev
    });
  }

  render() {
    let info = this.props.contentInfo;
    let athleteInfo = this.state.athleteInfo;
    let showNext = this.state.goToNext ? this._showNext() : false;
    let showPrev = this.state.goToPrev ? this._showPrevious() : false;

    return (
      <div className="multi-view-container">
        {
          info.map((item, index) => {
            let divStyle = { transform: 'translateX(' + Math.round(index * 100) + '%)'};

            return (
              <div className="view" data-translate={ Math.round(index * 100) } key={ 'view-' + index } style={ divStyle }>
                <ul className="list">
                  {
                    _.isEmpty(item.content) ?
                      <p className="empty-list">No content available. :(</p> :
                      item.content.map((item) => {
                        return <TabViewListItem key={ item.id } { ... item } athleteInfo={ athleteInfo } />;
                      })
                  }
                </ul>
              </div>
            );
          })
        }
      </div>
    );
  }

  // PRIVATE

  _showNext() {
    let views = document.querySelectorAll('.view');

    if (this.state.currentView <= views.length) {
      for (var i = 0; i < views.length; i++) {
        let currentX = views[i].dataset.translate,
            newX = currentX - 100;
        views[i].style.transform = 'translateX(' + newX + '%)';
        views[i].dataset.translate = newX;
      }
      this.state.currentView++;
    } else {
      return;
    }
  }

  _showPrevious() {
    let views = document.querySelectorAll('.view');

    if (this.state.currentView >= 3) {
      for (var i = 0; i < views.length; i++) {
        let currentX = views[i].dataset.translate,
            newX = parseInt(currentX) + 100;
        views[i].style.transform = 'translateX(' + newX + '%)';
        views[i].dataset.translate = newX;
      }
      this.state.currentView--;
    } else {
      return;
    }
  }
}

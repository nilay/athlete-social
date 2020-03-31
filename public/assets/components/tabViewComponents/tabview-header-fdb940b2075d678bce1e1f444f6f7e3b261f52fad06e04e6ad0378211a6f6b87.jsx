class TabViewHeader extends React.Component {
  static propTypes() {
    let tabInfo = React.PropTypes.array.isRequired;
    return tabInfo;
  }

  static defaultProps() {
    let initialCount = [
      { title: 'first' , content: {} },
      { title: 'second', content: {} }
    ];
    return initialCount;
  }

  constructor(props) {
    super(props);
  }

  componentDidMount() {
    let el = document.getElementById('tab-0');
    el.className = 'active tab-view-info';
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      activeTab: nextProps.activeTab
    });
  }

  render() {
    let info = this.props.tabInfo;

    return(
      <div className="tab-view-content">
       <div className="tab-view-wrapper">
         {
          info.map((item, index) => {
            return (
              <a className="tab-view-info" id={ 'tab-' + index } key={ index }
                 href="javascript:void(0)">
                <TabViewCount count={ item.content.length } />
                <TabViewTitle title={ item.title } />
              </a>
            );
          })
         }

         <div id="tabViewBar" className="bar"></div>
       </div>
     </div>
    );
  }
}

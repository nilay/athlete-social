class TagPerson {
  constructor() {
    this._createPill    = this._createPill.bind(this);
    this._selectAthlete = this._selectAthlete.bind(this);
  }


  showList(athletesArray) {
    let el_container = document.getElementById('returnAthleteListWrapper'),
        el_list = document.getElementById('returnTagList'),
        athlete, li, name;

    if (athletesArray.length == 1) {
      athlete = athletesArray[0];
      name = athlete.first_name + ' ' + athlete.last_name;
      this._createPill(name, athlete.id);
    } else {
      athletesArray.map((athlete) => {
        li = document.createElement('li');
        name = athlete.first_name + ' ' + athlete.last_name;

        li.dataset.uid = athlete.id;
        li.className = 'returned-tagged-item';
        li.innerHTML = name;
        li.addEventListener('click', this._selectAthlete, false);
        el_list.appendChild(li);
      });

      el_container.className = 'tag-athlete-list';
    }
  }

  // PRIVATE

  _createPill(name, uid) {
    let origName = name.split(' '),
        firstChar  = origName[0].charAt(0),
        li = document.createElement('li'),
        el_container = document.getElementById('tagList'),
        firstLetter, lastLetter, initials;

    // assign initials
    if (firstChar === '') {
      firstLetter = typeof origName[1] !== 'undefined' ? origName[1].charAt(0) : '';
      lastLetter  = typeof origName[2] !== 'undefined' ? origName[2].charAt(0) : '';
    } else {
      firstLetter = typeof origName[0] !== 'undefined' ? origName[0].charAt(0) : '';
      lastLetter  = typeof origName[1] !== 'undefined' ? origName[1].charAt(0) : '';
    }

    // create initials
    initials = firstLetter + lastLetter;

    // add pill to list
    li.dataset.uid = uid;
    li.className = 'tag-pill';
    li.innerHTML = initials;
    el_container.appendChild(li);
  }

  _selectAthlete(e) {
    let target = e.target,
        name   = target.innerHTML,
        uid    = target.dataset.uid,
        el_container = document.getElementById('returnAthleteListWrapper'),
        el_list = document.getElementById('returnTagList');

    this._createPill(name, uid);
    el_container.className = 'tag-athlete-list none';
    el_list.innerHTML = '';
  }
}
let TaggingPerson = new TagPerson();

// requires MomentJS

class ModalActions {
  showModal(modalTemplate, data) {
    let template = modalTemplate || '';
    this._open(modalTemplate, data);
  }

  closeModal() {
    this._close();
  }

  // PRIVATE

  _checkType(data) {
    switch (data.modalType) {
      case 'question.edit':
        this._updateEditModal(data);
        break;
      case 'question.create':
        this._updateCreateModal(data);
        break;
      case 'question.changeStatus':
        this._updateStatusModal(data);
        break;
      case 'athlete.changeStatus':
        this._updateAthleteStatusModal(data);
        break;
      case 'post.showDetail':
        this._updatePostDetailModal(data);
        break;
      default:
    }
  }

  _close() {
    let el_container =  document.getElementById('modalContainer'),
        el_wrapper   = document.getElementById('modalContentWrapper');

    // outro animation
    el_wrapper.className = 'modal-content-wrapper animated bounceOutUp';

    window.setTimeout(function() {
      el_container.className = 'modal-container';
      el_wrapper.innerHTML = '';
    }, 600);
  }

  _open(targetTemplate, data) {
    let el_container = document.getElementById('modalContainer'),
        el_template  = document.getElementById('modalTemplate').innerHTML,
        el_wrapper   = document.getElementById('modalContentWrapper'),
        html = document.getElementById(targetTemplate).innerHTML,
        avatar = data.avatar || {},
        firstName = data.first_name || 'captain',
        lastName = data.last_name || 'unknown',
        modalType = data.modalType || 'default',
        props = data.props || {},
        questionerId = data.questionerId || '',
        status = data.status || '',
        text = data.text || '',
        title = data.title || '',
        type = data.type || '',
        id = data.id || '',
        uid = data.uid || '',
        el_title, newTemplate, checkParamsData;

    // compile new template
    newTemplate = _.template(el_template)({
      title: title,
      content: html
    });

    // data required for specific modal types
    checkParamsData = {
      avatar: avatar,
      firstName: firstName,
      id: id,
      lastName: lastName,
      modalType: modalType,
      props: props,
      questionerId: questionerId,
      status: status,
      text: text,
      title: title,
      type: type,
      userId: uid
    };

    // update modal template
    el_wrapper.innerHTML = newTemplate;

    // figure out way to add this to component
    if (title === '') {
      el_title = el_wrapper.querySelector('.title');
      el_title.className = 'title no-title';
    }

    // update modal-specific content
    this._checkType(checkParamsData);

    // show modal
    el_container.className = 'modal-container active';

    // clear animated out class
    if (el_wrapper.className == 'modal-content-wrapper animated bounceOutUp') {
      el_wrapper.className = 'modal-content-wrapper animated';
    }

    el_wrapper.className = 'modal-content-wrapper animated bounceInDown';
  }

  _updateCreateModal(data) {
    let el_wrapper  = document.getElementById('modalContentWrapper'),
        el_textarea = el_wrapper.querySelector('.js-create-textarea'),
        el_label    = el_wrapper.querySelector('.active-label'),
        el_input    = el_wrapper.querySelector('.js-user-id');

    el_textarea.dataset.type = data.type;
    el_textarea.dataset.firstname = data.firstName;
    el_textarea.dataset.lastname = data.lastName;
    el_textarea.value = data.text;
    el_input.value = data.userId;
    el_label.style.display = 'block';
  }

  _updateEditModal(data) {
    let el_wrapper  = document.getElementById('modalContentWrapper'),
        el_textarea = el_wrapper.querySelector('.js-edit-textarea'),
        el_input = el_wrapper.querySelector('.js-question-id');
    el_textarea.value = data.text;
    el_input.value = data.id;
  }

  _updateAthleteStatusModal(data) {
    let el_wrapper  = document.getElementById('modalContentWrapper'),
        el_formContainer = el_wrapper.querySelector('.js-athlete-status-change-container'),
        el_activeForm = el_wrapper.querySelector('#activateForm'),
        el_inactiveForm = el_wrapper.querySelector('#deactivateForm'),
        el_name = el_wrapper.querySelector('.js-athlete-name'),
        el_id_input;

    if (data.props.active) {
      el_formContainer.removeChild(el_activeForm);
    } else {
      el_formContainer.removeChild(el_inactiveForm);
    }

    // get elements in selected form
    el_id_input = el_wrapper.querySelector('.js-athlete-info');

    el_name.innerHTML = `${data.props.first_name} ${data.props.last_name}`;
    el_id_input.dataset.props = JSON.stringify(data.props);
  }

  _updatePostDetailModal(data) {
    let el_wrapper   = document.getElementById('modalContentWrapper'),
        el_avatar    = el_wrapper.querySelector('.js-athlete-avatar'),
        el_comments  = el_wrapper.querySelector('.js-total-comments'),
        el_download  = el_wrapper.querySelector('.js-download-item-btn'),
        el_post      = el_wrapper.querySelector('.js-post-detail-image'),
        el_reactions = el_wrapper.querySelector('.js-total-reactions'),
        el_time      = el_wrapper.querySelector('.js-time-posted'),
        el_username  = el_wrapper.querySelector('.username'),
        rawName      = data.props.athleteName,
        downloadName = rawName.replace(/\s+/g, ''),
        rawTime      = data.props.timestamp || new Date(),
        convTime     = moment(rawTime),
        serverDay    = convTime.format('YYYY M DD'),
        today        = moment().format('YYYY M DD'),
        time         = today === serverDay ? convTime.startOf('hour').fromNow() : convTime.format('MMM Do YYYY'),
        avatar;

    avatar = typeof data.props.avatar.thumbnail_url !== 'undefined' ? data.props.avatar.thumbnail_url : data.props.avatar;

    el_avatar.src = avatar;
    el_download.href = data.props.post || '';
    el_download.download = downloadName + '_post_' + data.props.postId;
    el_post.src = data.props.postImg || '';
    el_post.dataset.postId = data.props.postId || '';
    el_comments.innerHTML = data.props.total_comments || 0;
    el_reactions.innerHTML = data.props.total_reactions || 0;
    el_time.innerHTML = time;
    el_username.innerHTML = data.props.athleteName || '';
  }

  _updateStatusModal(data) {
    let el_wrapper  = document.getElementById('modalContentWrapper'),
        el_formContainer = el_wrapper.querySelector('.js-status-change-container'),
        el_activeForm = el_wrapper.querySelector('#activateForm'),
        el_inactiveForm = el_wrapper.querySelector('#deactivateForm'),
        el_text = el_wrapper.querySelector('.js-question-title'),
        el_id_input, el_type_input;

    if (data.status == 'active') {
      el_formContainer.removeChild(el_activeForm);
    } else {
      el_formContainer.removeChild(el_inactiveForm);
    }

    // get elements in selected form
    el_id_input = el_wrapper.querySelector('.js-question-id');
    el_type_input = el_wrapper.querySelector('.js-questioner-type');

    el_text.innerHTML = data.text;
    el_id_input.value = data.id;
    el_type_input.value = data.type;
  }
}

let ModalAction = new ModalActions();

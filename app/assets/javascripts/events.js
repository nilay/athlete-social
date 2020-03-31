// requires jQuery
// requires loDash

var events = (function($) {
  'use strict';

  var newQuestionId = 1;

  var cleanup = function cleanup() {
    $(document).off('click', '.js-close-modal');
    $(document).off('click', '.js-delete-post-btn');
    $(document).off('click', '.js-no-leave');
    $(document).off('click', '.js-retire-account');
    $(document).off('click', '.js-tag-person');
    $(document).off('click', '.tag-pill');
    $(document).off('keydown', '.tag-input');
    $(document).off('mouseenter', '.tag-pill');
    $(document).off('mouseleave', '.tag-pill');
    $(document).off('submit', '#athleteDeleteForm');
    $(document).off('submit', '#athleteDeactivateForm');
    $(document).off('submit', '#athleteActivateForm');
    $(document).off('submit', '#createQuestionForm');
    $(document).off('submit', '#editQuestionForm');
    $(document).off('submit', '#inviteAthleteForm');
    $(document).off('submit', '#resetPasswordForm');
    $(document).off('submit', '.js-athlete-status-change-container form');
    $(document).off('submit', '.js-status-change-container form');
  };


  var initAthleteConfirmDelete = function initAthleteConfirmDelete() {
    $(document).on('submit', '#athleteDeleteForm', function(e) {
      var modalData = {
        title: 'confirm account removal'
      };

      e.preventDefault();
      ModalAction.showModal('deleteAccount', modalData);
    });
  };


  var initAthleteDeleteAccount = function initAthleteDeleteAccount() {
    $(document).on('click', '.js-retire-account', function(e) {
      var $form = $('#athleteDeleteForm'),
          url   = $form.attr('action'),
          dataObj;

      dataObj = {
        url: url,
        method: 'POST',
        successMsg: '',
        errorMsg: 'Unable to hide account :('
      };

      e.preventDefault();
      events.fetch(dataObj, function() {
        window.location.href = './';
      });
    });
  };


  var initDisableAthlete = function initDisableAthlete() {
    $(document).on('submit', '#athleteDeactivateForm', function(e) {
      var $form = $('#athleteDeactivateForm'),
          url   = $form.attr('action'),
          dataObj;

      dataObj = {
        url: url,
        method: 'POST',
        successMsg: 'Your account is hidden from the public',
        errorMsg: 'Unable to hide account :('
      };

      e.preventDefault();
      events.fetch(dataObj, function() {
        var $refresh = $('.refresh-container');
        $refresh.show();
      });
    });
  };


  var initEnableAthlete = function initEnableAthlete() {
    $(document).on('submit', '#athleteActivateForm', function(e) {
      var $form = $('#athleteActivateForm'),
          url   = $form.attr('action'),
          dataObj;

      dataObj = {
        url: url,
        method: 'POST',
        successMsg: 'Your profile is now public',
        errorMsg: 'Unable to enable account :('
      };

      e.preventDefault();
      events.fetch(dataObj, function() {
        var $refresh = $('.refresh-container');
        events.party();
        $refresh.show();
      });
    });
  };


  var initModalClose = function initModalClose() {
    $(document.body).on('click', '.js-close-modal', function() {
      ModalAction.closeModal();
    });
  };


  var initModalAthleteInvite = function initModalAthleteInvite() {
    $(document).on('submit', '#inviteAthleteForm', function(e) {
      var $form = $('#inviteAthleteForm'),
          url = $form.attr('action'),
          email = $form.find('.js-athlete-email').val(),
          jEmail = JSON.stringify({ 'email': email }),
          dataObj;

      dataObj = {
        url: url,
        method: 'POST',
        contentType: 'application/json; charset=UTF-8',
        params: jEmail,
        successMsg: 'Invite sent.',
        errorMsg: 'Unable to send invite. :('
      };

      // stop submit to allow modal animate out
      e.preventDefault();
      ModalAction.closeModal();
      events.fetch(dataObj);
    });
  };


  var initModalCreateQuestion = function initModalCreateQuestion() {
    $(document).on('submit', '#createQuestionForm', function(e) {
      var $form  = $('#createQuestionForm'),
          $tags  = $('.tag-pill'),
          url    = $form.attr('action'),
          userId = $form.find('.js-user-id').val(),
          status = $form.find('.toggle-btn'),
          checked = status.hasClass('active') ? 'active' : 'inactive',
          tagArray = [],
          text   = $form.find('.js-create-textarea').val(),
          type   = $form.find('.js-create-textarea').data('type'),
          tag, dataObj, uid;

      for (var i = 0; i < $tags.length; i++) {
        tag = $tags[i];
        uid = tag.dataset.uid;
        tagArray.push(uid);
      }

      dataObj = {
        url: url,
        method: 'POST',
        params: {
          question: {
            questioner_id: userId,
            questioner_type: type,
            status: checked,
            tags: tagArray,
            text: text
          }
        },
        successMsg: 'Question added.',
        errorMsg: 'Unable to add question. :('
      };

      // stop submit to allow modal animate out
      e.preventDefault();
      ModalAction.closeModal();

      events.fetch(dataObj, function(data) {
        Action.addQuestion({
          created_at: data.created_at,
          id: data.id,
          questioner_type: data.questioner_type,
          questioner_name: data.questioner_name,
          status: data.status,
          text: data.text
        });
      });
    });
  };


  var initModalChangeAthleteStatus = function initModalChangeAthleteStatus() {
    $(document).on('submit', '.js-athlete-status-change-container form', function(e) {
      var $form = $(this),
          url = $form.attr('action'),
          name = $form.find('.js-athlete-name').html(),
          props = $form.find('.js-athlete-info').data('props'),
          status = $form.find('.btn').data('status'),
          dataObj;

      dataObj = {
        url: url,
        method: 'POST',
        params: {
          id: props.id
        },
        successMsg: 'Athlete status updated',
        errorMsg: 'Unable to update athlete status. :('
      };

      // stop submit to allow modal animate out
      e.preventDefault();
      e.stopPropagation();
      ModalAction.closeModal();

      events.fetch(dataObj, function() {
        props.active = status == 'active' ? true : false;
        Action.editQuestion(props);
      });
    });
  };


  var initModalChangeQuestionStatus = function initModalChangeQuestionStatus() {
    $(document).on('submit', '.js-status-change-container form', function(e) {
      var $form = $(this),
          url = $form.attr('action'),
          id = $form.find('.js-question-id').val(),
          type = $form.find('.js-questioner-type').val(),
          status = $form.find('.btn').data('status'),
          text = $form.parents('.content').find('.js-question-title').html(),
          dataObj;

      dataObj = {
        url: url,
        method: 'POST',
        params: {
          id: id
        },
        successMsg: 'Question status updated',
        errorMsg: 'Unable to update question status. :('
      };

      // stop submit to allow modal animate out
      e.preventDefault();
      ModalAction.closeModal();

      events.fetch(dataObj, function() {
        Action.editQuestion({
          id: id,
          text: text,
          status: status,
          questioner_type: type
        });
      });
    });
  };


  var initModalDeletePost = function initModalDeletePost() {
    $(document).on('click', '.js-delete-post-btn', function() {
      var $img      = $('.js-post-detail-image'),
          postId    = $img.data('postId'),
          $origPost = $('.post-grid-container').find('.list-item[data-id="' + postId + '"]'),
          dataObj;

      dataObj = {
        url: './posts/' + postId,
        method: 'DELETE',
        successMsg: 'Post removed from players stats.',
        errorMsg: 'Unable to delete post. :('
      };

      events.fetch(dataObj, function() {
        var $refresh = $('.refresh-container');
        ModalAction.closeModal();
        $origPost.remove();
        $refresh.css({ display: 'flex' });
      });
    });
  };


  var initModalEditQuestion = function initModalEditQuestion() {
    $(document).on('submit', '#editQuestionForm', function(e) {
      var $form = $('#editQuestionForm'),
          url   = $form.attr('action'),
          id    = $form.find('.js-question-id').val(),
          text  = $form.find('.js-edit-textarea').val(),
          dataObj;

      dataObj = {
        url: './questions/' + id,
        method: 'PUT',
        params: {
          question: {
            text: text
          }
        },
        successMsg: 'Question udpated.',
        errorMsg: 'Unable to update question. :('
      };

      // stop submit to allow modal animate out
      e.preventDefault();
      ModalAction.closeModal();

      // send submit to edit Question, if successful, update Store
      events.fetch(dataObj, function() {
        Action.editQuestion({
          id: id,
          questioner_type: 'TODO',
          status: 'active',
          text: text
        });
      });
    });
  };


  var initNoLeaveMsg = function initNoLeaveMsg() {
    $(document).on('click', '.js-no-leave', function(e) {
      toast.showBasicToast("We knew you weren't a fair weather fan!");
      e.stopPropagation();
    });
  };


  var initRemoveTagPill = function() {
    var text = '';

    $(document).on('mouseenter', '.tag-pill', function() {
      text = $(this).html();

      $(this)
        .addClass('kill')
        .html('X');
    });

    $(document).on('mouseleave', '.tag-pill', function() {
      $(this)
        .removeClass('kill')
        .html(text);
    });

    $(document).on('click', '.tag-pill', function() {
      $(this).remove();
    });
  };


  var initResetPassword = function initResetPassword() {
    $(document).on('submit', '#resetPasswordForm', function(e) {
      var $form = $('#resetPasswordForm'),
          url   = $form.attr('action'),
          email = $form.find('#js-user-email').val(),
          jEmail = JSON.stringify({ 'user': { 'email': email } }),
          dataObj;

      dataObj = {
        contentType: 'application/json; charset=UTF-8',
        url: url,
        method: 'POST',
        params: jEmail,
        successMsg: 'Request sent. Check your email.',
        errorMsg: 'Unable to send request right now. :('
      };

      e.preventDefault();
      events.fetch(dataObj);
      $form.find('#js-user-email').val('');
    });
  };


  var initTagInput = function() {
    $(document).on('keydown', '.tag-input', function(e) {
      var key = e.target.value,
          name, dataObj;

      if (key.indexOf(',') > -1) {
        name = key.split(',');

        dataObj = {
          contentType: 'application/json; charset=UTF-8',
          url: './athletes.json?search=' + name[0],
          method: 'GET',
          successMsg: name[0] + ' tagged.',
          errorMsg: 'unable to tag ' + name[0] + ' :('
        };

        // clear input
        e.target.value = '';

        // search for athlete
        $.ajax({
          contentType: dataObj.contentType,
          data: dataObj.params,
          method: dataObj.method,
          url: dataObj.url,
        }).success(function(data, status, jqXHR) {
          var noAthletes = _.isEmpty(data.athletes);

          if (noAthletes) {
            toast.showBasicErrorToast("Athlete doesn't exist :(");
          } else {
            toast.showBasicToast(dataObj.successMsg);
            TaggingPerson.showList(data.athletes);
          }
        }).error(function(jqXHR, status, error) {
          toast.showBasicErrorToast(dataObj.errorMsg);
        });
      } else {
        return;
      }
    });
  };


  var initTagPerson = function initTagPerson() {
    $(document).on('click', '.js-tag-person', function() {
      var $tagInput   = $('.tag-input-wrapper'),
          $tagList    = $('.tagged-list'),
          inputHidden = $tagInput.hasClass('none');

      if (inputHidden) {
        $tagInput.removeClass('none');
        $tagList.removeClass('none');
      } else {
        $tagInput.addClass('none');
        $tagList.addClass('none');
      }
    });
  };


  var initToggleBtn = function initToggleBtn() {
    $(document.body).on('click', '.toggle-btn', function(e) {
      var $toggleBtn  = $(this),
          $active = $toggleBtn.parent().find('.active-label'),
          $inactive = $toggleBtn.parent().find('.inactive-label');

      if ($toggleBtn.hasClass('active')) {
        $toggleBtn.removeClass('active');
        $active.hide();
        $inactive.show();
      } else {
        $toggleBtn.addClass('active');
        $inactive.hide();
        $active.show();
      }

      e.stopPropagation();
    });
  };

  var party = function party() {
    var $canvas = $('.party-house');
    $canvas.addClass('party-time');

    window.setTimeout(function() {
      $canvas.addClass('get-lit');
    }, 400);

    window.setTimeout(function() {
      $canvas.removeClass('get-lit');
    }, 2000);

    window.setTimeout(function() {
      $canvas.removeClass('party-time');
    }, 2400);
  };


  var updateClass = function updateClass(target, oldObj) {
    oldObj.removeClass('active');
    target.addClass('active');
  };


  var fetch = function fetch(data, callback) {
    var token = $('meta[name="csrf-token"]').attr('content'),
        cmsToken = $('body').data('key'),
        contentType = data.contentType || 'application/x-www-form-urlencoded; charset=UTF-8',
        url = data.url || '',
        method = data.method || '',
        params = data.params || '',
        successMsg = data.successMsg || '',
        errorMsg = data.errorMsg || '';

    $.ajax({
      contentType: contentType,
      data: params,
      headers: {
        'X-CSRF-Token': token,
        'X-Cms-Admin-Auth-Token': cmsToken
      },
      method: method,
      url: url,
    }).success(function(data, status, jqXHR) {
      ModalAction.closeModal();
      window.setTimeout(function() {
        toast.showBasicToast(successMsg);
        if (callback) {
          callback(data);
        } else {
          return;
        }
      }, 600);
    }).error(function(jqXHR, status, error) {
      ModalAction.closeModal();
      window.setTimeout(function() {
        toast.showBasicErrorToast(errorMsg);
      }, 600);
    });
  };


  // PUBLIC

  return {
    cleanup: cleanup,
    initAthleteConfirmDelete: initAthleteConfirmDelete,
    initAthleteDeleteAccount: initAthleteDeleteAccount,
    initDisableAthlete: initDisableAthlete,
    initEnableAthlete: initEnableAthlete,
    initModalAthleteInvite: initModalAthleteInvite,
    initModalDeletePost: initModalDeletePost,
    initModalClose: initModalClose,
    initModalChangeAthleteStatus: initModalChangeAthleteStatus,
    initModalCreateQuestion: initModalCreateQuestion,
    initModalChangeQuestionStatus: initModalChangeQuestionStatus,
    initModalEditQuestion: initModalEditQuestion,
    initNoLeaveMsg: initNoLeaveMsg,
    initRemoveTagPill: initRemoveTagPill,
    initResetPassword: initResetPassword,
    initTagPerson: initTagPerson,
    initTagInput: initTagInput,
    initToggleBtn: initToggleBtn,
    fetch: fetch,
    party: party,
    updateClass: updateClass
  };

})(window.jQuery);

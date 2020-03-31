(function($) {
  'use strict';

  var user = $(document.body).data('athlete') ? 'athlete' : 'admin';

  String.prototype.trunc = function trunc(n, useWordBoundary) {
    var isTooLong = this.length > n,
        s_ = isTooLong ? this.substr(0,n-1) : this;
        s_ = (useWordBoundary && isTooLong) ? s_.substr(0,s_.lastIndexOf(' ')) : s_;
    return  isTooLong ? s_ + '...' : s_;
  };

  function setupLodash() {
    _.templateSettings.interpolate = /{{([\s\S]+?)}}/g;
  }

  // iOS has a different viewport
  function setUpiOSNine() {
    if(/iPad|iPhone|iPod/.test(navigator.userAgent) && !window.MSStream){
      document.body.className = 'ios';
      document.querySelector('meta[name=viewport]').setAttribute(
        'content',
        'initial-scale=1.0001, minimum-scale=1.0001, maximum-scale=1.0001, user-scalable=no'
      );
    }
  }


  function adminUserInit() {
    setupLodash();
    setUpiOSNine();
    events.cleanup();
    events.initModalAthleteInvite();
    events.initModalClose();
    events.initModalCreateQuestion();
    events.initModalChangeAthleteStatus();
    events.initModalChangeQuestionStatus();
    events.initModalDeletePost();
    events.initModalEditQuestion();
    events.initRemoveTagPill();
    events.initResetPassword();
    events.initTagPerson();
    events.initTagInput();
    events.initToggleBtn();
  }


  function athleteUserInit() {
    setupLodash();
    setUpiOSNine();
    events.cleanup();
    events.initAthleteConfirmDelete();
    events.initAthleteDeleteAccount();
    events.initDisableAthlete();
    events.initEnableAthlete();
    events.initModalAthleteInvite();
    events.initModalClose();
    events.initModalDeletePost();
    events.initNoLeaveMsg();
    events.initResetPassword();
    events.initToggleBtn();
  }


  $(function() {
    if (user == 'admin') {
      adminUserInit();
    } else {
      athleteUserInit();
    }
  });

})(window.jQuery);

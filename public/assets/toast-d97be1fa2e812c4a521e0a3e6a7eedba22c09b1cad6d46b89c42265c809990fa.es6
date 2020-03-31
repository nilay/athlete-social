// requires jQuery
// requires events module

const toastSelectors = {
  container: '.toast-container',
  msgContainer: '.toast-msg',
  undoContainer: '.undo-link-container',
  undoLink: '.undo-link'
};


class Toast {
  showBasicToast(msg) {
    this._startTimeout();
    this._showToast(msg);
    this._addUndoListener();
  }

  showBasicErrorToast(msg) {
    let $toast    = $(toastSelectors.container);
    $toast.addClass('error');
    this._hideUndoLink();
    this._startTimeout();
    this._showToast(msg);
  }


  // PRIVATE

  _addUndoListener() {
    let that    = this,
        $el     = $(toastSelectors.container).find(toastSelectors.undoLink),
        message = $(toastSelectors.container).find(toastSelectors.msgContainer).html().toLowerCase();

    if (!(message == 'question deleted.' || message == 'question archived.')) {
      this._hideUndoLink();
      return;
    } else {
      this._showUndoLink();

      $el.on('click', function(e) {
        switch (message) {
          case 'question deleted.':
            that._undoDeletedItem();
            break;
          default:
            that._undoArchivedItem();
            break;
        }
        e.stopPropagation();
      });
    }
  }


  _hideToast(timeout) {
    let $toast = $(toastSelectors.container),
        $message = $(toastSelectors.msgContainer);

    if ($toast.hasClass('error')) {
      $toast.removeClass('error');
      $toast.removeClass('active');
    } else {
      $toast.removeClass('active');
    }

    // empty node after transition ends
    window.setTimeout(function() {
      $message.empty();
    }, 200);

    window.clearTimeout(timeout);
    this._removeUndoListener();
  }


  _hideUndoLink() {
    var $undo = $(toastSelectors.undoContainer);
    $undo.hide();
  }


  _initCloseClick() {
    let that = this,
        $toast = $(toastSelectors.container);
    $toast.click(function() {
      that._hideToast();
    });
  }


  _removeUndoListener() {
    let $el     = $(toastSelectors.container).find(toastSelectors.undoLink);
    $el.off('click');
  }


  _showToast(msg) {
   let $toast   = $(toastSelectors.container),
       $message = $(toastSelectors.msgContainer),
       message  = msg || "you're awesome!";
   $message.html(message);
   $toast.addClass('active');
 }


 _showUndoLink() {
   var $undo = $(toastSelectors.undoContainer);
   $undo.show();
 }


  _startTimeout() {
    let that = this,
        timeoutID;

    timeoutID = window.setTimeout(function() {
      that._hideToast(timeoutID);
    }, 4000);
  }


  _undoArchivedItem() {
    let questionId, status, url, method, dataObj,
        $undo = $(toastSelectors.undoContainer);

    $undo.show();

    // get saved item
    status     = sessionStorage.getItem('status');
    questionId = sessionStorage.getItem('questionId');
    url        = sessionStorage.getItem('action');

    dataObj = {
      method: 'PUT',
      url: url,
      params: {
        question: {
          id: questionId,
          status: status
        }
      },
      successMsg: 'Reverted status.',
      errorMsg: 'Unable to undo question status. :(',
    };

    events.fetch(dataObj, function() {
      let $refreshContainer = $('.refresh-container');
      $refreshContainer.css({ display: 'flex' });
    });
  }


  _undoDeletedItem() {
    let userId, url, text, status, dataObj,
        $undo = $(toastSelectors.undoContainer);

    $undo.show();

    // get saved item
    userId = sessionStorage.getItem('userId');
    url    = sessionStorage.getItem('action');
    text   = sessionStorage.getItem('text');
    status = sessionStorage.getItem('status');

    // prep for AJAX call
    dataObj = {
      url: url,
      method: 'POST',
      params: {
        question: {
          text: text,
          questioner_id: userId,
          status: status
        }
      },
      successMsg: 'Reverted changes.',
      errorMsg: 'Unable to undo question. :(',
    };

    events.fetch(dataObj, function() {
      let $refreshContainer = $('.refresh-container');
      $refreshContainer.css({ display: 'flex' });
    });
  }
}
let toast = new Toast();

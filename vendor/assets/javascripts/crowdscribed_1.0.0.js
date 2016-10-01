(function() {
  // set up the crowdscried object
  function registerStartup(fn) {
    if (typeof window.jQuery === 'undefined') {
      return false
    }
    window.jQuery(fn);
    return true;
  }

  function tryRegister(fn, count, max) {
    if(!registerStartup(fn)) {
      if (count < max) {
        window.setTimeout(function() {
          tryRegister(fn, count + 1, max);
        }, 500);
      }
    }
  }

  Crowdscribed = function() {
  };
  Crowdscribed.prototype = {
    ready: function(fn) {
      tryRegister(fn, 0, 3);
    }
  };
  window.crowdscribed = new Crowdscribed();

  // Initialize
  function csInit() {
    window.jQuery.fn.purchaseButton = function() {

      var a = $(document.createElement("A"));
      a.text("Purchase");
      a.attr("href", "#");
      a.click(function() {
        console.log("purchase button click, cha-ching");
      });
      this.append(a);

      return this;
    };
  }

  // ensure libraries are loaded
  if(typeof window.jQuery === 'undefined') {
    window.onload = function() {
      var scriptElem = document.createElement("SCRIPT");
      scriptElem.setAttribute("src", "https://code.jquery.com/jquery-3.1.1.slim.min.js");
      document.body.appendChild(scriptElem);
    }
    tryRegister(csInit, 0, 3);
  } else {
    $(csInit());
  }
})();

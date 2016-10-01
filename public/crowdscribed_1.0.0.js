(function() {
  // set up the crowdscried object
  function registerStartup(fn) {
    if (typeof window.jQuery === 'undefined') {
      return false
    }
    window.jQuery(fn);
    return true;
  }

  function tryFunction(fn, count, max) {
    if(fn()) {
      return true;
    } else if (count < max) {
      window.setTimeout(function() {
        tryFunction(fn, count + 1, max);
      }, 500);
    } else {
      console.log("gave up in function");
      console.log(fn);
    }
  }

  Crowdscribed = function() {
  };
  Crowdscribed.prototype = {
    ready: function(fn) {
      tryFunction(function() {
        return registerStartup(fn);
      }, 0, 10);
    }
  };
  window.crowdscribed = new Crowdscribed();

  // Initialize
  function initializeJQuery() {
    if (typeof window.jQuery === 'undefined') {
      return false;
    }

    window.jQuery.fn.purchaseButton = function() {
      this.attr("ng-app", "crowdscribed");

      var div = $(document.createElement("DIV"));
      div.attr("purchase-tile", true);
      this.append(div);

      console.log("appended purchase-tile div");

      return this;
    };
    return true;
  }

  function initializeAngular() {
    if (typeof window.angular === 'undefined') {
      return false
    }

    angular.module('crowdscribed', [])
      .directive('purchaseTile', function() {
        return {
          template: '<a href="#">Purchase</a>'
        }
      })

    return true;
  }

  // ensure libraries are loaded
  function loadScript(src) {
    var scriptElem = document.createElement("SCRIPT");
    scriptElem.setAttribute("src", src);
    document.body.appendChild(scriptElem);
  }

  function registerLibraries() {
    var libraries = [
      {
        src: "https://code.jquery.com/jquery-3.1.1.js",
        test: function() { return typeof window.jQuery !== 'undefined' }
      },
      {
        src: "https://ajax.googleapis.com/ajax/libs/angularjs/1.5.8/angular.js",
        test: function() { return typeof window.angular !== 'undefined' }
      }
    ];
    for (var i = 0; i < libraries.length; i++) {
      var library = libraries[i];
      if (!library.test()) {
        loadScript(library.src);
      }
    }
  }

  // TODO May need to handle client that already handles onload
  window.onload = function() {
    registerLibraries();
  };

  // initializers
  tryFunction(initializeJQuery, 0, 3);
  tryFunction(initializeAngular, 0, 3);
})();

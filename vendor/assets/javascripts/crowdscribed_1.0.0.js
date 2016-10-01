(function() {
  // set up the crowdscried object
  function registerStartup(fn) {
    if (typeof window.jQuery === 'undefined') {

      console.log("no jQuery, cannot register startup script");

      return false
    }
    window.jQuery(fn);

    console.log("registered startup script");

    return true;
  }

  function tryFunction(fn, count, max) {
    if(fn()) {

      console.log("successfully called function");
      console.log(fn);

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
      if (window.angular === 'undefined') {
        console.log("tried to insert directive before angular module is defined");
      } else {
        var div = $(document.createElement("DIV"));
        div.attr("purchase-tile", true);
        this.append(div);

        console.log("appended purchase-tile div");
      }

      return this;
    };
    return true;
  }

  function initializeAngular() {
    if (typeof window.angular === 'undefined') {
      return false
    }

    console.log("define angular module");

    // Angulr initialization
    angular.module('crowdscribed')
      .directive('purchaseTile', function() {
        return {
          template: '<a href="#">Purchase</a>'
        }
      })

    console.log("registered angular directive 'purchaseTile'");
    return true;
  }

  // ensure libraries are loaded
  function loadScript(src) {
    var scriptElem = document.createElement("SCRIPT");
    scriptElem.setAttribute("src", src);
    document.body.appendChild(scriptElem);

    console.log("inserted script tag for " + src);
  }

  function registerLibraries() {
    var libraries = [
      {
        src: "https://code.jquery.com/jquery-3.1.1.slim.min.js",
        test: function() { return typeof window.jQuery !== 'undefined' }
      },
      {
        src: "https://ajax.googleapis.com/ajax/libs/angularjs/1.5.8/angular.min.js",
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

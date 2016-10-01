(function() {
  if (typeof window.angular === 'undefined') {
    console.log("The angular library has not been reference correctly. Please reference it and then continue.");
    return;
  }

  angular.module('crowdscribed', [])
    .directive('purchaseTile', function() {
      return {
        template: '<div class="purchase-tile"><a href="#">Purchase</a></div>'
      }
    })
})();

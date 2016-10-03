(function() {
  if (typeof window.angular === 'undefined') {
    console.log("The angular library has not been reference correctly. Please reference it and then continue.");
    return;
  }

  angular.module('crowdscribed', []).
    directive('purchaseTile', function() {
      return {
        restrict: 'E',
        templateUrl: 'purchase_tile.html'
      }
    })
  .factory('cs', ['$http', function($http) {
    this.getProduct = function(sku, callback) {
      var url = 'http://localhost:3030/api/v1/products/' + sku;
      $http.get(url, {
        headers: {
          'Authorization': 'Token token=fde100e5505140c5a93cede29321cd9c'
        }
      }).then(callback);
    }
    return this;
  }])
    .controller('purchaseTileController', ['$scope', 'cs', function($scope, cs) {
      $scope.$watch('sku', function(newValue, oldValue) {
        cs.getProduct(newValue, function(product) {
          $scope.price = product.price;
        });
      });
    }]);
})();

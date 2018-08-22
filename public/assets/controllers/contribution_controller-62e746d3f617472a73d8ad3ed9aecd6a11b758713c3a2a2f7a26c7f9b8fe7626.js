(function() {
  var app;

  app = angular.module('Crowdscribed');

  app.controller('ContributionController', [
    '$scope', '$http', function($scope, $http) {
      var createContribution, createPayment, handlePaymentReceived, loadRewards, refreshAvailableRewards, specifiedAmount;
      $scope.STATE_ABBR_PATTERN = "^[a-zA-Z]{2}$";
      $scope.POSTAL_CODE_PATTERN = "^\\d{5}$";
      $scope.campaignId = null;
      $scope.rewards = [];
      $scope.selectedRewardId = null;
      $scope.selectedReward = null;
      $scope.customContributionAmount = null;
      $scope.customRewardId = null;
      $scope.customReward = null;
      $scope.availableRewards = [];
      $scope.isInProgress = false;
      $scope.$watch('campaignId', function() {
        return loadRewards();
      });
      $scope.$watch('selectedRewardId', function() {
        if ($scope.selectedReward) {
          $scope.selectedReward.selected = false;
        }
        $scope.selectedReward = _.find($scope.rewards, function(r) {
          return r.id === $scope.selectedRewardId;
        });
        if ($scope.selectedReward) {
          $scope.selectedReward.selected = true;
          return $scope.customContributionAmount = null;
        }
      });
      $scope.$watch('customContributionAmount', function() {
        return refreshAvailableRewards();
      });
      $scope.$watch('customRewardId', function() {
        return $scope.customReward = _.find($scope.availableRewards, function(r) {
          return r.id === $scope.customRewardId;
        });
      });
      $scope.handleRewardClick = function(e) {
        return $scope.selectedRewardId = $(e.currentTarget).data('reward-id');
      };
      $scope.clearSelection = function() {
        return $scope.selectedRewardId = null;
      };
      $scope.addressRequired = function() {
        return _.chain([$scope.selectedReward, $scope.customReward]).some(function(r) {
          return r && r.physical_address_required;
        }).value();
      };
      $scope.submitForm = function() {
        $scope.isInProgress = true;
        $('#progressbar').progressbar({
          max: 3,
          value: 0
        });
        $('#payment-button').click();
      };
      specifiedAmount = function() {
        if ($scope.selectedReward) {
          return $scope.selectedReward.minimum_contribution;
        } else {
          return $scope.customContributionAmount;
        }
      };
      handlePaymentReceived = function(details) {
        $('#progressbar').progressbar('option', 'value', 1);
        createPayment(details.nonce);
      };
      createPayment = function(nonce) {
        var data, url;
        url = "/payments.json";
        data = {
          payment: {
            amount: specifiedAmount(),
            nonce: nonce
          }
        };
        return $http.post(url, data).then(function(response) {
          $('#progressbar').progressbar('option', 'value', 2);
          return createContribution(response.data.id);
        }, function(error) {
          console.log("Unable to create the payment.");
          console.log(error);
        });
      };
      createContribution = function(paymentId) {
        var data, url;
        url = "/campaigns/" + $scope.campaignId + "/contributions.json";
        data = {
          contribution: {
            amount: specifiedAmount(),
            email: $scope.email,
            payment_id: paymentId
          },
          fulfillment: {
            reward_id: $scope.selectedRewardId || $scope.customRewardId,
            email: $scope.email,
            address1: $scope.address1,
            address2: $scope.address2,
            city: $scope.city,
            state: $scope.state,
            postal_code: $scope.postalCode,
            recipient: $scope.recipient
          }
        };
        return $http.post(url, data).then(function(response) {
          $('#progressbar').progressbar('option', 'value', 3);
          return window.redirectTo("/contributions/" + response.data.public_key);
        }, function(error) {
          console.log("Unable to create the contribution.");
          return console.log(error);
        });
      };
      loadRewards = function() {
        var url;
        if ($scope.campaignId) {
          url = "/campaigns/" + $scope.campaignId + "/rewards.json";
          return $http.get(url).then(function(response) {
            $scope.rewards = response.data;
            if ($scope.rewards.length > 0) {
              return $scope.selectedRewardId = $scope.rewards[0].id;
            }
          }, function(error) {
            console.log("Unable to get the rewards.");
            return console.log(error);
          });
        } else {
          return $scope.rewards = [];
        }
      };
      refreshAvailableRewards = function() {
        if ($scope.customContributionAmount) {
          return $scope.availableRewards = _.filter($scope.rewards, function(r) {
            return r.minimum_contribution <= $scope.customContributionAmount;
          });
        } else {
          return $scope.availableRewards = [];
        }
      };
      window.redirectTo = function(url) {
        return window.location.href = url;
      };
      $(function() {
        return window.paymentReceivedCallbacks.add(handlePaymentReceived);
      });
    }
  ]);

}).call(this);

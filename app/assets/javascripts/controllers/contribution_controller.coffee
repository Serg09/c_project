#= require angular

app = angular.module('Crowdscribed', [])
app.controller('ContributionController', ['$scope', '$http', ($scope, $http) ->

  $scope.STATE_ABBR_PATTERN = "\\A[a-zA-Z]{2}\\z"
  $scope.POSTAL_CODE_PATTERN = "\\A\\d{5}\\z"

  $scope.campaignId = null
  $scope.rewards = []
  $scope.$watch 'campaignId', ->
    loadRewards()

  $scope.selectedRewardId = null
  $scope.selectedReward = null
  $scope.customContributionAmount = null
  $scope.customRewardId = null # reward selected after entering a custom donation amount
  $scope.customReward = null
  $scope.availableRewards = [] # rewards available for a custom amount

  $scope.$watch 'selectedRewardId', ->
    $scope.selectedReward.selected = false if $scope.selectedReward
    $scope.selectedReward = _.find $scope.rewards, (r) ->
      r.id == $scope.selectedRewardId
    if $scope.selectedReward
      $scope.selectedReward.selected = true
      $scope.customContributionAmount = null

  $scope.$watch 'customContributionAmount', ->
    refreshAvailableRewards()

  $scope.$watch 'customRewardId', ->
    $scope.customReward = _.find $scope.availableRewards, (r) ->
      r.id == $scope.customRewardId

  $scope.handleRewardClick = (e) ->
    $scope.selectedRewardId = $(e.currentTarget).data('reward-id')

  $scope.clearSelection = () ->
    $scope.selectedRewardId = null

  $scope.addressRequired = () ->
    _.chain([$scope.selectedReward, $scope.customReward]).
      some((r) -> r && r.physical_address_required).
      value()

  $scope.submitForm = () ->
    console.log "submitForm"

  loadRewards = ->
    if $scope.campaignId
      url = "/campaigns/#{$scope.campaignId}/rewards.json"
      $http.get(url).then (response)->
        $scope.rewards = response.data
        $scope.selectedRewardId = $scope.rewards[0].id if $scope.rewards.length > 0
      , (error)->
        console.log "Unable to get the rewards: #{error}"
    else
      $scope.rewards = []

  refreshAvailableRewards = ->
    if $scope.customContributionAmount
      $scope.availableRewards = _.filter $scope.rewards, (r) ->
        r.minimum_contribution <= $scope.customContributionAmount
    else
      $scope.availableRewards = []

  return
])

@wip
Feature: Administrator sign in
  As an administrator
  In order to administer the site
  I need to be able to sign in

  Scenario: An administrator signs in successfully
    Given there is an administrator with email "admin@cs.com" and password "please01"
    When I am on the administrator sign in page
    Then I should see "Administration" within the watermark
    And I should see "Sign in" within the page title

    When I fill in "Email" with "admin@cs.com"
    And I fill in "Password" with "please01"
    And I click "Sign in"

    Then I should see "You have been signed in successfully" within the notification area
    And I should see "Pending authors" within the main menu
    

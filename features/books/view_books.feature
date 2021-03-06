Feature: View books
  As a user
  In order to find books I might like to read
  I need to be able to see the books in the system

  Scenario: A user views the books
    Given users have submitted the following books
      | Author          | Title                    | Status   |
      | John Doe        | My Anonymous Life        | approved |
      | Jane Doe        | My Anonymous Husband     | approved |
      | Christian Piatt | Post Christian           | approved |
      | Mona Lin        | Love and first Click     | approved |
      | Jack Doe        | Not Ready for Prime Time | pending  |
      | Bill Trouble    | Downright Unacceptable   | rejected |

    When I am on the welcome page
    Then I should see "Browse books" within the main menu

    When I click "Browse books" within the main menu
    Then I should see "Books" within the page title
    And I should see the following books
      | Author          | Title                    |
      | Mona Lin        | Love and first Click     |
      | Christian Piatt | Post Christian           |
      | Jane Doe        | My Anonymous Husband     |
      | John Doe        | My Anonymous Life        |

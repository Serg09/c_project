Feature: Link a product to a book
  As an administrator
  In order to make a book available for sale
  I need to be able to link it to a product

  Scenario: An administrator links a book to a product
    Given there is an author named "John Doe"
    And author "John Doe" has a book titled "Selling Online"
    Given there is an author named "Jane Doe"
    And author "Jane Doe" has a book titled "Not Relevant"
    And there is an administrator with email "john@doe.com" and password "please01"

    When I am signed in as an administrator with "john@doe.com/please01"
    Then I should see "Products" within the main menu

    When I click "Products" within the main menu
    Then I should see "Products" within the page title

    When I fill in "Title" with "Online"
    And I click the search button
    Then I should see the following books table
     | Title          | Author   |
     | Selling Online | John Doe |

   When I click the link button within the 1st book row
   Then I should see "Products for Selling Online" within the page title

   When I click "Add" within the admin content
   Then I should see "New Product for Selling Online" within the page title

   When I fill in "SKU" with "0000000000001"
   And I fill in "Caption" with "Hardback"
   And I click "Save"
   Then I should see "The product link was created successfully" within the notification area
   And I should see "Products for Selling Online" within the page title
   And I should see the following products table
     | Caption  | SKU           |
     | Hardback | 0000000000001 |

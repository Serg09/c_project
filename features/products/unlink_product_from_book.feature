Feature: Link a product to a book
  As an administrator
  In order to correct a mistake
  I need to be able to unlink a book from a product

  Scenario: An administrator links a book to a product
    Given there is an author named "John Doe"
    And author "John Doe" has a book titled "Selling Online"
    Given there is an author named "Jane Doe"
    And author "Jane Doe" has a book titled "Not Relevant"
    And book "Selling Online" is associated with SKU "0000000000001" with caption "Hardback"
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
   And I should see the following products table
     | Caption  | SKU           |
     | Hardback | 0000000000001 |

   When I click the delete button within the 1st product row
   Then I should see "Products for Selling Online" within the page title
   And I should see "The association between the product and the book was removed successfully" within the notification area
   And I should see the following products table
     | Caption  | SKU           |

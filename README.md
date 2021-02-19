# Rails Engine
This repository is a project from the Mod 3 curriculum at Turing School of Software and Desig. 

## Premise
You are working for a company developing an E-Commerce Application. Your team is working in a service-oriented architecture, meaning the front and back ends of this application are separate and communicate via APIs. Your job is to expose the data that powers the site through an API that the front end will consume.

## End Points
* get **/api/v1/merchants** shows all merchants with id and name, with a default of 20 results per page
* get **/api/v1/merchants/{{merchant_id}}** shows one merchant's information
* get **/api/v1/merchants/{{merchant_id}}/items** shows a merchant's information and that merchant's items
* get **/api/v1/items** shows all items and attributes, with a default of 20 results per page
* get **/api/v1/items/{{item_id}}** shows one item's information
* post **/api/v1/items** create an item
* delete **/api/v1/items** delete an item
* put **/api/v1/items/{{item_id}}** update an item
* get **/api/v1/items/{{item_id}}/merchant** shows an item's merchant attributes
* get **/api/v1/merchants/find?name={{criteria}}** shows one merchant by name criteria
* get **/api/v1/merchants/find_all?name={{criteria}}** shows all merchant matches by name criteria
* get **/api/v1/items/find?name={{criteria}}** shows one item by name criteria
* get **/api/v1/items/find_all?name={{criteria}}** shows all item matches by name criteria
* get **/api/v1/merchants/most_items?quantity={{amount}}** shows merchants in order of which merchant sold the most items
* get **/api/v1/revenue?start={{start_date}}&end={{end_date}}** shows total revenue within a date range
* get **/api/v1/revenue/merchants/{{merchant_id}}** shows the total revenue of one merchant
* get **/api/v1/revenue/items** lists items by which has the highest total revenue
* get **/api/v1/revenue/unshipped** displays the total potential revenue of invoices that are not yet shipped
* get **/api/v1/revenue/weekly** displays the total revenue by week 

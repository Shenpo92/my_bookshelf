# my_bookshelf
Search or scroll through the list of my favorite books. 


This project uses https://api.itbook.store/ API to retrieve a list of books depending on a searched keyword.
We can see more details and write notes about each book by clicking on its card.

Project was build using the **Provider** package as a state management. The provider we created allows a list of books to be passed downd into the widget tree and to provide and cache its information.

For the API call the **http** package was used to send our request to via network to the API endpoints.

The **url_launcher** package is used to allow users to navigate to the links available in the books'description using the phone's navigator.

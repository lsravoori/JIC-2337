# For the People

An easy to use application which allows users to find local minority/women-owned businesses in a specific zip code to find their respective needs.

Current iteration of the project includes business names. When clicking on these names, the information will display in a new screen.

Future iterations will include log-in pages with different options for users, business, and admin. In addition reviewing the business and flagging them is another major 
feature that we are looking to implement. Admin features such as reviewing businesses is also high in our priorities.

The code consists mainly of Flutter for Android/IOS as the front end. And firebase for the database and cloud utilization. Expansion into using Java Spring Boot is 
considered as the code base continues to grow.

# Release Notes

## v0.3.0
### Features
-Flagging button to report businesses that misrepresent themselves

-Verification icon displayed for businesses that have been checked and approved by the admins

-Reviews allowing consumers to describe their experiences

-Ratings allow users to get an idea of a business's quality

-Broke user/business demographics into more categories to diversify filter system

-Added 'assets/images/' folder to allow for ease of inserting basic images such as the app logo

### Bug Fixes
-Fixed the filter system

-Fixed issues with displaying business information (correct name shown)

### Known Issues
-Need to hyperlink the address so users can click on it and be taken to the address on Google Maps

-Editing the Account Page details does not save for Gender or Ethnicity

## v0.2.0
### Features
-Filter page with checkboxes

-See details of business

-Login and Logout with User-Authentication

-Account pages for users

-General Search Page

-Business and User Registration Page

-Checking for user-authentication before access
### Bug Fixes
-Updated filters with filter page

-Navigation bar included (More usable UI)

-Updated database formating

### Known Issues
-Want guest and google login pages

-When new businesses are added, filters stop working

-LGBTQ+ filter refreshes every time instead of holding state.

-Business details page doesn't link to correct document's data for businesses with auto-generated IDs.

## v0.1.0
### Features
-Filter business by type or location

-See details of business

-Login as Guest
### Bug Fixes
-Removed faulty back button

### Known Issues
-Positoning of drop-down filters

-UI (general app theme)

-Back Button vs Return Button on business information page overlap

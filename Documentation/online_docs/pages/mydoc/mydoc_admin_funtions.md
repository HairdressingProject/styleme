---
title: Admin Functions
keywords: Admin portal, admin
last_updated: April 4, 2020
tags: [admin]
summary: "This document outlines the various functions of UI elements found on each Admin page."
sidebar: mydoc_sidebar
permalink: mydoc_admin_functions.html
folder: mydoc
---

## 1. Sign Up

{% include image.html file="sign_up.png" alt="Sign in screenshot" caption="Sign up form" %}

<!-- {% include inline_image.html file="sign_up.png" alt="Sign up screenshot" %} -->

<!-- Using Navtabs -->



<ul id="signUpfunctionTabs" class="nav nav-tabs">
    <li class="active"><a href="#signUpDetails" data-toggle="tab">Details</a></li>
    <li><a href="#signUpFields" data-toggle="tab">Sections/Fields</a></li>
</ul>

<div class="tab-content">

<div role="tabpanel" class="tab-pane active" id="signUpDetails">
    <ul>
        <li>Every new user must enter the details outlined above to register in the admin portal</li>
        <li>Basic password validation will make accounts slightly more secure</li>
        <li>A privacy policy might be written for the application itself rather than the admin portal</li>
        <li>The “Sign up” button should be greyed out if a required field is invalid</li>
        <li>The “Sign In” link conveniently redirects existing users to the sign in page</li>
    </ul>
</div>

<div role="tabpanel" class="tab-pane" id="signUpFields">
    <ol>
        <li>Given name input <span class="label label-warning">required</span></li>
        <li>Family name input</li>
        <li>Username input <span class="label label-warning">required</span></li>
        <li>Email input <span class="label label-warning">required</span></li>
        <li>Password input <span class="label label-warning">required</span></li>
        <li>Privacy policy checkbox <span class="label label-warning">required</span></li>
        <li>Sign up button</li>
        <li>Sign in link</li>
    </ol>
</div>

</div>


<!-- Using Tables -->

<!-- | Function | Details | Fields |
|-------|--------|---------|
| Sign up form | Every new user must enter the details outlined above to register in the admin portal | (1) Given name input <span class="label label-warning">required</span> |
| | Basic password validation will make accounts slightly more secure | (2) Family name put |
| | A privacy policy might be written for the application itself rather than the admin portal | (4) Email input <span class="label label-warning">required</span> |
| | The “Sign up” button should be greyed out if a required field is invalid | (5) Password input <span class="label label-warning">required</span> |
| | The “Sign In” link conveniently redirects existing users to the sign in page | (6) Privacy policy checkbox <span class="label label-warning">required</span> |
| | | (7) Sign up button (submit form) |
| | | (8) Sign in link -->


## 2. Sign In


{% include image.html file="sign_in.png" alt="Sign in screenshot" caption="Sign in form" %}

<!-- | Function | Details | Fields |
|-------|--------|---------|
| Sign in form | Users have the option to enter either their username or email to sign in |
| | A pop-up message should be displayed if either field is incorrect |
| | Checking the “remember me” checkbox stores a token in the user’s browser that identifies them next time they access the admin portal |
| | The “forgot password” link should redirect users to the forgot password page |
| | The “forgot password” link should redirect new users to the sign up page |

{% include links.html %} -->

<ul id="signInFunctionTabs" class="nav nav-tabs">
    <li class="active"><a href="#signInDetails" data-toggle="tab">Details</a></li>
    <li><a href="#signInFields" data-toggle="tab">Sections/Fields</a></li>
</ul>

<div class="tab-content">

<div role="tabpanel" class="tab-pane active" id="signInDetails">
    <ul>
        <li>Users have the option to enter either their username or email to sign in</li>
        <li>A pop-up message should be displayed if either field is incorrect</li>
        <li>Checking the “remember me” checkbox stores a token in the user’s browser that identifies them next time they access the admin portal</li>
        <li>The “forgot password” link should redirect users to the forgot password page</li>
        <li>The “forgot password” link should redirect new users to the sign up page</li>
    </ul>
</div>

<div role="tabpanel" class="tab-pane" id="signInFields">
    <ol>
        <li>Username or Email input <span class="label label-warning">required</span></li>
        <li>Password input <span class="label label-warning">required</span></li>
        <li>Remember me checkbox</li>
        <li>Forgot password link</li>
        <li>Sign in button (submit form)</li>
        <li>Sign up link</li>
    </ol>
</div>

</div>

## 3. Forgot Password

{% include image.html file="forgotPassword.png" alt="Sign in screenshot" caption="Forgot password form" %}
{% include image.html file="forgotPassword2.png" alt="Sign in screenshot" caption="Email sent notification" %}
{% include image.html file="forgotPassword3.png" alt="Sign in screenshot" caption="No email notification" %}

<ul id="forgotPasswordTabs" class="nav nav-tabs">
    <li class="active"><a href="#forgotPasswordDetails" data-toggle="tab">Details</a></li>
    <li><a href="#forgotPasswordFields" data-toggle="tab">Sections/Fields</a></li>
</ul>

<div class="tab-content">

<div role="tabpanel" class="tab-pane active" id="forgotPasswordDetails">
    <ul>
        <li>Users can enter either username or email to recover their account</li>
        <li>If an account associated with the information entered is found, an email will be sent to the user with instructions on how to create a new password. Additionally, a success message should pop up at the top of the window to let the user know.</li>
        <li>If no account is found, an error message should pop up at the top of the window to inform the user.</li>
        <li>If the username/email input field is invalid or empty, the “recover password” button should be inactive.</li>
        <li>The sign in/ sign up links below the form should redirect users to the corresponding pages.</li>
    </ul>
</div>

<div role="tabpanel" class="tab-pane" id="forgotPasswordFields">
    <ol>
        <li>Username or Email input <span class="label label-warning">required</span></li>
        <li>Recover Password button (submit form)</li>
        <li>Sign in link</li>
        <li>Sign up link</li>
    </ol>
</div>

</div>


## 4. New Password

{% include image.html file="newPassword.png" alt="Sign in screenshot" caption="New password form" %}

<ul id="newPasswordTabs" class="nav nav-tabs">
    <li class="active"><a href="#newPasswordDetails" data-toggle="tab">Details</a></li>
    <li><a href="#newPasswordFields" data-toggle="tab">Sections/Fields</a></li>
</ul>

<div class="tab-content">

<div role="tabpanel" class="tab-pane active" id="newPasswordDetails">
    <ul>
        <li>The “email” field is read-only and lets users be aware of which email is associated with the account that they wish to recover.</li>
        <li>Both the “new password” and “confirm new password” input fields have basic validation and must match.</li>
        <li>If any of the fields is invalid, empty or the passwords do not match, the “change password” button should be inactive.</li>
        <li>If all inputs are valid, clicking on the “change password” button should redirect users to the dashboard page, with a success message at the top of the window informing them that their password has changed (possibly along with an email).</li>
        <li>The sign in/ sign up links below the form should redirect users to the corresponding pages.</li>
    </ul>
</div>

<div role="tabpanel" class="tab-pane" id="newPasswordFields">
    <ol>
        <li>Email (read-only)</li>
        <li>New password input <span class="label label-warning">required</span></li>
        <li>Confirm new password input <span class="label label-warning">required</span></li>
        <li>Change Password button (submit form)</li>
        <li>Sign in link</li>
        <li>Sign up link</li>
    </ol>
</div>

</div>


## 5. Dashboard

{% include image.html file="dashboard.png" alt="Sign in screenshot" caption="Dashboard page" %}

<ul id="dashboardTabs" class="nav nav-tabs">
    <li class="active"><a href="#dashboardDetails" data-toggle="tab">Details</a></li>
    <li><a href="#dashboardFields" data-toggle="tab">Sections/Fields</a></li>
</ul>

<div class="tab-content">

<div role="tabpanel" class="tab-pane active" id="dashboardDetails">
    <ul>
        <li>The dashboard is the home page of the admin portal. It is the first page that users see after signing in.</li>
        <li>The settings button exposes a menu containing links for account information, logout and more.</li>
        <li>Clicking on the notifications button should show a small panel with the latest (important) changes in the databases or in the current user’s account, such as password or permissions. It should also display a switch button with the option to disable such notifications.</li>
        <li>The sidebar is the main navigation element of the admin portal. Clicking on each button should redirect users to the respective page.</li>
        <li>Recently updated tables should show which column/row has been modified, with the name of the respective table and database and a timestamp.</li>
        <li>The statistics section should display a simple pie chart or graph with useful data about users.</li>
        <li>Activity log refers to the latest changes specifically made by registered users of the application, with timestamp.</li>
    </ul>
</div>

<div role="tabpanel" class="tab-pane" id="dashboardFields">
    <ol>
        <li>Settings button</li>
        <li>Notifications button</li>
        <li>Profile picture and name</li>
        <li>Sidebar with links</li>
        <li>Collapse sidebar button</li>
        <li>Recently updated tables</li>
        <li>Statistics pie chart</li>
        <li>Activity log table</li>
    </ol>
</div>

</div>

### 5.1. Dashboard - Settings dropdown

{% include image.html file="dashboard_settings_dropdown.jpg" alt="Sign in screenshot" caption="Settings dropdown" %}

<ul id="settingsDropdownTabs" class="nav nav-tabs">
    <li class="active"><a href="#settingsDropdownDetails" data-toggle="tab">Details</a></li>
    <li><a href="#settingsDropdownFields" data-toggle="tab">Sections/Fields</a></li>
</ul>

<div class="tab-content">

<div role="tabpanel" class="tab-pane active" id="settingsDropdownDetails">
    <ul>
        <li>This dropdown menu is displayed when users click on the settings (gear) icon.</li>
        <li>It provides four elements: a link to the application’s privacy policy (2), another link to the cloud instance where user pictures are stored (3), a toggle button to show or turn off notifications (4) and another toggle button to enable or disable dark mode (5).</li>
        <li>Clicking on the settings icon again or clicking anywhere outside of the settings dropdown (1) should close it.</li>
    </ul>
</div>

<div role="tabpanel" class="tab-pane" id="settingsDropdownFields">
    <ol>
        <li>Settings dropdown</li>
        <li>Privacy policy link</li>
        <li>Pictures storage link</li>
        <li>Show notifications toggle button</li>
        <li>Dark mode toggle button</li>
    </ol>
</div>

</div>



### 5.2. Dashboard - Notifications dropdown

{% include image.html file="dashboard_notifications_dropdown.jpg" alt="Sign in screenshot" caption="Notifications dropdown" %}

<ul id="notificationsDropdownTabs" class="nav nav-tabs">
    <li class="active"><a href="#notificationsDropdownDetails" data-toggle="tab">Details</a></li>
    <li><a href="#notificationsDropdownFields" data-toggle="tab">Sections/Fields</a></li>
</ul>

<div class="tab-content">

<div role="tabpanel" class="tab-pane active" id="notificationsDropdownDetails">
    <ul>
        <li>This dropdown menu is displayed when users click on the notifications (bell) icon.</li>
        <li>The notifications to be shown should sorted by date/time (most recent ones at the top) and unread notifications should be highlighted (a badge with unread notifications count should also be displayed before clicking on the notifications icon). </li>
        <li>The nature of these notifications remains to be decided, although they should be relevant enough to not be spammy.</li>
        <li>Clicking on the notifications icon again or clicking anywhere outside of the notifications dropdown (1) should close it.</li>
    </ul>
</div>

<div role="tabpanel" class="tab-pane" id="notificationsDropdownFields">
    <ol>
        <li>Notifications dropdown</li>
    </ol>
</div>

</div>



### 5.3. Dashboard - Account dropdown

{% include image.html file="dashboard_account_dropdown.jpg" alt="Sign in screenshot" caption="Account dropdown" %}

<ul id="accountDropdownTabs" class="nav nav-tabs">
    <li class="active"><a href="#accountDropdownDetails" data-toggle="tab">Details</a></li>
    <li><a href="#accountDropdownFields" data-toggle="tab">Sections/Fields</a></li>
</ul>

<div class="tab-content">

<div role="tabpanel" class="tab-pane active" id="accountDropdownDetails">
    <ul>
        <li>This dropdown menu is displayed when users click on the small chevron (arrow) down at the right of the current user’s name.</li>
        <li>It should contain two links: “My account” (2) brings users to the My account page (see section 6 for more details) and “Logout” (3) ends the current session and redirects users to the Sign in page (see section 2).</li>
        <li>Clicking on the small chevron down again or clicking anywhere outside of the account dropdown (1) should close it.</li>
    </ul>
</div>

<div role="tabpanel" class="tab-pane" id="accountDropdownFields">
    <ol>
        <li>Account dropdown</li>
        <li>My account link</li>
        <li>Logout link</li>
    </ol>
</div>

</div>

## 6. My Account

{% include image.html file="my_account.jpg" alt="Sign in screenshot" caption="My account page" %}
{% include image.html file="my_account_success_message.jpg" alt="Sign in screenshot" caption="My account success feedback message" %}
{% include image.html file="my_account_error_message.jpg" alt="Sign in screenshot" caption="My account error feedback message" %}

<ul id="myAccountTabs" class="nav nav-tabs">
    <li class="active"><a href="#myAccountDetails" data-toggle="tab">Details</a></li>
    <li><a href="#myAccountFields" data-toggle="tab">Sections/Fields</a></li>
</ul>

<div class="tab-content">

<div role="tabpanel" class="tab-pane active" id="myAccountDetails">
    <ul>
        <li>This page should display the current user’s information and allow modifications.</li>
        <li>At the top of the account container (1), users should see their account’s profile picture (which can be changed by clicking on it), their first_name and last_name in the title and their user_role below their names. The user_role cannot be directly modified by the current user, an admin or another suitable user should do it for them.</li>
        <li>Any changes made to the current user’s account details should be saved (by clicking on the “Save changes” button (8)) to persist in the database, which should then bring users to the dashboard page and display a feedback message, as shown in the previous pictures. Before that, the current user must confirm their password in the “Confirm password” input field (6).</li>
        <li>The restore button (7) should overwrite all input fields with their respective initial states.</li>
        <li>See section 7.1 for more details regarding validation of input fields.</li>
    </ul>
</div>

<div role="tabpanel" class="tab-pane" id="myAccountFields">
    <ol>
        <li>Account container</li>
        <li>user_name input field <span class="label label-warning">required</span></li>
        <li>user_email input field <span class="label label-warning">required</span></li>
        <li>first_name input field <span class="label label-warning">required</span></li>
        <li>user_password input field <span class="label label-warning">required</span></li>
        <li>Confirm password input field <span class="label label-warning">required</span></li>
        <li>Restore all fields button</li>
        <li>Save changes button</li>
    </ol>
</div>

</div>

## 7. Databases

{% include image.html file="databases.png" alt="Sign in screenshot" caption="Databases page" %}

<ul id="databasesTabs" class="nav nav-tabs">
    <li class="active"><a href="#databasesDetails" data-toggle="tab">Details</a></li>
    <li><a href="#databasesFields" data-toggle="tab">Sections/Fields</a></li>
</ul>

<div class="tab-content">

<div role="tabpanel" class="tab-pane active" id="databasesDetails">
    <ul>
        <li>The databases page should show all tables contained in each database (highlighted by (3)), with timestamps for created at and last updated dates.</li>
        <li>When users select a row in the tables section, a new section should pop up at the right (4), showing all entries of the table selected. If no row in the latter is selected, the “edit” and “delete” buttons should remain inactive.</li>
        <li>The search input fields (1, 2, 5) let users look for a specific database, table or entry, respectively. As they type, the respective table should automatically display only relevant results. Clearing a field should restore the respective table to show all records.</li>
        <li>The “add” button (6) allows users to create new entries in the selected table and the “edit” (7) and “delete” (8) buttons enable modification of the selected entry. See 6.1. (Add entry modal), 6.2. (Edit entry modal) and 6.3. (Delete entry modal) for more details.</li>
        <li>All other UI elements not outlined in the previous picture have already been covered.</li>
    </ul>
</div>

<div role="tabpanel" class="tab-pane" id="databasesFields">
    <ol>
        <li>Search for a database input</li>
        <li>Search for a table input</li>
        <li>Tables section</li>
        <li>Entries section</li>
        <li>Search for an entry input</li>
        <li>Add new entry button</li>
        <li>Edit selected entry button</li>
        <li>Delete selected entry button</li>
    </ol>
</div>
</div>


### 7.1. Databases - Add entry modal

{% include image.html file="databases_add_entry_modal.png" alt="Sign in screenshot" caption="Add entry modal" %}

<ul id="addEntryModalTabs" class="nav nav-tabs">
    <li class="active"><a href="#addEntryModalDetails" data-toggle="tab">Details</a></li>
    <li><a href="#addEntryModalFields" data-toggle="tab">Sections/Fields</a></li>
</ul>

<div class="tab-content">

<div role="tabpanel" class="tab-pane active" id="addEntryModalDetails">
    <ul>
        <li>The add entry modal should pop up when users click on the “add” button from the databases page.</li>
        <li>When users click on the “cancel” button (7) or when they click outside of this modal, it should close.</li>
        <li>When users click on the “clear” button (9), all input fields should be cleared.</li>
        <li>Fields marked with (*) are required. A validation tooltip should appear when an input field is invalid.</li>
        <li>The “add” button (8) should be disabled as long as at least one field is invalid or empty. If all fields are valid, it should turn active. Clicking on it should add a new entry to the selected table, close the modal and display a feedback message at the top of the window.</li>
        <li><b>TODO:</b> Add error handling.</li>
    </ul>
</div>

<div role="tabpanel" class="tab-pane" id="addEntryModalFields">
    <ol>
        <li>user_name input field <span class="label label-warning">required</span></li>
        <li>user_email input field <span class="label label-warning">required</span></li>
        <li>user_password input field <span class="label label-warning">required</span></li>
        <li>first_name input field <span class="label label-warning">required</span></li>
        <li>last_name input field</li>
        <li>user_role dropdown <span class="label label-warning">required</span></li>
        <li>Cancel add entry button</li>
        <li>Add entry button</li>
        <li>Clear all fields button</li>
    </ol>
</div>
</div>

<p><b>Note:</b> The users table was only shown as an example here. The same concepts apply to all other tables.</p> 


### 7.2. Databases - Edit entry modal

{% include image.html file="databases_edit_entry_modal.png" alt="Sign in screenshot" caption="Edit entry modal" %}

<ul id="editEntryModalTabs" class="nav nav-tabs">
    <li class="active"><a href="#editEntryModalDetails" data-toggle="tab">Details</a></li>
    <li><a href="#editEntryModalFields" data-toggle="tab">Sections/Fields</a></li>
</ul>

<div class="tab-content">

<div role="tabpanel" class="tab-pane active" id="editEntryModalDetails">
    <ul>
        <li>The edit entry modal should pop up when users click on the “edit” button from the databases page.</li>
        <li>When users click on the “restore” button (3), all input fields should be overwritten with their respective initial values.</li>
        <li>The “edit” button (2) should be disabled as long as at least one field is invalid or empty. If all fields are valid, it should turn active. Clicking on it should edit the selected entry of the current table, close the modal and display a feedback message at the top of the window.</li>
        <li>Every other UI element not mentioned here works in the same way as 6.1.</li>
    </ul>
</div>

<div role="tabpanel" class="tab-pane" id="editEntryModalFields">
    <ol>
        <li>Cancel edit entry button</li>
        <li>Edit entry button</li>
        <li>Restore all fields button</li>
    </ol>
</div>
</div>

### 7.3. Databases - Delete entry modal

{% include image.html file="databases_delete_entry_modal.png" alt="Sign in screenshot" caption="Delete entry modal" %}

<ul id="deleteEntryModalTabs" class="nav nav-tabs">
    <li class="active"><a href="#deleteEntryModalDetails" data-toggle="tab">Details</a></li>
    <li><a href="#deleteEntryModalFields" data-toggle="tab">Sections/Fields</a></li>
</ul>

<div class="tab-content">

<div role="tabpanel" class="tab-pane active" id="deleteEntryModalDetails">
    <ul>
        <li>The delete entry modal should pop up when users click on the “delete” button from the databases page.</li>
        <li>The “cancel” button (1) should close the modal and the “confirm” (2) button should delete the selected entry from the table, close the modal and then display a feedback message at the top of the window.</li>
        <li>In this modal all fields should be read-only, since there is no need to modify any of them.</li>
    </ul>
</div>

<div role="tabpanel" class="tab-pane" id="deleteEntryModalFields">
    <ol>
        <li>Cancel delete entry button</li>
        <li>Confirm delete entry button</li>
    </ol>
</div>
</div>


## 8. Traffic

{% include image.html file="traffic.png" alt="Sign in screenshot" caption="Traffic page" %}

<ul id="trafficTabs" class="nav nav-tabs">
    <li class="active"><a href="#trafficDetails" data-toggle="tab">Details</a></li>
    <li><a href="#trafficFields" data-toggle="tab">Sections/Fields</a></li>
</ul>

<div class="tab-content">

<div role="tabpanel" class="tab-pane active" id="trafficDetails">
    <ul>
        <li>The traffic page should show relevant data regarding usage of the Hairdressing application. </li>
        <li>The first section (1) should display the number of times that the application has been browsed so far. The total views could optionally count only unique users.</li>
        <li>The second section (2) should present a graph that summarises user activity in the Hairdressing application by date, which could distinguish registered users from anonymous ones.</li>
        <li>Ideally, a well-supported JavaScript library would be used to handle data visualisation for this page, so that users would be able to hover or click on specific points in the graph to see more details about the corresponding dates.</li>
        <li>All other UI elements not outlined in the previous picture have already been covered.</li>
    </ul>
</div>

<div role="tabpanel" class="tab-pane" id="trafficFields">
    <ol>
        <li>Total views data</li>
        <li>User activity data</li>
    </ol>
</div>

</div>



## 9. Permissions

{% include image.html file="permissions.png" alt="Sign in screenshot" caption="permissions page" %}

<ul id="permissionsTabs" class="nav nav-tabs">
    <li class="active"><a href="#permissionsDetails" data-toggle="tab">Details</a></li>
    <li><a href="#permissionsFields" data-toggle="tab">Sections/Fields</a></li>
</ul>

<div class="tab-content">

<div role="tabpanel" class="tab-pane active" id="permissionsDetails">
    <ul>
        <li>The permissions page allows admins to change the role of any registered user. As such, it can only be viewed by users with “admin” as their user_role</li>
        <li>The main section of the page (1) shows all entries of the “users” table. If there is no entry currently selected, the “change user_role to” button (2) should be disabled.</li>
        <li>Once a user is selected, clicking on the “change user_role to” button (2) should open a small drop-right with all the available user roles as radio buttons (3).</li>
        <li>After a user role is chosen, the “users” table should be automatically updated. A feedback message should be displayed at the top of the page.</li>
        <li>All other UI elements not outlined in the previous picture have already been covered.</li>
    </ul>
</div>

<div role="tabpanel" class="tab-pane" id="permissionsFields">
    <ol>
        <li>Users table (main section)</li>
        <li>Change user_role to button </li>
        <li>User role drop-right</li>
    </ol>
</div>

</div>


## 10. Pictures

{% include image.html file="pictures.png" alt="Sign in screenshot" caption="pictures page" %}

<ul id="picturesTabs" class="nav nav-tabs">
    <li class="active"><a href="#picturesDetails" data-toggle="tab">Details</a></li>
    <li><a href="#picturesFields" data-toggle="tab">Sections/Fields</a></li>
</ul>

<div class="tab-content">

<div role="tabpanel" class="tab-pane active" id="picturesDetails">
    <ul>
        <li>The pictures page should display user-submitted pictures from the Hairdressing application. Those pictures are not present in the databases, they are stored in a separate cloud instance (possibly AWS S3), which is why this page is needed.</li>
        <li>The main section of this page (1) should show all pictures available in the cloud storage in a table, sorted by user/user id.</li>
        <li>Double-clicking on a row should bring users to the URL where pictures submitted by that particular user is stored in the cloud.</li>
        <li>Note: See the project specification document for more info about how pictures are handled in this project.</li>
        <li>All other UI elements not outlined in the previous picture have already been covered.</li>
    </ul>
</div>

<div role="tabpanel" class="tab-pane" id="picturesFields">
    <ol>
        <li>Pictures uploaded (main section)</li>
    </ol>
</div>

</div>



# officehours

## Authors
* William Smith 
* Jhalak Gurung
* Robert Spark
* Gera Groshev

## Purpose
* officehours is an app that links learners and tutors in a social environment.
	It combines a virtual shared whiteboard, with features such as image import 
	and editing, and chat, with a social networking page that allows users to 
	search for existing groups in any number of subjects, or create one if it 
	doesn’t exist. Within these groups, users and content creators can post tutorial
	links, ask questions in a q&a forum, or request one on one tutoring from a 
	friend or a highly rated content creator. Content creators are ranked and 
	reviewed by the users.

## Features
* Shared whiteboard
* Importing photos and documents into whiteboard.
* Whiteboard view chatroom.
* Group creation and search.
* Group Q&A forum.
* Search by subject matter
* Auto ranking of content creators.
* Profile list sorted by rank
* “Available” UI for profile widget (blue if available, else red)
* Recommendation feature for users to rate private tutoring sessions.
* Youtube API integration for posting videos in group forums

## Control Flow
* Users are initially presented with the OAuth page, where new users will 
	create accounts using Facebook or Twitter accounts.

* After login, the user will be presented with the main page, which is a Tab 
	View Controller. The default tab in view will be the Explorer View, which 
	inherits from Collection View Controller. The Explorer View will contain a 
	listing of the most commonly searched for subject matters (Math, Computer 
	Science, English), in the case of the new user, along with a ranking of the 
	top tutors in each area. For a returning user, the explorer view will be 
	populated with suggested groups. These group suggestions will be created 
	based on commonly clustered group memberships among existing users.

* Other tabs will include Search View and Dashboard View. 

* Search View: In search view, the user can search interests to find groups 
	and tutors, as well as search content creators by profile name, or even their 
	friends. The search page will populate results based on the search query, in a 
	table view. The table View Cells will be populated with group widgets, or 
	profile widgets. Profile widgets will be greyed out if the user is not online, 
	green if the user is online and available, and red if the user is online and 
	in a closed tutoring session. From the search results, users can request 
	tutoring sessions from tutors, or join open groups. If the user joins a 
	tutoring session, then the app will segue to the digital whiteboard. If the 
	user selects a group, the group will be saved to the user’s dashboard account, 
	and the user will be notified.

* Dashboard View: In the Dashboard view, the user can edit profile settings, 
	such as username, “content creator” boolean (yes if the user is a content 
	creator), and topics about which the user is knowledgeable (like on Quora). 
	Additionally, the page will be populated with all of the groups for which the 
	user is a member. If the user selects a group, the app will segue to the group 
	page. The group page contents will contain content posted by member of the 
	group, and a list of group members and content creators in that group category.

* Whiteboard View: Whiteboard view will be entered upon two or more parties 
	agreeing to a tutoring session, either from the Explorer View or a Group View. 
	Whiteboard View will contain a blank canvas with the ability for the user to 
	write directly. The user will be able to import photos to be displayed onto the 
	canvas for editing, as well as chat with other users in the whiteboard session.

## Implementation
### Model
* userProfile (contains name, email address, list of group memberships, 
	list of knowledge subjects), as well as globalProfileList (dictionary 
	of username -> online)

* groupData (contains names of all members, group purpose, dictionary of 
	content), as well as globalGroupList

### View
* LoginView
* ExplorerView
* GroupView
* WhiteboardView
* DashboardView
* SearchView

### Controller
* LoginViewController
* ExplorerViewController
* GroupViewController
* WhiteboardViewController
* DashboardViewController
* SearchViewController




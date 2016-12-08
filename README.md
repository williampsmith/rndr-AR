# RNDR

## Authors
* William Smith
* Jhalak Gurung
* Robert Spark
* Gera Groshev

## Purpose
* RNDR is an augmented social network. It allows users to post images and text
	that are bound to a location. Other users can see these posts, but only if
	they are close enough in proximity to the bound location of the post! This
	thereby encourages users to physically explore their area! As an advanced
	feature, RNDR supports Augmented Reality, allowing posts to be as 3D objects
	embedded in the camera view, however support for this is currently limited.

	[Frontend Demo Link](https://youtu.be/R-x-eO138Xw) | 
	[Augmented Reality Demo Link](https://youtu.be/b8fywEQZPy4)

## Features
* Discovery view for viewing posts nearby.
* Map view for navigating to post locations.
* Post view for creating posts.
* Supports text and images currently.
* Markers on map view pinned to post location.
* Colored coded proximity tracking as a visual indicator of distance to a post.
* Limited Augmented Reality View in iOS Camera against static image targets.
* Augmented Reality view currently does not support dynamic post creation.

## Control Flow
* Users are initially presented with the CreateView, where they can create a new
	post. This is embedded in a Tab Bar Controller. The user can choose from
	selecting a photo from their camera roll and/or posting text in a text box.

* The user can then optionally create a post here and post it, or switch to
	another tab. Other tabs include ExploreView and StatusView.

* ExploreView presents the user with a Google Maps view centered around their
	location. This view generates an icon for the user's current location, and
	markers for the locations of all nearby posts.

* StatusView shows a TableView containing data of nearby posts. The user is
	limited to metadata about the post, such as the author, and current distance
	from the post origin, until the user becomes close enough to the post origin.
	The distance to the post origin is indicated by a color code in the cell,
	which ranges from light blue (cold), indicating far distances, to dark red
	(hot), indicating the user is very close and the content is viewable. Once the
	content is viewable, the user can select the cell and segue to a PostView.

* ARView shows a camera view, which is connected to a Vuforia backend with
	image recognition capabilities and Unity 3D rendering. When the view of the
	camera is placed over an object in the real world which the backend recognizes
	as a post target, the associated post is shown in 3D, rendered in the camera
	view.

## Implementation
### Model
* Post Class -- encapsulates all post information, including author, location,
	text, image URL, and post type. Persists in a Firebase Database, which is
	accessed by a RESTful API implemented in Node.JS and hosted on Heroku.

* Target/ Object Data -- For the Augmented Reality View. Contains all pertinent
	data for the 3D objects to be rendered, and the targets for image recognition.
	Persists in the Vuforia provided database, and accessed directly from the
	mobile client, as well as through a RESTful API implemented in Flask and
	hosted on Google App Engine.

* DataManager Class -- Object that handles data retrieval from the databases.

### View
* ExploreView
* StatusView
* CreateView
* ViewPostView

### Controller
* ExploreViewController
* StatusViewController
* CreateViewController
* ViewPostViewController

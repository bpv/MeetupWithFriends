# MeetupWithFriends
Find convenient places to meetup with friends on iOS.

## Functionality
The application helps users find convenient places to meet up with friends.

1. Sign in/Create Account
2. Choose an activity
3. Find a Place on Map
  * Map will search around user's current location for nearby places for the chosen 
  activity. If user's location is not available, it will search around Udacity's HQ.
  * Long-pressing on the map will drop a marker and search for places around the marker.
  * Use the search button to jump to another location and search around that location.
4. Pick A Place
  * Cards will come up with details about each nearby place. Swipe left/right to 
  view more cards.
  * Pressing the share button will bring up a UIActivityController.  Successfully
  sharing the place will add the place to the *History* tab.
5. History
  * Table view with places that have been shared.
  * Clicking the map button will open the location in Google Maps if available 
  and Apple Maps if not available.

## Libraries
This application leverages the following libraries:
* AlamoFire
* SwiftyJSON
* Google Maps SDK
* Google Places SDK
* Firebase
* iCarousel

## Installation
[CocoaPods](https://guides.cocoapods.org/using/getting-started.html) is used to install/manage dependencies.

1. Download/Clone this repo.
2. Install dependencies using: `pod install`

## Configuration
Now that the code and dependenices have been installed, we now need to configure the app to use your Firebase, Google and Facebook keys.

### Firebase
1. Go to: https://firebase.google.com/docs/ios/setup#add_firebase_to_your_app
2. Follow the instructions in the section "Add Firebase to your app".  The other steps have already been implemented.

### Google Sign-in
1. Enable Google Sign-In in the Firebase console:
   1. In the [Firebase console](https://console.firebase.google.com), open the **Auth** section.
   2. On the **Sign in method tab**, enable the **Google** sign-in method and click **Save**.
2. Add cutom URL schemes to your project:
   1. Go to: https://firebase.google.com/docs/auth/ios/google-signin#2_implement_google_sign-in
   2. Scroll down to the section: "2. Implement Google Sign-in"
   3. Follow the instructions in subsection "1 Add custom URL schemes to your Xcode project:".  The other steps have already been implemented.

### Facebook Login
1. Go to: https://firebase.google.com/docs/auth/ios/facebook-login
2. Follow the instructions in "Before you begin".  The other steps have already been implemented.


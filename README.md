# SoCal Locations

SoCal Locations is an iOS app designed to help users discover, explore, and share interesting locations in Southern California. The app provides an interactive map and list view of various locations, allowing users to filter, search, and contribute their own discoveries.

## Features

- **Interactive Map**: Explore locations on an interactive map with custom annotations.
- **List View**: View locations in a scrollable list format.
- **Search Functionality**: Quickly find locations by name or description.
- **Filtering System**: Filter locations by tags such as "View", "Food", "Hike", and more.
- **User Contributions**: Add new locations with custom details and images.
- **Favorites**: Mark and easily access your favorite locations.
- **Detailed Location View**: Get comprehensive information about each location, including address, coordinates, and user-submitted details.
- **Firebase Integration**: Real-time data synchronization and storage.

## Screenshots

<table>
  <tr>
    <td><img src="https://via.placeholder.com/250" alt="Map View" /></td>
    <td><img src="https://via.placeholder.com/250" alt="List View" /></td>
    <td><img src="https://via.placeholder.com/250" alt="Location Details" /></td>
  </tr>
</table>

## Requirements

- iOS 15.0+
- Xcode 12.0+
- Swift 5.3+
- CocoaPods (for Firebase dependencies)

## Installation

1. Clone the repository:
   ```
   git clone https://github.com/yourusername/SoCalLocations.git
   ```
2. Navigate to the project directory:
   ```
   cd SoCalLocations
   ```
3. Install dependencies using CocoaPods:
   ```
   pod install
   ```
4. Open `SoCalLocations.xcworkspace` in Xcode.
5. Set up Firebase:
   - Create a new Firebase project
   - Add your iOS app to the Firebase project
   - Download the `GoogleService-Info.plist` file and add it to your Xcode project
6. Build and run the project on your iOS device or simulator.

## Usage

1. Upon first launch, the app will request location permissions. Grant these for the best experience.
2. Use the bottom tab bar to switch between Map View, List View, and Add Location.
3. In Map or List View, use the search bar to find specific locations.
4. Tap on the Filter button to refine the displayed locations by tags.
5. Tap on a location marker or list item to view detailed information.
6. In the Add Location view, you can contribute new locations to the app.

## License

SoCal Locations is released under the MIT License. See [LICENSE](LICENSE) for details.

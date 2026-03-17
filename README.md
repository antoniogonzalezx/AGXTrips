# AGXTrips

## About

This app displays a list of bus trips fetched from an [API](https://sandbox-giravolta-static.s3.eu-west-1.amazonaws.com/tech-test/trips.json). Users can select any trip to visualize its route on a map, view stop details, and submit issue reports through a contact form. The project follows Clean Architecture principles and uses SwiftUI with the modern **@Observable** macro.

## Screenshots

| Main screen | Trip selected | Stop detail | Home screen (with badge) |
|:-----------:|:-------------:|:-----------:|:-----------:|
| <img width="200" alt="mainscreen" src="https://github.com/user-attachments/assets/d25eb19d-e8cb-4f2d-9276-08a958b99897" /> | <img width="200" alt="mainscreen-selected" src="https://github.com/user-attachments/assets/483676bd-b253-402c-a6da-0430600ebe12" /> | <img width="200" alt="stopdetail" src="https://github.com/user-attachments/assets/08beced3-74d2-4d13-bfa2-13c5e9b4e9be" /> | <img width="200" alt="homescreen" src="https://github.com/user-attachments/assets/be247691-74c5-4e5a-9232-b4c3362e97a6" /> |

| Main screen (Dark mode) | Stop detail (Dark mode) | Report | Report sent |
|:------------------:|:------------------:|:------:|:-----------:|
| <img width="200" alt="mainscreendark" src="https://github.com/user-attachments/assets/2ea66538-9e69-4825-8d47-eaeb29c9dc6a" /> | <img width="200" alt="stopdetaildark" src="https://github.com/user-attachments/assets/fca2d266-0225-4f14-9d18-6a7c8bffd7fc" /> | <img width="200" alt="reportscreen" src="https://github.com/user-attachments/assets/a0fbb52c-a430-4940-9733-c11aa0b95628" /> | <img width="200" alt="reportsent" src="https://github.com/user-attachments/assets/60fa427b-afe3-47b6-9ec6-dced8128ce03" /> |


## Features

### Trip list & map (Task 1)
When you launch the app, you'll see a scrollable list of available trips along with an interactive map at the top. Each trip card shows the route description, driver name, schedule, and current status (ongoing, scheduled, finished, or cancelled). 

### Trip selection (Task 2)
Tapping a trip card highlights it and draws its route on the map using MapKit's native polyline rendering.
> I chose to use Apple's MapKit polylines with the coordinate points provided by the API rather than implementing Google's encoded polyline algorithm. This keeps the project dependency-free while still displaying accurate routes between stops.

### Stop details (Task 3)
When a trip is selected, its stops appear as markers on the map. Tapping any stop marker opens a detail sheet showing the passenger name, address, pickup time, price, and if it's paid or not.

### Contact form (Task 4)
There's a report button in the navigation bar that opens a form where users can submit issues. The form collects name, surname, email, phone (optional), and a message (limited to 200 characters). Basic validation ensures required fields are filled and the email contains an *"@"* symbol before enabling submission.

Reports are persisted locally using **SwiftData**, and the app badge updates to show the total number of submitted reports. As the app badge requires some permissions given, I also added a badge in the report button.

## Technical Decisions

### Architecture
The project follows Clean Architecture with clear separation between layers:
- **App**: Entry point and dependency injection via `DependencyFactory`
- **Domain**: Business entities and repository protocols
- **Data**: Network layer, API responses, mappers, and repository implementations
- **Presentation**: SwiftUI views and `@Observable` view models

### Stops Endpoint
The original stops endpoint from the challenge only returned a single stop, which wasn't enough to demonstrate the app's functionality properly. To work around this, I created a [GitHub Gist](https://gist.githubusercontent.com/antoniogonzalezx/dda06d3f4cc229e9ce936e5efcc28eab/raw/48aafbc0e2e79671ccc8a7e46b0cc0cf8c282e0c/stops.json) with additional mock stop data that matches the trip IDs from the trips endpoint.

### Technologies
- SwiftUI with `@Observable` macro
- MapKit for maps and polylines
- SwiftData for local persistence
- Swift Testing for unit tests
- Async/await for networking

### Testing
The test suite covers domain entities, view model logic, and form validation. Repository mocks enable isolated testing of the view models without network dependencies.

### Accessibility
All interactive elements include accessibility labels and hints. Trip cards announce their full details when selected, stop details are properly grouped for VoiceOver, and form fields have appropriate content type hints

## Running the project

1. Open `AGXTrips.xcodeproj` in Xcode 26+
2. Select a simulator or device running iOS 26+
3. Build and run (⌘ + R)
4. Build and test (⌘ + U)

## Project structure

```
AGXTrips/
├── App/
│   ├── AGXTripsApp.swift
│   └── DependencyFactory.swift
├── Domain/
│   ├── Entities/
│   │   ├── Trip.swift
│   │   ├── Stop.swift
│   │   ├── Coordinate.swift
│   │   ├── Report.swift
│   │   └── Mocks/
│   │       └── Mocks.swift
│   └── Repositories/
│       ├── TripRepository.swift
│       └── StopRepository.swift
├── Data/
│   ├── Network/
│   │   ├── APIClient.swift
│   │   ├── APIError.swift
│   │   ├── Endpoint.swift
│   │   └── Responses/
│   │       ├── TripResponse.swift
│   │       └── StopResponse.swift
│   ├── Repositories/
│   │   ├── TripRepositoryImpl.swift
│   │   └── StopRepositoryImpl.swift
│   └── Mappers/
│       ├── Trip+Response.swift
│       └── Stop+Response.swift
├── Presentation/
│   ├── TripListView.swift
│   ├── TripListViewModel.swift
│   ├── TripCardView.swift
│   ├── StopDetailView.swift
│   ├── ReportFormView.swift
│   └── ReportFormViewModel.swift
└── Resources/
    └── Assets.xcassets/
```

## Future Improvements

Given more time, here are some enhancements that could be made to the app:

- **Offline support**: Cache trips and stops locally so the app works without network connectivity.
- **Search and filtering**: Allow users to search trips by driver name, destination, or filter by status
- **Report management**: Add a screen to view previously submitted reports and their status instead of having only a badge with the report count.
- **UI tests**: Expand the test coverage to include UI tests for the main user flows.

## Author

Antonio González Valdepeñas
- antoniogonzalezvaldepenas@gmail.com
- [LinkedIn](https://linkedin.com/in/antoniogonzalezvaldepenas)
- [GitHub](https://github.com/antoniogonzalezx)


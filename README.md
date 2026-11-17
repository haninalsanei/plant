<p align="center">
  <img src="icon.png" width="120" alt="Planto app icon">
</p>

<h1 align="center">Planto</h1>

**Planto** is an iOS app that helps you keep your plants alive by tracking when each plant needs watering and reminding you on time.

## Features

- 🪴 Add your plants with their name, room, and watering schedule
- 💧 Track which plants need water today
- ✅ Mark plants as watered with a single tap
- 🔔 Get reminders when it's time to water

## Tech Stack

- **Language:** Swift
- **UI:** SwiftUI
- **Architecture:** MVVM (Model–View–ViewModel)
- **IDE:** Xcode

## Project Structure

```
plant/
├── app/                          # App entry point
├── models/                       # Data models (Plant, etc.)
├── ViewModels/                   # Business logic & state
├── Views/                        # SwiftUI screens and components
├── Services/                     # Helpers (e.g. notifications, storage)
├── Assets.xcassets/              # Colors, icons, and images
└── plant watering app.xcodeproj  # Xcode project
```

## Getting Started

### Requirements

- macOS with **Xcode** installed
- iOS Simulator or an iPhone

### Run the App

```bash
git clone https://github.com/haninalsanei/plant.git
cd plant
open "plant watering app.xcodeproj"
```

Then select a simulator or your device in Xcode and press **Run** (⌘R).

## Screenshots

<!-- Add screenshots of the app here, for example: -->
<!-- <img src="screenshots/home.png" width="250"> -->

## Author

**Hanin Alsanei** – [@haninalsanei](https://github.com/haninalsanei)

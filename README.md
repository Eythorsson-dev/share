# Share

A multiplatform (iOS + macOS) URL bookmark manager with iCloud sync via CloudKit.

## Project Structure

```
Share/
  App/
    ShareApp.swift          # SwiftUI App entry point
    ContentView.swift       # Main bookmarks view
  ShareExtension/
    ShareViewController.swift  # Share extension principal class
    Info.plist              # Extension configuration
  Resources/
    Assets.xcassets/        # App icons and accent color
Share.entitlements          # Main app entitlements (CloudKit + App Group)
ShareExtension.entitlements # Extension entitlements (App Group)
project.yml                 # XcodeGen project spec
```

## Prerequisites

- Xcode 15+
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`)

## Setup

### 1. Apple Developer Portal

Before building, complete these steps in the [Apple Developer Portal](https://developer.apple.com):

#### App Group
1. Go to **Certificates, Identifiers & Profiles** → **Identifiers**
2. Create a new App Group identifier: `group.dev.eythorsson.share`

#### CloudKit Container
1. Go to **CloudKit Console** (or Certificates → Identifiers → CloudKit Containers)
2. Create a new CloudKit container: `iCloud.dev.eythorsson.share`

#### App Identifiers
1. Create App ID `dev.eythorsson.share`:
   - Enable **iCloud** capability, select the CloudKit container above
   - Enable **App Groups** capability, select the app group above
2. Create App ID `dev.eythorsson.share.ShareExtension`:
   - Enable **App Groups** capability, select the app group above

### 2. Generate the Xcode Project

```bash
xcodegen generate
```

This produces `Share.xcodeproj` from `project.yml`.

### 3. CloudKit Record Schema

In the [CloudKit Console](https://icloud.developer.apple.com), create the following record type in the **Private Database**:

**Record Type: `Bookmark`**

| Field Name        | Type        |
|-------------------|-------------|
| `url`             | String      |
| `title`           | String      |
| `descriptionText` | String      |
| `thumbnailURL`    | String      |
| `faviconURL`      | String      |
| `domain`          | String      |
| `note`            | String      |
| `savedAt`         | Date/Time   |

### 4. Xcode Capabilities (if not signing automatically)

If using manual signing, verify in Xcode that both targets have:
- **Share** target: iCloud (CloudKit checked, container `iCloud.dev.eythorsson.share`) + App Groups (`group.dev.eythorsson.share`)
- **ShareExtension** target: App Groups (`group.dev.eythorsson.share`)

## Tech Stack

- **SwiftUI** — shared codebase for iOS and macOS
- **CloudKit** — private database, iCloud sync
- **App Groups** — shared container between main app and share extension

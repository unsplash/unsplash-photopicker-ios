# Unsplash Photo Picker for iOS

UnsplashPhotoPicker is an iOS UI component that allows you to integrate Unsplash in your app with just a few lines of code.

- [Description](#description)
- [Requirements](#requirements)
- [Installation](#installation)
  - [Carthage](#carthage)
  - [CocoaPods](#cocoapods)
  - [Git submodule](#git-submodule)
- [Usage](#usage)
  - [Configuration](#configuration)
  - [Presenting](#presenting)
  - [Using the results](#using-the-results)
- [License](#license)

## Description

UnsplashPhotoPicker is a view controller. You present it to offer your users to select one or multiple photos from Unsplash. Once they have selected photos, the view controller returns `UnsplashPhoto` objects that you can use in your app.

## Requirements

- iOS 11.0+
- Xcode 4.2+
- Swift 4.1+
- Unsplash API access key and secret key

⚠️ UnsplashPhotoPicker does not work with Objective-C.

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](https://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate UnsplashPhotoPicker into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "unsplash/unsplash-photopicker-ios" ~> 1.0
```

Run `carthage update` to build the framework and drag the built `UnsplashPhotoPicker.framework` into your Xcode project.

### CocoaPods

**_Will update once tested._**

### Git submodule

If you prefer not to use any of the aforementioned dependency managers, you can integrate UnsplashPhotoPicker into your project manually.

- Open up Terminal, `cd` into your top-level project directory, and run the following command **if** your project is not initialized as a git repository:

  ```bash
  $ git init
  ```

- Add UnsplashPhotoPicker as a git [submodule](https://git-scm.com/docs/git-submodule) by running the following command:

  ```bash
  $ git submodule add https://github.com/unsplash/unsplash-photopicker-ios.git
  ```

- Open the new `unsplash-photopicker-ios` folder, and drag the `UnsplashPhotoPicker.xcodeproj` file into the Project Navigator of your application's Xcode project.

    > It should appear nested underneath your application's blue project icon. Whether it is above or below all the other Xcode groups does not matter.

- Select the `UnsplashPhotoPicker.xcodeproj` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- You will see two different `UnsplashPhotoPicker.xcodeproj` folders each with two different versions of the `UnsplashPhotoPicker.framework` nested inside a `Products` folder.

    > It does not matter which `Products` folder you choose from, but it does matter whether you choose the top or bottom `UnsplashPhotoPicker.framework`.

- Select the `UnsplashPhotoPicker.framework` for iOS.
- And that's it!

  > The `UnsplashPhotoPicker.framework` is automatically added as a target dependency, linked framework and embedded framework in a copy files build phase which is all you need to build on the simulator and a device.

## Usage

❗️Before you get started, you need to register as a developer on our [Developer](https://unsplash.com/developers) portal. Once registered, create a new app to get and **Access Key** and a **Secret Key**.

### Configuration

The `UnsplashPhotoPicker` is configured with an instance of `UnsplashPhotoPickerConfiguration`:

```swift
UnsplashPhotoPickerConfiguration(accessKey: String,
                                 secretKey: String,
                                 allowsMultipleSelection: Bool,
                                 memoryCapacity: Int,
                                 diskCapacity: Int)
```
| Property                      | Type     | Optional/Required | Default |
|-------------------------------|----------|-------------------|---------|
| **`accessKey`**               | _String_ | Required          | N/A     |
| **`secretKey`**               | _String_ | Required          | N/A     |
| **`allowsMultipleSelection`** | _Bool_   | Optional          | `false` |
| **`memoryCapacity`**          | _Int_    | Optional          | `50`    |
| **`diskCapacity`**            | _Int_    | Optional          | `100`   |

### Presenting

`UnsplashPhotoPicker` is a subclass of `UINavigationController`. We recommend that you present it modally or as a popover on iPad. Before presenting it, you need to implement the `UnsplashPhotoPickerDelegate` protocol, and use the `photoPickerDelegate` property to get the results.

```swift
protocol UnsplashPhotoPickerDelegate: class {
  func unsplashPhotoPicker(_ photoPicker: UnsplashPhotoPicker, didSelectPhotos photos: [UnsplashPhoto])
  func unsplashPhotoPickerDidCancel(_ photoPicker: UnsplashPhotoPicker)
}
```

### Using the results


`UnsplashPhotoPicker` returns an array or `UnsplashPhoto` objects. See [UnsplashPhoto.swift](UnsplashPhotoPicker/UnsplashPhotoPicker/Classes/Models/UnsplashPhoto.swift) for more details.

## License

MIT License

Copyright (c) 2018 Unsplash Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
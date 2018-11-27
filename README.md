# Unsplash Photo Picker for iOS

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/UnsplashPhotoPicker.svg?style=flat-square)](https://cocoapods.org/pods/UnsplashPhotoPicker)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat-square)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/UnsplashPhotoPicker.svg?style=flat-square)](https://alamofire.github.io/Alamofire)
[![License](https://img.shields.io/github/license/unsplash/unsplash-photopicker-ios.svg?style=flat-square)](https://github.com/unsplash/unsplash-photopicker-ios)

UnsplashPhotoPicker is an iOS UI component that allows you to quickly search the Unsplash library for free high-quality photos with just a few lines of code.

Android coming soon.

![Unsplash Photo Picker for iOS preview](https://i.imgur.com/BtpxvAP.png "Unsplash Photo Picker for iOS")

## Table of Contents

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
- Xcode 10.0+
- Swift 4.2+
- [Unsplash API Access Key and Secret Key](https://unsplash.com/documentation#registering-your-application)

⚠️ UnsplashPhotoPicker is not compatible with Objective-C.

## Installation

### Carthage

To integrate UnsplashPhotoPicker into your Xcode project using [Carthage](https://github.com/Carthage/Carthage), specify it in your `Cartfile`:

```ogdl
github "unsplash/unsplash-photopicker-ios" ~> 1.0
```

Run `carthage update` to build the framework and drag the built `UnsplashPhotoPicker.framework` into your Xcode project.

### CocoaPods

To integrate UnsplashPhotoPicker into your Xcode project using [CocoaPods](https://cocoapods.org), specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'UnsplashPhotoPicker', '~> 1.0'
end
```

Then run `pod install`.

### Git submodule

If you prefer not to use any of the aforementioned dependency managers, you can integrate UnsplashPhotoPicker into your project manually as a [git submodule](https://git-scm.com/docs/git-submodule) by running the following command in the project's folder:

  ```bash
  $ git submodule add https://github.com/unsplash/unsplash-photopicker-ios.git
  ```

Drag the `UnsplashPhotoPicker.xcodeproj` file into your Xcode project, then drag the `UnsplashPhotoPicker.framework` to your target's "Embedded Binaries".

## Usage

❗️Before you get started, you need to register as a developer on our [Developer](https://unsplash.com/developers) portal. Once registered, create a new app to get an **Access Key** and a **Secret Key**.

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

`UnsplashPhotoPicker` returns an array of `UnsplashPhoto` objects. See [UnsplashPhoto.swift](UnsplashPhotoPicker/UnsplashPhotoPicker/Classes/Models/UnsplashPhoto.swift) for more details.

## License

MIT License

Copyright (c) 2018 Unsplash Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# APMCDemo

iOS and iPadOS app, minimum OS version is 16+
Architecture: MVVM-ish
Language: Swift 6 with async/await modern concurrency

## Assumptions

Both light and dark UI modes are supported.
Based on the wording of the Tech Excerisde, I did not add a full sceen video player. 
Video player is show on the Episode Details screen. In order to support both interface orientations I opted for a scroll view on this screen.
Video player has a placeholder image in case videoUrl cannot be constructed from the provided string. 
A loading indicator displayed while the video is buffering. 

# APMCCore

A Swift Package with some core functionality, such as:

## ApiClient

Contains classes for performing REST API requests. 
ApiClient protocol contains the shared base functionality and error handling.
ApiClient is implemented by MockyService that performs concrete API requests against https://run.mocky.io/ 

## Models

Video - a Decodable struct returned by MockyService, represents a video episode

## ViewModels

VMs for Episode List and Episode 

## Extensions

A few helper functions


# APMCDemoUIKit

## Managers

PlayerManager - a simple observer of AVPlayerItem state and rate changes, uses Combine to notify subscribers

## UI

Episode List & Episode Details ViewControllers. Uses UIKit & AVFoundation frameworks for the purpose of this demo, as well as Combine.

## Extensions

A few helper functions


# APMCDemoSwiftUI

TBD

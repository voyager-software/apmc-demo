# APMCDemo

iOS and iPadOS app, minimum OS version is 16+
Language: Swift 6 with async/await modern concurrency

<img src="http://github.com/user-attachments/assets/0c40e51d-5035-4346-8a8d-bb681ca7a8a3" width="240" />  <img src="http://github.com/user-attachments/assets/3516917e-4541-417f-b3b2-b43fcd949893" width="240" />



https://github.com/user-attachments/assets/34616bf0-fb85-49b5-8063-1081ac31cdde



## Assumptions

Both light and dark UI modes are supported.

Based on the wording of the Tech Excerisde, I did not add a full sceen video player. 
Video player is shown on the Episode Details screen. 

In order to support both interface orientations I opted for a scroll view on this screen.

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

## Managers

PlayerManager - a simple observer of AVPlayerItem state and rate changes, uses Combine to notify subscribers

## Extensions

A few helper functions


# APMCDemoUIKit

UIKit flavor of the app

## UI

Episode List & Episode Details ViewControllers. Uses UIKit & AVFoundation frameworks for the purpose of this demo, as well as Combine.

## Extensions

A few helper functions


# APMCDemoSwiftUI

SwiftUI flavor of the app

## UI

Episode List & Episode Details Views. Uses SwiftUI & AVFoundation frameworks for the purpose of this demo, as well as Combine.

## Extensions

A few helper functions


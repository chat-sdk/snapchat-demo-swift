## Building a Snapchat app using Chat SDK

Chat SDK is a versatile, open source instant messaging framework that can support multiple back ends including [Firebase](https://github.com/chat-sdk/chat-sdk-ios) and [XMPP](https://chatsdk.co/downloads/xmpp-chat-sdk-for-ios/).

In this tutorial I'm going to show you how to customize the Chat SDK to be able to send snapchat style disappearing messages. 

So why use Chat SDK? Well, Chat SDK just provides tools that make it much easier to get started with Firebase. It already includes a full registration and login system, it allows users to be searched for and has contacts. It includes a user select screen and user table cells. And obviously, it includes instant messaging. 

This means that you could build a great Snapchat like app in days rather than weeks or months. 

This project requires a number of steps:

1. Download the Chat SDK and add it to your project
2. Create a Snapchat style image capture screen and add it to the tab bar
3. Create a new message type for snaps which includes an auto delete feature
4. Replace the standard public and private thread screens with a new screen to display the available snaps

This repositiory includes the full source code for this tutorial so you can see the finished, working project. At each major step of the project I've created a new branch. This means that if you want you can follow along with the tutorial. 

### Branches

1. `part_1` The empty project with Chat SDK
 

### Part 1 - The basic setup

To get started you can clone `part_1` branch. This will provide you with an empty Xcode project with the Chat SDK already added. If you want more information about Chat SDK setup and configuration you should look at the [main project](https://github.com/chat-sdk/chat-sdk-ios).

All you need to do is run `pod install` to install the pods. After that you can run the project and verify that the Chat SDK is working as expected. 

### Part 2 - Creating a snap screen

First create a new view controller called `BTakeSnapViewController` in this view controller we're going to allow users to send new snaps. 

Next we need to add this screen to the Chat SDK. Open the App Delegate and add the following code:

```
let snapViewController = BSnapViewController.init(nibName: nil, bundle: nil)
BInterfaceManager.shared().a.addTabBarViewController(snapViewController, at: 2)
```

Here we are creating a new instance of our view controller and adding it as the central tab. 

To take the photo, we will be using the `TGCameraViewController`.

To do this, add this line to your `Podfile`: 

```
pod 'TGCameraViewController'
```
 
Then install by running: 

```
pod install
```

Add the following to your app's plist file:

```
<key>NSPhotoLibraryUsageDescription</key>
<string>Enable Photos access to import photos from your library.</string>
<key>NSCameraUsageDescription</key>
<string>Enable Camera to take photos.</string>
```


### Creating the snaps inbox

In this section we're going to make a view to display snaps that have been sent to us. We need a table view which will be populated by a list of snaps in date order. 

First make a new class called `BSnapsViewController` and a new XIB file with the same name. 

Click the XIB file and then click **File's Owner** in the left panel. In the right panel open the **identity inspector** and enter `BSnapsViewController` into the **Class** field. Here we are setting which controller will be responsible for the view. 

Now drag a new **Table View** into the view and constrain it to full size (i.e. with insets of zero). 

Now open the `BSnapsViewController` and add the class definition:

```
import Foundation
import ChatSDKCore
import ChatSDKUI

class BSnapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
}
```

Here we are implementing the table delegate and datasource. This will allow us to handle the table. 

Go back to the XIB file and right click and drag from the table view to the **File's Owner**. Connect the **delegate** and **datasource**. 

Now click on the **File's Owner** item on the left side of the screen. In the right panel open the **Connections Inspector** and drag the view connection onto the **View** item in the left side panel. 

Now we want to be able to access our `tableView` property from the controller so click the **Assistant Editor** button. This will show a split view allowing you to right click drag from the table view into your controller. When you release the mouse button you can type in the name of the new outlet - type `tableView`. This will create a new variable:

```
@IBOutlet weak var tableView: UITableView!
```

Now we need to go back to the controller and add the table delegate methods. 

```
override func viewDidLoad() {
    super.viewDidLoad()
}
    
public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

}

public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

}

public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
}
```

These are all the methods we need to control the table view. In order to achieve our goal we need to do the following:

1. Create a new array to store our snaps
2. Register the `BUserCell` with our table view
3. Populate the table delegate methods to create and display our cells

First create a new variable to hold the snaps:

```
var snaps = [BSnap]()
```

We use the `var` keyword because this will be a mutable array. 

Next register the user cell class. Add the following to `viewDidLoad`

```
tableView.register(BUserCell.self, forCellReuseIdentifier: "UserCell")
```

This will make it easy for us to use the user cell in the table. We are using the user cell because it will allow us to set the name and image of the user who sent the snap. 

Now add the following to the `numberOfRowsInSection` method:

```
return snaps.count
```

### The Snap View Controller

The snap view controller will allow us to view the snaps that we are being sent. The view will display the photo and a timer showing how long we have left to view it. 

We're going to create a new view controller using the same method as used before. So create the controller file and XIB called `BSnapViewController`.

As before, make sure that the view's owner is set to the correct controller and that the **File's Owner** is connected to the main view. 

Next add a label at the bottom of the screen. We'll make the label `100px` high and constrained to the bottom on and the sides of the screen. Make sure the text is centre aligned. This label will be used to show the countdown. I changed the font of the label to System Ultra Light size 35. 

Next add an image view above the label and constrain it on the left, right and top to the super view. On the bottom, constrain it to the label with a `0px` space. 

Then add an activity indicator and constrain it to the center of the screen. 

Now open the assistant view - `BSnapViewController`. First define the class then left click drag outlets from the label, image view and the activity indicator into the controller.  
```

import Foundation
import ChatSDKUI

class BSnapViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
}
```

When we create the view, we will pass in the link to the image that will be displayed. Then when the view loads, it will load the image into the image view. 

While the image is loading we will display the activity indicator. When the image load is complete, we will hide the activity indicator and show the image and the label. We will also start the countdown, when it finishes, the image will be deleted. 
















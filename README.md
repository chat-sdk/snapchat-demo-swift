## Building a Snapchat app using Chat SDK

Chat SDK is a versatile, open source instant messaging framework that can support multiple back ends including [Firebase](https://github.com/chat-sdk/chat-sdk-ios) and [XMPP](https://chatsdk.co/downloads/xmpp-chat-sdk-for-ios/).

In this tutorial I'm going to show you how to customize the Chat SDK to be able to send snapchat style disappearing messages. 

This project requires a number of steps:

1. Download the Chat SDK and add it to your project
2. Create a Snapchat style image capture screen and add it to the tab bar
3. Create a new message type for snaps which includes an auto delete feature
4. Replace the standard public and private thread screens with a new screen to display the available snaps

This repositiory includes the full source code for this tutorial so you can see the finished, working project. At each major step of the project I've created a new branch. This means that if you want you can follow along with the tutorial. 

### Branches

1. `part_1` The empty project with Chat SDK
 



SubBuddy

SubBuddy is an iOS application that helps users manage their subscriptions, track expenses, and monitor active services in one centralized place.
About the Project
Many users subscribe to multiple digital services such as YouTube, Netflix, Spotify and others. Over time it becomes difficult to track all active subscriptions and expenses. SubBuddy was developed to simplify subscription management by providing a single interface to organize and monitor subscriptions.

Users can:
view active subscriptions
add new subscriptions
stop active subscriptions
track subscription status
monitor spending

Main Features
User authentication (Firebase Authentication)
Email verification system
User profile management
Subscription management
Stop subscription functionality
Subscription status tracking (Active / Ending Soon)
Search subscriptions
Profile image upload (Firebase Storage)
Cloud database (Firebase Firestore)

Technologies
The project is built using the following technologies:
Swift
UIKit
SnapKit
MVVM Architecture
Firebase Authentication
Firebase Firestore
Firebase Storage

Architecture
The project follows the MVVM (Model-View-ViewModel) architecture pattern.

Main project folders:

Core
Models
Managers
Firebase
Features

Core
Shared components, extensions and constants.

Models
Application data models such as AppModel, Subscription, UserModel.

Managers
Managers responsible for handling business logic.

Firebase
Firebase service layer.

Features
Application screens and functional modules.

Main Screens
Onboarding
Sign In
Sign Up
Complete Profile
Overview
App Detail
Checkout
My Subscriptions
Profile

Requirements
To run the project you need:
Xcode
iOS 15+
Firebase configuration
Apple Developer account

Installation
Clone the repository
git clone <repo-link>
Open the project in Xcode
Add your GoogleService-Info.plist
Change Bundle Identifier
Run the project

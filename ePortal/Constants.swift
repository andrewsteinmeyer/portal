//
//  Constants.swift
//
//  Created by Andrew Steinmeyer on 4/23/15.
//  Copyright (c) 2015 Andrew Steinmeyer. All rights reserved.
//

import Foundation

struct Constants {
  
  // AWS Configuration
  struct AWS {
    
    // Cognito
    struct Cognito {
      static let RegionType = AWSRegionType.USEast1
      static let DefaultServiceRegionType = AWSRegionType.USEast1
      static let IdentityPoolId = "us-east-1:e40dbc7f-9b3c-4535-9145-52e5e797dcee"
      
      struct Provider {
        static let Twitter = "Twitter"
      }
    }
    
    // AWS Lambda
    struct Lambda {
      static let GetFirebaseToken = "generateFirebaseToken"
      static let GetOpentokSessionId = "generateOpentokSessionId"
      static let GetOpentokTokenForSessionId = "generateOpentokTokenForSessionId"
    }
    
    // AWS S3
    struct S3 {
      static let SaleImagesBucket = "eportal-sale-images"
    }
       
  }
  
  // Firebase Configuration
  struct Firebase {
    static let RootUrl = "https://eportal.firebaseio.com"
  }
  
  // OpenTok
  struct OpenTok {
    static let VideoCaptureDefaultInitialFrameRate: Double = 15
  }
  
  // Fastly CDN Cache
  struct Fastly {
    static let RootUrl = "http://cdn.eportal.com.global.prod.fastly.net/"
  }
  
  // TabBarItem Index
  static let DiscoverTabBarItemIndex = 0
  static let BroadcastTabBarItemIndex = 1
  
  // ViewControllers
  static let LoginVC = "LoginViewController"
  static let MainTabBarVC = "MainTabBarController"
  static let BroadcastVC = "BroadcastViewController"
  static let SaleOptionsVC = "SaleOptionsTableViewController"
  static let SubscribeOverlayVC = "SubscribeOverlayViewController"
  static let BroadcastOverlayVC = "BroadcastOverlayViewController"
  
  // Photo Album
  static let PhotoAlbumTitle = "Portal"
  
  // Discover Collection Settings
  struct DiscoverCollection {
    static let CellIdentifier = "DiscoverCollectionViewCell"
    static let HeaderViewIdentifier = "DiscoverCollectionViewHeaderView"
    static let HeaderViewHeight: CGFloat = 200
  }
  
  // SaleOption Settings
  struct SaleOption {
    static let ProductImageLimit = 5
    static let ProductViewCellIdentifier = "ProductViewCell"
  }
  
  // Detail Collection Settings
  struct DetailCollection {
    static let CellIdentifier = "DetailCollectionViewCell"
    static let HeaderViewIdentifier = "DetailCollectionViewHeaderView"
    static let SectionHeaderIdentifier = "DetailCollectionViewSectionHeader"
    static let HeaderViewHeight: CGFloat = 300
  }
  
  // Segues
  struct Segue {
    static let ImagePicker = "ImagePickerSegue"
    static let EditImage = "EditImageSegue"
    static let Subscribe = "SubscribeSegue"
    static let DetailCollection = "DetailCollection"
    static let OverlayPageControl = "OverlayPageControl"
  }
  
  // Notifications
  struct Notifications {
    static let BroadcastImageDidDownload = "BroadcastImageDidDownload"
    static let BroadcastQuantityDidUpdate = "BroadcastQuantityDidUpdate"
    static let BroadcastSubscriberCountDidUpdate = "BroadcastSubscriberCountDidUpdate"
    static let BroadcastDidReceiveMessage = "BroadcastDidReceiveMessage"
  }
  
}

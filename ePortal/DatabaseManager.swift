//
//  DatabaseManager.swift
//  ePortal
//
//  Created by Andrew Steinmeyer on 7/29/15.
//  Copyright (c) 2015 Andrew Steinmeyer. All rights reserved.
//

import Firebase

/*!
 * DatabaseManager handles calls out to Firebase for persistence
 */
final class DatabaseManager {
  
  private var _root: Firebase
  private var _userRef: Firebase?
  private var _loggedInUser: FBUser?
  private var _feeds: [String: String]
  private var _users: [String: String]
  private var _providerData: [String: String]?
  
  var root: Firebase {
    get {
      return _root
    }
  }
  
  var userId: String? {
    get {
        return _loggedInUser?.userId ?? nil
    }
  }
  
  private init() {
    // firebase root for database calls
    _root = Firebase(url: Constants.Firebase.RootUrl)
    
    _feeds = [:]
    _users = [:]
    
    // Auth handled via a global singleton. Prevents modules squashing each other
    FBAuth.watchAuthForRef(_root, withBlock: { [weak self]
      (error: NSError?, user: FAuthData?) in
    
      if let strongSelf = self {
        if (error != nil) {
          //TODO: handle firebase login failure
          //NSLog("AUTHENTICATION ERROR: %@", error!)
          //self.delegate.loginAttemptDidFail()
        } else {
          strongSelf.onAuthStatus(user)
        }
      }
    })
  }
  
  func cleanup() {
    for handle in _feeds {
      //TODO
      //print(handle)
    }
  }
  
  /*!
   * Request firebase token with AWS lambda function and login to firebase database.
   * Use AWS Identity Id to generate unique firebase token
   */
  func logInWithIdentityId(id: String, providerData data: [String: String]?, completionHandler: AWSContinuationBlock) {
    LambdaHandler.sharedInstance.generateFirebaseTokenWithId(id).continueWithBlock() {
      task in
      
      // get firebase token from lambda result and use it to log in
      let token = task.result as! String
      return self.logInWithToken(token, providerData: data)
      
    }.continueWithBlock(completionHandler)
  }
  
  /*!
   * Login to firebase with token that is generated by AWS lambda
   */
  func logInWithToken(token: String, providerData data: [String: String]?) -> AWSTask {
    // initialize user data given by provider
    self.populateProviderData(data)
    
    return FBAuth.loginRef(_root, withToken: token, providerData: data)
  }
  
  /*!
   * User logged back into app with AWS Cognito
   * Check to see if user is still authorized to access database
   */
  func resumeSessionWithCompletionHandler(id: String, providerData data: [String: String]?, completionHandler: AWSContinuationBlock) {
    if (self.isAuthenticated()) {
      // already have user, initialize user data given by provider
      self.populateProviderData(data)
      
      AWSTask(result: "resuming database session").continueWithBlock(completionHandler)
    }
    else {
     // tried to resume, but no longer authorized.
     self.logInWithIdentityId(id, providerData: data, completionHandler: completionHandler)
    }
  }
  
  /*!
   * Listen to firebase for the user's authorization status.
   * If authorized, create the user, save initial user data to firebase, and set up observers
   * When the user becomes unauthorized, clear the user and remove observers
   */
  func onAuthStatus(user: FAuthData?) {
    if let userData = user {
      // add userId given by firebase to data
      var initData: [String: String] = [ "userId": userData.uid ]
      if let providerData = _providerData {
        initData.unionInPlace(providerData)
      }
      
      // set firebase root path for user (root/users/uid)
      // TODO: not using userRef yet
      _userRef = _root.childByAppendingPath("users").childByAppendingPath(userData.uid)
      
      // populate user with updated information from Firebase and set up observers
      // callback block only gets called on first login
      _loggedInUser = FBUser.loadFromRoot(_root, withUserData: initData) {
        user in
        
        user.updateFromRoot(self._root)
        self._loggedInUser?.delegate = self
        //TODO: self.delegate.loginStateDidChange(user)
      }
    } else {
      // User is no longer logged in.  If we had one before, remove observers
      if (self._loggedInUser != nil) {
        self._loggedInUser!.stopObserving()
      }
      
      self._loggedInUser = nil
      //TODO: self.delegate.loginStateDidChange(nil)
    }
  }
  
  /*!
   * Check to see if user is authorized to access database
   */
  func isAuthenticated() -> Bool {
    return (_root.authData != nil ? true : false)
  }
  
  /*!
   * ClientManager provides the DatabaseManager with initial user data
   * The user data comes from the provider that is used to login via AWS Cognito (ie. Twitter)
   */
  func populateProviderData(data: [String:String]?) {
    if let data = data {
      _providerData = data
    }
  }
  
  /*!
   * Unauthorize the user's access to database
   */
  func logout() {
    if (self.isAuthenticated()) {
      print("logging out of firebase")
      FBAuth.logoutRef(self._root)
    }
    
  }
  
  //MARK: Singleton
  
  class var sharedInstance: DatabaseManager {
    struct SingletonWrapper {
      static let singleton = DatabaseManager()
    }
    return SingletonWrapper.singleton
  }
}

//MARK: FBUserDelegate

extension DatabaseManager: FBUserDelegate {
  
  func userDidUpdate(user: FBUser) {
    // Pass through to our delegate that a user was updated
    //TODO: self.delegate.userDidUpdate(user)
  }
  
}
//
//  BroadcastDetailViewController.swift
//  test
//
//  Created by Andrew Steinmeyer on 10/5/15.
//  Copyright © 2015 Andrew Steinmeyer. All rights reserved.
//

import UIKit

class BroadcastDetailViewController: UIViewController, UIScrollViewDelegate {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var container: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.container.layer.cornerRadius = 5
    
    // start scroll near bottom and limit how far up it can go
    self.scrollView.delegate = self
    self.scrollView.contentInset = UIEdgeInsets(top: 400, left: 0, bottom: 0, right: 0)
    self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 200)
  }
  
  
  // stop scrolling when at top
  func scrollViewDidScroll(scrollView: UIScrollView) {
    if scrollView.contentOffset.y > -1 {
      scrollView.contentOffset = CGPointZero
    }
  }
  

}

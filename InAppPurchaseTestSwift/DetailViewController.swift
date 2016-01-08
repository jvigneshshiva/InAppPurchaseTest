//
//  DetailViewController.swift
//  InAppPurchaseTestSwift
//
//  Created by Vignesh on 29/12/15.
//  Copyright © 2015 Vignesh. All rights reserved.
//


import UIKit

class DetailViewController: UIViewController {
  
  var image: UIImage? {
    didSet {
      configureView()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }
  
  @IBOutlet weak var imageView: UIImageView?
  
  func configureView() {
    imageView?.image = image
  }
  
}


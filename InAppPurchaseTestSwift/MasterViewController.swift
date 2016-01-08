//
//  MasterViewController.swift
//  InAppPurchaseTestSwift
//
//  Created by Vignesh on 29/12/15.
//  Copyright © 2015 Vignesh. All rights reserved.
//


import UIKit
import StoreKit

class MasterViewController: UITableViewController {
  
  // This list of available in-app purchases
  var products = [SKProduct]()
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  // priceFormatter is used to show proper, localized currency
  lazy var priceFormatter: NSNumberFormatter = {
    let pf = NSNumberFormatter()
    pf.formatterBehavior = .Behavior10_4
    pf.numberStyle = .CurrencyStyle
    return pf
    }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    validateReceipt()
    title = "In App Demo"
    
    // Set up a refresh control, call reload to start things up
    refreshControl = UIRefreshControl()
    refreshControl?.addTarget(self, action: "reload", forControlEvents: .ValueChanged)
    reload()
    refreshControl?.beginRefreshing()
    
    // Create a Restore Purchases button and hook it up to restoreTapped
    let restoreButton = UIBarButtonItem(title: "Restore", style: .Plain, target: self, action: "restoreTapped:")
    navigationItem.rightBarButtonItem = restoreButton
    
    // Subscribe to a notification that fires when a product is purchased.
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "productPurchased:", name: IAPHelperProductPurchasedNotification, object: nil)
  }
  
  
  // Fetch the products from iTunes connect, redisplay the table on successful completion
  func reload() {
    products = []
    tableView.reloadData()
    RageProducts.store.requestProductsWithCompletionHandler { success, products in
      if success {
        self.products = products
        self.tableView.reloadData()
      }
      self.refreshControl?.endRefreshing()
    }
  }
  
  // Restore purchases to this device.
  func restoreTapped(sender: AnyObject) {
    RageProducts.store.restoreCompletedTransactions()
  }
  
  // Purchase the product
  func buyButtonTapped(button: UIButton) {
    let product = products[button.tag]
    RageProducts.store.purchaseProduct(product)
  }
  
  // When a product is purchased, this notification fires, redraw the correct row
  func productPurchased(notification: NSNotification) {
    let productIdentifier = notification.object as! String
    for (index, product) in products.enumerate() {
      if product.productIdentifier == productIdentifier {
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Fade)
        break
      }
    }
  }
  
  // MARK: - Segues
  
  // Only transition if the product is purchased
  override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
    if identifier == "showDetail" {
      let shouldTransition: Bool
      if let indexPath = self.tableView.indexPathForSelectedRow {
        let product = products[indexPath.row]
        shouldTransition = RageProducts.store.isProductPurchased(product.productIdentifier)
      }
      else {
        shouldTransition = false
      }
      return shouldTransition
    }
    return true
  }
  
  // Load the purchased resource and launch the detail view
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showDetail" {
      if let indexPath = self.tableView.indexPathForSelectedRow {
        let content: String
        let product = products[indexPath.row]
        if let name = resourceNameForProductIdentifier(product.productIdentifier),
          detailViewController = segue.destinationViewController as? DetailViewController {
            let image = UIImage(named: name)
            detailViewController.image = image
        }
      }
    }
  }
  
  // MARK: - Table View
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return products.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
    
    let product = products[indexPath.row]
    cell.textLabel?.text = product.localizedTitle
    
    if RageProducts.store.isProductPurchased(product.productIdentifier) {
      cell.accessoryType = .Checkmark
      cell.accessoryView = nil
      cell.detailTextLabel?.text = ""
    }
    else if IAPHelper.canMakePayments() {
      priceFormatter.locale = product.priceLocale
      cell.detailTextLabel?.text = priceFormatter.stringFromNumber(product.price)
      
      var button = UIButton(frame: CGRect(x: 0, y: 0, width: 72, height: 37))
      button.setTitleColor(view.tintColor, forState: .Normal)
      button.setTitle("Buy", forState: .Normal)
      button.tag = indexPath.row
      button.addTarget(self, action: "buyButtonTapped:", forControlEvents: .TouchUpInside)
      cell.accessoryType = .None
      cell.accessoryView = button
    }
    else {
      cell.accessoryType = .None
      cell.accessoryView = nil
      cell.detailTextLabel?.text = "Not available"
    }
    return cell
  }
func validateReceipt() {
        
        let receiptData : NSData = NSData(contentsOfURL: NSBundle.mainBundle().appStoreReceiptURL!)!
        
        let receiptString: NSString = receiptData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        let storeURL : NSURL = NSURL(string: "http://verifyinapps.vshiva.com/")!
        
        let storeRequest : NSMutableURLRequest = NSMutableURLRequest(URL: storeURL)
        
        storeRequest.HTTPMethod = "POST"
        
        storeRequest.HTTPBody = receiptString.dataUsingEncoding(NSASCIIStringEncoding)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(storeRequest, completionHandler: {data, response, error -> Void in
            
            let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSDictionary
            
            if let parseJSON = json {
                
                print("Receipt \(parseJSON)")
                
            }
                
            else {
                
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                
                print("Receipt Error: \(jsonStr)")
                
            }
            
        })
        
        task.resume();
        
        
        
    }


}


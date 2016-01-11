//
//  RageIAPHelper.swift
//  InAppPurchaseTestSwift
//
//  Created by Vignesh on 29/12/15.
//  Copyright © 2015 Vignesh. All rights reserved.
//


import Foundation

// Use enum as a simple namespace.  (It has no cases so you can't instantiate it.)
public enum RageProducts {
  
  /// TODO:  Change this to whatever you set on iTunes connect
  private static let Prefix = "com.care.springboard."
  

  
  /// MARK: - Supported Product Identifiers
  public static let PurchasePackConsumable = Prefix + "PurchasePackConsumable"
  public static let PurchasePackSubcriptionTest          = Prefix + "PurchasePackSubcriptionTest"
  public static let FreeSubscriptionTest         = Prefix + "FreeSubscriptionTest"
  
  // All of the products assembled into a set of product identifiers.
  private static let productIdentifiers: Set<ProductIdentifier> = [RageProducts.PurchasePackConsumable,
                                                                   RageProducts.PurchasePackSubcriptionTest,
                                                                   RageProducts.FreeSubscriptionTest]
  
  /// Static instance of IAPHelper that for rage products.
  public static let store = IAPHelper(productIdentifiers: RageProducts.productIdentifiers)
}

/// Return the resourcename for the product identifier.
func resourceNameForProductIdentifier(productIdentifier: String) -> String? {
  return productIdentifier.componentsSeparatedByString(".").last
}
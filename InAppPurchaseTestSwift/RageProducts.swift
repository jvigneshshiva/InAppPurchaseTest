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
  private static let Prefix = "com.vignesh.InAppPurchaseTest."
  

  
  /// MARK: - Supported Product Identifiers
  public static let GirlfriendOfDrummer = Prefix + "PurchasePackTest"
  public static let iPhoneRage          = Prefix + "PurchasePackSubcriptionTest"
  public static let NightlyRage         = Prefix + "FreeSubscriptionTest"
  public static let Updog               = Prefix + "updog"
  
  // All of the products assembled into a set of product identifiers.
  private static let productIdentifiers: Set<ProductIdentifier> = [RageProducts.GirlfriendOfDrummer,
                                                                   RageProducts.iPhoneRage,
                                                                   RageProducts.NightlyRage,
                                                                   RageProducts.Updog]
  
  /// Static instance of IAPHelper that for rage products.
  public static let store = IAPHelper(productIdentifiers: RageProducts.productIdentifiers)
}

/// Return the resourcename for the product identifier.
func resourceNameForProductIdentifier(productIdentifier: String) -> String? {
  return productIdentifier.componentsSeparatedByString(".").last
}
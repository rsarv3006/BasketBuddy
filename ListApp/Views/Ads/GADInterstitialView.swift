//
//  GADInterstitialView.swift
//  BasketBuddy
//
//  Created by Robert J. Sarvis Jr on 4/12/23.
//

import SwiftUI
import GoogleMobileAds
import UIKit


final class Interstitial: NSObject, GADFullScreenContentDelegate {
    private var interstitial: GADInterstitialAd?
    
    override init() {
        super.init()
        loadInterstitial()
    }
    
    func loadInterstitial(){
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: getAdmobUnitId(variant: .Interstitial_Share_Create),
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self
        }
        )
    }
    
    func showAd(){
        if interstitial != nil {
            let root = UIApplication.shared.windows.first?.rootViewController
            if let root = root {
                interstitial?.present(fromRootViewController: root)
            }
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        loadInterstitial()
    }
    
}

//struct ContentView:View{
//    var interstitial:Interstitial
//
//    init(){
//        self.interstitial = Interstitial()
//    }
//
//    var body : some View{
//        Button(action: {self.interstitial.showAd()}){
//            Text("My Button")
//        }
//    }
//}

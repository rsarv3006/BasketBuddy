//
//  GADBannerView.swift
//  ListApp
//
//  Created by Robert J. Sarvis Jr on 2/27/23.
//

import GoogleMobileAds
import SwiftUI
import UIKit
import Appodeal

private struct AdBannerViewRepresentable: UIViewRepresentable {
    typealias UIViewType = APDBannerView
    
    func makeUIView(context: Context) -> APDBannerView {
        let bannerView = APDBannerView(size: kAPDAdSize320x50)
        bannerView.loadAd()
        return bannerView
    }
    
    func updateUIView(_ uiView: APDBannerView, context: Context) {}
}

private struct AdRectangleViewRepresentable: UIViewRepresentable {
    typealias UIViewType = APDBannerView
    
    func makeUIView(context: Context) -> APDBannerView {
        let bannerView = APDBannerView(size: kAPDAdSize300x250)
        bannerView.loadAd()
        return bannerView
    }
    
    func updateUIView(_ uiView: APDBannerView, context: Context) {}
}

struct AdBannerView: View {
    var body: some View {
        AdBannerViewRepresentable()
            .frame(height: 50)
    }
}

struct AdRectangleView: View {
    var body: some View {
        AdRectangleViewRepresentable()
            .frame(height: 250)
    }
}

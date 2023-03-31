//
//  ContactSupport.swift
//  BasketBuddy
//
//  Created by Robert J. Sarvis Jr on 3/28/23.
//

import SwiftUI

struct ContactSupport: View {
    var body: some View {
        Button("Contact Support", action: {
            let webCrawlerObfuscation = "@incoming.gitlab.com"
            let email = "contact-project+donutsahoy-listapp-32477383-issue-\(webCrawlerObfuscation)"
            let subject = "Support Request"
            
            let urlString = "mailto:\(email)?subject=\(subject)"
            let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        })
        .buttonStyle(.bordered)
        .padding(.top)
    }
}

struct ContactSupport_Previews: PreviewProvider {
    static var previews: some View {
        ContactSupport()
    }
}

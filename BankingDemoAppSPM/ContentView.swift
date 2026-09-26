//
//  ContentView.swift
//  BankingDemoAppSPM
//
//  Created by Anurag on 24/09/26.
//

import SwiftUI
import BankingNetworkKit

struct ContentView: View {
    var body: some View {
        VStack {
            Button("Test NetworkKit") {
                let client = BankingNetworkClient()
                client.testConnection()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

//
//  ContentView.swift
//  HeartBeatAnimation
//
//  Created by Sharan Thakur on 13/02/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            ZStack {
                switch colorScheme {
                case .light:
                    Color.white
                        .ignoresSafeArea()
                case .dark:
                    Color.black
                        .ignoresSafeArea()
                default:
                    Color.accentColor
                }
                
                HeartView()
            }
            .padding(.horizontal)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Heart Animation")
        }
    }
}

#Preview {
    ContentView()
}

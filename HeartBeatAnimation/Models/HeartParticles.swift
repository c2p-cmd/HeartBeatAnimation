//
//  HeartParticles.swift
//  HeartBeatAnimation
//
//  Created by Sharan Thakur on 13/02/24.
//

import SwiftUI

struct HeartParticle: Identifiable {
    let id = UUID()
}

struct BigHeartView: View {
    var body: some View {
        Image(systemName: "suit.heart.fill")
            .font(.system(size: 100))
    }
}

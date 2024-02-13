//
//  HeartView.swift
//  HeartBeatAnimation
//
//  Created by Sharan Thakur on 13/02/24.
//

import SwiftUI

// MARK: - Main HeartView
struct HeartView: View {
    // View Properties
    @State private var beatAnimation = false
    @State private var particles = [HeartParticle]()
    @State private var showPulses = false
    @State private var currentHeartRate = 84
    @State private var previousHeartRate = 77
    
    var body: some View {
        VStack {
            ZStack {
                if showPulses {
                    TimelineView(.animation(minimumInterval: 0.7, paused: false)) { timeline in
                        ZStack {
                            ForEach(particles) { _ in
                                PulseHeartView()
                            }
                        }
                        .onChange(of: timeline.date) {
                            if beatAnimation {
                                showPulses = true
                                addNewParticles()
                                
                                withAnimation(.bouncy) {
                                    previousHeartRate = currentHeartRate
                                    currentHeartRate = .random(in: 80...150)
                                }
                            }
                        }
                    }
                }
                
                BigHeartView()
                    .foregroundStyle(.pink.gradient)
                    .symbolEffect(
                        .bounce,
                        options: beatAnimation ? .repeating.speed(1) : .default,
                        value: beatAnimation
                    )
            }
            .frame(maxWidth: 350, maxHeight: 350)
            .overlay(alignment: .bottomLeading, content: textGroupView)
            .background(.bar, in: .rect(cornerRadius: 30, style: .continuous))
            
            Toggle("Animate", isOn: $beatAnimation)
                .fontWeight(.semibold)
                .fontDesign(.rounded)
                .padding(15)
                .frame(maxWidth: 350)
                .background(.bar, in: .rect(cornerRadius: 30, style: .continuous))
                .padding(.top, 20)
                .onChange(of: beatAnimation) {
                    if particles.isEmpty {
                        showPulses = true
                    }
                    
                    if beatAnimation {
                        addNewParticles()
                    }
                }
        }
    }
    
    @ViewBuilder
    func textGroupView() -> some View {
        VStack(alignment: .leading) {
            Text("Current")
                .font(.title3)
            
            HStack(alignment: .bottom, spacing: 6) {
                Text("\(currentHeartRate)")
                    .font(.system(size: 45))
                    .contentTransition(.numericText())
                
                Text("BPM")
                    .font(.callout)
                    .foregroundStyle(.pink.gradient)
            }
            
            Text("\(previousHeartRate) BPM, 1m ago")
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .fontWeight(.bold)
        .fontDesign(.rounded)
        .offset(x: 30, y: -35)
    }
    
    private func addNewParticles() {
        /// creating new particle
        let particle = HeartParticle()
        
        /// adding to array
        particles.append(particle)
        
        /// removing after 3 seconds
        executeAfter(deadline: 3) {
            particles.removeAll { $0.id == particle.id }
            
            if particles.isEmpty {
                showPulses = false
            }
        }
    }
    
    private func executeAfter(deadline: TimeInterval, execute: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + deadline, execute: execute)
    }
}

// MARK: - PulseHeartView for the pulsing background of the heart view
fileprivate struct PulseHeartView: View {
    @State private var startAnimating = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        BigHeartView()
            .foregroundStyle(.pink)
            .background {
                BigHeartView()
                    .foregroundStyle(foregroundColor)
                    .blur(radius: 5, opaque: false)
                    .scaleEffect(startAnimating ? 1.1 : 0)
                    .animation(.linear(duration: 1.5), value: startAnimating)
            }
            .scaleEffect(startAnimating ? 4 : 1)
            .opacity(startAnimating ? 0 : 0.7)
            .onAppear {
                withAnimation(.linear(duration: 3)) {
                    startAnimating = true
                }
            }
    }
     
    private var foregroundColor: some ShapeStyle {
        switch colorScheme {
        case .light:
            Color.gray
        case .dark:
            Color.black
        default:
            Color.accentColor
        }
    }
}


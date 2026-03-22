//
//  StatCircleCard.swift
//  StudyLock
//
//  Created by Emi Swinford on 3/21/26.
//


import SwiftUI

struct StatCircleCard: View {
    let title: String
    let valueText: String
    let subtitle: String
    let progress: Double
    let color: Color

    var body: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.15), lineWidth: 12)

                Circle()
                    .trim(from: 0, to: min(max(progress, 0), 1))
                    .stroke(color, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 2) {
                    Text(valueText)
                        .font(.title2.bold())
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 120, height: 120)

            Text(title)
                .font(.headline)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(18)
    }
}

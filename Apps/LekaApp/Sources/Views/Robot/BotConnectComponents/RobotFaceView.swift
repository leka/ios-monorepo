// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct RobotFaceView: View {

    @Binding var isSelected: Bool
    @Binding var isConnected: Bool
    @Binding var name: String

    @State private var rotation: CGFloat = 0.0

    var body: some View {
        VStack {
            DesignKitAsset.Images.robotFaceSimple.swiftUIImage
                .overlay(content: {
                    Circle()
                        .inset(by: -10)
                        .stroke(
                            DesignKitAsset.Colors.lekaGreen.swiftUIColor,
                            style: StrokeStyle(
                                lineWidth: 2,
                                lineCap: .butt,
                                lineJoin: .round,
                                dash: [12, 3])
                        )
                        .opacity(isSelected ? 1 : 0)
                        .rotationEffect(.degrees(rotation), anchor: .center)
                        .animation(Animation.linear(duration: 15).repeatForever(autoreverses: false), value: rotation)
                        .onAppear {
                            rotation = 360
                        }
                })
                .background(DesignKitAsset.Colors.lekaGreen.swiftUIColor, in: Circle().inset(by: isConnected ? -26 : 2))
                .padding(.bottom, 40)

            Text(name)
        }
        .animation(.default, value: isConnected)
    }
}

struct RobotFaceView_Previews: PreviewProvider {
    static var previews: some View {
        RobotFaceView(
            isSelected: .constant(true),
            isConnected: .constant(true),
            name: .constant("LKAL 007")
        )
    }
}

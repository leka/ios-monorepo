// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - BotFaceView

struct BotFaceView: View {
    // MARK: Internal

    @Binding var isSelected: Bool
    @Binding var isConnected: Bool
    @Binding var name: String
    @Binding var battery: Int
    @Binding var isCharging: Bool
    @Binding var osVersion: String

    var body: some View {
        VStack {
            Image("robot_connexion_bluetooth")
                .overlay(content: {
                    Circle()
                        .inset(by: -10)
                        .stroke(
                            Color(.green),
                            style: StrokeStyle(
                                lineWidth: 2,
                                lineCap: .butt,
                                lineJoin: .round,
                                dash: [12, 3]
                            )
                        )
                        .opacity(self.isSelected ? 1 : 0)
                        .rotationEffect(.degrees(self.rotation), anchor: .center)
                        .animation(Animation.linear(duration: 15).repeatForever(autoreverses: false), value: self.rotation)
                        .onAppear {
                            self.rotation = 360
                        }
                })
                .background(Color(.green), in: Circle().inset(by: self.isConnected ? -26 : 2))
                .padding(.bottom, 40)

            Text(self.name)

            Text("Battery level : \(self.battery)")

            Text("Charging Status : " + (self.isCharging ? "On" : "Off"))

            Text("OS Version : \(self.osVersion)")
        }
        .animation(.default, value: self.isConnected)
    }

    // MARK: Private

    @State private var rotation: CGFloat = 0.0
}

// MARK: - BotFaceView_Previews

struct BotFaceView_Previews: PreviewProvider {
    static var previews: some View {
        BotFaceView(
            isSelected: .constant(true),
            isConnected: .constant(true),
            name: .constant("LKAL 007"),
            battery: .constant(100),
            isCharging: .constant(true),
            osVersion: .constant("1.4.0")
        )
    }
}

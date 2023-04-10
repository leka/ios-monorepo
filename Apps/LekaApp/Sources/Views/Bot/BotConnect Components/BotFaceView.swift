//
//  BotFaceView.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 16/11/22.
//

import SwiftUI

struct BotFaceView: View {

    @Binding var isSelected: Bool
    @Binding var isConnected: Bool
    @Binding var name: String

    @State private var rotation: CGFloat = 0.0

    var body: some View {
        VStack {
            Image("robot_connexion_bluetooth")
                .overlay(content: {
                    Circle()
                        .inset(by: -10)
                        .stroke(
                            Color("lekaGreen"),
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
                .background(Color("lekaGreen"), in: Circle().inset(by: isConnected ? -26 : 2))
                .padding(.bottom, 40)

            Text(name)
        }
        .animation(.default, value: isConnected)
    }
}

struct BotFaceView_Previews: PreviewProvider {
    static var previews: some View {
        BotFaceView(isSelected: .constant(true), isConnected: .constant(true), name: .constant("LKAL 007"))
    }
}

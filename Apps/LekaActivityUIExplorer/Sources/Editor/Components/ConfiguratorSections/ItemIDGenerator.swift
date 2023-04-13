//
//  ItemIDGenerator.swift
//  LekaActivityEditor
//
//  Created by Mathieu Jeannot on 3/4/23.
//

import SwiftUI

struct ItemIDGenerator: View {

    //	@EnvironmentObject var configuration: GameLayoutTemplatesConfigurations
    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults

    @Binding var forID: UUID
    var label: String

    @State private var buttonRotation: Double = 0

    var body: some View {
        LabeledContent {
            HStack(spacing: 10) {
                Text("\(forID)")
                    .font(defaults.reg17)
                    .foregroundColor(Color("darkGray").opacity(0.5))
                    .padding(.horizontal, 10)
                    .frame(height: 34)
                    .frame(minWidth: 350, maxWidth: 500)
                    .background(Color("lekaLightGray"), in: RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray.opacity(0.2), lineWidth: 1)
                    )

                Button(
                    action: {
                        buttonRotation += 360
                        forID = UUID()
                    },
                    label: {
                        Circle()
                            .fill(.white)
                            .frame(width: 34, height: 34)
                            .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 0)
                            .overlay(
                                Image(systemName: "arrow.clockwise")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(Color("lekaSkyBlue"))
                                    .padding(8)
                                    .offset(y: -1)
                                    .rotationEffect(Angle(degrees: buttonRotation))
                                    .animation(.default, value: buttonRotation)
                            )
                    })
            }
            .frame(minWidth: 350, maxWidth: 500)
        } label: {
            Text(label)
                .foregroundColor(Color("lekaDarkGray"))
                .padding(.leading, 30)
        }
        .frame(minHeight: 35)
    }
}

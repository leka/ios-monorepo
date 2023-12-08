// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct BinaryChoiceToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.teal)

                .frame(width: 50, height: 30)
                .overlay(
                    Circle()
                        .foregroundColor(Color.white)
                        .padding(3)
                        .offset(x: configuration.isOn ? 10 : -10)
                )
                .onTapGesture {
                    withAnimation {
                        configuration.isOn.toggle()
                    }
                }
        }
        .frame(alignment: .center)
        .padding(0)
    }
}

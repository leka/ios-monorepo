// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import MarkdownUI
import SwiftUI

struct InstructionView: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults
    @Binding var text: String

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            markDownView
        }
        .safeAreaInset(edge: .top) {
            instructionTitle
        }
    }

    private var markDownView: some View {
        Markdown(text)
            .markdownTextStyle(textStyle: {
                FontProperties(family: .system(), size: 17)
                ForegroundColor(Color("darkGray"))
            })
            .padding(.horizontal, 40)
    }

    private var instructionTitle: some View {
        HStack {
            Spacer()
            Text("DESCRIPTION & INSTALLATION")
                .font(defaults.reg18)
                .foregroundColor(Color("darkGray").opacity(0.8))
                .padding(.vertical, 22)
            Spacer()
        }
        .padding(.top, 30)
        .background(Color("lekaLightGray"))
    }
}

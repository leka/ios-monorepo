// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct AccessoryManager: View {

    @EnvironmentObject var gameEngine: GameEngine
    @State private var displaySound: Bool = false

    var body: some View {
        Section {
            displaySoundToggle
        } header: {
            Text("Affichage des accessoires")
                .foregroundColor(.accentColor)
                .headerProminence(.increased)
        }
    }

    private var displaySoundToggle: some View {
        LabeledContent {
            Toggle("", isOn: $displaySound)
                .toggleStyle(SwitchToggleStyle(tint: Color("lekaSkyBlue")))
                .labelsHidden()
                .onChange(of: displaySound) { newValue in
                    if newValue {
                        gameEngine.bufferActivity.activityType = "listen_then_touch_to_select"
                    } else {
                        gameEngine.bufferActivity.activityType = "touch_to_select"
                    }
                    gameEngine.setupGame()
                }
                .onAppear {
                    if gameEngine.currentActivity.activityType != "listen_then_touch_to_select" {
                        displaySound = false
                    } else {
                        displaySound = true
                    }
                }
        } label: {
            Text("Afficher le bouton de lecture")
                .foregroundColor(Color("lekaDarkGray"))
                .padding(.leading, 20)
        }
    }
}

// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct XylophoneLayout: View {

    @EnvironmentObject var gameEngine: GameEngine
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults
    @StateObject var templateDefaults = XylophoneTemplatesDefaults()

    @State private var colors: [Color] = [.green, .purple, .red, .yellow, .blue]
    @State private var showAlert: Bool = false

    var body: some View {
        HStack(spacing: templateDefaults.xylophoneTilesSpacing) {
            ForEach($colors, id: \.self) { color in
                XylophoneTile(templateDefaults: templateDefaults, color: color)
            }
        }
        .onAppear {
            showAlert = true
        }
        .alert("Cette activité nécessite l'utilisation du robot !", isPresented: $showAlert) {
            alertContent
        } message: {
            Text("Avant de commencer l'activité, connectez-vous en Bluetooth à votre robot.")
        }
    }

    private var alertContent: some View {
        Group {
            Button(
                role: .destructive,
                action: {
                    showAlert.toggle()
                },
                label: {
                    Text("Annuler")
                })

            Button(
                role: .none,
                action: {
                    showAlert.toggle()
                },
                label: {
                    Text("Continuer sans le robot")
                })

            Button(
                role: .cancel,
                action: {
                    showAlert.toggle()
                },
                label: {
                    Text("Me connecter")
                        .font(defaults.semi17)
                        .foregroundColor(.accentColor)
                })
        }
    }
}

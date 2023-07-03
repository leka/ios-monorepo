// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct RobotNeededAlert: ViewModifier {
    @EnvironmentObject var defaults: GameLayoutTemplatesDefaults
    @State private var showAlert: Bool = false

    func body(content: Content) -> some View {
        content
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

extension View {
    func robotNeededAlert() -> some View {
        modifier(RobotNeededAlert())
    }
}

// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct AlertWhenRobotIsNeeded: ViewModifier {
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
                    Text("Continuer sans le robot")
                })
            Button(
                role: .none,
                action: {
                    showAlert.toggle()
                },
                label: {
                    Text("Se connecter")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.accentColor)
                })
        }
    }
}

extension View {
    func alertWhenRobotIsNeeded() -> some View {
        modifier(AlertWhenRobotIsNeeded())
    }
}

// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - AlertWhenNoUserSelected

struct AlertWhenNoUserSelected: ViewModifier {
    @State private var showAlert: Bool = false

    func body(content: Content) -> some View {
        content
            .onAppear {
                showAlert = true
            }
            .alert("Aucun utilisateur sélectionné pour cette activité.", isPresented: $showAlert) {
                alertContent
            } message: {
                Text("Avant de commencer l'activité, sélectionnez un utilisateur.")
            }
    }

    public init() {
        // nothing to do
    }

    private var alertContent: some View {
        Group {
            Button(
                role: .destructive,
                action: {
                    showAlert.toggle()
                },
                label: {
                    Text("Continuer sans utilisateur")
                })
            Button(
                role: .none,
                action: {
                    showAlert.toggle()
                },
                label: {
                    Text("Sélectionner un utilisateur")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.accentColor)
                })
        }
    }
}

public extension View {
    func alertWhenNoUserSelected() -> some View {
        modifier(AlertWhenNoUserSelected())
    }
}

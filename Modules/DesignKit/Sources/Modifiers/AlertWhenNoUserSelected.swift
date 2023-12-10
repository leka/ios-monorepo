// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

// MARK: - AlertWhenNoUserSelected

struct AlertWhenNoUserSelected: ViewModifier {
    // MARK: Lifecycle

    public init() {
        // nothing to do
    }

    // MARK: Internal

    func body(content: Content) -> some View {
        content
            .onAppear {
                self.showAlert = true
            }
            .alert("Aucun utilisateur sélectionné pour cette activité.", isPresented: self.$showAlert) {
                self.alertContent
            } message: {
                Text("Avant de commencer l'activité, sélectionnez un utilisateur.")
            }
    }

    // MARK: Private

    @State private var showAlert: Bool = false

    private var alertContent: some View {
        Group {
            Button(
                role: .destructive,
                action: {
                    self.showAlert.toggle()
                },
                label: {
                    Text("Continuer sans utilisateur")
                }
            )
            Button(
                role: .none,
                action: {
                    self.showAlert.toggle()
                },
                label: {
                    Text("Sélectionner un utilisateur")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.accentColor)
                }
            )
        }
    }
}

public extension View {
    func alertWhenNoUserSelected() -> some View {
        modifier(AlertWhenNoUserSelected())
    }
}

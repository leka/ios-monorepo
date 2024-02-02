// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - ProfileEditorView

struct ProfileEditorView: View {
    // MARK: Internal

    @EnvironmentObject var company: CompanyViewModelDeprecated
    @EnvironmentObject var settings: SettingsViewModelDeprecated
    @EnvironmentObject var metrics: UIMetrics
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            DesignKitAsset.Colors.lekaLightBlue.swiftUIColor.ignoresSafeArea()

            Group {
                HStack(spacing: 40) {
                    Spacer()
                    ProfileSet_TeachersDeprecated()
                    Spacer()
                    ProfileSet_UsersDeprecated()
                    Spacer()
                }
                .padding(.top, 60)
            }
        }
        .onAppear {
            if !self.settings.companyIsConnected {
                self.company.emptyProfilesSelection()
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) { self.navigationTitle }
            ToolbarItem(placement: .navigationBarLeading) { self.closeButton }
            ToolbarItem(placement: .navigationBarTrailing) { self.validateButton }
        }
    }

    // MARK: Private

    // Toolbar
    private var navigationTitle: some View {
        HStack(spacing: 4) {
            Text("Choisir ou créer de nouveaux profils")
            if self.settings.companyIsConnected, self.settings.exploratoryModeIsOn {
                Image(systemName: "binoculars.fill")
            }
        }
        // TODO: (@ui/ux) - Design System - replace with Leka font
        .font(.headline)
    }

    private var closeButton: some View {
        Button(
            action: {
                // Leave without saving new selection
                self.dismiss()
            },
            label: {
                Text("Fermer")
            }
        )
    }

    private var validateButton: some View {
        Button {
            if self.settings.companyIsConnected {
                if self.settings.exploratoryModeIsOn {
                    self.settings.showSwitchOffExploratoryAlert.toggle()
                } else {
                    // Save new selection and leave
                    self.company.assignCurrentProfiles()
                    self.dismiss()
                }
            } else {
                self.settings.showConnectInvite.toggle()
            }
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "checkmark.circle")
                Text("Valider la sélection")
            }
        }
        .disabled(!self.settings.companyIsConnected)
        .disabled(!self.company.selectionSetIsCorrect())
    }
}

// MARK: - ProfileEditorView_Previews

struct ProfileEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditorView()
            .environmentObject(CompanyViewModelDeprecated())
            .environmentObject(SettingsViewModelDeprecated())
            .environmentObject(UIMetrics())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

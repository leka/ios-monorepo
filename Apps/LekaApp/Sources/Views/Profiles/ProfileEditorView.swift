// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - ProfileEditorView

struct ProfileEditorView: View {
    // MARK: Internal

    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var metrics: UIMetrics
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            DesignKitAsset.Colors.lekaLightBlue.swiftUIColor.ignoresSafeArea()

            Group {
                HStack(spacing: 40) {
                    Spacer()
                    ProfileSet_Teachers()
                    Spacer()
                    ProfileSet_Users()
                    Spacer()
                }
                .padding(.top, 60)
            }
        }
        .onAppear {
            if !settings.companyIsConnected {
                company.emptyProfilesSelection()
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) { navigationTitle }
            ToolbarItem(placement: .navigationBarLeading) { closeButton }
            ToolbarItem(placement: .navigationBarTrailing) { validateButton }
        }
    }

    // MARK: Private

    // Toolbar
    private var navigationTitle: some View {
        HStack(spacing: 4) {
            Text("Choisir ou créer de nouveaux profils")
            if settings.companyIsConnected, settings.exploratoryModeIsOn {
                Image(systemName: "binoculars.fill")
            }
        }
        .font(metrics.semi17)
        .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
    }

    private var closeButton: some View {
        Button(
            action: {
                // Leave without saving new selection
                dismiss()
            },
            label: {
                Text("Fermer")
            })
    }

    private var validateButton: some View {
        Button {
            if settings.companyIsConnected {
                if settings.exploratoryModeIsOn {
                    settings.showSwitchOffExploratoryAlert.toggle()
                } else {
                    // Save new selection and leave
                    company.assignCurrentProfiles()
                    dismiss()
                }
            } else {
                settings.showConnectInvite.toggle()
            }
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "checkmark.circle")
                Text("Valider la sélection")
            }
            .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
        }
        .disabled(!settings.companyIsConnected)
        .disabled(!company.selectionSetIsCorrect())
    }
}

// MARK: - ProfileEditorView_Previews

struct ProfileEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditorView()
            .environmentObject(CompanyViewModel())
            .environmentObject(SettingsViewModel())
            .environmentObject(UIMetrics())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

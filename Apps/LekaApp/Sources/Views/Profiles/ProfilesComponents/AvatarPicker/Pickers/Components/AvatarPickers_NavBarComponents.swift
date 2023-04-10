//
//  AvatarPickers_NavBarComponents.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 20/3/23.
//

import SwiftUI

struct AvatarPicker_NavigationTitle: View {

    @EnvironmentObject var metrics: UIMetrics
    @EnvironmentObject var company: CompanyViewModel

    var body: some View {
        Text("Quel est ton avatar ?")
            .font(metrics.semi17)
            .foregroundColor(.accentColor)
    }
}

struct AvatarPicker_AdaptiveBackButton: View {

    @EnvironmentObject var viewRouter: ViewRouter
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button {
            // go back without saving
            dismiss()
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                if viewRouter.currentPage == .welcome {
                    Text("Retour")
                } else {
                    Text("Annuler")
                }
            }
        }
        .tint(.accentColor)
    }
}

struct AvatarPicker_ValidateButton: View {

    @EnvironmentObject var company: CompanyViewModel
    @Environment(\.dismiss) var dismiss

    @Binding var selected: String
    var action: () -> Void

    var body: some View {
        Button {
            action()
            dismiss()
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "checkmark.circle")
                Text("Valider la sélection")
            }
            .foregroundColor(.accentColor)
        }
        .disabled(selected.isEmpty)
    }
}

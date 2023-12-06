// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct JobPicker: View {
    @EnvironmentObject var company: CompanyViewModel
    @EnvironmentObject var metrics: UIMetrics
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var navigationVM: NavigationViewModel
    @Environment(\.dismiss) var dismiss

    @FocusState var focusedField: FormField?
    @State private var otherJobText: String = ""
    @State private var isEditing = false
    @State private var selectedJobs: [String] = []

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.top)

            JobPickerStore(selectedJobs: $selectedJobs)
                .onAppear {
                    selectedJobs = company.bufferTeacher.jobs
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .safeAreaInset(edge: .bottom) {
                    customJobTextField
                }
                .toolbar {
                    ToolbarItem(placement: .principal) { navigationTitle }
                    ToolbarItem(placement: .navigationBarLeading) { adaptiveBackButton }
                    ToolbarItem(placement: .navigationBarTrailing) { validateButton }
                }
        }
        .toolbarBackground(navigationVM.showProfileEditor ? .visible : .automatic, for: .navigationBar)
    }

    private var customJobTextField: some View {
        VStack(spacing: 0) {
            Divider()
                .padding(.horizontal, 20)
            LekaTextField(label: "Autre (préciser)", entry: $otherJobText, isEditing: $isEditing, type: .name) {
                if !otherJobText.isEmpty || !company.bufferTeacher.jobs.contains(otherJobText) {
                    selectedJobs.append(otherJobText)
                }
            }
            .padding(.vertical, 30)
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(
            Rectangle()
                .fill(.white)
                .edgesIgnoringSafeArea(.all)
        )
    }

    private var navigationTitle: some View {
        Text("Sélectionnez vos professions")
            .font(metrics.semi17)
            .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
    }

    private var adaptiveBackButton: some View {
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
        .tint(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
    }

    private var validateButton: some View {
        Button {
            company.bufferTeacher.jobs = selectedJobs
            dismiss()
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "checkmark.circle")
                Text("Valider la sélection")
            }
            .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
        }
        .disabled(selectedJobs.isEmpty)
        .disabled(isEditing)
    }
}

struct JobPicker_Previews: PreviewProvider {
    static var previews: some View {
        JobPicker()
            .environmentObject(CompanyViewModel())
            .environmentObject(ViewRouter())
            .environmentObject(UIMetrics())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

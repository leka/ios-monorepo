// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - JobPickerDeprecated

struct JobPickerDeprecated: View {
    // MARK: Internal

    @EnvironmentObject var company: CompanyViewModelDeprecated
    @EnvironmentObject var metrics: UIMetrics
    @EnvironmentObject var viewRouter: ViewRouterDeprecated
    @EnvironmentObject var navigationVM: NavigationViewModel
    @Environment(\.dismiss) var dismiss

    @FocusState var focusedField: FormField?

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.top)

            JobPickerStoreDeprecated(selectedJobs: self.$selectedJobs)
                .onAppear {
                    self.selectedJobs = self.company.bufferTeacher.jobs
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .safeAreaInset(edge: .bottom) {
                    self.customJobTextField
                }
                .toolbar {
                    ToolbarItem(placement: .principal) { self.navigationTitle }
                    ToolbarItem(placement: .navigationBarLeading) { self.adaptiveBackButton }
                    ToolbarItem(placement: .navigationBarTrailing) { self.validateButton }
                }
        }
        .toolbarBackground(self.navigationVM.showProfileEditor ? .visible : .automatic, for: .navigationBar)
    }

    // MARK: Private

    @State private var otherJobText: String = ""
    @State private var isEditing = false
    @State private var selectedJobs: [String] = []

    private var customJobTextField: some View {
        VStack(spacing: 0) {
            Divider()
                .padding(.horizontal, 20)
            LekaTextFieldDeprecated(label: "Autre (préciser)", entry: self.$otherJobText, isEditing: self.$isEditing, type: .name) {
                if !self.otherJobText.isEmpty || !self.company.bufferTeacher.jobs.contains(self.otherJobText) {
                    self.selectedJobs.append(self.otherJobText)
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
            // TODO: (@ui/ux) - Design System - replace with Leka font
            .font(.headline)
    }

    private var adaptiveBackButton: some View {
        Button {
            // go back without saving
            self.dismiss()
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                if self.viewRouter.currentPage == .welcome {
                    Text("Retour")
                } else {
                    Text("Annuler")
                }
            }
        }
    }

    private var validateButton: some View {
        Button {
            self.company.bufferTeacher.jobs = self.selectedJobs
            self.dismiss()
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "checkmark.circle")
                Text("Valider la sélection")
            }
        }
        .disabled(self.selectedJobs.isEmpty)
        .disabled(self.isEditing)
    }
}

// MARK: - JobPicker_Previews

struct JobPicker_Previews: PreviewProvider {
    static var previews: some View {
        JobPickerDeprecated()
            .environmentObject(CompanyViewModelDeprecated())
            .environmentObject(ViewRouterDeprecated())
            .environmentObject(UIMetrics())
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

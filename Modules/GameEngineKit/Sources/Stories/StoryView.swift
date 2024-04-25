// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import LocalizationKit
import RobotKit
import SVGView
import SwiftUI

// MARK: - StoryView

public struct StoryView: View {
    // MARK: Lifecycle

    public init(story: Story) {
        self._viewModel = StateObject(wrappedValue: StoryViewViewModel(story: story))
    }

    // MARK: Public

    public var body: some View {
        ModelPages(self.viewModel.currentStory.pages,
                   currentPage: self.$viewModel.currentPageIndex,
                   transitionStyle: .pageCurl,
                   hasControl: false)
        { _, page in
            PageView(page: page)
//                .padding()
        }
//        Color.red
//        .frame(maxWidth: .infinity)
        .ignoresSafeArea(.all)
        .navigationTitle(self.viewModel.currentStory.details.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    self.isAlertPresented = true
                } label: {
                    Image(systemName: "xmark.circle")
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    self.isInfoSheetPresented.toggle()
                } label: {
                    Image(systemName: "info.circle")
                }
            }
        }
        .alert(String(l10n.StoryView.QuitStoryAlert.title.characters), isPresented: self.$isAlertPresented) {
            Button(String(l10n.StoryView.QuitStoryAlert.saveQuitButtonLabel.characters), action: {
                // TODO: (@mathieu) - Save displayable data in session
                self.dismiss()
            })
            Button(String(l10n.StoryView.QuitStoryAlert.quitWithoutSavingButtonLabel.characters), role: .destructive, action: {
                // TODO: (@mathieu) - Save undisplayable data in session
                self.dismiss()
            })
            Button(String(l10n.StoryView.QuitStoryAlert.cancelButtonLabel.characters), role: .cancel, action: {
                self.isAlertPresented = false
            })
        } message: {
            Text(l10n.StoryView.QuitStoryAlert.message)
        }
        .sheet(isPresented: self.$isInfoSheetPresented) {
            StoryDetailsView(story: self.viewModel.currentStory)
        }
        .onAppear {
            Robot.shared.stop()
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            Robot.shared.stop()
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }

    // MARK: Internal

    @Environment(\.dismiss) var dismiss

    // TODO: (@ladislas) check why not @ObservedObject
    @StateObject var viewModel: StoryViewViewModel

    // MARK: Private

    @State private var isAlertPresented: Bool = false
    @State private var isInfoSheetPresented: Bool = false
}

#Preview {
    NavigationStack {
        StoryView(story: Story.mock)
    }
}

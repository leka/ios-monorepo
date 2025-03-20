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
        self.currentStory = story
    }

    // MARK: Public

    public var body: some View {
        ZStack {
            Pages(
                pages: self.currentStory.pages.compactMap { PageView(page: $0) },
                currentPage: self.$currentPage
            )
            .onChange(of: self.currentPage) { newPage in
                if newPage == self.currentStory.pages.count - 1 {
                    self.showFinishButton = false
                    withAnimation(.easeInOut.delay(1)) {
                        if newPage == self.currentStory.pages.count - 1 {
                            self.showFinishButton = true
                        }
                    }
                } else {
                    self.showFinishButton = false
                }
            }

            if self.showFinishButton {
                VStack {
                    Spacer()

                    Button {
                        self.dismiss()
                    } label: {
                        Text(l10n.StoryView.finishButtonLabel)
                            .font(.title3.bold())
                            .foregroundColor(.white)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.center)
                            .frame(width: 300, height: 300.0 / 4.0)
                            .scaledToFit()
                            .background(Capsule().fill(.green).shadow(radius: 3))
                    }
                    .padding(.bottom, 30)
                }
            }
        }
        .ignoresSafeArea(.all)
        .navigationTitle(self.currentStory.details.title)
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
            Button(String(l10n.StoryView.QuitStoryAlert.cancelButtonLabel.characters), role: .cancel, action: {
                self.isAlertPresented = false
            })
            Button(String(l10n.StoryView.QuitStoryAlert.quitButtonLabel.characters), role: .destructive, action: {
                // TODO: (@mathieu) - Save displayable data in session
                self.dismiss()
            })
        } message: {
            Text(l10n.StoryView.QuitStoryAlert.message)
        }
        .sheet(isPresented: self.$isInfoSheetPresented) {
            StoryDetailsView(story: self.currentStory)
                .logEventScreenView(
                    screenName: "story_details",
                    context: .sheet,
                    parameters: [
                        "lk_story_id": "\(self.currentStory.name)-\(self.currentStory.id)",
                    ]
                )
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
    let currentStory: Story

    // MARK: Private

    @State private var currentPage = 0
    @State private var showFinishButton = false
    @State private var isAlertPresented: Bool = false
    @State private var isInfoSheetPresented: Bool = false
}

#Preview {
    NavigationStack {
        StoryView(story: Story.mock)
    }
}

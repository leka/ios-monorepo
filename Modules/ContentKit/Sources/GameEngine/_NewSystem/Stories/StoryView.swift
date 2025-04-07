// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

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
            TabView(selection: self.$currentPageIndex) {
                ForEach(0..<self.currentStory.pages.count, id: \.self) { index in
                    PageView(page: self.currentStory.pages[index])
                        .tag(index)
                }
            }
            .ignoresSafeArea(.all)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.default, value: self.currentPageIndex)
            .onChange(of: self.currentPageIndex) {
                self.isLastPage = false
                if self.currentPageIndex == self.currentStory.pages.count - 1 {
                    withAnimation(.easeInOut(duration: 0.3).delay(1)) {
                        self.isLastPage = true
                    }
                }
            }

            self.toolbarView

            VStack {
                Spacer()
                if self.isLastPage {
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
                            .padding(.bottom, 30)
                    }
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
            InfoDetailsView(CurationItemModel(id: self.currentStory.id, contentType: .story))
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

    let currentStory: Story

    // MARK: Private

    @State private var isLastPage: Bool = false
    @State private var currentPageIndex: Int = 0
    @State private var isAlertPresented: Bool = false
    @State private var isInfoSheetPresented: Bool = false

    private var toolbarView: some View {
        VStack {
            HStack {
                Button {
                    self.isAlertPresented = true
                } label: {
                    Image(systemName: "xmark.circle")
                        .font(.title2)
                }

                Spacer()

                Text(self.currentStory.details.title)
                    .font(.title2.bold())
                    .foregroundStyle(.black)

                Spacer()

                Button {
                    self.isInfoSheetPresented.toggle()
                } label: {
                    Image(systemName: "info.circle")
                        .font(.title2)
                }
            }

            Spacer()

            HStack {
                if self.currentPageIndex > 0 {
                    Button {
                        self.currentPageIndex -= 1
                    } label: {
                        Image(systemName: "arrow.backward")
                            .font(.title.bold())
                    }
                }

                Spacer()

                if self.currentPageIndex < self.currentStory.pages.count - 1 {
                    Button {
                        self.currentPageIndex += 1
                    } label: {
                        Image(systemName: "arrow.forward")
                            .font(.title.bold())
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        StoryView(story: Story.mock)
    }
}

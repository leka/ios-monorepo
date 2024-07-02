// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import LocalizationKit
import MarkdownUI
import SwiftUI
import Yams

// MARK: - CategoryHome

struct CategoryHome: View {
    // MARK: Lifecycle

    // TODO: (@team) - do-catch within the init instead of try!
    // cf GeneralSuggestions_iOS17.swift for suggestion
    init() {
        let fileURL = Bundle.main.url(forResource: "home", withExtension: "yml")!
        let decoder = YAMLDecoder()
        // swiftlint:disable:next force_try
        let homeContent = try! decoder.decode(HomeContent.self, from: try! Data(contentsOf: fileURL))

        if l10n.language == .french {
            self.content = homeContent.frFR
        } else {
            self.content = homeContent.enUS
        }
    }

    // MARK: Internal

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 40) {
                VStack {
                    LekaAppAsset.Assets.lekaLogoStripes.swiftUIImage
                        .resizable()
                        .scaledToFit()
                        .frame(height: 60)
                        .padding(.bottom)

                    Text(self.content.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)

                    Divider()
                        .padding(.horizontal)
                        .padding(.horizontal)
                }

                Markdown(self.content.intro)
                    .markdownTheme(.gitHub)

                Markdown(self.content.features)
                    .markdownTheme(.gitHub)

                Markdown(self.content.comingSoon)
                    .markdownTheme(.gitHub)

                Markdown(self.content.feedback)
                    .markdownTheme(.gitHub)

                HStack {
                    Spacer()
                    Link(self.content.feedbackButton, destination: URL(string: self.content.feedbackLink)!)
                        .buttonStyle(.borderedProminent)
                        .font(.headline)
                    Spacer()
                }

                Markdown(self.content.thankYou)
                    .markdownTheme(.gitHub)
            }
            .padding()
            .padding(.horizontal)
        }
        .navigationTitle(self.content.navigationTitle)
    }

    // MARK: Private

    private let content: HomeContentLocalized
}

// MARK: - HomeContent

struct HomeContent: Codable {
    enum CodingKeys: String, CodingKey {
        case frFR = "fr_FR"
        case enUS = "en_US"
    }

    let frFR: HomeContentLocalized
    let enUS: HomeContentLocalized
}

// MARK: - HomeContentLocalized

struct HomeContentLocalized: Codable {
    enum CodingKeys: String, CodingKey {
        case navigationTitle = "navigation_title"
        case title
        case intro
        case features
        case comingSoon = "coming_soon"
        case feedback
        case feedbackButton = "feedback_button"
        case feedbackLink = "feedback_link"
        case underDevelopment = "under_development"
        case thankYou = "thank_you"
    }

    let navigationTitle: String
    let title: String
    let intro: String
    let features: String
    let comingSoon: String
    let feedback: String
    let feedbackButton: String
    let feedbackLink: String
    let underDevelopment: String
    let thankYou: String
}

#Preview {
    NavigationSplitView {
        Text("Sidebar")
    } detail: {
        CategoryHome()
    }
}

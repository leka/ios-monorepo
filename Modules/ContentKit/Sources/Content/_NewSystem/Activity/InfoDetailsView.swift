// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import Fit
import LocalizationKit
import MarkdownUI
import SwiftUI

// MARK: - InfoDetailsView

public struct InfoDetailsView: View {
    // MARK: Lifecycle

    public init?(_ content: CurationItemModel) {
        switch content.contentType {
            case .activity:
                guard let activity = Activity(id: content.id) else {
                    logCK.error("Content \(content.id) is labeled as activity but not decoded as such ")
                    return nil
                }
                self.iconImage = activity.details.iconImage
                self.title = activity.details.title
                self.subtitle = activity.details.subtitle
                self.shape = Circle()
                self.shortDescription = activity.details.shortDescription
                self.description = activity.details.description
                self.instructions = activity.details.instructions
                self.skills = activity.skills
                self.authors = activity.authors
                self.contentType = .activity
            case .story:
                guard let story = Story(id: content.id) else {
                    logCK.error("Content \(content.id) is labeled as story but not decoded as such ")
                    return nil
                }
                self.iconImage = story.details.iconImage
                self.title = story.details.title
                self.subtitle = story.details.subtitle
                self.shape = RoundedRectangle(cornerRadius: 10 / 57 * self.kIconSize)
                self.shortDescription = story.details.shortDescription
                self.description = story.details.description
                self.instructions = story.details.instructions
                self.skills = story.skills
                self.authors = story.authors
                self.contentType = .story
            default:
                logCK.error("Content \(content.id) cannot be detailed as Story or Activity")
                return nil
        }
    }

    // MARK: Public

    public var body: some View {
        List {
            Section {
                HStack {
                    HStack(alignment: .center) {
                        Image(uiImage: self.iconImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: self.kIconSize, height: self.kIconSize)
                            .clipShape(AnyShape(self.shape))

                        VStack(alignment: .leading, spacing: 8) {
                            HStack(alignment: .center) {
                                Text(self.title)
                                    .font(.largeTitle)
                                    .bold()

                                Spacer()

                                VStack {
                                    Image(systemName: self.contentType.icon)
                                        .font(.title3)
                                    Text(self.contentType.label)
                                        .font(.caption)
                                }
                            }

                            if let subtitle = self.subtitle {
                                Text(subtitle)
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                            }

                            Text(markdown: self.shortDescription)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }

                    Spacer()
                }

                HStack(alignment: .firstTextBaseline) {
                    Text(l10n.InfoDetailsView.skillsSectionTitle)
                    Spacer()
                    Fit(itemSpacing: .viewSpacing(minimum: 15)) {
                        ForEach(self.skills, id: \.self) { skill in
                            TagView(title: skill.name, systemImage: "info.circle") {
                                self.selectedSkill = skill
                            }
                        }
                    }
                    .sheet(item: self.$selectedSkill, onDismiss: { self.selectedSkill = nil }, content: { skill in
                        VStack(alignment: .leading) {
                            Text(skill.name)
                                .font(.headline)
                            Text(skill.description)
                        }
                        .padding()
                    })
                }

                HStack(alignment: .firstTextBaseline) {
                    Text(l10n.InfoDetailsView.authorsSectionTitle)
                    Spacer()
                    Fit(itemSpacing: .viewSpacing(minimum: 15)) {
                        ForEach(self.authors, id: \.self) { author in
                            let author = Authors.hmi(id: author)!

                            TagView(title: author.name, systemImage: "info.circle") {
                                self.selectedAuthor = author
                            }
                        }
                    }
                    .sheet(item: self.$selectedAuthor, onDismiss: { self.selectedAuthor = nil }, content: { author in
                        VStack(alignment: .leading) {
                            Text(author.name)
                                .font(.headline)
                            Text(author.description)
                        }
                        .padding()
                    })
                }
            }

            Section(String(l10n.InfoDetailsView.descriptionSectionTitle.characters)) {
                Markdown(self.description)
            }

            Section(String(l10n.InfoDetailsView.instructionsSectionTitle.characters)) {
                Markdown(self.instructions)
            }
        }
    }

    // MARK: Private

    @State private var selectedAuthor: Author?
    @State private var selectedSkill: Skill?

    private let iconImage: UIImage
    private let shape: any Shape
    private let title: String
    private let subtitle: String?
    private let shortDescription: String
    private let skills: [Skill]
    private let authors: [String]
    private let description: String
    private let instructions: String
    private let contentType: ContentType
    private let kIconSize: CGFloat = 150
}

// MARK: - l10n.InfoDetailsView

extension l10n {
    enum InfoDetailsView {
        static let skillsSectionTitle = LocalizedString("content_kit.info_details_view.skills_section_title",
                                                        bundle: Bundle.module,
                                                        value: "Skills",
                                                        comment: "InfoDetailsView 'skills' section title")

        static let authorsSectionTitle = LocalizedString("content_kit.info_details_view.authors_section_title",
                                                         bundle: Bundle.module,
                                                         value: "Authors",
                                                         comment: "InfoDetailsView 'authors' section title")

        static let descriptionSectionTitle = LocalizedString("content_kit.info_details_view.description_section_title",
                                                             bundle: Bundle.module,
                                                             value: "Description",
                                                             comment: "InfoDetailsView 'description' section title")

        static let instructionsSectionTitle = LocalizedString("content_kit.info_details_view.instructions_section_title",
                                                              bundle: Bundle.module,
                                                              value: "Instructions",
                                                              comment: "InfoDetailsView 'instructions' section title")
    }
}

#Preview {
    TabView {
        InfoDetailsView(CurationItemModel(id: ContentKit.allActivities.first!.key, contentType: .activity))
            .tabItem {
                Text("Activity")
            }

        InfoDetailsView(CurationItemModel(id: ContentKit.allStories.first!.key, contentType: .story))
            .tabItem {
                Text("Story")
            }
    }
}

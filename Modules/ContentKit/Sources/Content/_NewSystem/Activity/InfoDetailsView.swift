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
            case .curriculum:
                guard let curriculum = Curriculum(id: content.id) else {
                    logCK.error("Content \(content.id) is labeled as curriculum but not decoded as such ")
                    return nil
                }
                self.iconImage = curriculum.details.iconImage
                self.title = curriculum.details.title
                self.subtitle = curriculum.details.subtitle
                self.shape = RoundedRectangle(cornerRadius: 10 / 57 * self.kIconSize)
                self.abstract = curriculum.details.abstract
                self.description = curriculum.details.description
                self.skills = curriculum.skills
                self.authors = curriculum.authors
                self.activityCount = curriculum.activities.count
                self.contentType = .curriculum
            case .activity:
                guard let activity = Activity(id: content.id) else {
                    logCK.error("Content \(content.id) is labeled as activity but not decoded as such ")
                    return nil
                }
                self.iconImage = activity.details.iconImage
                self.title = activity.details.title
                self.subtitle = activity.details.subtitle
                self.shape = Circle()
                self.abstract = activity.details.shortDescription
                self.description = activity.details.description
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
                self.abstract = story.details.shortDescription
                self.description = story.details.description
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
        Section {
            HStack(alignment: .top) {
                Image(uiImage: self.iconImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: self.kIconSize, height: self.kIconSize)
                    .clipShape(AnyShape(self.shape))

                VStack(alignment: .leading) {
                    HStack {
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

                        if let activityCount = self.activityCount {
                            VStack {
                                Text(activityCount.description)
                                    .font(.title3)
                                Text(l10n.InfoDetailsView.activitiesSectionTitle)
                                    .font(.caption)
                            }
                        }
                    }

                    if let subtitle = self.subtitle {
                        Text(subtitle)
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }

                    Text(markdown: self.abstract)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
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

            VStack(spacing: 10) {
                HStack {
                    Text(l10n.InfoDetailsView.descriptionSectionTitle)

                    Spacer()

                    Button {
                        self.isDescriptionExpanded.toggle()
                    } label: {
                        Text(self.isDescriptionExpanded ? l10n.InfoDetailsView.seeLessLabel : l10n.InfoDetailsView.seeMoreLabel)
                            .font(.subheadline)
                            .foregroundColor(self.styleManager.accentColor ?? .blue)
                    }
                }

                if self.isDescriptionExpanded {
                    Markdown(self.description)
                        .markdownTheme(.gitHub)
                }
            }
        }
    }

    // MARK: Private

    @State private var selectedAuthor: Author?
    @State private var selectedSkill: Skill?
    @State private var isDescriptionExpanded = false

    private let iconImage: UIImage
    private let shape: any Shape
    private let title: String
    private let subtitle: String?
    private let skills: [Skill]
    private let authors: [String]
    private let abstract: String
    private let description: String
    private var activityCount: Int?
    private let contentType: ContentType
    private let kIconSize: CGFloat = 150

    private var styleManager: StyleManager = .shared
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

        static let activitiesSectionTitle = LocalizedString("content_kit.info_details_view.activities_section_title",
                                                            bundle: Bundle.module,
                                                            value: "Activities",
                                                            comment: "InfoDetailsView 'activities' section title")

        static let seeMoreLabel = LocalizedString("content_kit.info_details_view.see_more_label",
                                                  bundle: Bundle.module,
                                                  value: "See more",
                                                  comment: "See more button label")

        static let seeLessLabel = LocalizedString("content_kit.info_details_view.see_less_label",
                                                  bundle: Bundle.module,
                                                  value: "See less",
                                                  comment: "See less button label")
    }
}

#Preview {
    let activity = ContentKit.allActivities.first!.value
    let story = ContentKit.allStories.first!.value
    TabView {
        InfoDetailsView(CurationItemModel(id: activity.id, name: activity.name, contentType: .activity))
            .tabItem {
                Text("Activity")
            }

        InfoDetailsView(CurationItemModel(id: story.id, name: story.name, contentType: .story))
            .tabItem {
                Text("Story")
            }
    }
}

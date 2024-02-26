// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import MarkdownUI
import SwiftUI

// MARK: - ActivityDetailsView

public struct ActivityDetailsView: View {
    // MARK: Lifecycle

    public init(activity: Activity) {
        self.activity = activity
    }

    // MARK: Public

    public var body: some View {
        List {
            Section {
                HStack {
                    HStack(alignment: .center) {
                        Image(uiImage: self.activity.details.iconImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())

                        VStack(alignment: .leading, spacing: 8) {
                            Text(self.activity.details.title)
                                .font(.largeTitle)
                                .bold()

                            Text(self.activity.details.subtitle)
                                .font(.title2)
                                .foregroundColor(.secondary)

                            Text(self.activity.details.shortDescription)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }

                    Spacer()
                }

                DisclosureGroup("**Skills**") {
                    ForEach(self.activity.skills, id: \.self) { skill in
                        let skill = Skills.skill(id: skill)!
                        HStack {
                            Text(skill.name)
                            Button {
                                self.selectedSkill = skill
                            } label: {
                                Image(systemName: "info.circle")
                            }
                        }
                    }
                }
                .sheet(item: self.$selectedSkill, onDismiss: { self.selectedSkill = nil }, content: { skill in
                    VStack(alignment: .leading) {
                        Text(skill.name)
                            .font(.headline)
                        Text(skill.description)
                    }
                })

                DisclosureGroup("**Authors**") {
                    ForEach(self.activity.authors, id: \.self) { author in
                        let author = Authors.hmi(id: author)!
                        HStack {
                            Text(author.name)
                            Button {
                                self.selectedAuthor = author
                            } label: {
                                Image(systemName: "info.circle")
                            }
                        }
                    }
                }
                .sheet(item: self.$selectedAuthor, onDismiss: { self.selectedAuthor = nil }, content: { author in
                    VStack(alignment: .leading) {
                        Text(author.name)
                            .font(.headline)
                        Text(author.description)
                    }
                })
            }

            Section("Description") {
                Markdown(self.activity.details.description)
                    .markdownTheme(.gitHub)
            }

            Section("Instructions") {
                Markdown(self.activity.details.instructions)
                    .markdownTheme(.gitHub)
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    print("Start activity")
                    self.activityToStart = self.activity
                } label: {
                    Image(systemName: "play.circle")
                    Text("Start activity")
                }
                .buttonStyle(.borderedProminent)
                .tint(.lkGreen)
            }
        }
        .fullScreenCover(item: self.$activityToStart) {
            self.activityToStart = nil
        } content: { activity in
            ActivityView(activity: activity)
        }
    }

    // MARK: Private

    private let activity: Activity

    @State private var selectedAuthor: Author?
    @State private var selectedSkill: Skill?

    @State private var activityToStart: Activity?
}

#Preview {
    NavigationStack {
        ActivityDetailsView(activity: Activity.mock)
    }
}

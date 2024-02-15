// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import LocalizationKit
import MarkdownUI
import SwiftUI

// MARK: - RowView

struct RowView<T: StringProtocol>: View {
    // MARK: Lifecycle

    init(label: String) where T == String {
        self.label = label
        self.value = ""
    }

    init(label: String, value: T?) {
        self.label = label
        self.value = value
    }

    // MARK: Internal

    let label: String
    let value: T?

    var body: some View {
        HStack {
            Text("**\(self.label)**")
            Spacer()
            Text(self.value ?? "")
                .foregroundStyle(.secondary)
        }
    }
}

// MARK: - ActivityDetailsView

struct ActivityDetailsView: View {
    // MARK: Internal

    let activity: Activity

    var body: some View {
        List {
            Section("Information") {
                RowView(label: "UUID", value: self.activity.id)
                RowView(label: "Name", value: self.activity.name)

                RowView(label: "Status", value: self.activity.status == .published ? "published" : "draft")

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

                DisclosureGroup("**Available languages**") {
                    ForEach(self.activity.languages, id: \.self) { lang in
                        Text(lang.identifier)
                    }
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

                DisclosureGroup("**HMI**") {
                    ForEach(self.activity.hmi, id: \.self) { hmi in
                        let hmi = HMI.hmi(id: hmi)!
                        HStack {
                            Text(hmi.name)
                            Button {
                                self.selectedHMI = hmi
                            } label: {
                                Image(systemName: "info.circle")
                            }
                        }
                    }
                }
                .sheet(item: self.$selectedHMI, onDismiss: { self.selectedHMI = nil }, content: { hmi in
                    VStack(alignment: .leading) {
                        Text(hmi.name)
                            .font(.headline)
                        Text(hmi.description)
                    }
                })

                DisclosureGroup("**Tags**") {
                    ForEach(self.activity.tags, id: \.self) { skill in
                        Text(skill)
                    }
                }
            }

            Section("Details (in: \(l10n.language.identifier))") {
                Text(self.activity.details.title)
                    .font(.title)
                Text(self.activity.details.subtitle)
                    .font(.title2)
                Markdown(self.activity.details.description)
                    .markdownTheme(.gitHub)
                Markdown(self.activity.details.instructions)
                    .markdownTheme(.gitHub)
            }
        }
        .navigationTitle(self.activity.name)
    }

    // MARK: Private

    @State private var selectedSkill: Skill?
    @State private var selectedHMI: HMIDetails?
    @State private var selectedAuthor: Author?
}

#Preview {
    NavigationStack {
        ActivityDetailsView(activity: Activity.mock)
    }
}

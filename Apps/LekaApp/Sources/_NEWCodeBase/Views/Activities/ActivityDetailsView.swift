// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import MarkdownUI
import SwiftUI

// MARK: - ActivityDetailsView

struct ActivityDetailsView: View {
    // MARK: Internal

    let activity: Activity

    var body: some View {
        List {
            Section {
                HStack {
                    HStack(alignment: .lastTextBaseline) {
                        Image(uiImage: self.activity.details.iconImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())

                        VStack(alignment: .leading) {
                            Text(self.activity.details.title)
                                .font(.title)

                            Text(self.activity.details.subtitle)
                                .font(.title2)
                                .foregroundColor(.secondary)

                            Text(self.activity.details.description)
                        }
                    }

                    Spacer()
                }
            }

            Section {
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

                DisclosureGroup("**Activity Types**") {
                    ForEach(self.activity.types, id: \.self) { type in
                        let type = ActivityTypes.type(id: type)!
                        HStack {
                            Text(type.name)
                            Button {
                                self.selectedType = type
                            } label: {
                                Image(systemName: "info.circle")
                            }
                        }
                    }
                }
                .sheet(item: self.$selectedType, onDismiss: { self.selectedType = nil }, content: { type in
                    VStack(alignment: .leading) {
                        Text(type.name)
                            .font(.headline)
                        Text(type.description)
                    }
                })
            }

            Section {
                Markdown(self.activity.details.instructions)
                    .markdownTheme(.gitHub)
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    print("Start activity")
                    self.navigation.currentActivity = self.activity
                } label: {
                    Image(systemName: "play.circle")
                    Text("Start activity")
                }
                .buttonStyle(.borderedProminent)
                .tint(.lkGreen)
            }
        }
    }

    // MARK: Private

    @State private var selectedAuthor: Author?
    @State private var selectedSkill: Skill?
    @State private var selectedHMI: HMIDetails?
    @State private var selectedType: ActivityType?

    private let navigation: Navigation = .shared
}

#Preview {
    NavigationStack {
        ActivityDetailsView(activity: Activity.mock)
    }
}

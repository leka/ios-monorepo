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

                        VStack(alignment: .leading) {
                            Text(self.activity.details.title)
                                .font(.title)

                            Text(self.activity.details.subtitle)
                                .font(.title2)
                                .foregroundColor(.secondary)

                            Text(self.activity.details.shortDescription)
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
    @State private var selectedHMI: HMIDetails?
    @State private var selectedType: ActivityType?

    @State private var activityToStart: Activity?
}

#Preview {
    NavigationStack {
        ActivityDetailsView(activity: Activity.mock)
    }
}

// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import LocalizationKit
import MarkdownUI
import SwiftUI

extension Theme {
    static let leka: Theme = .gitHub
        .text {
            BackgroundColor(.clear)
        }
}

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

// MARK: - MainView

struct MainView: View {
    // MARK: Internal

    var body: some View {
        List {
            Section("Information") {
                RowView(label: "UUID", value: self.activity?.id ?? "nil")
                RowView(label: "Name", value: self.activity?.name ?? "nil")

                DisclosureGroup("**Authors**") {
                    ForEach(self.activity?.authors ?? [], id: \.self) { author in
                        Text(author)
                    }
                }

                DisclosureGroup("**Available languages**") {
                    ForEach(self.activity?.languages ?? [], id: \.self) { lang in
                        Text(lang.identifier)
                    }
                }

                DisclosureGroup("**Skills**") {
                    ForEach(self.activity?.skills ?? [], id: \.self) { skill in
                        Text(skill)
                    }
                }

                DisclosureGroup("**Tags**") {
                    ForEach(self.activity?.tags ?? [], id: \.self) { skill in
                        Text(skill)
                    }
                }
            }

            Section("Details (in: \(l10n.language.identifier))") {
                Text(self.activity?.details.title ?? "nil")
                    .font(.title)
                Text(self.activity?.details.subtitle ?? "nil")
                    .font(.title2)
                Markdown(self.activity?.details.description ?? "nil")
                    .markdownTheme(.leka)
                Markdown(self.activity?.details.instructions ?? "nil")
                    .markdownTheme(.leka)
            }
        }
        .onAppear {
            self.activity = ContentKit.decodeActivity("activity")
            print(self.activity ?? "not working")
        }
    }

    // MARK: Private

    @State private var activity: Activity?
}

#Preview {
    MainView()
}

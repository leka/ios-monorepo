// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AnalyticsKit
import ContentKit
import QuickLook
import SwiftUI

// MARK: - ResourceFileView

public struct ResourceFileView: View {
    // MARK: Lifecycle

    public init(resource: ContentCategory.Resource) {
        self.resource = resource
    }

    // MARK: Public

    public var body: some View {
        GroupBox(label: Label(self.resource.title, systemImage: self.resource.icon)) {
            VStack {
                if let description = self.resource.description {
                    Text(description)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color.secondary)
                }

                Spacer()

                Image(uiImage: self.resource.illustrationImage)
                    .resizable()
                    .scaledToFit()
            }
            .aspectRatio(16 / 9, contentMode: .fit)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onTapGesture {
            self.url = ContentKitResources.bundle.url(forResource: self.resource.value, withExtension: "resource.pdf")
            AnalyticsManager.logEventSelectContent(
                type: .resourceFile,
                id: self.resource.id.uuidString,
                name: self.resource.title,
                origin: Navigation.shared.selectedCategory?.rawValue
            )
        }
        .quickLookPreview(self.$url)
        .padding()
    }

    // MARK: Internal

    @State var isPresented: Bool = false

    let resource: ContentCategory.Resource

    // MARK: Private

    @State private var url: URL?
}

#Preview {
    NavigationStack {
        ResourceFileView(
            resource: ContentKit.allResources.first!.value.sections[0].resources[1].resource
        )
    }
}

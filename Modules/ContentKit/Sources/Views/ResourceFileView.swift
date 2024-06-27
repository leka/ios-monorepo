// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import QuickLook
import SwiftUI

// MARK: - ResourceFileView

public struct ResourceFileView: View {
    // MARK: Lifecycle

    public init(resource: Category.Resource) {
        self.resource = resource
    }

    // MARK: Public

    public var body: some View {
        GroupBox(label: Label(self.resource.title, systemImage: self.resource.icon)) {
            HStack {
                Image(systemName: self.resource.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.accentColor)
                    .padding()

                Spacer()

                VStack {
                    Text(self.resource.description)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color.secondary)
                    Spacer()
                }
            }
            .aspectRatio(16 / 9, contentMode: .fit)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onTapGesture {
            self.url = ContentKitResources.bundle.url(forResource: self.resource.value, withExtension: "resource.pdf")
        }
        .quickLookPreview(self.$url)
        .padding()
    }

    // MARK: Internal

    let resource: Category.Resource

    @State var isPresented: Bool = false

    // MARK: Private

    @State private var url: URL?
}

#Preview {
    NavigationStack {
        ResourceFileView(
            resource: ContentKit.firstStepsResources.content.map(\.resource)[0]
        )
    }
}

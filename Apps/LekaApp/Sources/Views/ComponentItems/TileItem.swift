// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import ContentKit
import SwiftUI

// MARK: - TileItem

public struct TileItem: View {
    // MARK: Lifecycle

    public init?(_ content: CurationItemModel) {
        if content.contentType == .curation {
            guard let curation = CategoryCuration(id: content.id) else {
                log.error("Content \(content.id) is labeled as curation but not decoded as such")
                return nil
            }
            self.icon = curation.icon
            self.title = curation.details.title
            self.color = curation.color
        } else {
            log.error("Content \(content.id) is a not curation and cannot be decoded as TileItem")
            return nil
        }
    }

    // MARK: Public

    public var body: some View {
        GroupBox {
            VStack {
                if let icon = UIImage(named: "\(self.icon).skill.icon.png", in: .module, with: nil) {
                    Image(uiImage: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                } else {
                    Image(systemName: self.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.white)
                }

                Text(self.title)
                    .font(.title3.bold())
                    .foregroundStyle(.white)
            }
            .frame(height: 100)
            .frame(minWidth: 200, maxWidth: .infinity)
        }
        .backgroundStyle(self.color)
    }

    // MARK: Private

    private var icon: String
    private var title: String
    private var color: Color
}

#Preview {
    let curations: [CurationItemModel] = [
        .init(id: "0E1860BB217C4E2DA93AF366B1D1F283", contentType: .curation),
        .init(id: "E2C641B879A248C982AA0C93B21A690A", contentType: .curation),
        .init(id: "181519A691954BAC8C4825E660E91E45", contentType: .curation),
        .init(id: "Wrong UUID", contentType: .activity),
    ]
    return HStack {
        ForEach(curations) { curation in
            TileItem(curation)
        }
    }
}

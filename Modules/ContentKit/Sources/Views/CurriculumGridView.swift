// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - CurriculumGridView

public struct CurriculumGridView: View {
    // MARK: Lifecycle

    public init(curriculums: [Curriculum]? = nil, onActivitySelected: ((Activity) -> Void)?) {
        self.curriculums = curriculums ?? []
        self.onActivitySelected = onActivitySelected
    }

    // MARK: Public

    public var body: some View {
        LazyVGrid(columns: self.columns) {
            ForEach(self.curriculums) { curriculum in
                NavigationLink(destination:
                    CurriculumDetailsView(curriculum: curriculum, onActivitySelected: self.onActivitySelected)
                ) {
                    GroupBox {
                        VStack(spacing: 10) {
                            Image(uiImage: curriculum.details.iconImage)
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .frame(width: 150)

                            Text(curriculum.details.title)
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Color.primary)

                            Text(curriculum.details.subtitle ?? "")
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Color.secondary)

                            Spacer()

                            Button(l10n.language == .french ? "Découvrir" : "Discover") {}
                                .buttonStyle(.bordered)
                                .allowsHitTesting(false)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
        }
        .padding()
    }

    // MARK: Internal

    let curriculums: [Curriculum]
    let onActivitySelected: ((Activity) -> Void)?

    // MARK: Private

    private let columns = Array(repeating: GridItem(), count: 3)
    @ObservedObject private var styleManager: StyleManager = .shared
}

// MARK: - l10n.CurriculumGridView

extension l10n {
    enum CurriculumGridView {
        static let buttonLabel = LocalizedString("contentkit.curriculum_grid_view.button_label",
                                                 value: "Discover",
                                                 comment: "Discover button label of CurriculumGridView ")
    }
}

#Preview {
    NavigationStack {
        CurriculumGridView(
            curriculums: ContentKit.allCurriculums,
            onActivitySelected: { _ in
                print("Activity Selected")
            }
        )
    }
}

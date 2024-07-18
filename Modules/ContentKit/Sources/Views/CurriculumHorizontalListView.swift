// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - CurriculumHorizontalListView

public struct CurriculumHorizontalListView: View {
    // MARK: Lifecycle

    public init(curriculums: [Curriculum]? = nil, onActivitySelected: ((Activity) -> Void)?) {
        self.curriculums = curriculums ?? []
        self.onActivitySelected = onActivitySelected
    }

    // MARK: Public

    public var body: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .firstTextBaseline) {
                ForEach(self.curriculums) { curriculum in
                    NavigationLink(destination:
                        CurriculumDetailsView(curriculum: curriculum, onActivitySelected: self.onActivitySelected)
                    ) {
                        GroupBox {
                            VStack(spacing: 10) {
                                Image(uiImage: curriculum.details.iconImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150, height: 150)
                                    .clipShape(RoundedRectangle(cornerRadius: 10 / 57 * 150))
                                    .fixedSize(horizontal: false, vertical: true)

                                Text(curriculum.details.title)
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(Color.primary)
                                    .fixedSize(horizontal: false, vertical: true)

                                Text(curriculum.details.subtitle ?? "")
                                    .font(.body)
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(Color.secondary)
                                    .fixedSize(horizontal: false, vertical: true)

                                Spacer()

                                Button(String(l10n.CurriculumHorizontalListView.buttonLabel.characters)) {}
                                    .buttonStyle(.bordered)
                                    .allowsHitTesting(false)
                            }
                            .frame(width: 280)
                        }
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
    private let rows = [GridItem()]
    @ObservedObject private var styleManager: StyleManager = .shared
}

// MARK: - l10n.CurriculumHorizontalListView

extension l10n {
    enum CurriculumHorizontalListView {
        static let buttonLabel = LocalizedString("content_kit.curriculum_grid_view.button_label",
                                                 bundle: ContentKitResources.bundle,
                                                 value: "Discover",
                                                 comment: "Discover button label of CurriculumGridView ")
    }
}

#Preview {
    NavigationStack {
        ScrollView {
            VStack {
                Section {
                    CurriculumHorizontalListView(
                        curriculums: ContentKit.allCurriculums,
                        onActivitySelected: { _ in
                            print("Activity Selected")
                        }
                    )
                }

                Section {
                    CurriculumHorizontalListView(
                        curriculums: ContentKit.allCurriculums,
                        onActivitySelected: { _ in
                            print("Activity Selected")
                        }
                    )
                }

                Section {
                    CurriculumHorizontalListView(
                        curriculums: ContentKit.allCurriculums,
                        onActivitySelected: { _ in
                            print("Activity Selected")
                        }
                    )
                }

                Section {
                    CurriculumHorizontalListView(
                        curriculums: ContentKit.allCurriculums,
                        onActivitySelected: { _ in
                            print("Activity Selected")
                        }
                    )
                }
            }
        }
    }
}

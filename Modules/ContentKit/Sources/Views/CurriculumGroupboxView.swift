// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import AccountKit
import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - CurriculumGroupboxView

public struct CurriculumGroupboxView: View {
    // MARK: Lifecycle

    public init(curriculum: Curriculum) {
        self.curriculum = curriculum
    }

    // MARK: Public

    public var body: some View {
        GroupBox {
            VStack {
                HStack {
                    Image(systemName: "graduationcap")
                        .foregroundStyle(Color.secondary)

                    Text(l10n.CurriculumGroupboxView.curriculumLabel)
                        .foregroundStyle(Color.secondary)

                    Spacer()

                    #if DEVELOPER_MODE || TESTFLIGHT_BUILD
                        if let currentCaregiverID = self.caregiverManagerViewModel.currentCaregiver?.id {
                            Button {}
                                label: {
                                    Menu {
                                        if self.rootAccountViewModel.isCurriculumSaved(curriculumID: self.curriculum.uuid) {
                                            Button(role: .destructive) {
                                                self.rootAccountViewModel.removeSavedCurriculum(curriculumID: self.curriculum.uuid)
                                            } label: {
                                                Label("Delete from Library", systemImage: "trash")
                                            }
                                        } else {
                                            Button {
                                                self.rootAccountViewModel.addSavedCurriculum(
                                                    curriculumID: self.curriculum.uuid,
                                                    caregiverID: currentCaregiverID
                                                )
                                            } label: {
                                                Label("Add to Library", systemImage: "plus")
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "ellipsis")
                                    }
                                    .buttonStyle(TranslucentButtonStyle(color: self.styleManager.accentColor!))
                                }
                        }
                    #endif
                }

                VStack(spacing: 10) {
                    Image(uiImage: self.curriculum.details.iconImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 10 / 57 * 150))

                    Text(self.curriculum.details.title)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.primary)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(self.curriculum.details.subtitle ?? "")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.secondary)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer()

                    HStack(alignment: .center) {
                        Spacer()

                        Text(l10n.CurriculumGroupboxView.activityCountLabel(self.curriculum.activities.count))
                            .font(.caption.bold())
                            .foregroundStyle(Color.secondary)

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.title3)
                            .foregroundStyle(Color.secondary)
                    }
                }
            }
            .frame(width: 280)
        }
    }

    // MARK: Private

    private let curriculum: Curriculum

    @ObservedObject private var styleManager: StyleManager = .shared

    @StateObject private var rootAccountViewModel = RootAccountManagerViewModel()
    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()
}

// MARK: - l10n.CurriculumGroupboxView

extension l10n {
    enum CurriculumGroupboxView {
        static let curriculumLabel = LocalizedString("content_kit.curriculum_groupbox_view.curriculum_label",
                                                     bundle: ContentKitResources.bundle,
                                                     value: "Curriculum",
                                                     comment: "CurriculumDetailsView's content type description label")

        static let activityCountLabel = LocalizedStringInterpolation("content_kit.curriculum_groupbox_view.activity_count_label",
                                                                     bundle: ContentKitResources.bundle,
                                                                     value: "%d activity",
                                                                     comment: "Activity count label of CurriculumGroupboxView")
    }
}

#Preview {
    NavigationStack {
        CurriculumGroupboxView(
            curriculum: ContentKit.allCurriculums[0]
        )
    }
}

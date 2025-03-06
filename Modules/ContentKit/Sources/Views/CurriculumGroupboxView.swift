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
                            if self.libraryManagerViewModel.isCurriculumFavoritedByCurrentCaregiver(
                                curriculumID: self.curriculum.uuid,
                                caregiverID: currentCaregiverID
                            ) {
                                Image(systemName: "star.circle")
                                    .font(.system(size: 25))
                                    .foregroundColor(self.styleManager.accentColor ?? .blue)
                            }

                            Menu {
                                self.addOrRemoveButton(curriculum: self.curriculum, caregiverID: currentCaregiverID)
                                Divider()
                                self.addOrRemoveFavoriteButton(curriculum: self.curriculum, caregiverID: currentCaregiverID)
                            } label: {
                                Button {
                                    // Nothing to do
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .bold()
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

                    ZStack {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title3)
                                .foregroundStyle(Color.secondary)
                                .opacity(self.libraryManagerViewModel.isCurriculumSaved(curriculumID: self.curriculum.uuid) ? 1 : 0)

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.title3)
                                .foregroundStyle(Color.secondary)
                        }

                        Text(l10n.CurriculumGroupboxView.activityCountLabel(self.curriculum.activities.count))
                            .font(.caption.bold())
                            .foregroundStyle(Color.secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(width: 280)
        }
    }

    // MARK: Private

    @ObservedObject private var libraryManagerViewModel: LibraryManagerViewModel = .shared
    @ObservedObject private var styleManager: StyleManager = .shared

    @StateObject private var caregiverManagerViewModel = CaregiverManagerViewModel()

    private var libraryManager: LibraryManager = .shared
    private let curriculum: Curriculum

    @ViewBuilder
    private func addOrRemoveButton(curriculum: Curriculum, caregiverID: String) -> some View {
        if self.libraryManagerViewModel.isCurriculumSaved(curriculumID: curriculum.uuid) {
            Button(role: .destructive) {
                self.libraryManager.removeCurriculum(curriculumID: curriculum.uuid)
            } label: {
                Label("Remove from Library", systemImage: "trash")
            }
        } else {
            Button {
                self.libraryManager.addCurriculum(
                    curriculumID: curriculum.uuid,
                    caregiverID: caregiverID
                )
            } label: {
                Label("Add to Library", systemImage: "plus")
            }
        }
    }

    @ViewBuilder
    private func addOrRemoveFavoriteButton(curriculum: Curriculum, caregiverID: String) -> some View {
        if self.libraryManagerViewModel.isCurriculumFavoritedByCurrentCaregiver(
            curriculumID: curriculum.uuid,
            caregiverID: caregiverID
        ) {
            Button {
                self.libraryManager.removeCurriculumFromFavorites(
                    curriculumID: curriculum.uuid,
                    caregiverID: caregiverID
                )
            } label: {
                Label("Undo Favorite", systemImage: "star.slash")
            }
        } else {
            Button {
                self.libraryManager.addCurriculumToLibraryAsFavorite(
                    curriculumID: curriculum.uuid,
                    caregiverID: caregiverID
                )
            } label: {
                Label("Favorite", systemImage: "star")
            }
        }
    }
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

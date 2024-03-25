// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI
import Yams

class CurriculumViewModelDeprecated: ObservableObject, YamlFileDecodable {
    // MARK: - CurriculumList Published properties

    @Published var currentCurriculumCategory: CurriculumCategories = .emotionRecognition
    @Published var availableCurriculums: [CurriculumDeprecated] = []

    // MARK: - Current || selected Curriculum Published properties

    @Published var currentCurriculum = CurriculumDeprecated()
    @Published var currentCurriculumSelectedActivityID: UUID?
    @Published var selectedCurriculumHeaderTitle: String = ""
    @Published var selectedCurriculumRank: String = ""
    @Published var selectedCurriculumIcon: String = ""
    @Published var selectedCurriculumDescription: String = ""

    // MARK: - ActivityList -> will not stay here - list activities files from the Bundle instead

    @Published var activityFilesCompleteList: [String] = [] // will not stay like that - list files instead

    @Published var selectedCurriculum: Int? = 0 {
        didSet {
            self.currentCurriculum = self.availableCurriculums[self.selectedCurriculum ?? 0]
            self.selectedCurriculumRank = "\(String(describing: (self.selectedCurriculum ?? 0) + 1))/\(self.availableCurriculums.count)"
            self.selectedCurriculumHeaderTitle = self.availableCurriculums[self.selectedCurriculum ?? 0].fullTitle.localized()
            self.selectedCurriculumIcon = self.setCurriculumIcon(for: self.currentCurriculum) // from Yaml later
            self.selectedCurriculumDescription = // swiftlint:disable:next line_length
                "Reconnaissance des 5 émotions primaires \n(peur, joie, tristesse, colère et dégoût) \nà travers les photos de 5 personnes différentes."
        }
    }

    // MARK: - CurriculumList related Work

    func getCurriculumList(category: CurriculumCategories) -> CurriculumListDeprecated {
        do {
            return try decodeYamlFile(withName: category.rawValue, toType: CurriculumListDeprecated.self)
        } catch {
            print("Failed to decode Yaml file with error:", error)
            return CurriculumListDeprecated()
        }
    }

    func populateCurriculumList(category: CurriculumCategories) {
        self.availableCurriculums.removeAll()
        for item in self.getCurriculumList(category: category).curriculums {
            self.availableCurriculums.append(self.getCurriculum(item))
        }
    }

    func getCurriculumsFrom(category: CurriculumCategories) -> [CurriculumDeprecated] {
        var curriculums: [CurriculumDeprecated] = []
        for item in self.getCurriculumList(category: category).curriculums {
            curriculums.append(self.getCurriculum(item))
        }
        return curriculums
    }

    // MARK: - Curriculum-Specific Work

    func getCurriculum(_ title: String) -> CurriculumDeprecated {
        do {
            return try decodeYamlFile(withName: title, toType: CurriculumDeprecated.self)
        } catch {
            print("Failed to decode Yaml file with error:", error)
            return CurriculumDeprecated()
        }
    }

    func setCurriculumDetailNavTitle() -> String {
        "\(self.getCurriculumList(category: self.currentCurriculumCategory).sectionTitle.localized()) \(String(describing: (self.selectedCurriculum ?? 0) + 1))/\(self.availableCurriculums.count)"
    }

    func setCurriculumIcon(for curriculum: CurriculumDeprecated) -> String {
        switch curriculum.id {
            case "ec6fca8d-ac0f-44f8-b641-c9a96f9195c5": "parcours_Emotion_Recognition_Pictures"
            case "7859be5a-9fa5-11ec-b909-0242ac120002": "parcours_Emotion_Recognition_Images"
            case "6d41484b-71ff-4556-a821-ad85ad107c80": "parcours_Emotion_Recognition_Pictograms"
            case "14a71d61-ed35-4122-b7a4-0a8895e06386": "parcours_Emotion_Recognition_Generalization"
            case "a3a4aa6a-1ea5-4a8f-82cd-f3879cfbdc72": "parcours_Emotion_Recognition_Sounds"
            default: "parcours_Emotion_Recognition_Pictures"
        }
    }

    func getCompleteActivityList() {
        for curriculum in self.availableCurriculums {
            self.activityFilesCompleteList.append(contentsOf: curriculum.activities)
        }
    }
}

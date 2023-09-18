// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI
import Yams

class CurriculumViewModel: ObservableObject, YamlFileDecodable {

    // MARK: - CurriculumList Published properties
    @Published var currentCurriculumCategory: CurriculumCategories = .emotionRecognition
    @Published var availableCurriculums: [Curriculum] = []

    // MARK: - Current || selected Curriculum Published properties
    @Published var currentCurriculum = Curriculum()
    @Published var currentCurriculumSelectedActivityID: UUID?
    @Published var selectedCurriculumHeaderTitle: String = ""
    @Published var selectedCurriculumRank: String = ""
    @Published var selectedCurriculumIcon: String = ""
    @Published var selectedCurriculumDescription: String = ""
    @Published var selectedCurriculum: Int? = 0 {
        didSet {
            currentCurriculum = availableCurriculums[selectedCurriculum ?? 0]
            selectedCurriculumRank = "\(String(describing: (selectedCurriculum ?? 0)+1))/\(availableCurriculums.count)"
            selectedCurriculumHeaderTitle = availableCurriculums[selectedCurriculum ?? 0].fullTitle.localized()
            selectedCurriculumIcon = setCurriculumIcon(for: currentCurriculum)  // from Yaml later
            selectedCurriculumDescription =  // swiftlint:disable:next line_length
                "Reconnaissance des 5 émotions primaires \n(peur, joie, tristesse, colère et dégoût) \nà travers les photos de 5 personnes différentes."
        }
    }

    // MARK: - CurriculumList related Work
    func getCurriculumList(category: CurriculumCategories) -> CurriculumList {
        do {
            return try self.decodeYamlFile(withName: category.rawValue, toType: CurriculumList.self)
        } catch {
            print("Failed to decode Yaml file with error:", error)
            return CurriculumList()
        }
    }

    func populateCurriculumList(category: CurriculumCategories) {
        availableCurriculums.removeAll()
        for item in getCurriculumList(category: category).curriculums {
            availableCurriculums.append(getCurriculum(item))
        }
    }

    func getCurriculumsFrom(category: CurriculumCategories) -> [Curriculum] {
        var curriculums: [Curriculum] = []
        for item in getCurriculumList(category: category).curriculums {
            curriculums.append(getCurriculum(item))
        }
        return curriculums
    }

    // MARK: - Curriculum-Specific Work
    func getCurriculum(_ title: String) -> Curriculum {
        do {
            return try self.decodeYamlFile(withName: title, toType: Curriculum.self)
        } catch {
            print("Failed to decode Yaml file with error:", error)
            return Curriculum()
        }
    }

    func setCurriculumDetailNavTitle() -> String {

        "\(getCurriculumList(category: currentCurriculumCategory).sectionTitle.localized()) \(String(describing: (selectedCurriculum ?? 0)+1))/\(availableCurriculums.count)"
    }

    func setCurriculumIcon(for curriculum: Curriculum) -> String {
        switch curriculum.id {
            case "ec6fca8d-ac0f-44f8-b641-c9a96f9195c5": return "parcours_Emotion_Recognition_Pictures"
            case "7859be5a-9fa5-11ec-b909-0242ac120002": return "parcours_Emotion_Recognition_Images"
            case "6d41484b-71ff-4556-a821-ad85ad107c80": return "parcours_Emotion_Recognition_Pictograms"
            case "14a71d61-ed35-4122-b7a4-0a8895e06386": return "parcours_Emotion_Recognition_Generalization"
            case "a3a4aa6a-1ea5-4a8f-82cd-f3879cfbdc72": return "parcours_Emotion_Recognition_Sounds"
            default: return "parcours_Emotion_Recognition_Pictures"
        }
    }

    // MARK: - ActivityList -> will not stay here - list activities files from the Bundle instead
    @Published var activityFilesCompleteList: [String] = []  // will not stay like that - list files instead
    func getCompleteActivityList() {
        for curriculum in availableCurriculums {
            activityFilesCompleteList.append(contentsOf: curriculum.activities)
        }
    }

}

//
//  CustomTypes.swift
//  Leka Emotion
//
//  Created by Mathieu Jeannot on 1/7/22.
//

import Foundation
import SwiftUI

// MARK: - Localized Custom Type for Yaml Translations
struct LocalizedContent: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case enUS = "en_US"
        case frFR = "fr_FR"
    }
    var enUS, frFR: String?
}

// MARK: - Game States for UI Translations
enum ResultType {
    case idle, fail, medium, success
}

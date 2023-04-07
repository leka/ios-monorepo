//
//  CustomTypes.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 9/2/23.
//

import Foundation
import SwiftUI

// MARK: - LekaTextFields type and focus managment
enum FormField {
    case mail, password, confirm, name
}

// MARK: - Localized Custom Type for Yaml Translations
struct LocalizedContent: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case enUS = "en_US"
        case frFR = "fr_FR"
    }
    var enUS: String?
    var frFR: String?
}

// MARK: - Game States for UI Translations
enum ResultType {
    case idle, fail, medium, success
}

// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI
import UniformTypeIdentifiers

// MARK: - CardItem

struct CardItem: Codable, Hashable, Transferable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .cardItem)
        // check other representationTypes: here is Codable representation
        // => Data representation
        // => File representation
    }

    let id: UUID
    let title: String
    let color: String
}

extension UTType {
    static let cardItem = UTType(exportedAs: "io.leka.apf.app.uiexplorer.sequencing.card_item")
}

// MARK: - MockData

enum MockData {
    static let card1 = CardItem(id: UUID(), title: "Card #1", color: "xyloAttach")
    static let card2 = CardItem(id: UUID(), title: "Card #2", color: "lekaOrange")
    static let card3 = CardItem(id: UUID(), title: "Card #3", color: "lekaGreen")
    static let card4 = CardItem(id: UUID(), title: "Card #4", color: "lekaBlue")
    static let card5 = CardItem(id: UUID(), title: "Card #5", color: "bravoHighlights")
}

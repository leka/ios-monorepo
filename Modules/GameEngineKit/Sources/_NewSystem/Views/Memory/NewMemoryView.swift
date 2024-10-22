// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - MemoryViewUIChoiceModel

public struct MemoryViewUIChoiceModel: Identifiable {
    // MARK: Lifecycle

    init(id: String = UUID().uuidString, view: some View = EmptyView()) {
        self.id = id
        self.view = AnyView(view)
    }

    // MARK: Public

    public let id: String

    // MARK: Internal

    let view: AnyView
}

// MARK: - MemoryViewUIChoicesWrapper

public struct MemoryViewUIChoicesWrapper {
    // MARK: Internal

    static let zero = MemoryViewUIChoicesWrapper(choices: [])

    var choices: [MemoryViewUIChoiceModel]

    var choiceSize: CGFloat {
        MemoryGridSize(self.choices.count).choiceSize
    }

    // MARK: Private

    // swiftlint:disable identifier_name

    private enum MemoryGridSize: Int {
        case one = 1
        case two
        case three
        case four
        case five
        case six
        case none

        // MARK: Lifecycle

        init(_ rawValue: Int) {
            switch rawValue {
                case 1:
                    self = .one
                case 2:
                    self = .two
                case 3:
                    self = .three
                case 4:
                    self = .four
                case 5:
                    self = .five
                case 6:
                    self = .six
                default:
                    self = .none
            }
        }

        // MARK: Internal

        var choiceSize: CGFloat {
            switch self {
                case .one,
                     .two:
                    300
                case .three:
                    280
                case .four,
                     .five,
                     .six,
                     .none:
                    240
            }
        }
    }

    // swiftlint:enable identifier_name
}

// MARK: - NewMemoryView

public struct NewMemoryView: View {
    // MARK: Lifecycle

    public init(viewModel: NewMemoryViewViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: Public

    public var body: some View {
        VStack(spacing: 100) {
            HStack(spacing: 100) {
                ForEach(self.viewModel.choices[0...2]) { choice in
                    choice.view
                        .onTapGesture {
                            self.viewModel.onTapped(choice: choice)
                        }
                }
            }

            HStack(spacing: 100) {
                ForEach(self.viewModel.choices[3...5]) { choice in
                    choice.view
                        .onTapGesture {
                            self.viewModel.onTapped(choice: choice)
                        }
                }
            }
        }
    }

    // MARK: Private

    @StateObject private var viewModel: NewMemoryViewViewModel
}

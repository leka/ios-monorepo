// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - TTSViewUIChoiceModel

public struct TTSViewUIChoiceModel: Identifiable {
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

// MARK: - TTSViewUIChoicesWrapper

public struct TTSViewUIChoicesWrapper {
    // MARK: Internal

    static let zero = TTSViewUIChoicesWrapper(choices: [])

    var choices: [TTSViewUIChoiceModel]

    var choiceSize: CGFloat {
        TTSGridSize(self.choices.count).choiceSize
    }

    // MARK: Private

    // swiftlint:disable identifier_name

    private enum TTSGridSize: Int {
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

// MARK: - TTSView

public struct TTSView: View {
    // MARK: Lifecycle

    public init(viewModel: TTSViewViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: Public

    public var body: some View {
        VStack(spacing: 100) {
            HStack(spacing: 100) {
                ForEach(self.viewModel.choices[0...2]) { choice in
                    Button {
                        self.viewModel.onTapped(choice: choice)
                    } label: {
                        choice.view
                    }
                }
            }

            HStack(spacing: 100) {
                ForEach(self.viewModel.choices[3...5]) { choice in
                    Button {
                        self.viewModel.onTapped(choice: choice)
                    } label: {
                        choice.view
                    }
                }
            }
        }
    }

    // MARK: Private

    @StateObject private var viewModel: TTSViewViewModel
}

#Preview {
    // MARK: - TTSEmptyCoordinator

    class TTSEmptyCoordinator: TTSGameplayCoordinatorProtocol {
        var uiChoices = CurrentValueSubject<TTSViewUIChoicesWrapper, Never>(TTSViewUIChoicesWrapper(choices: [
            TTSViewUIChoiceModel(view: TTSCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 1", type: .text, size: 240, state: .idle)),
            TTSViewUIChoiceModel(view: TTSCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 2", type: .text,
                                                                                    size: 240, state: .idle)),
            TTSViewUIChoiceModel(view: TTSCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 3\nCorrect", type: .text,
                                                                                    size: 240, state: .correct)),
            TTSViewUIChoiceModel(view: TTSCoordinatorFindTheRightAnswers.ChoiceView(value: "exclamationmark.triangle.fill", type: .sfsymbol,
                                                                                    size: 240, state: .wrong)),
            TTSViewUIChoiceModel(view: TTSCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 5", type: .text, size: 240, state: .idle)),
            TTSViewUIChoiceModel(view: TTSCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 6", type: .text, size: 240, state: .idle)),
        ]))

        func processUserSelection(choice: TTSViewUIChoiceModel) {
            log.debug("\(choice.id)")
        }
    }

    let coordinator = TTSEmptyCoordinator()
    let viewModel = TTSViewViewModel(coordinator: coordinator)

    return TTSView(viewModel: viewModel)
}

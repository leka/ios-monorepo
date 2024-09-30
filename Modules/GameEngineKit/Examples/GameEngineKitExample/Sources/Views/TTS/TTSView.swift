// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import SwiftUI

// MARK: - TTSChoiceModel

struct TTSChoiceModel: Identifiable {
    // MARK: Lifecycle

    init(id: String = UUID().uuidString, view: some View = EmptyView()) {
        self.id = id
        self.view = AnyView(view)
    }

    // MARK: Internal

    let id: String
    let view: AnyView
}

// MARK: - UIChoices

struct UIChoices {
    // MARK: Internal

    static let zero = UIChoices(choices: [])

    var choices: [TTSChoiceModel]

    var choiceSize: CGFloat {
        TTSGridSize(rawValue: self.choices.count).choiceSize
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

        init(rawValue: Int) {
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

struct TTSView: View {
    // MARK: Lifecycle

    init(viewModel: TTSViewViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: Internal

    @StateObject var viewModel: TTSViewViewModel

    var body: some View {
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
}

#Preview {
    // MARK: - TTSEmptyCoordinator

    class TTSEmptyCoordinator: TTSGameplayCoordinatorProtocol {
        var uiChoices = CurrentValueSubject<UIChoices, Never>(UIChoices(choices: [
            TTSChoiceModel(view: TTSCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 1", type: .text, size: 240, state: .idle)),
            TTSChoiceModel(view: TTSCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 2", type: .text,
                                                                              size: 240, state: .idle)),
            TTSChoiceModel(view: TTSCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 3\nCorrect", type: .text,
                                                                              size: 240, state: .correct)),
            TTSChoiceModel(view: TTSCoordinatorFindTheRightAnswers.ChoiceView(value: "exclamationmark.triangle.fill", type: .sfsymbol,
                                                                              size: 240, state: .wrong)),
            TTSChoiceModel(view: TTSCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 5", type: .text, size: 240, state: .idle)),
            TTSChoiceModel(view: TTSCoordinatorFindTheRightAnswers.ChoiceView(value: "Choice 6", type: .text, size: 240, state: .idle)),
        ]))

        func processUserSelection(choice: TTSChoiceModel) {
            log.debug("\(choice.id)")
        }
    }

    let coordinator = TTSEmptyCoordinator()
    let viewModel = TTSViewViewModel(coordinator: coordinator)

    return TTSView(viewModel: viewModel)
}

// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import SwiftUI

// MARK: - ActionThenTTSViewUIChoiceModel

public struct ActionThenTTSViewUIChoiceModel: Identifiable {
    // MARK: Lifecycle

    public init(id: String = UUID().uuidString, view: some View = EmptyView()) {
        self.id = id
        self.view = AnyView(view)
    }

    // MARK: Public

    public let id: String

    // MARK: Internal

    let view: AnyView
}

// MARK: - ActionThenTTSViewUIChoicesWrapper

public struct ActionThenTTSViewUIChoicesWrapper {
    // MARK: Internal

    static let zero = ActionThenTTSViewUIChoicesWrapper(action: nil, choices: [])

    var action: Exercise.Action?
    var choices: [ActionThenTTSViewUIChoiceModel]

    var choiceSize: CGFloat {
        ActionThenTTSGridSize(self.choices.count).choiceSize(for: self.action)
    }

    // MARK: Private

    // swiftlint:disable identifier_name

    private enum ActionThenTTSGridSize: Int {
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

        func choiceSize(for action: Exercise.Action?) -> CGFloat {
            switch action {
                case .ipad(type: .image(_)),
                     .ipad(type: .sfsymbol(_)):
                    switch self {
                        case .one,
                             .two,
                             .three,
                             .four:
                            180
                        case .five,
                             .six,
                             .none:
                            140
                    }
                default:
                    switch self {
                        case .one,
                             .two:
                            300
                        case .three,
                             .four:
                            240
                        case .five,
                             .six,
                             .none:
                            200
                    }
            }
        }
    }

    // swiftlint:enable identifier_name
}

// MARK: - ActionThenTTSView

public struct ActionThenTTSView: View {
    // MARK: Lifecycle

    public init(viewModel: ActionThenTTSViewViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: Public

    public var body: some View {
        HStack(spacing: 0) {
            Button {
                // nothing to do
            }
            label: {
                ActionButtonView(action: self.viewModel.action)
                    .padding(20)
            }
            .simultaneousGesture(
                TapGesture()
                    .onEnded { _ in
                        withAnimation {
                            self.viewModel.isActionTriggered = true
                        }
                    }
            )

            Divider()
                .opacity(0.4)
                .frame(maxHeight: 500)
                .padding(.vertical, 20)

            Spacer()

            VStack(spacing: 40) {
                HStack(spacing: 40) {
                    ForEach(self.viewModel.choices[0...2]) { choice in
                        Button {
                            self.viewModel.onTapped(choice: choice)
                        } label: {
                            choice.view
                        }
                    }
                }

                HStack(spacing: 40) {
                    ForEach(self.viewModel.choices[3...5]) { choice in
                        Button {
                            self.viewModel.onTapped(choice: choice)
                        } label: {
                            choice.view
                        }
                    }
                }
            }
            .modifier(AnimatableBlur(blurRadius: self.viewModel.isActionTriggered ? 0 : 20))
            .modifier(AnimatableSaturation(saturation: self.viewModel.isActionTriggered ? 1 : 0))
            .disabled(self.viewModel.isActionTriggered ? false : true)

            Spacer()
        }
    }

    // MARK: Internal

    @StateObject var viewModel: ActionThenTTSViewViewModel
}

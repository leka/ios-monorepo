// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Combine
import ContentKit
import DesignKit
import GameEngineKit
import SwiftUI

// MARK: - NewActivityViewModel

class NewActivityViewModel: ObservableObject {
    // MARK: Lifecycle

    init(activity: Activity) {
        self.activity = activity
    }

    // MARK: Internal

    let activity: Activity
}

// MARK: - NewActivityView

public struct NewActivityView: View {
    // MARK: Lifecycle

    init(viewModel: NewActivityViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: Public

    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                VStack(spacing: 15) {
                    Text("Progress bar")
                    Button("Exercise instructions button") {
                        log.warning("Exercise instructions button tapped")
                    }
                    .buttonStyle(.borderedProminent)
                }

                VStack {
                    Spacer()
                    Text("Exercise Interface")
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(.lkBackground)
        .ignoresSafeArea(.all, edges: .bottom)
        .navigationTitle(self.viewModel.activity.details.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    log.warning("Reinforcer animation toggled")
                } label: {
                    Image(systemName: "livephoto")
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    log.warning("Move to previous exercise")
                } label: {
                    Image(systemName: "arrow.backward")
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    log.warning("Move to next exercise")
                } label: {
                    Image(systemName: "arrow.forward")
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    log.warning("Activity information sheet toggled")
                } label: {
                    Image(systemName: "info.circle")
                }
            }
        }
    }

    // MARK: Internal

    @StateObject var viewModel: NewActivityViewModel

    @Environment(\.dismiss) var dismiss
}

#Preview {
    NavigationStack {
        let activity = ContentKit.allTemplateActivities.first!
        let viewModel = NewActivityViewModel(activity: activity)
        NewActivityView(viewModel: viewModel)
    }
}

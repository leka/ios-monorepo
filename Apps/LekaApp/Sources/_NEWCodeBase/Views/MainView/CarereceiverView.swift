// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import LocalizationKit
import SwiftUI

// MARK: - CarereceiverView

struct CarereceiverView: View {
    // MARK: Internal

    @State var carereceiver: Carereceiver_OLD

    var body: some View {
        VStack {
            Button {
                self.rootOwnerViewModel.isEditCarereceiverViewPresented = true
            } label: {
                self.editCarereceiverButtonLabel
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 120, alignment: .center)
            .sheet(isPresented: self.$rootOwnerViewModel.isEditCarereceiverViewPresented) {
                EditCarereceiverView(modifiedCarereceiver: self.$carereceiver)
            }

            Divider()

            Spacer()

            Text(l10n.CarereceiverView.availableSoonLabel)
                .font(.largeTitle)

            Spacer()
        }
        .navigationTitle(self.carereceiver.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: Private

    private let strokeColor: Color = .init(light: UIColor.systemGray3, dark: UIColor.systemGray2)
    @ObservedObject private var rootOwnerViewModel: RootOwnerViewModel = .shared

    private var editCarereceiverButtonLabel: some View {
        Image(self.carereceiver.avatar, bundle: Bundle(for: DesignKitResources.self))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle())
            .overlay {
                Image(systemName: "pencil.circle.fill")
                    .resizable()
                    .renderingMode(.original)
                    .frame(maxWidth: 30, maxHeight: 30)
                    .foregroundStyle(.orange)
                    .padding(5)
                    .offset(x: 35, y: -35)
            }
            .overlay {
                Circle()
                    .strokeBorder(self.strokeColor, lineWidth: 2)
                    .background {
                        Circle()
                            .fill(Color(uiColor: UIColor.systemGray6))
                    }
                    .overlay {
                        Image(uiImage: self.rootOwnerViewModel.getReinforcerFor(index: self.carereceiver.reinforcer))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(5)
                    }
                    .frame(maxWidth: 45)
                    .offset(x: 40, y: 30)
            }
    }
}

// MARK: - l10n.CarereceiverView

// swiftlint:disable line_length

extension l10n {
    enum CarereceiverView {
        static let availableSoonLabel = LocalizedString("lekapp.carereceiver_view.available_soon_label", value: "🚧 Monitoring available soon...", comment: "Temporary content for carereceiver monitoring")
    }
}

// swiftlint:enable line_length

#Preview {
    CarereceiverView(carereceiver: Carereceiver_OLD(name: "Peet", avatar: DesignKitAsset.Avatars.avatarsBoy1a.name, reinforcer: 2))
}

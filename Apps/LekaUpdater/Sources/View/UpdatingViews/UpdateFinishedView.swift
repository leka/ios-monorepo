// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct UpdateFinishedIllustration: View {
    var body: some View {
        ZStack {
            Circle().fill(.white)

            Circle().strokeBorder(DesignKitAsset.Colors.lekaUpdaterRobotUpToDate.swiftUIColor, lineWidth: 5)

            LekaUpdaterAsset.Assets.robotOnBase.swiftUIImage
                .resizable()
                .scaledToFit()
                .frame(height: 180)

            VStack {
                Spacer()

                ZStack {
                    Circle().fill(.white)
                        .frame(height: 56)

                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 56))
                        .foregroundColor(DesignKitAsset.Colors.lekaUpdaterRobotUpToDate.swiftUIColor)
                }
            }
        }
        .frame(width: 250, height: 300)
        .padding()
    }
}

struct UpdateFinishedContentView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text(
                """
                Bravo ! 🥳
                Votre robot est maintenant à jour
                """
            )
            .multilineTextAlignment(.center)
            .font(.title2)
            .bold()

            HStack {
                Button {
                    dismiss()
                } label: {
                    Text("Voir les infos de ce robot")
                        .padding(.horizontal)
                        .foregroundColor(DesignKitAsset.Colors.lekaUpdaterBtnPrincipal.swiftUIColor)
                        .frame(height: 50)
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 10).fill(.white)
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(
                                        DesignKitAsset.Colors.lekaUpdaterBtnPrincipal.swiftUIColor, lineWidth: 2)
                            }
                        )
                        .cornerRadius(10)
                }
                .padding(.trailing)

                Button {
                    // TODO: Go to connection page
                } label: {
                    Text("Mettre à jour un autre robot")
                        .padding(.horizontal)
                        .foregroundColor(.white)
                        .frame(height: 50)
                        .background(DesignKitAsset.Colors.lekaUpdaterBtnPrincipal.swiftUIColor)
                        .cornerRadius(10)
                }
                .buttonStyle(.plain)
                .padding(.leading)
            }
            .shadow(radius: 3, y: 4)
            .padding()
        }
    }
}

struct UpdateFinishedView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            UpdateFinishedIllustration()
                .frame(height: 250)
                .padding(.bottom)
                .padding(.bottom)

            Text("Étape 3/3")
                .font(.title)
                .bold()
                .monospacedDigit()
                .padding()

            VStack {
                UpdateFinishedContentView()
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: 250)
        }
    }
}

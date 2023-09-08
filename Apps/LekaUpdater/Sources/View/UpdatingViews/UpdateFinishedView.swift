// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

struct UpdateFinishedIllustration: View {
    var body: some View {
        ZStack {
            Circle().fill(.white)

            Circle().strokeBorder(DesignKitAsset.Colors.lekaGreen.swiftUIColor, lineWidth: 5)

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
                        .foregroundColor(DesignKitAsset.Colors.lekaGreen.swiftUIColor)
                }
            }
        }
        .frame(width: 250, height: 300)
        .padding()
    }
}

struct UpdateFinishedContentView: View {
    @Environment(\.dismiss) var dismiss

    @Binding var isConnectionViewPresented: Bool

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
                    isConnectionViewPresented = true
                } label: {
                    Text("Mettre à jour un autre robot")
                        .padding(.horizontal)
                        .foregroundColor(DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor)
                        .frame(height: 50)
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 10).fill(.white)
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(
                                        DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor, lineWidth: 2)
                            }
                        )
                        .cornerRadius(10)
                }
                .padding(.trailing)

                Button {
                    let appURL = URL(string: "LekaApp://")
                    let appStoreURL = URL(string: "https://apps.apple.com/fr/app/mon-leka-alpha/id1607862221")!

                    if let appURL = appURL, UIApplication.shared.canOpenURL(appURL) {
                        UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
                    }
                } label: {
                    Text("Lancer LekaApp 🚀")
                        .padding(.horizontal)
                        .foregroundColor(.white)
                        .frame(height: 50)
                        .background(DesignKitAsset.Colors.lekaSkyBlue.swiftUIColor)
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
    @State static var isConnectionViewPresented = false

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
                UpdateFinishedContentView(isConnectionViewPresented: $isConnectionViewPresented)
                Spacer()
            }
            .foregroundColor(DesignKitAsset.Colors.darkGray.swiftUIColor)
            .frame(maxWidth: .infinity, maxHeight: 250)
        }
    }
}

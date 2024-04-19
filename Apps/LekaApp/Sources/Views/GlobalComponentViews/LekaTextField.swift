// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import DesignKit
import SwiftUI

// MARK: - LekaTextField

struct LekaTextField: View {
    // MARK: Internal

    @EnvironmentObject var metrics: UIMetrics

    var label: String
    @Binding var entry: String
    var color: Color = DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor
    @Binding var isEditing: Bool
    var type = FormField.mail
    @FocusState var focused: FormField?
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(self.label)
                // TODO: (@ui/ux) - Design System - replace with Leka font
                .font(.body)
                .foregroundColor(self.color)
                .padding(.leading, 10)
            self.entryField
        }
    }

    // MARK: Private

    @ViewBuilder
    private var entryField: some View {
        TextField("", text: self.$entry) { isEditingNow in
            withAnimation {
                self.isEditing = isEditingNow
            }
        }
        .keyboardType(self.type == .mail ? .emailAddress : .default)
        .textContentType(self.type == .mail ? .emailAddress : .name)
        .submitLabel(self.type == .mail ? .next : .done)
        .onSubmit { self.action() }
        .autocapitalization(.none)
        .autocorrectionDisabled()
        .padding(10)
        .frame(width: 400, height: 44)
        .background(
            DesignKitAsset.Colors.lekaLightGray.swiftUIColor, in: RoundedRectangle(cornerRadius: self.metrics.btnRadius)
        )
        .overlay(
            RoundedRectangle(cornerRadius: self.metrics.btnRadius)
                .stroke(self.focused == self.type ? self.color : .clear, lineWidth: 1)
        )
    }
}

// MARK: - LekaPasswordField

struct LekaPasswordField: View {
    @EnvironmentObject var metrics: UIMetrics

    var label: String
    @Binding var entry: String
    var color: Color = DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor

    var type = FormField.password
    @FocusState var focused: FormField?
    @State private var isSecured: Bool = true
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(self.label)
                // TODO: (@ui/ux) - Design System - replace with Leka font
                .font(.body)
                .foregroundColor(self.color)
                .padding(.leading, 10)
            self.passwordField
        }
    }

    @ViewBuilder
    private var passwordField: some View {
        HStack {
            Group {
                if self.isSecured {
                    SecureField("", text: self.$entry)
                } else {
                    TextField("", text: self.$entry)
                }
            }
            .padding(10)
            .autocapitalization(.none)
            .textContentType(.password)
            .submitLabel(.continue)
            .onSubmit { self.action() }
            .focused(self.$focused, equals: self.type)
            Spacer()
            Button {
                self.isSecured.toggle()
            } label: {
                Image(systemName: self.isSecured ? "eye" : "eye.slash")
                    .foregroundColor(DesignKitAsset.Colors.lekaDarkBlue.swiftUIColor)
                    .padding(10)
            }
            .disabled(self.entry.isEmpty)
        }
        .frame(width: 400, height: 44)
        .background(
            DesignKitAsset.Colors.lekaLightGray.swiftUIColor, in: RoundedRectangle(cornerRadius: self.metrics.btnRadius)
        )
        .overlay(
            RoundedRectangle(cornerRadius: self.metrics.btnRadius)
                .stroke(self.focused == self.type ? self.color : .clear, lineWidth: 1)
        )
    }
}

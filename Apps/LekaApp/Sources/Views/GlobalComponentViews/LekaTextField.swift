//
//  LekaTextField.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 7/12/22.
//

import SwiftUI

struct LekaTextField: View {

    @EnvironmentObject var metrics: UIMetrics

    var label: String
    @Binding var entry: String
    var color: Color = .accentColor
    @Binding var isEditing: Bool
    var type = FormField.mail
    @FocusState var focused: FormField?
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(label)
                .font(metrics.reg17)
                .foregroundColor(color)
                .padding(.leading, 10)
            entryField
        }
    }

    @ViewBuilder
    private var entryField: some View {
        TextField("", text: $entry) { isEditingNow in
            withAnimation {
                isEditing = isEditingNow
            }
        }
        .focused($focused, equals: type)
        .keyboardType(type == .mail ? .emailAddress : .default)
        .textContentType(type == .mail ? .emailAddress : .name)
        .submitLabel(type == .mail ? .next : .done)
        .onSubmit { action() }
        .autocapitalization(.none)
        .autocorrectionDisabled()
        .padding(10)
        .frame(width: 400, height: 44)
        .background(Color("lekaLightGray"), in: RoundedRectangle(cornerRadius: metrics.btnRadius))
        .overlay(
            RoundedRectangle(cornerRadius: metrics.btnRadius)
                .stroke(focused == type ? color : .clear, lineWidth: 1)
        )
    }
}

struct LekaPasswordField: View {

    @EnvironmentObject var metrics: UIMetrics

    var label: String
    @Binding var entry: String
    var color: Color = .accentColor

    var type = FormField.password
    @FocusState var focused: FormField?
    @State private var isSecured: Bool = true
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(label)
                .font(metrics.reg17)
                .foregroundColor(color)
                .padding(.leading, 10)
            passwordField
        }
    }

    @ViewBuilder
    private var passwordField: some View {
        HStack {
            Group {
                if isSecured {
                    SecureField("", text: $entry)
                } else {
                    TextField("", text: $entry)
                }
            }
            .padding(10)
            .autocapitalization(.none)
            .textContentType(.password)
            .submitLabel(.continue)
            .onSubmit { action() }
            .focused($focused, equals: type)
            Spacer()
            Button {
                isSecured.toggle()
            } label: {
                Image(systemName: isSecured ? "eye" : "eye.slash")
                    .foregroundColor(.accentColor)
                    .padding(10)
            }
            .disabled(entry.isEmpty)
        }
        .frame(width: 400, height: 44)
        .background(Color("lekaLightGray"), in: RoundedRectangle(cornerRadius: metrics.btnRadius))
        .overlay(
            RoundedRectangle(cornerRadius: metrics.btnRadius)
                .stroke(focused == type ? color : .clear, lineWidth: 1)
        )
    }
}

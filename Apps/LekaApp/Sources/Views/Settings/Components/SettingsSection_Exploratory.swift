//
//  SettingsSection_Exploratory.swift
//  LekaTestBucket
//
//  Created by Mathieu Jeannot on 16/3/23.
//

import SwiftUI

struct SettingsSection_Exploratory: View {

    @EnvironmentObject var settings: SettingsViewModel
    @EnvironmentObject var metrics: UIMetrics

    var body: some View {
        Section {
            LabeledContent {
                Toggle("Mode exploratoire", isOn: $settings.exploratoryModeIsOn)
                    .toggleStyle(SwitchToggleStyle(tint: Color("lekaSkyBlue")))
                    .labelsHidden()
            } label: {
                Text("Le mode exploratoire vous permet de découvrir les contenus sans enregistrer l'utilisation")
                    .font(metrics.reg13)
                    .foregroundColor(Color("lekaDarkGray"))
                    .frame(maxWidth: 300)
            }
            .frame(maxHeight: 52)
        } header: {
            HStack {
                Image(systemName: "binoculars.fill")
                Text("Mode exploratoire")
            }
            .font(metrics.reg15)
            .foregroundColor(.accentColor)
            .headerProminence(.increased)
        }
    }
}

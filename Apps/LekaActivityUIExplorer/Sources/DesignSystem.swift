// Leka - iOS Monorepo
// Copyright 2023 APF France handicap
// SPDX-License-Identifier: Apache-2.0

import SwiftUI

struct DesignSystem: View {
    @Environment(\.dismiss) var dismiss

    @State var darkModeOn: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 50) {
                        VStack(alignment: .leading, spacing: 10) {
                            TitleView(title: "Fonts")
                            FontsView()
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            TitleView(title: "Buttons")
                            ButtonsView()
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            TitleView(title: "Colors (SwiftUI)")
                            ColorsView()
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            TitleView(title: "Colors (UIColors)")
                            UIColorsView()
                        }
                    }
                }

            }
            .padding()
            .navigationTitle("Design System")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Toggle(isOn: $darkModeOn) {
                        Image(systemName: "circle.lefthalf.filled")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                    }
                }
            }
        }
        .preferredColorScheme(darkModeOn ? .dark : .light)
    }
}

struct TitleView: View {
    let title: String
    var body: some View {
        Text(title)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .font(.largeTitle)
            .background(.gray)
            .foregroundStyle(.white)
    }
}

struct FontsView: View {

    struct FontView: View {
        let font: Font

        var body: some View {
            VStack(alignment: .leading) {
                Text(fontName)
                Text("The quick brown fox jumps over the lazy dog")
            }
            .font(font)
        }

        private var fontName: String {
            switch font {
                case .largeTitle:
                    return "Large Title"
                case .title:
                    return "Title"
                case .title2:
                    return "Title 2"
                case .title3:
                    return "Title 3"
                case .headline:
                    return "Headline"
                case .subheadline:
                    return "Subheadline"
                case .body:
                    return "Body"
                case .callout:
                    return "Callout"
                case .caption:
                    return "Caption"
                case .caption2:
                    return "Caption 2"
                case .footnote:
                    return "Footnote"
                default:
                    return "Unknown"
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            FontView(font: .largeTitle)
            FontView(font: .title)
            FontView(font: .title2)
            FontView(font: .title3)
            FontView(font: .headline)
            FontView(font: .subheadline)
            FontView(font: .body)
            FontView(font: .callout)
            FontView(font: .caption)
            FontView(font: .caption2)
            FontView(font: .footnote)
        }
    }
}

struct ColorsView: View {

    struct ColorView: View {
        @Environment(\.self) var environment

        let color: Color

        init(color: Color) {
            self.color = color
        }

        init(uiColor: UIColor) {
            self.color = Color(uiColor: uiColor)
        }

        var body: some View {
            HStack {
                Rectangle()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                VStack(alignment: .leading) {
                    Text("\(color.description): \(String(describing: color.resolve(in: environment).description))")
                    Text("The quick brown fox jumps over the lazy dog")

                }
            }
            .foregroundColor(color)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ColorView(color: .primary)
            ColorView(color: .secondary)
            ColorView(color: .accentColor)

            Divider()

            ColorView(color: .black)
            ColorView(color: .gray)
            ColorView(color: .white)

            Divider()

            ColorView(color: .red)
            ColorView(color: .orange)
            ColorView(color: .yellow)
            ColorView(color: .green)
            ColorView(color: .mint)
            ColorView(color: .teal)
            ColorView(color: .cyan)
            ColorView(color: .blue)
            ColorView(color: .indigo)
            ColorView(color: .purple)
            ColorView(color: .pink)
            ColorView(color: .brown)

            Divider()
            ColorView(color: Color(hex: 0xAFCE36))
            ColorView(color: Color(hex: 0x0A579B))
            ColorView(color: Color(hex: 0xCFEBFC))

        }
    }

}

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.displayP3, red: red, green: green, blue: blue, opacity: opacity)
    }
}

struct UIColorsView: View {

    struct ColorView: View {
        @Environment(\.self) var environment

        let color: UIColor

        init(color: UIColor) {
            self.color = color
        }

        var body: some View {
            HStack {
                Rectangle()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                VStack(alignment: .leading) {
                    Text("\(color.accessibilityName): \(color.hex.uppercased())")
                    Text("The quick brown fox jumps over the lazy dog")

                }
            }
            .foregroundColor(Color(uiColor: color))
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Adaptable colors")
                .font(.title2)
            ColorView(color: .systemRed)
            ColorView(color: .systemOrange)
            ColorView(color: .systemYellow)
            ColorView(color: .systemGreen)
            ColorView(color: .systemMint)
            ColorView(color: .systemTeal)
            ColorView(color: .systemCyan)
            ColorView(color: .systemBlue)
            ColorView(color: .systemIndigo)
            ColorView(color: .systemPurple)
            ColorView(color: .systemPink)
            ColorView(color: .systemBrown)

            Text("Adaptable gray colors")
                .font(.title2)
            ColorView(color: .systemGray)
            ColorView(color: .systemGray2)
            ColorView(color: .systemGray3)
            ColorView(color: .systemGray4)
            ColorView(color: .systemGray5)
            ColorView(color: .systemGray6)

            Text("Fixed colors")
                .font(.title2)
            ColorView(color: .black)
            ColorView(color: .darkGray)
            ColorView(color: .gray)
            ColorView(color: .lightGray)
            ColorView(color: .white)

            ColorView(color: .red)
            ColorView(color: .orange)
            ColorView(color: .yellow)
            ColorView(color: .green)
            ColorView(color: .cyan)
            ColorView(color: .blue)
            ColorView(color: .purple)
            ColorView(color: .magenta)
            ColorView(color: .brown)
        }
    }

}

extension UIColor {
    var hex: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0

        getRed(&r, green: &g, blue: &b, alpha: &a)

        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0

        return String(format: "#%06x", rgb)
    }
}

struct ButtonsView: View {

    let colors: [Color] = [
        .primary,
        .secondary,
        .accentColor,
        .red,
        .orange,
        .yellow,
        .green,
        .mint,
        .teal,
        .cyan,
        .blue,
        .indigo,
        .purple,
        .pink,
        .brown,
        Color(hex: 0xAFCE36),
        Color(hex: 0x0A579B),
        Color(hex: 0xCFEBFC),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                ScrollView(.horizontal) {
                    HStack(spacing: 40) {
                        VStack(alignment: .leading) {
                            Button("automatic default") {}
                                .buttonStyle(.automatic)

                            Button("bordered default") {}
                                .buttonStyle(.bordered)

                            Button("borderedProminent default") {}
                                .buttonStyle(.borderedProminent)

                            Button("borderless default") {}
                                .buttonStyle(.borderless)
                            Button("custom bordered default") {}
                                .buttonStyle(.robotControlBorderedButtonStyle())
                        }

                        ForEach(colors, id: \.self) { color in
                            VStack(alignment: .leading) {
                                Button("automatic tint \(color.description)") {}
                                    .buttonStyle(.automatic)
                                    .tint(color)

                                Button("bordered tint \(color.description)") {}
                                    .buttonStyle(.bordered)
                                    .tint(color)

                                Button("borderedProminent tint \(color.description)") {}
                                    .buttonStyle(.borderedProminent)
                                    .tint(color)

                                Button("borderless tint \(color.description)") {}
                                    .buttonStyle(.borderless)
                                    .tint(color)

                                Button("custom bordered \(color.description)") {}
                                    .buttonStyle(.robotControlBorderedButtonStyle(foreground: color, border: color))
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    DesignSystem()
}

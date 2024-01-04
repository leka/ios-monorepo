// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

//
//  DownAttributedString.swift
//  Down-SwiftUI-Example
//
//  Created by Mikhail Ivanov on 01.06.2021.
//  Copyright © 2021 Down. All rights reserved.
//
import SwiftUI

// MARK: - MarkdownObservable

// TODO(@ladislas): reimport when Down is fixed
// import Down

class MarkdownObservable: ObservableObject {
    // MARK: Lifecycle

    init(text: String) {
        self.text = text
    }

    // MARK: Public

    @Published public var textView = UITextView()
    public let text: String
}

// MARK: - MarkdownRepresentable

struct MarkdownRepresentable: UIViewRepresentable {
    // MARK: Lifecycle

    init(height: Binding<CGFloat>) {
        _dynamicHeight = height
    }

    // MARK: Internal

    class Coordinator: NSObject {
        // MARK: Lifecycle

        init(text: UITextView) {
            self.textView = text
        }

        //		func textAttachmentDidLoadImage(textAttachment: AsyncImageLoad, displaySizeChanged: Bool)
        //		{
        //			if displaySizeChanged
        //			{
        //				textView.layoutManager.setNeedsLayout(forAttachment: textAttachment)
        //			}
        //
        //			// always re-display, the image might have changed
        //			textView.layoutManager.setNeedsDisplay(forAttachment: textAttachment)
        //		}

        // MARK: Public

        // }, AsyncImageLoadDelegate {
        public var textView: UITextView
    }

    @Binding var dynamicHeight: CGFloat
    @EnvironmentObject var markdownObject: MarkdownObservable

    func makeCoordinator() -> Coordinator {
        Coordinator(text: self.markdownObject.textView)
    }

    func makeUIView(context _: Context) -> UITextView {
        // TODO(@ladislas): reimport when Down is fixed
        // let down = Down(markdownString: markdownObject.text)
        // let attributedText = try? down.toAttributedString(styler: DownStyler())//delegate: context.coordinator))

        // TODO(@ladislas): reimport when Down is fixed
        // let attributedText = try? down.toAttributedString(styler: DownStyler())
        let attributedText = NSMutableAttributedString(
            string: "TODO(@ladislas): use real markdown when Down is fixed")

        self.markdownObject.textView.attributedText = attributedText
        self.markdownObject.textView.textAlignment = .left
        self.markdownObject.textView.isScrollEnabled = false
        self.markdownObject.textView.isUserInteractionEnabled = true
        self.markdownObject.textView.showsVerticalScrollIndicator = false
        self.markdownObject.textView.showsHorizontalScrollIndicator = false
        self.markdownObject.textView.isEditable = false
        self.markdownObject.textView.backgroundColor = .clear
        self.markdownObject.textView.textColor = UIColor(named: "darkGray")
        // markdownObject.textView.font = UIFont(name: "SF Pro Regular", size: 14)

        self.markdownObject.textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        self.markdownObject.textView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        return self.markdownObject.textView
    }

    func updateUIView(_ uiView: UITextView, context _: Context) {
        DispatchQueue.main.async {
            //			uiView.textColor = UIColor(named: "darkGray")

            self.dynamicHeight =
                uiView.sizeThatFits(
                    CGSize(
                        width: uiView.bounds.width,
                        height: CGFloat.greatestFiniteMagnitude
                    )
                )
                .height
        }
    }
}

// MARK: - DownAttributedString

struct DownAttributedString: View {
    // MARK: Lifecycle

    init(text: String) {
        self.markdownString = text
        self.markdownObject = MarkdownObservable(text: text)
    }

    // MARK: Internal

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                MarkdownRepresentable(height: self.$height)
                    .frame(height: self.height)
                    .environmentObject(self.markdownObject)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: Private

    @ObservedObject private var markdownObject: MarkdownObservable
    private var markdownString: String

    @State private var height: CGFloat = .zero
}

//
//  DownAttributedString.swift
//  Down-SwiftUI-Example
//
//  Created by Mikhail Ivanov on 01.06.2021.
//  Copyright © 2021 Down. All rights reserved.
//
import SwiftUI

// TODO(@ladislas): reimport when Down is fixed
// import Down

class MarkdownObservable: ObservableObject {
	@Published public var textView = UITextView()
	public let text: String

	init(text: String) {
		self.text = text
	}
}

struct MarkdownRepresentable: UIViewRepresentable {
	@Binding var dynamicHeight: CGFloat
	@EnvironmentObject var markdownObject: MarkdownObservable

	init(height: Binding<CGFloat>) {
		self._dynamicHeight = height
	}

	func makeCoordinator() -> Coordinator {
		Coordinator(text: markdownObject.textView)
	}

	func makeUIView(context: Context) -> UITextView {

		// TODO(@ladislas): reimport when Down is fixed
		// let down = Down(markdownString: markdownObject.text)
		// let attributedText = try? down.toAttributedString(styler: DownStyler())//delegate: context.coordinator))

		// TODO(@ladislas): reimport when Down is fixed
		// let attributedText = try? down.toAttributedString(styler: DownStyler())
		let attributedText = NSMutableAttributedString.init(
			string: "TODO(@ladislas): use real markdown when Down is fixed")

		markdownObject.textView.attributedText = attributedText
		markdownObject.textView.textAlignment = .left
		markdownObject.textView.isScrollEnabled = false
		markdownObject.textView.isUserInteractionEnabled = true
		markdownObject.textView.showsVerticalScrollIndicator = false
		markdownObject.textView.showsHorizontalScrollIndicator = false
		markdownObject.textView.isEditable = false
		markdownObject.textView.backgroundColor = .clear
		markdownObject.textView.textColor = UIColor(named: "darkGray")
		// markdownObject.textView.font = UIFont(name: "SF Pro Regular", size: 14)

		markdownObject.textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
		markdownObject.textView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

		return markdownObject.textView
	}

	func updateUIView(_ uiView: UITextView, context: Context) {
		DispatchQueue.main.async {
			//			uiView.textColor = UIColor(named: "darkGray")

			dynamicHeight =
				uiView.sizeThatFits(
					CGSize(
						width: uiView.bounds.width,
						height: CGFloat.greatestFiniteMagnitude)
				)
				.height
		}
	}

	class Coordinator: NSObject {  // }, AsyncImageLoadDelegate {

		public var textView: UITextView

		init(text: UITextView) {
			textView = text
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
	}
}

struct DownAttributedString: View {
	@ObservedObject private var markdownObject: MarkdownObservable
	private var markdownString: String

	@State private var height: CGFloat = .zero

	init(text: String) {
		self.markdownString = text
		self.markdownObject = MarkdownObservable(text: text)
	}

	var body: some View {
		VStack(alignment: .leading) {
			ScrollView {
				MarkdownRepresentable(height: $height)
					.frame(height: height)
					.environmentObject(markdownObject)
			}
		}
		.navigationBarTitleDisplayMode(.inline)
	}
}

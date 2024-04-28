// Leka - iOS Monorepo
// Copyright APF France handicap
// SPDX-License-Identifier: Apache-2.0

import Foundation
import SwiftUI
import UIKit

// MARK: - Pages

struct Pages: UIViewControllerRepresentable {
    typealias UIViewControllerType = StoryViewController

    let pages: [StoryView.PageView]

    func makeUIViewController(context _: Context) -> StoryViewController {
        StoryViewController(pages: self.pages)
    }

    func updateUIViewController(_: StoryViewController, context _: Context) {
        // nothing to do
    }
}

// MARK: - StoryViewController

// swiftlint:disable identifier_name

class StoryViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    // MARK: Lifecycle

    init(pages: [StoryView.PageView]) {
        self.pages = pages
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    var pageController: UIPageViewController!
    var controllers = [UIViewController]()

    let pages: [StoryView.PageView]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.pageController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        self.pageController.dataSource = self
        self.pageController.delegate = self

        addChild(self.pageController)
        view.addSubview(self.pageController.view)

        for page in self.pages {
            let vc = UIHostingController(rootView: page)
            self.controllers.append(vc)
        }

        self.pageController.setViewControllers([self.controllers[0]], direction: .forward, animated: false)

        self.setupNavigationButtons()
    }

    func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController) {
            if index > 0 {
                return self.controllers[index - 1]
            } else {
                return nil
            }
        }

        return nil
    }

    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = controllers.firstIndex(of: viewController) {
            if index < self.controllers.count - 1 {
                return self.controllers[index + 1]
            } else {
                return nil
            }
        }

        return nil
    }

    // MARK: Private

    private let nextButton = UIButton(type: .system)
    private let prevButton = UIButton(type: .system)

    private func updateButtonVisibility() {
        if let currentViewController = pageController.viewControllers?.first,
           let currentIndex = controllers.firstIndex(of: currentViewController)
        {
            self.prevButton.isHidden = currentIndex == 0
            self.nextButton.isHidden = currentIndex == self.controllers.count - 1
        }
    }

    private func setupNavigationButtons() {
        let nextImage = UIImage(systemName: "arrow.forward")!
        self.nextButton.setImage(nextImage, for: .normal)
        self.nextButton.tintColor = .black
        self.nextButton.addTarget(self, action: #selector(self.goToNextPage), for: .touchUpInside)
        self.nextButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self.nextButton)

        let prevImage = UIImage(systemName: "arrow.backward")!
        self.prevButton.setImage(prevImage, for: .normal)
        self.prevButton.tintColor = .black
        self.prevButton.addTarget(self, action: #selector(self.goToPrevPage), for: .touchUpInside)
        self.prevButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self.prevButton)

        NSLayoutConstraint.activate([
            self.nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            self.nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            self.prevButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            self.prevButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])

        self.updateButtonVisibility()
    }

    @objc private func goToNextPage() {
        if let currentViewController = pageController.viewControllers?.first,
           let currentIndex = controllers.firstIndex(of: currentViewController),
           currentIndex < controllers.count - 1
        {
            let nextViewController = self.controllers[currentIndex + 1]
            self.pageController.setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
            self.updateButtonVisibility()
        }
    }

    @objc private func goToPrevPage() {
        if let currentViewController = pageController.viewControllers?.first,
           let currentIndex = controllers.firstIndex(of: currentViewController),
           currentIndex > 0
        {
            let prevViewController = self.controllers[currentIndex - 1]
            self.pageController.setViewControllers([prevViewController], direction: .reverse, animated: true, completion: nil)
            self.updateButtonVisibility()
        }
    }
}

// swiftlint:enable identifier_name

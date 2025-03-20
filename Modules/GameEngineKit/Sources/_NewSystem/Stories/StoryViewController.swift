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
    @Binding var currentPage: Int

    func makeUIViewController(context _: Context) -> StoryViewController {
        StoryViewController(pages: self.pages, currentPage: self.$currentPage)
    }

    func updateUIViewController(_: StoryViewController, context _: Context) {
        // nothing to do
    }
}

// MARK: - StoryViewController

class StoryViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    // MARK: Lifecycle

    init(pages: [StoryView.PageView], currentPage: Binding<Int>) {
        self.pages = pages
        self._currentPage = currentPage
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    @Binding var currentPage: Int

    var pageController: UIPageViewController!
    var controllers = [UIViewController]()

    let pages: [StoryView.PageView]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.pageController = UIPageViewController(transitionStyle: .pageCurl,
                                                   navigationOrientation: .horizontal,
                                                   options: nil)
        self.pageController.dataSource = self
        self.pageController.delegate = self

        addChild(self.pageController)
        view.addSubview(self.pageController.view)
        self.pageController.view.frame = view.bounds

        self.controllers = self.pages.map { UIHostingController(rootView: $0) }

        if let first = self.controllers.first {
            self.pageController.setViewControllers([first], direction: .forward, animated: false)
            self.currentPage = 0
        }

        self.setupNavigationButtons()
    }

    func pageViewController(_: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        guard let index = controllers.firstIndex(of: viewController), index > 0 else { return nil }
        self.updateButtonVisibility(for: index - 1)
        self.currentPage = index - 1
        return self.controllers[index - 1]
    }

    func pageViewController(_: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let index = controllers.firstIndex(of: viewController), index < self.controllers.count - 1 else { return nil }
        self.updateButtonVisibility(for: index + 1)
        self.currentPage = index + 1
        return self.controllers[index + 1]
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

    private func updateButtonVisibility(for index: Int) {
        self.prevButton.isHidden = index == 0
        self.nextButton.isHidden = index == self.controllers.count - 1
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
            let nextVC = self.controllers[currentIndex + 1]
            self.pageController.setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
            self.currentPage = currentIndex + 1
            self.updateButtonVisibility()
        }
    }

    @objc private func goToPrevPage() {
        if let currentViewController = pageController.viewControllers?.first,
           let currentIndex = controllers.firstIndex(of: currentViewController),
           currentIndex > 0
        {
            let prevVC = self.controllers[currentIndex - 1]
            self.pageController.setViewControllers([prevVC], direction: .reverse, animated: true, completion: nil)
            self.currentPage = currentIndex - 1
            self.updateButtonVisibility()
        }
    }
}

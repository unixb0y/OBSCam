//
//  TutorialController.swift
//  OBSCam
//
//  Created by Davide Toldo on 01.10.20.
//  Copyright © 2020 Davide Toldo. All rights reserved.
//

import UIKit

class TutorialController: UIPageViewController {
    private var currentIndex: Int = 0
    
    private let page1 = TutorialPage1()
    private let page2 = TutorialPage2()
    private let page3 = TutorialPage3()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .secondarySystemBackground
        
        delegate = self
        dataSource = self
        setViewControllers([page1], direction: .forward, animated: true, completion: nil)
    }
}

extension TutorialController: UIPageViewControllerDelegate {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 3
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }
}

extension TutorialController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController == page1 { return nil }
        if viewController == page2 { return page1 }
        if viewController == page3 { return page2 }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController == page3 { return nil }
        if viewController == page2 { return page3 }
        if viewController == page1 { return page2 }
        return nil
    }
}


//
//  ContainerViewController.swift
//  iOS NASA App
//
//  Created by Woodchuck on 3/18/19.
//  Copyright © 2019 Treehouse Island. All rights reserved.
//

import Foundation
import UIKit


class ContainerViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!

    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let thePageViewController = segue.destination as? PageViewController {
            thePageViewController.pageViewDelegate = self
        }
    }
}



extension ContainerViewController: PageViewControllerDelegate {
    
    func pageViewController(pageViewController: PageViewController, didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
        
        print("accessing page control count")
    }
    
    func pageViewController(pageViewController: PageViewController, didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
        
        print("accessing index page control")
    }
    
}




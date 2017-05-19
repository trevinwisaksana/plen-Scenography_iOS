//
//  MotionViewController.swift
//  Scenography
//
//  Created by PLEN Project on 2016/03/02.
//  Copyright © 2016年 PLEN Project. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PageMenu

enum PLTabStyle {
    case none
    case inactiveFaded(fadedAlpha: CGFloat)
}


class PlenMotionPageViewController: UIViewController, CAPSPageMenuDelegate {
    
    // MARK: - PageMenu
    var pageMenu: CAPSPageMenu!
    // Array to keep track of controllers in page menu
    var controllerArray: [PlenMotionTableViewController] = []
    // Keeps track if the page menu has already been setup
    // reloadDataCount is used to count how many times reloadData is called
    var reloadDataCount = 0
    
    // MARK: - RxSwift
    let rx_motionCategories = Variable([PlenMotionCategory]())
    
    var motionCategories: [PlenMotionCategory] {
        get {
            return rx_motionCategories.value
        } set(value) {
            rx_motionCategories.value = value
        }
    }
    
    fileprivate let _disposeBag = DisposeBag()
    
    
    // MARK: - Variables
    var draggable = true {
        didSet {
            reloadData()
        }
    }
    
    
    // MARK: – Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Reload data
        initBindings()
        // Assigning the delegate
        pageMenu.delegate = self
    }
    
    
    // MARK: - Methods
    /// Auto reload data
    fileprivate func initBindings() {
        rx_motionCategories.asObservable().bindNext { [weak self] _ in
            self?.reloadData()
        }.addDisposableTo(_disposeBag)
    }
    
    
    fileprivate func reloadData() {
        
        controllerArray = motionCategories.map {
            
            let controller = UIViewControllerUtil.loadXib(PlenMotionTableViewController.self)
            
            controller.motionCategory = $0
            controller.draggable = draggable
            
            return controller
        }
        
        if reloadDataCount < 2 {
            // Displays the cells on the page menu
            pageMenuSetup()
            // Allows this portion of code to run twice
            reloadDataCount += 1
        }
    }
    
    // MARK: - Methods
    func pageMenuSetup() {
        
        let frame = CGRect(
            x: 0,
            y: 0,
            width: self.view.frame.width,
            height: self.view.frame.height
        )
        
        pageMenu = CAPSPageMenu(
            viewControllers: controllerArray,
            frame: frame,
            pageMenuOptions: nil
        )
        
        guard let pageMenu = pageMenu else { return }
        
        self.view.addSubview(pageMenu.view)
    }
    
    func willMoveToPage(_ controller: UIViewController, index: Int) {
        
    }
    
    
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        
    }

}

//
//  ScrollParentViewController.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 12/30/19.
//  Copyright © 2019 Fiesta Togo Inc. All rights reserved.
//

import UIKit

class ScrollParentViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!

    var pages = [CurrentWeatherViewController]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.dayBackground()
        
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        let page1 = setupNewVC()
        let page2 = setupNewVC()
        let page3 = setupNewVC()
        
        let views: [String: UIView] = ["view": view, "page1": page1.view, "page2": page2.view, "page3": page3.view]
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[page1(==view)]", options: [], metrics: nil, views: views)
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[page1(==view)][page2(==view)][page3(==view)]|", options: [.alignAllTop, .alignAllBottom], metrics: nil, views: views)
        NSLayoutConstraint.activate(verticalConstraints + horizontalConstraints)
    }
    
    private func setupNewVC() -> CurrentWeatherViewController {
        let page = storyboard!.instantiateViewController(identifier: "CurrentWeatherViewController") as! CurrentWeatherViewController

        page.view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(page.view)
        addChild(page)
        page.didMove(toParent: self)
        return page
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

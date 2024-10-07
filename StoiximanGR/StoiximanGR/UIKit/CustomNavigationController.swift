//
//  CustomNavigationController.swift
//  StoiximanGR
//
//  Created by Dionisis Chatzimarkakis on 5/10/24.
//

import Foundation
import UIKit
import SwiftUI

class CustomNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Ensure inline style is always used
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.largeTitleDisplayMode = .never
        super.pushViewController(viewController, animated: animated)
    }
    
}

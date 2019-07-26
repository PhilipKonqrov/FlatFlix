//
//  NoNetworkVC.swift
//  FlatFlix
//
//  Created by Philip Plamenov on 25.07.19.
//  Copyright © 2019 Philip Plamenov. All rights reserved.
//
import Foundation
import UIKit

class NoNetworkVC: UIViewController {
    let network = NetworkManager.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        // If the network is reachable show the main controller
        network.reachability.whenReachable = { _ in
            self.showMainController()
        }
        
    }
    
    private func showMainController() -> Void {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
}

//
//  ViewController.swift
//  AssistTools
//
//  Created by 锋 on 2021/1/8.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        AEMutedTools.shared.isMuted { isMuted in
            print("1111111---\(isMuted)")
        }
    }

}


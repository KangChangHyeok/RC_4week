//
//  PopUpViewController.swift
//  ImageCatch
//
//  Created by 강창혁 on 2022/06/08.
//

import UIKit

class PopUpViewController: UIViewController {

    var getscore = ""
    @IBOutlet weak var myScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myScore.text = getscore
    }
    
    @IBAction func yesButtonTapped(_ sender: UIButton) {
        
        self.presentingViewController?.dismiss(animated: true)
    }
    @IBAction func noButtonTapped(_ sender: UIButton) {
        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exit(0)
        }
        
    }
    

}

//
//  ViewController.swift
//  ImageCatch
//
//  Created by 강창혁 on 2022/06/08.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var gamescore: UILabel!
    @IBOutlet weak var gameFeverTime: UILabel!
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var thridImage: UIImageView!
    @IBOutlet weak var firstLife: UIImageView!
    @IBOutlet weak var secondLife: UIImageView!
    @IBOutlet weak var thridLife: UIImageView!
    
    let imageArr: [UIImage] = [UIImage(named: "potatochip_blue.png")!,UIImage(named: "potatochip_green.png")!,UIImage(named: "potatochip_yellow.png")!]
    var fevertimeper = 0
    var gamestart: Bool = true
    var Life1: Bool = true
    var Life2: Bool = true
    var Life3: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameSetting()
    }
    
    func gameSetting() {
        //처음 게임 실행했을때 점수 0으로 세팅
        self.gamescore.text = "0"
        
        DispatchQueue.global(qos: .userInitiated).async {
            while self.gamestart {
                DispatchQueue.main.async {
                    self.firstImage.image = self.imageArr.randomElement()
                }
                usleep(500000)
            }
        }
        DispatchQueue.global(qos: .userInitiated).async {
            while self.gamestart {
                DispatchQueue.main.async {
                    self.secondImage.image = self.imageArr.randomElement()
                    
                    
                }
                usleep(500000)
            }
        }
        DispatchQueue.global(qos: .userInitiated).async {
            while self.gamestart {
                DispatchQueue.main.async {
                    self.thridImage.image = self.imageArr.randomElement()
                    
                    
                }
                usleep(500000)
            }
        }
    }
    func showPopupV() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let popup = storyboard.instantiateViewController(withIdentifier: "popupVC") as! PopUpViewController
        popup.modalPresentationStyle = .overFullScreen
        popup.modalTransitionStyle = .crossDissolve
        popup.getscore = self.gamescore.text!
        self.present(popup, animated: true) {
            self.reset()
        }
        
    }
    func reset() {
        self.gamescore.text = "0"
        self.firstLife.image = UIImage(named: "banana.png")
        self.secondLife.image = UIImage(named: "banana.png")
        self.thridLife.image = UIImage(named: "banana.png")
        self.gamestart = true
        self.Life1 = true
        self.Life2 = true
        self.Life3 = true
    }
    @IBAction func catchButtonTapped(_ sender: UIButton) {
        //3개의 이미지뷰의 이미지가 같다면 점수 100 증가
        if firstImage.image == secondImage.image && secondImage.image == thridImage.image {
            if var score = Int(self.gamescore.text!) {
                score += Int(100)
                self.gamescore.text = String(score)
            }
//            self.fevertimeper += 25
//            if fevertimeper == 100 {
//
//            }
        }
        //이미지가 같지 않은데 버튼을 눌렀다면 실패가능횟수 - 1
        if firstImage.image != secondImage.image || secondImage.image != thridImage.image || thridImage.image != firstImage.image {
//            self.fevertimeper -= 25
//            if fevertimeper < 0 {
//                fevertimeper = 0
//            }
            if Life1 == true {
                self.firstLife.image = UIImage(named: "x.png")
                Life1 = false
                return
            }
            if Life2 == true {
                self.secondLife.image = UIImage(named: "x.png")
                Life2 = false
                return
            }
            if Life3 == true {
                self.thridLife.image = UIImage(named: "x.png")
                Life3 = false
                showPopupV()
                return
            }
            //5번 연속 성공하면 피버타임 발동(점수 획득 2배, 5번 성공 가능, 실패시 피버타임 종료
            
        }
        
    }
    
}

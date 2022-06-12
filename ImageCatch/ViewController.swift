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
    var fevertime = Timer()
    let imageArr: [UIImage] = [UIImage(named: "potatochip_blue.png")!,UIImage(named: "potatochip_green.png")!,UIImage(named: "potatochip_yellow.png")!]
    //목숨
    enum Life {
        case havethree, havetwo, haveone, havezero
    }
    
    var fevertimeper = 0
    var gamestart: Bool = true //게임 종료시 false로 전환되어 비동기 실행 종료
    var Life = Life.havethree // 목숨 3개로 시작

    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameSetting()
          print("dasdsa")
    }
    //초기 기본 게임 세팅값
    func gameSetting() {
        //처음 게임 실행했을때 점수 0으로 세팅
        self.gamescore.text = "0"
        
        DispatchQueue.global(qos: .userInitiated).async {
            //task 1 -> 2번쓰레드
            print("task1시작")
            while self.gamestart {
                DispatchQueue.main.async {
                    self.firstImage.image = self.imageArr.randomElement()
                }
                sleep(1)
            }
            print("task1종료")
        }
        DispatchQueue.global(qos: .userInitiated).async {
            //task 2 -> 3번쓰레드
            print("task2시작")
            while self.gamestart {
                DispatchQueue.main.async {
                    self.secondImage.image = self.imageArr.randomElement()
                    
                    
                }
                sleep(1)
            }
            print("task2종료")
        }
        DispatchQueue.global(qos: .userInitiated).async {
            //task3  -> 4번쓰레드
            print("task3시작")
            while self.gamestart {
                DispatchQueue.main.async {
                    self.thridImage.image = self.imageArr.randomElement()
                    
                    
                }
                sleep(1)
            }
            print("task3종료")
        }
    }
    //실패가능횟수 다 소진시 커스텀 팝업창으로 이동
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
    //게임 종료시 리소스 모두 초기상태로 리셋
    func reset() {
        self.gamescore.text = "0"
        self.firstLife.image = UIImage(named: "banana.png")
        self.secondLife.image = UIImage(named: "banana.png")
        self.thridLife.image = UIImage(named: "banana.png")
        self.gamestart = true
        self.Life = .havethree
    }
    //fevertime을 위한 timer설저
    func feverTimeTimer() {
        fevertime = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(feverTime), userInfo: nil, repeats: true)
    }
    //출력확인용 타이머 실행 함수?
    @objc func feverTime() {
        print("fevertime!")
    }
    @IBAction func catchButtonTapped(_ sender: UIButton) {
        //3개의 이미지뷰의 이미지가 같다면 점수 100 증가
        if firstImage.image == secondImage.image && secondImage.image == thridImage.image {
            //점수 증가
            if var score = Int(self.gamescore.text!) {
                score += Int(100)
                self.gamescore.text = String(score)
            }
            //피버타임 게이지 증가
            self.fevertimeper += 25
            
            //4번 연속 성공하면 피버타임 발동(점수 획득 2배, 5번 성공 가능, 실패시 피버타임 종료
            if fevertimeper == 25 {
                feverTimeTimer()
            }
        }
        
        //이미지가 같지 않은데 버튼을 눌렀을때
        if firstImage.image != secondImage.image || secondImage.image != thridImage.image || thridImage.image != firstImage.image {

            //실패할 경우 게이지 25 감소, -가 될수 있으므로 if문으로 0으로 설정
            self.fevertimeper -= 25
            if fevertimeper < 0 {
                fevertimeper = 0
            }
            
            //목숨 감소
            switch self.Life {
            case .havethree:
                self.firstLife.image = UIImage(named: "x.png")
                self.Life = .havetwo
            case .havetwo:
                self.secondLife.image = UIImage(named: "x.png")
                self.Life = .haveone
            case .haveone:
                self.thridLife.image = UIImage(named: "x.png")
                self.Life = .havezero
            //게임종료
            case .havezero:
                self.showPopupV()
            }
        }
        
    }
    
}

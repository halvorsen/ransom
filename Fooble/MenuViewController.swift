

import UIKit
import CoreData
import SwiftyStoreKit
import StoreKit


class MenuViewController: UIViewController {
    var timerBool = false
    var count = 0
    var numbersForLevelArray = [Int]()
    var winLoseLabelText = ""
    var resultsLevelsPassedMenu = [AnyObject]()
    var resultsLevelsPassed = [Int]()
    var passedLevels = [Int]()
    var passedLevel = false
    let scrollView = UIScrollView(frame: UIScreen.main.bounds)
    var levelButtons = [UIButton]()
    var tagLevelIdentifier = Int()
    var yScrollCenterLocation: CGFloat = 3000*UIScreen.main.bounds.height/600
    let header = 326*UIScreen.main.bounds.width/750
    let verticalSpacing = (120/750)*(UIScreen.main.bounds.width)
    var isFirstLoadView = true

    let menuX = UIButton()
    var seg = String()
    var campaignUnlocked = false {didSet{print("campaignunlocked changed to: \(campaignUnlocked)")}}
    var levelsPassed = [Int]()
    let myLoadSaveCoreData = LoadSaveCoreData()
    let myColor = PersonalColor()
    
    func addButton(name: UIButton, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, title: String, font: String, fontSize: CGFloat, titleColor: UIColor, bgColor: UIColor, cornerRad: CGFloat, boarderW: CGFloat, boarderColor: UIColor, act:
        Selector, addSubview: Bool) {
        name.frame = CGRect(x: (x/750)*screenWidth, y: (y/1334)*screenHeight, width: width*screenWidth/750, height: height*screenWidth/750)
        name.setTitle(title, for: UIControlState.normal)
        name.titleLabel!.font = UIFont(name: font, size: fontSizeMultiplier*fontSize)
        name.setTitleColor(titleColor, for: .normal)
        name.backgroundColor = bgColor
        name.layer.cornerRadius = cornerRad
        name.layer.borderWidth = boarderW
        name.layer.borderColor = boarderColor.cgColor
        name.addTarget(self, action: act, for: .touchUpInside)
        if addSubview {
            view.addSubview(name)
        }
    }
    func addLabel(name: UILabel, text: String, textColor: UIColor, textAlignment: NSTextAlignment, fontName: String, fontSize: CGFloat, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, lines: Int) {
        
        name.text = text
        name.textColor = textColor
        name.textAlignment = textAlignment
        name.font = UIFont(name: fontName, size: fontSizeMultiplier*fontSize)
        name.frame = CGRect(x: (x/750)*screenWidth, y: (y/1334)*screenHeight, width: (width/750)*screenWidth, height: (height/750)*screenWidth)
        name.numberOfLines = lines
        
    }

    private func setUpLabelsWithCheckmarks() {
        var levelsAddressed = [Int]()
        resultsLevelsPassed = myLoadSaveCoreData.loadDataForLevelsPassed()
        
        for level in resultsLevelsPassed {
            if !levelsPassed.contains(level){
                levelsPassed.append(level)
            }
        }
        if resultsLevelsPassed.count > 0 {
        for i in 1...resultsLevelsPassed.count {
            
            for n in 1...levelButtons.count {
                
                
                if resultsLevelsPassed[i-1] == levelButtons[n-1].tag {
                    
                    
                    if !levelsAddressed.contains(n-1) {
                        levelButtons[n-1].setTitle(nil, for: .normal)
                       
                        let offset = levelButtons[n-1].frame.origin.y - 3*screenHeight/4
                        scrollView.contentOffset.y = offset
                        
                        let image = UIImage(named: "checkmark.png")
                        let checkImageView = UIImageView(image: image!)
                        checkImageView.frame.size = CGSize( width: (38/750)*screenWidth, height: (30/750)*screenWidth)
                        if n < levelButtons.count{
                            
                            yScrollCenterLocation = (levelButtons[n].frame.midY - 400)*(UIScreen.main.bounds.height/600)
                            
                        }///do i return to the last level played or the last level beat. it would probably depend on if you're just opening the app or if you've just come from the menu
                        
                        var xValue = CGFloat()
                        
                        switch (n-1) {
                        case 0,8,16,24,32,40,48:
                            xValue = 0.62*screenWidth
                            
                        case 1,7,9,15,17,23,25,31,33,39,41,47,49:
                            xValue = 0.64*screenWidth - screenWidth / 7
                            
                        case 2,6,10,14,18,22,26,30,34,38,42,46,50:
                            xValue = 0.64*screenWidth - screenWidth / 3.5
                            
                        case 3,5,11,13,19,21,27,29,35,37,43,45,51:
                            xValue = 0.64*screenWidth - screenWidth / 3.5 - screenWidth / 7
                            
                        case 4,12,20,28,36,44,52:
                            xValue = 0.66*screenWidth - 2*screenWidth / 3.5
                            
                        default:
                            break
                        }
                        
                        let xValuePlus = xValue + 0.1174*screenWidth
                        checkImageView.frame.origin.x = xValuePlus
                        checkImageView.frame.origin.y = CGFloat(n-1)*((120/750)*screenWidth)+(26/740)*screenWidth + header
                        //checkImageView.next
                        self.view.addSubview(checkImageView)
                        levelsAddressed.append(n-1)
                    }
                    
                    
                    if !passedLevels.contains(resultsLevelsPassed[i-1]) {
                        passedLevels.append(resultsLevelsPassed[i-1])}
                    
                }
            }
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    var imageViewArray = [UIImageView]()
    private func addButtons() {
        //exit Button
        
        
        let princessImage = UIImage(named: "Princess.png")
        let princessView = UIImageView(image: princessImage)
        princessView.frame = CGRect(x: (450/750)*screenWidth, y: header - (265/750)*screenWidth, width: 263*screenWidth/750, height: 242*screenWidth/750)
      //  self.view.addSubview(princessView)
        
        var n = [Int]()
        for j in 0...42 {
            n.append(43 - j)
        }
        
        for i in 1...43 {
            
            var xValue = CGFloat()
            
            switch (i-1) {
            case 0,8,16,24,32,40:
                xValue = 0.62*screenWidth
                
            case 1,7,9,15,17,23,25,31,33,39,41:
                xValue = 0.64*screenWidth - screenWidth / 7
                
            case 2,6,10,14,18,22,26,30,34,38,42:
                xValue = 0.64*screenWidth - screenWidth / 3.5
                
            case 3,5,11,13,19,21,27,29,35,37,43,45:
                xValue = 0.64*screenWidth - screenWidth / 3.5 - screenWidth / 7
                
            case 4,12,20,28,36,44:
                xValue = 0.66*screenWidth - 2*screenWidth / 3.5
                
            default:
                break
            }
            
            let levelButton = UIButton()
            switch (i-1)%4 {
            case 2: //red
                levelButton.backgroundColor = myColor.pink
            case 3: //light
                levelButton.backgroundColor = myColor.yellow
            case 0: //light
                levelButton.backgroundColor = myColor.blue
            case 1: //teal
                levelButton.backgroundColor = myColor.white
            default:
                break
            }
            
            levelButton.frame.size = CGSize( width: screenWidth / 3.5, height: screenWidth / 9)
            levelButton.frame.origin.x = xValue
            levelButton.frame.origin.y = CGFloat(i-1)*((120/750)*screenWidth) + header
            self.view.addSubview(levelButton)
            levelButton.setTitle(String(n[i-1]), for: UIControlState.normal)
            levelButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*18)
            levelButton.setTitleColor(myColor.background, for: .normal)
            levelButton.tag = n[i-1]
            levelButton.addTarget(self, action: #selector(MenuViewController.levels(_:)), for: .touchUpInside)
            levelButtons.append(levelButton)
        }
        for i in 1...levelButtons.count {
            levelButtons[i-1].layer.cornerRadius = 0.0
            levelButtons[i-1].clipsToBounds = true
            
        }
        
        //top add more levels labels
        let menuHeader1 = UILabel()
        menuHeader1.text = "More Levels Super Soon"
        menuHeader1.textColor = myColor.offWhite
        menuHeader1.textAlignment = NSTextAlignment.right
        menuHeader1.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*15)
        menuHeader1.backgroundColor = myColor.background
        menuHeader1.frame = CGRect(x: screenWidth/2, y: 0, width: screenWidth/2.1, height: (40/750)*screenWidth)
       // view.addSubview(menuHeader1)
        
        
        //bottom dude image
        let image = UIImage(named: "menuIcon.png")
        
        imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0.28*screenWidth, y: 43.15*verticalSpacing + header, width: 0.93*screenWidth/2, height: 0.93*screenWidth/2)
        view.addSubview(imageView)
        imageViewArray.append(imageView)
        //imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(MenuViewController.punchGhost(_:)))
        view.addGestureRecognizer(tap)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(MenuViewController.menuX2(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        menuX.frame = CGRect(x: (25/750)*screenWidth, y: (25/750)*screenWidth, width: 50*screenWidth/750, height: 50*screenWidth/750)
        menuX.setTitle("X", for: UIControlState.normal)
        menuX.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*20)
        menuX.setTitleColor(UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0), for: .normal)
        menuX.addTarget(self, action: #selector(MenuViewController.menuX(_:)), for: .touchUpInside)
        self.view.addSubview(menuX)
        
        
        
    }
    @objc private func punchGhost(_ gesture: UIGestureRecognizer) {
        if imageView.frame.contains(gesture.location(in: view)) {  //gesture.location(in: view)
        imageView.image = #imageLiteral(resourceName: "ghostHurt")
        }
    }
    var imageView = UIImageView()
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.1) {self.scrollView.alpha = 0.9}
        ghostAnimation()
        _ = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(MenuViewController.ghostAnimation), userInfo: nil, repeats: true)
    }
    
    @objc private func ghostAnimation() {
        let rz = drand48()
        if rz > 0.95 {
            wink()
        }
        if rz < 0.1 {
            blink()
        }
        
        let rx = drand48()
        let ry = drand48()
        let x = 4*screenWidth*CGFloat(rx)/5  - screenWidth/6
        let y = 4.3*screenHeight - screenHeight*CGFloat(ry)/4
                UIView.animate(withDuration: 8.0) {
        self.imageView.frame.origin = CGPoint(x: x, y: y)
        }
    }
    
    private func wink() {
        imageView.image = #imageLiteral(resourceName: "ghostWink")
        delay(bySeconds: 0.7) {
            self.imageView.image = #imageLiteral(resourceName: "menuIcon")
        }
        
    }
    
    private func blink() {
        imageView.image = #imageLiteral(resourceName: "ghostBlink")
        delay(bySeconds: 0.2) {
            self.imageView.image = #imageLiteral(resourceName: "menuIcon")
            delay(bySeconds: 0.5) {
                self.imageView.image = #imageLiteral(resourceName: "ghostBlink")
                delay(bySeconds: 0.2) {
                    self.imageView.image = #imageLiteral(resourceName: "menuIcon")
                    
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        
        
        self.view = self.scrollView
        self.scrollView.contentSize = CGSize(width: screenWidth, height: (6000/750)*screenWidth)
        self.scrollView.backgroundColor = myColor.background
        
        let point = CGPoint(x: 0.0, y: yScrollCenterLocation)
        self.scrollView.setContentOffset(point, animated: false)
        
        addButtons()
        
        campaignUnlocked = myLoadSaveCoreData.isCampaignUnlocked()
        
        
        
    }
    let annotationView = UILabel()
    var fillLayer = CAShapeLayer()
    override func viewWillAppear(_ animated: Bool) {
        
        
        
        //  loadData()
        setUpLabelsWithCheckmarks()
        
        
        
        
    }
    
    
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if seg == "game" {
            
            let gameView: GameViewController = segue.destination as! GameViewController
            
            gameView.tagLevelIdentifier = tagLevelIdentifier
            
        } else {
            
        }
    }
    
    
    @objc private func levels(_ sender: UIButton) {
       // let hack = true
        tagLevelIdentifier = sender.tag
        if (levelsPassed.count >= 2*tagLevelIdentifier/3 && campaignUnlocked) {
            seg = "game"
            self.performSegue(withIdentifier: "fromMenuToGame", sender: self)
        } else if tagLevelIdentifier == 1 {
            seg = "game"
            self.performSegue(withIdentifier: "fromMenuToGame", sender: self)
        } else if !campaignUnlocked {
            prepareForPurchase(productId: "ransom.iap.campaign")
        } else {
            sender.setTitle("locked", for: UIControlState.normal)
        }
    }
    
    var backBlack = UILabel()
    var purcha = UIButton()
    var message = UILabel()
    var tru = UIButton()

    func prepareForPurchase(productId: String) {
        backBlack.backgroundColor = myColor.background
        backBlack.alpha = 0.9
        backBlack.frame = CGRect(x: 0, y: 0, width: screenWidth, height: (6000/750)*screenWidth)
        view.addSubview(backBlack)
        view.bringSubview(toFront: backBlack)
        addButton(name: tru, x: 59, y: 5127, width: 633, height: 85, title: "Try Other Modes", font: "HelveticaNeue-Bold", fontSize: 20, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 0, boarderW: 1, boarderColor: myColor.offWhite, act: #selector(MenuViewController.tru(_:)), addSubview: true)
        addButton(name: purcha, x: 59, y: 4989, width: 633, height: 85, title: "Purchase", font: "HelveticaNeue-Bold", fontSize: 20, titleColor: myColor.offWhite, bgColor: .clear, cornerRad: 0, boarderW: 1, boarderColor: myColor.offWhite, act: #selector(MenuViewController.purch(_:)), addSubview: true)
        addLabel(name: message, text: "Campaign Mode Trial Over\n Purchase for $0.99 or\n Try other game modes for free", textColor: myColor.offWhite, textAlignment: .center, fontName: "HelveticaNeue-Bold", fontSize: 18, x: 100, y: 4726, width: 550, height: 200, lines: 0)
        view.addSubview(message)
        
  
    }
    @objc private func tru(_ button: UIButton) {
    self.performSegue(withIdentifier: "fromMenuToIntro", sender: self)
    }
    let progressHUD = ProgressHUD(text: "Loading")
    @objc private func purch(_ button: UIButton) {
       // progressHUD.activityIndictor.frame.origin.y = 5100*screenHeight/1334
        
        self.view.addSubview(progressHUD)
        backBlack.removeFromSuperview()
        tru.removeFromSuperview()
        purcha.removeFromSuperview()
        message.removeFromSuperview()
        

        purchase(productId: "ransom.iap.campaign")
        print("campaignUnlocked Bool: \(campaignUnlocked)")
    }

    
    
    func unlockLevel() -> Int {
        var unlockLevelList = [Int]()
        for i in 2...45 {
            unlockLevelList.append(i)
        }
        var m = 0
        var check = true
        while check {
            
            if passedLevels.contains(unlockLevelList[m]) {
                m += 1
            } else {
                check = false
            }
        }
        return unlockLevelList[m] //returns next level to beat
    }
    
    @objc private func menuX(_ button: UIButton) {
        self.performSegue(withIdentifier: "fromMenuToIntro", sender: self)
    }
    
    @objc private func menuX2(_ gesture: UIGestureRecognizer) {
        
        self.performSegue(withIdentifier: "fromMenuToIntro", sender: self)
        
    }
    
    func purchase(productId: String) {
        SwiftyStoreKit.purchaseProduct(productId) { result in
            switch result {
            case .success( _):
                print("enter1")
                if productId == "ransom.iap.campaign" {
                    self.myLoadSaveCoreData.savePurchase(purchase: "campaign")
                    self.campaignUnlocked = true
                    print("enter2")
                   self.progressHUD.removeFromSuperview()
                }
                
                
            case .error(let error):
                print("error: \(error)")
                print("Purchase Failed: \(error)")
                print("enter5")
                self.progressHUD.removeFromSuperview()
            }
        }
        print("enter5")
    }
    
}

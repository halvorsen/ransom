

import UIKit
import CoreData
//import SwiftyStoreKit
//import StoreKit


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
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    var yScrollCenterLocation: CGFloat = 3000*UIScreen.main.bounds.height/600
    let header = 326*UIScreen.main.bounds.width/750
    let verticalSpacing = (120/750)*(UIScreen.main.bounds.width)
    var isFirstLoadView = true
    var fontSizeMultiplier = UIScreen.main.bounds.width / 375
    let menuX = UIButton()
    var seg = String()
    var campaignUnlocked = false
    var levelsPassed = [Int]()
    let myLoadSaveCoreData = LoadSaveCoreData()
    let myIAP = IAP()

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
        princessView.frame = CGRect(x: (410/750)*screenWidth, y: header - (236/750)*screenWidth, width: 263*screenWidth/750, height: 242*screenWidth/750)
        self.view.addSubview(princessView)
        
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
            case 1: //blue
                levelButton.backgroundColor = UIColor(red: 60/255, green: 54/255, blue: 116/255, alpha: 1.0)
            case 2: //green
                levelButton.backgroundColor = UIColor(red: 69/255, green: 125/255, blue: 59/255, alpha: 1.0)
            case 3: //yellow
                levelButton.backgroundColor = UIColor(red: 190/255, green: 154/255, blue: 35/255, alpha: 1.0)
            case 0: //red
                levelButton.backgroundColor = UIColor(red: 101/255, green: 34/255, blue: 35/255, alpha: 1.0)
            default:
                break
            }
            
            levelButton.frame.size = CGSize( width: screenWidth / 3.5, height: screenWidth / 9)
            levelButton.frame.origin.x = xValue
            levelButton.frame.origin.y = CGFloat(i-1)*((120/750)*screenWidth) + header
            self.view.addSubview(levelButton)
            levelButton.setTitle(String(n[i-1]), for: UIControlState.normal)
            levelButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*18)
            levelButton.setTitleColor(UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1.0), for: .normal)
            levelButton.tag = n[i-1]
            levelButton.addTarget(self, action: #selector(MenuViewController.levels(_:)), for: .touchUpInside)
            levelButtons.append(levelButton)
        }
        for i in 1...levelButtons.count {
            levelButtons[i-1].layer.cornerRadius = 5.0
            levelButtons[i-1].clipsToBounds = true
            
        }
        
        //top add more levels labels
        let menuHeader1 = UILabel()
        menuHeader1.text = "More Levels Super Soon"
        menuHeader1.textColor = UIColor(red: 23/255, green: 23/255, blue: 23/255, alpha: 0.25)
        menuHeader1.textAlignment = NSTextAlignment.right
        menuHeader1.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*15)
        menuHeader1.backgroundColor = UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1.0)
        menuHeader1.frame = CGRect(x: screenWidth/2, y: 0, width: screenWidth/2.1, height: (40/750)*screenWidth)
        view.addSubview(menuHeader1)
        
        
        //bottom dude image
        let image = UIImage(named: "Icon.png")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0.28*screenWidth, y: 43.15*verticalSpacing + header, width: 0.93*screenWidth/2, height: 0.6205*screenWidth)
        view.addSubview(imageView)
        imageViewArray.append(imageView)
        menuX.frame = CGRect(x: (25/750)*screenWidth, y: (25/750)*screenWidth, width: 50*screenWidth/750, height: 50*screenWidth/750)
        menuX.setTitle("X", for: UIControlState.normal)
        menuX.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*30)
        menuX.setTitleColor(UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 1.0), for: .normal)
        menuX.addTarget(self, action: #selector(MenuViewController.menuX(_:)), for: .touchUpInside)
        self.view.addSubview(menuX)
        
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        
        
        self.view = self.scrollView
        self.scrollView.contentSize = CGSize(width: screenWidth, height: (6000/750)*screenWidth)
        self.scrollView.backgroundColor = UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1.0)
        
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
            campaignUnlocked = myIAP.purchase(productId: "ransom.iap.campaign")
        } else {
            sender.setTitle("locked", for: UIControlState.normal)
        }
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
    
    
}

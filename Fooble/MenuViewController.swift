

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
    
    
    
    
    
    //      private func loadData() {
    //        let appDel = (UIApplication.shared.delegate as! AppDelegate)
    //        let context = appDel.persistentContainer.viewContext
    //
    //        let requestLevelsPassed = NSFetchRequest<NSFetchRequestResult>(entityName: "Levels")
    //
    //        do { resultsLevelsPassedMenu = try context.fetch(requestLevelsPassed) } catch  {
    //            print("Could not cache the response \(error)")
    //        }
    //
    //        let requestLives = NSFetchRequest<NSFetchRequestResult>(entityName: "Purchased")
    //
    //        do {
    //            resultsLives = try context.fetch(requestLives) } catch  {
    //                print("Could not cache the response \(error)")
    //        }
    //        let requestHints = NSFetchRequest<NSFetchRequestResult>(entityName: "Purchased2")
    //
    //        do {
    //            resultsHints = try context.fetch(requestHints) } catch  {
    //                print("Could not cache the response \(error)")
    //        }
    //        let requestLevelSkips = NSFetchRequest<NSFetchRequestResult>(entityName: "Purchased3")
    //
    //        do {
    //            resultsLevelSkips = try context.fetch(requestLevelSkips) } catch  {
    //                print("Could not cache the response \(error)")
    //        }
    //        let requestTime = NSFetchRequest<NSFetchRequestResult>(entityName: "Time")
    //
    //        do { resultsTime = try context.fetch(requestTime) } catch  {
    //            print("Could not cache the response \(error)")
    //        }
    //
    //        if resultsLives.count > 20000 {
    //            deleteAllData(entity: "Purchased")
    //        }
    //        if resultsHints.count > 20000 {
    //            deleteAllData(entity: "Purchased2")
    //        }
    //        if resultsLevelSkips.count > 50000 {
    //            deleteAllData(entity: "Purchased3")
    //        }
    //        if resultsTime.count > 10000 {
    //            deleteAllData(entity: "Time")
    //            timestamp = 0.0
    //            saveTimestamp()
    //        }
    //
    //        if isFirstLoadView {
    //            if resultsLives.count > 0 {
    //
    //                lives = resultsLives.last?.value(forKeyPath: "lives") as! Int
    //
    //            } else {
    //                lives = 10
    //            }
    //            if resultsHints.count > 0 {
    //                hintAmount = resultsHints.last?.value(forKeyPath: "hints") as! Int
    //            } else {
    //                hintAmount = 3
    //            }
    //            if resultsLevelSkips.count > 0 {
    //                skipLevelAmount = resultsLevelSkips.last?.value(forKeyPath: "levelSkips") as! Int
    //            } else {
    //                skipLevelAmount = 5
    //            }
    //            if resultsTime.count > 0 {
    //                timestamp = resultsTime.last?.value(forKeyPath: "stamp") as! Double
    //            } else {
    //                timestamp = 0.0
    //            }
    //            checkExtraHintsAndLives()
    //            isFirstLoadView = false
    //        }
    //
    //        saveTimestamp()
    //
    //
    //
    //
    //
    //    }
    //coredata functions end
    
    
    private func setUpLabelsWithCheckmarks() {
        
        if (resultsLevelsPassedMenu.count > 0) && (levelButtons.count > 0) {
            var levelsAddressed = [Int]()
            
            for i in 1...resultsLevelsPassedMenu.count {
                resultsLevelsPassed.append((resultsLevelsPassedMenu[i-1].value(forKeyPath: "name") as? Int)!)
            }
            
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
            levelButton.titleLabel!.font = UIFont(name: "HelveticaNeue-Bold", size: fontSizeMultiplier*16)
            levelButton.setTitleColor(UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1.0), for: .normal)
            levelButton.tag = n[i-1]
            levelButton.addTarget(self, action: #selector(MenuViewController.levels(_:)), for: .touchUpInside)
            levelButtons.append(levelButton)
        }
        for i in 1...levelButtons.count {
            levelButtons[i-1].layer.cornerRadius = 5.0
            levelButtons[i-1].clipsToBounds = true
            
        }
        
        
        let a: CGFloat = 0.25
        
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
        seg = "game"
         tagLevelIdentifier = sender.tag
        self.performSegue(withIdentifier: "fromMenuToGame", sender: self)
        
        //        yScrollCenterLocation = (sender.frame.midY - 400)*(UIScreen.main.bounds.height/600)//sender.frame.midY - screenWidth
        
        //        if passedLevels.contains(tagLevelIdentifier) {
        //            passedLevel = true
        //        } else {
        //            passedLevel = false
        //        }
        //
        //
        //            switch sender.tag {
        //
        //            case 9:
        //
        //                if passedLevels.contains(9) || passedLevels.contains(8){
        //                    numbersForLevelArray = [5,3,1,7,7,2,3,4,4,7,1,6,3,2,6,6,2,1,7,2,7,1,3,5,7,4,3,3,7,3,5,2,2,1,6,3,1,2,5,5,7,1,5,7,4,5,1,4,3,5,5,5,1,5,1,6,4,4,6,7,10,10,10,10,1,4,5,6,1,2,10,10,10,10,1,5,1,4,4,1,10,10,10,10,2,3,6,1,5,1,10,10,10,10,4,6,2,1,4,3]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //
        //            case 12: //verified
        //
        //                if passedLevels.contains(12) || passedLevels.contains(11){numbersForLevelArray = [6, 4, 2, 6, 5, 6, 4, 1, 6, 4, 7, 3, 4, 4, 6, 3, 4, 2, 1, 1, 4, 2, 7, 4, 2, 5, 6, 4, 3, 5, 3, 2, 3, 7, 6, 1, 2, 4, 1, 1, 2, 2, 4, 2, 7, 6, 2, 4, 4, 1, 5, 1, 1, 4, 6, 2, 4, 6, 4, 7, 3, 2, 3, 2, 2, 3, 5, 3, 2, 4, 3, 6, 5, 3, 1, 6, 6, 4, 1, 1, 3, 2, 2, 5, 3, 7, 5, 1, 4, 3, 3, 1, 1, 3, 2, 1, 7, 4, 1, 7]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //
        //            case 13: //verified
        //
        //                if passedLevels.contains(13) || passedLevels.contains(12){
        //                    numbersForLevelArray = [1, 1, 5, 7, 7, 2, 2, 6, 4, 6, 3, 7, 1, 5, 6, 7, 6, 7, 6, 1, 2, 2, 1, 2, 7, 2, 7, 1, 3, 2, 1, 4, 2, 1, 7, 7, 2, 4, 2, 3, 7, 2, 1, 3, 2, 7, 3, 2, 4, 1, 5, 2, 7, 5, 1, 1, 2, 6, 4, 6, 1, 1, 1, 3, 2, 1, 5, 2, 7, 4, 3, 1, 1, 7, 3, 7, 3, 6, 6, 5, 4, 6, 4, 6, 5, 7, 3, 2, 7, 5, 6, 1, 7, 7, 6, 5, 7, 3, 5, 4]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //
        //            case 16:
        //
        //                if passedLevels.contains(16) || passedLevels.contains(15){
        //                    numbersForLevelArray = [3, 2, 10, 1, 8, 4, 4, 8, 5, 4, 5, 5, 5, 4, 2, 4, 4, 2, 7, 10, 3, 10, 10, 4, 7, 8, 6, 1, 1, 2, 5, 6, 1, 6, 5, 1, 6, 8, 9, 10, 4, 6, 4, 8, 1, 1, 5, 6, 3, 5, 4, 6, 3, 2, 2, 6, 4, 9, 4, 2, 4, 7, 3, 8, 5, 9, 9, 4, 2, 5, 3, 2, 9, 10, 4, 8, 9, 5, 8, 3, 1, 9, 4, 8, 3, 5, 9, 1, 3, 7, 4, 3, 4, 3, 10, 9, 9, 10, 5, 7]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //
        //            case 19: //verified
        //
        //                if passedLevels.contains(19) || passedLevels.contains(18){
        //                    numbersForLevelArray = [5, 3, 5, 5, 8, 3, 2, 5, 7, 5, 4, 6, 7, 3, 8, 1, 4, 8, 1, 8, 2, 8, 2, 1, 9, 5, 8, 9, 9, 9, 10, 4, 9, 5, 1, 9, 5, 10, 7, 6, 5, 2, 7, 7, 3, 10, 4, 3, 5, 10, 8, 5, 7, 7, 4, 10, 9, 2, 2, 10, 4, 4, 1, 3, 10, 5, 5, 6, 7, 4, 6, 5, 8, 6, 4, 8, 8, 1, 1, 3, 5, 2, 2, 2, 2, 9, 8, 2, 6, 9, 9, 5, 7, 10, 3, 8, 1, 2, 2, 8]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //
        //            case 22: //verified
        //
        //                if passedLevels.contains(22) || passedLevels.contains(21){
        //                    numbersForLevelArray = [4, 8, 6, 8, 5, 6, 4, 9, 9, 9, 5, 9, 3, 6, 3, 9, 9, 4, 5, 7, 7, 9, 5, 7, 7, 7, 1, 5, 1, 8, 5, 1, 7, 10, 8, 9, 5, 1, 8, 4, 9, 4, 4, 1, 6, 9, 7, 10, 9, 9, 10, 7, 5, 10, 3, 10, 2, 1, 4, 7, 10, 1, 10, 3, 3, 2, 9, 4, 6, 9, 4, 4, 2, 1, 5, 1, 9, 3, 8, 6, 7, 8, 5, 10, 2, 7, 3, 1, 9, 1, 6, 6, 7, 10, 9, 7, 9, 8, 7, 3]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //
        //            case 23: //verified
        //
        //                if passedLevels.contains(23) || passedLevels.contains(22){
        //                    numbersForLevelArray = [9, 1, 1, 2, 2, 1, 2, 3, 2, 3, 4, 2, 1, 7, 9, 8, 6, 5, 5, 7, 4, 9, 7, 1, 4, 5, 3, 6, 8, 10, 1, 6, 1, 8, 9, 10, 7, 4, 8, 2, 4, 6, 8, 4, 9, 6, 1, 8, 3, 2, 7, 10, 7, 6, 6, 8, 2, 8, 9, 10, 8, 8, 4, 1, 3, 3, 6, 9, 3, 5, 3, 7, 9, 7, 7, 10, 3, 9, 6, 5, 4, 4, 8, 4, 2, 7, 4, 2, 2, 3, 1, 7, 6, 10, 3, 8, 3, 9, 9, 6]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //
        //            case 7:
        //
        //                if passedLevels.contains(7) || passedLevels.contains(6){
        //                    numbersForLevelArray = [11,11,1,1,1,1,1,1,11,11,11,11,6,6,7,6,6,6,11,11,11,11,6,3,8,3,4,4,11,11,11,11,2,3,7,1,4,6,11,11,11,11,6,2,1,3,1,7,11,11,11,11,9,8,9,8,9,8,11,11,11,11,9,8,9,8,9,8,11,11,11,11,4,4,4,4,4,4,11,11,11,11,5,5,5,5,5,5,11,11,11,11,9,9,9,9,9,9,11,11]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //
        //            case 3:
        //
        //                if passedLevels.contains(3) || passedLevels.contains(2){
        //                    numbersForLevelArray = [1,2,3,4,2,3,1,4,3,1,5,3,2,4,1,2,4,3,2,4,2,3,1,2,3,5,4,3,4,5,4,3,2,1,2,3,3,2,2,1,4,3,2,3,3,2,4,3,3,1,2,1,2,1,4,3,2,3,2,1,2,3,2,4,4,4,2,1,2,1,1,3,2,4,2,3,4,3,3,2,4,3,2,3,2,1,2,3,3,1,9,9,9,9,9,9,9,9,9,9]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //
        //            case 4:
        //
        //                if passedLevels.contains(4) || passedLevels.contains(3){
        //                    numbersForLevelArray = [11,11,2,7,2,5,2,6,11,11,11,11,2,2,7,6,3,6,11,11,11,11,3,2,7,3,5,3,11,11,11,11,4,2,3,5,2,3,11,11,11,11,1,5,6,4,7,6,11,11,11,11,2,2,1,4,4,2,11,11,11,11,7,7,2,6,2,3,11,11,11,11,7,2,3,3,4,2,11,11,11,11,6,5,2,3,3,1,11,11,11,11,4,3,6,4,5,2,11,11]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //
        //            case 5:
        //
        //                if passedLevels.contains(5) || passedLevels.contains(4){
        //                    numbersForLevelArray = [1,2,3,4,2,3,1,4,3,1,5,3,2,4,1,2,4,3,2,0,2,3,1,2,3,5,4,3,4,5,4,3,2,1,2,3,3,2,2,1,4,3,2,3,3,2,4,3,3,1,2,1,2,1,4,3,2,0,2,1,2,3,2,4,4,4,2,1,2,1,1,3,2,4,2,3,4,3,0,2,4,3,2,3,2,1,2,3,3,1,9,9,9,9,9,9,9,9,9,9]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //
        //            case 6:
        //
        //                if passedLevels.contains(6) || passedLevels.contains(5){
        //                    numbersForLevelArray = [4,4,2,1,2,1,1,3,2,4,2,3,6,2,2,1,4,3,2,3,3,2,4,3,3,1,2,1,2,6,5,3,1,2,4,3,5,6,4,5,3,4,2,1,3,4,5,6,5,4,2,3,1,4,3,3,4,5,2,6,4,6,1,2,6,3,2,1,4,3,6,5,3,2,4,1,2,4,3,1,3,4,5,6,4,5,6,6,5,5,2,2,3,4,4,4,1,2,3,1]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //
        //            case 1: //verified
        //
        //                numbersForLevelArray = [11,11,11,11,11,11,11,11,11,1,11,11,11,11,11,11,11,11,11,1,11,11,11,11,11,11,11,11,11,1,11,11,11,11,11,11,11,11,11,1,11,11,11,11,11,11,11,11,11,1,11,11,11,11,11,11,11,11,11,1,11,11,11,11,11,11,11,11,11,1,8,1,1,1,1,1,1,1,1,1,11,9,11,11,11,11,11,11,11,1,11,9,11,11,11,11,11,11,11,11]
        //                self.performSegue(withIdentifier: "toGame", sender: self)
        //
        //            case 2:
        //
        //                if passedLevels.contains(1) || passedLevels.contains(2) {
        //                    numbersForLevelArray = [7,7,0,4,0,5,0,0,7,7,7,7,0,0,0,0,0,0,7,7,7,7,0,0,0,0,0,0,7,7,7,7,0,0,0,0,0,0,7,7,7,7,0,0,0,0,0,0,7,7,7,7,0,0,0,0,0,0,7,7,7,7,0,0,0,0,0,0,7,7,7,7,0,0,0,0,0,0,7,7,7,7,0,0,0,0,0,0,7,7,7,7,7,9,7,7,7,7,7,7]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //
        //            case 8:
        //
        //                if passedLevels.contains(7) || passedLevels.contains(8){
        //                    numbersForLevelArray = [11,11,4,7,2,7,2,2,11,11,11,11,6,6,5,3,2,7,11,11,11,11,5,1,5,7,3,1,11,11,11,11,2,3,7,1,4,6,11,11,11,11,2,2,1,3,3,7,11,11,11,11,6,3,7,1,11,11,11,11,11,11,2,2,1,5,11,11,11,11,11,11,5,3,1,5,11,11,11,11,11,11,5,6,9,1,11,11,11,11,11,11,4,3,9,7,11,11,11,11]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //
        //
        //
        //
        //            case 10: //verified
        //
        //                if passedLevels.contains(9) || passedLevels.contains(10){
        //                    numbersForLevelArray = [6,7,6,5,4,6,4,3,2,7,2,1,3,4,2,3,4,5,4,1,1,2,4,3,5,5,2,2,5,1,7,4,3,5,2,6,5,5,4,7,1,3,6,7,5,7,7,3,4,2,1,2,3,2,3,2,3,2,3,2,1,2,3,4,3,2,5,3,4,5,4,2,6,4,4,8,4,4,5,9,1,7,7,5,5,7,5,5,4,7,4,8,8,8,8,8,8,8,8,2]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //
        //            case 15: //verified
        //
        //                if passedLevels.contains(15) || passedLevels.contains(14){
        //                    numbersForLevelArray = [4,7,3,1,7,9,2,2,1,9,3,7,6,1,7,7,3,3,2,7,2,5,4,1,7,4,3,2,1,2,1,1,3,6,7,5,1,7,3,2,1,7,2,7,2,3,5,4,2,7,5,3,1,7,6,2,8,2,2,3,8,7,6,1,7,4,5,6,5,7,9,4,5,3,4,5,6,7,4,5,4,7,4,5,5,4,4,7,6,7,5,3,4,5,7,3,6,5,9,9]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //
        //            case 11: //random with 10min
        //
        //print("boo")
        //
        //            case 14: //random with 5min
        //
        //    print("boo")
        //
        //            case 17: //random with 3min
        //
        //print("boo")
        //
        //            case 21: //random with 2min
        //
        //print("boo")
        //
        //            case 25: //random with 1min
        //print("boo")
        //
        //            case 18: //verified
        //
        //                if passedLevels.contains(18) || passedLevels.contains(17){
        //                    numbersForLevelArray = [4, 1, 4, 4, 3, 2, 6, 6, 1, 4, 1, 3, 2, 2, 1, 5, 2, 2, 5, 5, 1, 2, 4, 5, 5, 4, 2, 2, 1, 5, 1, 3, 5, 6, 5, 3, 7, 5, 6, 7, 3, 1, 1, 6, 2, 1, 3, 2, 6, 6, 2, 2, 3, 5, 1, 3, 7, 2, 3, 6, 7, 3, 1, 4, 4, 2, 1, 7, 1, 3, 5, 1, 6, 5, 2, 3, 1, 5, 5, 5,10,10,10,10,9,9,10,10,10,10,10,10,10,10,8,8,10,10,10,10]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //
        //            case 20: //verified
        //
        //                if passedLevels.contains(20) || passedLevels.contains(19){
        //                    numbersForLevelArray = [8,6,5,9,3,2,2,1,9,9,9,9,9,9,9,9,9,9,9,9,8,8,8,8,8,8,8,8,8,8,7,7,7,7,7,7,7,7,7,7,6,6,6,6,6,6,6,6,6,6,5,5,5,5,5,5,5,5,5,5,4,4,4,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //
        //            case 24: //verified
        //
        //                if passedLevels.contains(24) || passedLevels.contains(23){
        //                    numbersForLevelArray = [10,10,10,10,10,10,10,10,10,10, 7, 3, 4, 4, 6, 3, 4, 2, 1, 1, 4, 2, 7, 4, 2, 5, 5, 4, 3, 5, 3, 2, 3, 7, 6, 1, 2, 4, 1, 1, 2, 2, 4, 2, 7, 6, 2, 4, 4, 1, 10, 0, 1, 4, 6, 2, 4, 6, 0, 10, 10,10, 0, 2, 2, 3, 5, 0, 10,10, 10,10,10, 0, 1, 6, 0,10,10,10, 10,10,10,10, 3, 7, 10,10,10,10, 10,10,10,10, 2, 1, 10,10,10,10]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //
        //            case 26:
        //
        //                if passedLevels.contains(26) || passedLevels.contains(25){ //verified, start middle, loop back to the left bottom and release the 9 in #2 position
        //                    numbersForLevelArray = [1, 8, 9, 5, 2, 3, 8, 6, 4, 9, 9, 2, 4, 3, 6, 5, 7, 3, 3, 3, 2, 1, 4, 2, 5, 5, 3, 1, 9, 1, 8, 1, 7, 5, 1, 4, 9, 9, 1, 4, 8, 4, 6, 5, 2, 7, 5, 1, 1, 8, 5, 4, 1, 6, 2, 4, 3, 1, 3, 5, 8, 5, 1, 9, 4, 4, 5, 5, 8, 7, 5, 2, 4, 4, 2, 6, 9, 9, 5, 1, 7, 1, 5, 2, 6, 6, 7, 5, 6, 1, 8, 5, 5, 5, 3, 9, 2, 5, 9, 1]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //
        //            case 27:
        //
        //                if passedLevels.contains(27) || passedLevels.contains(26){
        //                    numbersForLevelArray = [9, 8, 4, 6, 8, 9, 2, 7, 9, 9, 3, 4, 6, 5, 6, 2, 6, 2, 7, 2, 7, 3, 3, 2, 9, 5, 8, 3, 6, 9, 8, 6, 1, 1, 4, 9, 8, 3, 9, 2, 9, 8, 1, 8, 5, 8, 9, 9, 8, 6, 2, 7, 6, 1, 3, 9, 1, 6, 8, 2, 5, 1, 2, 3, 8, 1, 7, 3, 8, 2, 1, 4, 2, 3, 9, 6, 5, 6, 6, 7, 4, 9, 9, 1, 2, 4, 8, 4, 1, 6, 5, 2, 1, 9, 3, 7, 2, 2, 5, 5]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //
        //            case 28:
        //
        //                if passedLevels.contains(28) || passedLevels.contains(27){
        //                    numbersForLevelArray = [2, 7, 9, 5, 2, 2, 9, 1, 4, 5, 1, 1, 1, 4, 2, 5, 3, 3, 5, 7, 1, 6, 6, 7, 3, 6, 8, 5, 9, 8, 3, 1, 8, 5, 4, 7, 5, 7, 8, 1, 3, 5, 8, 9, 6, 4, 5, 5, 1, 2, 9, 4, 9, 4, 5, 8, 8, 4, 6, 8, 9, 5, 7, 3, 2, 2, 3, 5, 3, 7, 7, 4, 3, 1, 5, 8, 7, 1, 5, 4, 8, 6, 8, 5, 9, 7, 2, 9, 6, 5, 3, 4, 9, 3, 8, 1, 3, 1, 9, 7]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //
        //            case 29:
        //
        //                if passedLevels.contains(29) || passedLevels.contains(28){
        //                    numbersForLevelArray = [2, 2, 6, 8, 8, 5, 5, 3, 9, 8, 5, 7, 3, 5, 1, 6, 7, 1, 5, 8, 3, 8, 5, 4, 5, 8, 3, 7, 4, 4, 7, 7, 9, 6, 1, 4, 2, 1, 9, 7, 6, 3, 5, 6, 8, 1, 4, 5, 4, 8, 2, 1, 7, 6, 8, 8, 6, 1, 1, 5, 3, 8, 9, 1, 1, 7, 8, 6, 5, 1, 5, 8, 7, 4, 8, 6, 5, 2, 4, 7, 2, 5, 1, 2, 5, 1, 2, 2, 5, 8, 3, 7, 1, 5, 8, 5, 4, 5, 9, 6]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //
        //            case 30:
        //
        //                if passedLevels.contains(30) || passedLevels.contains(29) { //hacked
        //                    numbersForLevelArray = [8, 9, 2, 7, 2, 10, 2, 9, 3, 4, 9, 5, 4, 1, 2, 5, 8, 4, 3, 9, 4, 8, 2, 4, 1, 7, 2, 7, 3, 10, 6, 4, 3, 7, 7, 8, 1, 5, 8, 3, 3, 8, 9, 2, 1, 8, 5, 8, 5, 4, 3, 10, 2, 2, 9, 9, 9, 6, 3, 8, 6, 2, 3, 5, 2, 7, 5, 8, 1, 2, 2, 10, 9, 2, 2, 1, 4, 7, 4, 5, 8, 5, 8, 6, 6, 9, 5, 10, 10, 3, 7, 9, 7, 7, 2, 2, 3, 8, 6, 2]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //
        //            case 31:
        //
        //                if passedLevels.contains(31) || passedLevels.contains(30){
        //                    numbersForLevelArray = [4, 4, 5, 3, 5, 3, 1, 2, 7, 4, 1, 5, 1, 7, 3, 6, 2, 3, 3, 1, 3, 5, 2, 6, 6, 6, 3, 4, 5, 5, 5, 3, 3, 5, 4, 7, 3, 6, 1, 6, 4, 4, 4, 3, 2, 6, 1, 3, 2, 4, 5, 7, 5, 2, 5, 7, 4, 4, 1, 4, 4, 7, 5, 7, 2, 5, 1, 4, 2, 6, 7, 6, 7, 4, 6, 7, 7, 1, 2, 4, 4, 2, 2, 7, 2, 7, 5, 6, 5, 1, 3, 1, 6, 4, 1, 4, 5, 4, 5, 2]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //
        //            case 32:
        //
        //                if passedLevels.contains(32) || passedLevels.contains(31){
        //                    numbersForLevelArray = [4, 6, 5, 6, 2, 4, 7, 2, 6, 3, 4, 2, 3, 3, 1, 1, 2, 2, 6, 6, 7, 3, 6, 7, 3, 5, 7, 5, 5, 5, 2, 6, 2, 3, 6, 3, 7, 6, 3, 3, 7, 1, 6, 3, 1, 6, 5, 2, 2, 4, 1, 7, 1, 4, 3, 6, 4, 2, 1, 1, 7, 1, 3, 1, 7, 3, 1, 7, 7, 4, 4, 6, 5, 5, 5, 3, 3, 4, 6, 1, 7, 4, 1, 5, 4, 5, 3, 4, 4, 5, 6, 7, 4, 3, 6, 7, 2, 4, 5, 3]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //
        //            case 33:
        //
        //                if passedLevels.contains(33) || passedLevels.contains(32){
        //                    numbersForLevelArray = [2, 2, 7, 10, 8, 2, 3, 5, 9, 8, 2, 2, 1, 8, 9, 4, 6, 8, 4, 3, 4, 10, 3, 10, 8, 8, 1, 7, 6, 1, 7, 9, 5, 2, 6, 1, 2, 10, 6, 3, 6, 2, 4, 1, 2, 7, 3, 2, 10, 3, 3, 3, 9, 1, 1, 1, 3, 2, 6, 9, 5, 7, 2, 7, 4, 3, 9, 10, 2, 2, 9, 2, 8, 7, 2, 5, 10, 3, 7, 8, 6, 6, 1, 5, 5, 10, 8, 10, 7, 5, 2, 7, 8, 7, 10, 7, 3, 4, 9, 5]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //
        //            case 34:
        //
        //                if passedLevels.contains(34) || passedLevels.contains(33){
        //                    numbersForLevelArray = [1, 2, 9, 9, 8, 3, 3, 1, 2, 5, 6, 6, 9, 1, 6, 3, 3, 6, 4, 7, 10, 10, 8, 2, 7, 8, 10, 1, 1, 4, 9, 6, 8, 8, 4, 4, 2, 5, 1, 5, 8, 9, 10, 8, 9, 7, 6, 4, 2, 7, 1, 1, 5, 4, 5, 9, 9, 2, 9, 6, 8, 4, 4, 2, 3, 5, 1, 9, 8, 3, 8, 6, 6, 6, 4, 9, 6, 8, 4, 4, 4, 10, 9, 1, 9, 6, 9, 7, 10, 5, 6, 7, 1, 1, 10, 1, 4, 9, 3, 6]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //            case 35:
        //
        //print("boo")
        //
        //            case 36:
        //
        //print("boo")
        //
        //            case 37:
        //
        //                if passedLevels.contains(37) || passedLevels.contains(36){
        //                    numbersForLevelArray = [7, 3, 2, 5, 6, 1, 2, 5, 4, 1, 5, 2, 5, 4, 7, 4, 7, 7, 6, 7, 6, 2, 2, 1, 5, 1, 1, 1, 5, 3, 6, 3, 6, 5, 4, 5, 7, 5, 2, 2, 6, 5, 6, 4, 3, 6, 4, 3, 7, 6, 3, 2, 4, 6, 5, 7, 6, 5, 6, 7, 2, 1, 3, 5, 3, 2, 5, 5, 3, 1, 2, 6, 6, 7, 4, 1, 1, 1, 4, 3, 5, 2, 2, 6, 2, 4, 1, 5, 6, 5, 6, 7, 1, 1, 7, 6, 4, 6, 5, 3]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //            case 38:
        //
        //                if passedLevels.contains(38) || passedLevels.contains(37){
        //                    numbersForLevelArray = [7, 6, 4, 7, 1, 1, 2, 6, 6, 1, 6, 1, 2, 4, 2, 6, 1, 3, 6, 4, 1, 4, 5, 3, 4, 1, 4, 1, 2, 4, 4, 4, 4, 1, 1, 5, 2, 3, 2, 2, 3, 3, 5, 1, 3, 3, 4, 6, 7, 4, 4, 6, 1, 5, 7, 6, 6, 2, 5, 2, 3, 3, 7, 6, 3, 6, 1, 5, 7, 1, 6, 2, 3, 7, 7, 3, 5, 6, 2, 4, 6, 2, 1, 2, 5, 3, 1, 5, 5, 1, 4, 5, 4, 5, 6, 2, 7, 3, 6, 3]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //
        //            case 39:
        //
        //                if passedLevels.contains(39) || passedLevels.contains(38){
        //                    numbersForLevelArray = [1, 2, 7, 6, 1, 3, 2, 4, 7, 7, 6, 4, 7, 2, 5, 6, 6, 3, 2, 4, 4, 7, 3, 3, 5, 4, 7, 1, 6, 7, 2, 5, 6, 2, 1, 4, 7, 2, 2, 1, 2, 5, 4, 2, 3, 2, 2, 5, 2, 7, 6, 7, 4, 7, 7, 6, 5, 6, 4, 6, 3, 2, 6, 7, 2, 3, 6, 1, 2, 7, 6, 3, 4, 7, 5, 7, 1, 4, 5, 6, 4, 5, 6, 3, 1, 6, 7, 2, 6, 7, 4, 7, 1, 1, 1, 1, 2, 6, 2, 6]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //
        //            case 40:
        //
        //                if passedLevels.contains(40) || passedLevels.contains(39){
        //                    numbersForLevelArray = [2, 6, 2, 6, 5, 2, 3, 2, 6, 2, 6, 1, 7, 2, 1, 7, 6, 6, 4, 5, 1, 1, 2, 5, 1, 5, 1, 1, 1, 1, 4, 3, 6, 4, 4, 5, 4, 7, 7, 6, 7, 4, 2, 5, 1, 2, 7, 6, 5, 5, 3, 7, 5, 4, 5, 1, 6, 3, 6, 6, 5, 3, 5, 2, 3, 1, 7, 1, 5, 1, 5, 7, 2, 1, 2, 7, 5, 6, 1, 7, 1, 6, 5, 3, 1, 4, 4, 1, 2, 1, 2, 1, 7, 6, 5, 1, 3, 3, 1, 7]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //
        //            case 41:
        //
        //                if passedLevels.contains(41) || passedLevels.contains(40){
        //                    numbersForLevelArray = [1, 1, 3, 1, 4, 3, 5, 2, 6, 1, 3, 4, 5, 2, 2, 6, 7, 7, 4, 7, 3, 7, 5, 4, 2, 1, 3, 6, 1, 4, 5, 6, 1, 4, 6, 3, 5, 7, 1, 4, 3, 2, 6, 6, 5, 3, 3, 2, 3, 2, 2, 5, 4, 1, 4, 7, 1, 3, 3, 7, 7, 4, 2, 3, 7, 6, 6, 4, 2, 3, 7, 3, 6, 4, 4, 5, 3, 4, 1, 7, 5, 3, 1, 7, 7, 3, 1, 6, 6, 1, 1, 5, 3, 3, 7, 7, 4, 7, 2, 3]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //
        //            case 42:
        //
        //                if passedLevels.contains(42) || passedLevels.contains(41){
        //                    numbersForLevelArray = [3, 1, 4, 4, 2, 7, 2, 4, 5, 4, 4, 1, 1, 5, 4, 4, 7, 6, 6, 3, 2, 2, 3, 5, 5, 3, 3, 4, 6, 4, 7, 4, 4, 2, 3, 3, 6, 6, 3, 7, 1, 3, 5, 5, 5, 1, 2, 4, 4, 7, 5, 3, 2, 2, 7, 5, 4, 6, 7, 7, 7, 5, 5, 2, 6, 1, 3, 4, 4, 1, 7, 6, 1, 1, 5, 5, 3, 5, 6, 6, 1, 5, 3, 3, 2, 4, 4, 6, 4, 3, 5, 3, 7, 2, 6, 2, 4, 7, 3, 4]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //
        //            case 43:
        //
        //                if passedLevels.contains(43) || passedLevels.contains(42){
        //                    numbersForLevelArray = [7, 3, 2, 5, 6, 1, 2, 5, 4, 1, 5, 2, 5, 4, 7, 4, 7, 7, 6, 7, 6, 2, 2, 1, 5, 1, 1, 1, 5, 3, 6, 3, 6, 5, 4, 5, 7, 5, 2, 2, 6, 5, 6, 4, 3, 6, 4, 3, 7, 6, 3, 2, 4, 6, 5, 7, 6, 5, 6, 7, 2, 1, 3, 5, 3, 2, 5, 5, 3, 1, 2, 6, 6, 7, 4, 1, 1, 1, 4, 3, 5, 2, 2, 6, 2, 4, 1, 5, 6, 5, 6, 7, 1, 1, 7, 6, 4, 6, 5, 3]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //                
        //            case 44:
        //                
        //                if passedLevels.contains(44) || passedLevels.contains(43){
        //                    numbersForLevelArray = [4, 1, 7, 3, 4, 7, 2, 2, 5, 6, 7, 3, 6, 3, 5, 1, 3, 3, 7, 7, 1, 4, 3, 4, 5, 2, 7, 5, 6, 3, 2, 5, 5, 5, 1, 7, 5, 5, 6, 6, 4, 3, 1, 3, 3, 2, 4, 1, 7, 4, 7, 5, 2, 1, 4, 1, 1, 3, 5, 4, 5, 1, 5, 4, 6, 4, 4, 5, 3, 6, 4, 3, 1, 2, 2, 4, 2, 2, 1, 3, 1, 1, 2, 4, 7, 7, 3, 6, 6, 3, 2, 6, 1, 1, 4, 2, 5, 6, 6, 1]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //                
        //            case 45:
        //                
        //                if passedLevels.contains(45) || passedLevels.contains(44){
        //                    numbersForLevelArray = [7, 2, 6, 4, 5, 2, 3, 5, 4, 5, 7, 1, 2, 3, 6, 5, 3, 2, 1, 4, 4, 7, 3, 1, 4, 2, 3, 3, 3, 3, 5, 5, 2, 4, 1, 7, 2, 4, 6, 7, 6, 6, 5, 7, 1, 3, 5, 2, 2, 2, 1, 4, 2, 6, 2, 3, 7, 6, 7, 7, 2, 5, 5, 1, 1, 1, 5, 6, 3, 3, 3, 2, 1, 6, 7, 6, 3, 2, 5, 4, 7, 7, 5, 1, 5, 7, 7, 3, 3, 5, 1, 5, 3, 7, 3, 5, 2, 1, 7, 7]
        //                    self.performSegue(withIdentifier: "toGame", sender: self)}
        //                
        //            case 100: //easy heart.png
        //                
        //    print("boo")
        //                
        //                
        //                
        //            default:
        //                
        //                break
        //            }
        
    }
    
    // set up offering to pay to pass level *Instead going to make it an icon in the gameviewcontroller
    
    private func unlockLevel() -> Int {
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

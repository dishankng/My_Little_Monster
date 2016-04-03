//
//  ViewController.swift
//  My Little Monster
//
//  Created by Dishank on 1/2/16.
//  Copyright © 2016 Dishank. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var heartImg: DragImg!
    @IBOutlet weak var foodImg: DragImg!
    @IBOutlet weak var targetView: UIView!
    @IBOutlet weak var penalty1Img: UIImageView!
    @IBOutlet weak var penalty2Img: UIImageView!
    @IBOutlet weak var penalty3Img: UIImageView!
    @IBOutlet weak var restartBtn: UIButton!
    @IBOutlet weak var Score: UILabel!
    @IBOutlet weak var highScore: UILabel!
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var penalties = -1
    var timer: NSTimer!
    var monsterHappy = false
    var currentItem: UInt32 = 0
    var counter = 0
    var hScore: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do{
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))

            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxBite.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxSkull.prepareToPlay()
            
            musicPlayer.numberOfLoops = -1



        } catch let err as NSError {
            print(err.debugDescription)
        }
        musicPlayer.play()
        
        heartImg.dropTarget = targetView
        foodImg.dropTarget = targetView
        
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        foodImg.alpha = DIM_ALPHA
        heartImg.alpha = DIM_ALPHA
        foodImg.userInteractionEnabled = false
        heartImg.userInteractionEnabled = false
        
        if let top = NSUserDefaults.standardUserDefaults().valueForKeyPath("highscore") as? Int{
            hScore = top
        } else {
            hScore = 0
        }
        
        startTimer()
      
    }
   
    func itemDroppedOnCharacter(notif: AnyObject) {
        monsterHappy = true
        counter++
        startTimer()
        foodImg.alpha = DIM_ALPHA
        heartImg.alpha = DIM_ALPHA
        foodImg.userInteractionEnabled = false
        heartImg.userInteractionEnabled = false
        
        if currentItem == 0 {
            sfxHeart.play()
        } else {
            sfxBite.play()
        }
        
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        
        
        if !monsterHappy {
            
            penalties++
            if penalties > 0 {
                sfxSkull.play()
            }
            
            switch penalties {
            case 1: penalty1Img.alpha = OPAQUE
            penalty2Img.alpha = DIM_ALPHA
            penalty3Img.alpha = DIM_ALPHA
                
            case 2: penalty1Img.alpha = OPAQUE
            penalty2Img.alpha = OPAQUE
            penalty3Img.alpha = DIM_ALPHA
                
            case 3: penalty1Img.alpha = OPAQUE
            penalty2Img.alpha = OPAQUE
            penalty3Img.alpha = OPAQUE
                
            default: penalty1Img.alpha = DIM_ALPHA
            penalty2Img.alpha = DIM_ALPHA
            penalty3Img.alpha = DIM_ALPHA
                
            }
            
        }
        
        let rand = arc4random_uniform(2)  //0to1
        if rand == 0 {
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
            heartImg.alpha = OPAQUE
            heartImg.userInteractionEnabled = true
        } else {
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false
            foodImg.alpha = OPAQUE
            foodImg.userInteractionEnabled = true
        }
        if penalties >= MAX_PENALTIES {
            gameOver()
        }
        
        
        currentItem = rand
        monsterHappy = false
        
    }
    
    @IBAction func restartPressed(sender: AnyObject) {
        restartBtn.hidden = true
        Score.hidden = true
        highScore.hidden = true
        penalties = -1
        counter = 0
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
        monsterImg.playIdleAnimation()
        monsterHappy = false
        startTimer()
        
        
    }
    func gameOver() {
        timer.invalidate()
        sfxDeath.play()
        foodImg.alpha = DIM_ALPHA
        heartImg.alpha = DIM_ALPHA
        foodImg.userInteractionEnabled = false
        heartImg.userInteractionEnabled = false
        monsterImg.playDeadAnimation()
        Score.text = "Score: \(counter)"
        Score.hidden = false
        if counter > hScore {
            hScore = counter
            NSUserDefaults.standardUserDefaults().setValue(hScore, forKey: "highscore")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        highScore.hidden = false
        highScore.text = "High Score: \(hScore)"
        
        restartBtn.hidden = false
    }

}


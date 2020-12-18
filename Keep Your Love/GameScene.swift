//
//  GameScene.swift
//  Keep Your Love
//
//  Created by Amelia Sihombing on 2018/12/31.
//  Copyright © 2018 Amelia Esra. All rights reserved.
//THIS SOURCE CODE RUNNING FOR IPHONE 5S

import SpriteKit
import GameplayKit
import CoreMotion
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var score = 0
    var loveNode = SKSpriteNode()
    var torpedoNode = SKSpriteNode()
    let coreMotionManager = CMMotionManager()
    let foregroundNode = SKSpriteNode()
    let torpedoCollisionCategory : UInt32 = 0x1 << 1
    let playerNodeCollisionCategory : UInt32 = 0x1 << 2
    let girlNodeCollisionCategory : UInt32 = 0x1 << 3
    static var backgroundMusicPlayer: AVAudioPlayer!
    let torpedoCollisionSound = SKAction.playSoundFileNamed("died_pop.mp3", waitForCompletion: false)
    let girlCollisionSound = SKAction.playSoundFileNamed("DING.mp3", waitForCompletion: false)
    
    lazy var backgroundNode : SKSpriteNode = {
       let backgroundNode = SKSpriteNode(imageNamed: "Sky Background")
        backgroundNode.size = CGSize(width: frame.size.width, height: frame.size.height)
        backgroundNode.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        backgroundNode.position = CGPoint(x: frame.size.width / 2, y: 0.0)
    
        return backgroundNode
    }()
    
    
    lazy var playerNode : SKSpriteNode = {
        let playerNode = SKSpriteNode(imageNamed: "Boy")
        playerNode.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        playerNode.position = CGPoint(x: size.width / 2, y: 0.0)
        playerNode.size = CGSize(width: 70.0, height: 70.0)
        playerNode.physicsBody = SKPhysicsBody(rectangleOf: playerNode.size)
        playerNode.physicsBody?.isDynamic = false
        playerNode.physicsBody?.categoryBitMask = playerNodeCollisionCategory
        playerNode.physicsBody?.contactTestBitMask = girlNodeCollisionCategory | torpedoCollisionCategory
        playerNode.physicsBody?.collisionBitMask = 0
        playerNode.name = "Man Icon"
        
        return playerNode
    }()
    
    
    lazy var scoreTextNode : SKLabelNode = {
        let scoreTextNode = SKLabelNode(fontNamed: "Copperplate")
        scoreTextNode.text = "SCORE : \(score)"
        scoreTextNode.fontSize = 20
        scoreTextNode.fontColor = SKColor.black
        scoreTextNode.position = CGPoint(x: size.width - 10, y: size.height - 20)
        scoreTextNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        
        return scoreTextNode
    }()
    
    
    
    lazy var playTextNode : SKLabelNode = {
        let playTextNode = SKLabelNode(fontNamed: "Copperplate")
        playTextNode.text = "TAP ANYWHERE TO START!"
        playTextNode.fontSize = 20
        playTextNode.fontColor = SKColor.black
        playTextNode.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        playTextNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        
        
        return playTextNode
    }()
 
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0);
        isUserInteractionEnabled = true
        
        addChild(backgroundNode)
        addChild(foregroundNode)
        addChild(playerNode)
        addChild(scoreTextNode)
        addChild(playTextNode)
       
        setUpBackgroundSound()
        
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func spawnLoveNode() {
        
        loveNode = SKSpriteNode(imageNamed: "Love")
        loveNode.size = CGSize(width: 50, height: 50)
        loveNode.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Love Mask"), size: loveNode.size)
        loveNode.physicsBody?.categoryBitMask = girlNodeCollisionCategory
        loveNode.physicsBody?.linearDamping = 1.0
        loveNode.physicsBody?.allowsRotation = false
        loveNode.physicsBody?.isDynamic = true
        loveNode.name = "Love Icon"
        
        addChild(loveNode)
        
        //Determine where to spawn the loveNode along the X axis
        let actualX = random(min: loveNode.size.width, max: frame.size.width - loveNode.size.width)
        loveNode.position = CGPoint(x: actualX , y: frame.size.height - 5 )
        
        //Determine speed of loveNode
        let actualDurationLove = random(min: CGFloat(2.0), max: CGFloat(3.0))
        
        //Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: 0.0), duration: TimeInterval(actualDurationLove))
        let actionMoveDone = SKAction.removeFromParent()
        let actionSequence = SKAction.sequence([actionMove,actionMoveDone])
        let actionRepeat = SKAction.repeatForever(actionSequence)
        loveNode.run(actionRepeat)
        
    }
    
    func spawnTorpedoNode() {
        torpedoNode = SKSpriteNode(imageNamed: "torpedo")
        torpedoNode.name = "Torpedo Icon"
        torpedoNode.size = CGSize(width: 50, height: 50)
        torpedoNode.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Torpedo Mask"), size: torpedoNode.size)
        torpedoNode.physicsBody?.isDynamic = true
        torpedoNode.physicsBody?.allowsRotation = false
        torpedoNode.physicsBody?.linearDamping = 1.0
        torpedoNode.physicsBody?.categoryBitMask = torpedoCollisionCategory
        torpedoNode.physicsBody?.collisionBitMask = 0
        
        let torpedoEngine = SKEmitterNode(fileNamed: "TorpedoEngine.sks")!
        torpedoEngine.particleSize = torpedoNode.size
        torpedoEngine.position = torpedoNode.position
        torpedoNode.addChild(torpedoEngine)
        
        addChild(torpedoNode)
        
        //Determine where to spawn the girlNode along the X axis
        let actualX = random(min: torpedoNode.size.width, max: frame.size.width - torpedoNode.size.width)
        torpedoNode.position = CGPoint(x: actualX , y: frame.size.height - 10 )
        
        //Determine speed of girlNode
        let actualDuration = random(min: CGFloat(0.5), max: CGFloat(1.5))
        
        //Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: 0.0), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        let actionSequence = SKAction.sequence([actionMove,actionMoveDone])
        let actionRepeat = SKAction.repeatForever(actionSequence)
        torpedoNode.run(actionRepeat)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !playerNode.physicsBody!.isDynamic {
            playTextNode.removeFromParent()
            playerNode.physicsBody?.isDynamic = true
            
            run(SKAction.repeatForever(SKAction.sequence([SKAction.run(spawnLoveNode), SKAction.wait(forDuration: 2)])));
            
            run(SKAction.repeatForever(SKAction.sequence([SKAction.run(spawnTorpedoNode), SKAction.wait(forDuration: 5)])));
            
            coreMotionManager.accelerometerUpdateInterval = 0.2
            coreMotionManager.startAccelerometerUpdates()
        }
        
    }
    
    func gameOverWithResult(_ gameResult: Bool) {
       
        if gameResult {
            let transition = SKTransition.crossFade(withDuration: 2.0)
            let menuScene = MenuScene(size: size, gameResult: gameResult, score: score)
            view?.presentScene(menuScene, transition: transition)
        }
        else {
            print("You Won!")
        }
        
        
    }
    
    func setUpBackgroundSound(){
        if GameScene.backgroundMusicPlayer == nil {
            let backgroundSoundURL = Bundle.main.url(forResource: "Wind.mp3", withExtension: nil)
            
            do{
                let theme = try AVAudioPlayer(contentsOf: backgroundSoundURL!)
                GameScene.backgroundMusicPlayer = theme
                
            } catch {
                
            }
            
            GameScene.backgroundMusicPlayer.numberOfLoops = -1
        }
        
        if !GameScene.backgroundMusicPlayer.isPlaying {
            GameScene.backgroundMusicPlayer.play()
        }
        
    }
    
    
    override func didSimulatePhysics() {
        if let accelerometerData = coreMotionManager.accelerometerData {
            playerNode.physicsBody!.velocity = CGVector(dx: CGFloat(accelerometerData.acceleration.x * 380.0), dy: playerNode.physicsBody!.velocity.dy)
        }
            if playerNode.position.x < -(playerNode.size.width / 2) {
                playerNode.position =
                    CGPoint(x: size.width - playerNode.size.width / 2,
                            y: playerNode.position.y);
                
            }
            else if playerNode.position.x > self.size.width {
                playerNode.position = CGPoint(x: playerNode.size.width / 2,
                                              y: playerNode.position.y);
            }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if let nodeB = contact.bodyB.node {
            if nodeB.name == "Love Icon" {
                run(girlCollisionSound)
                score += 1
                scoreTextNode.text = "SCORE : \(score)"
                nodeB.removeFromParent()

            } else if nodeB.name == "Torpedo Icon" {
                run(torpedoCollisionSound)
                playerNode.physicsBody?.contactTestBitMask = 0
                let colorizeAction = SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 1)
                playerNode.run(colorizeAction)
                playerNode.removeFromParent()
                playerNode.run(SKAction.wait(forDuration: 2))
                gameOverWithResult(true)
            
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if playerNode.position.y < 0.0 {
            gameOverWithResult(true)
        }
        
        else if score > 10000 {
            gameOverWithResult(false)
        }
        
    }
    
    deinit {
        coreMotionManager.stopAccelerometerUpdates()
    }
    
    
}
        
        

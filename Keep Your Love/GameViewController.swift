//
//  GameViewController.swift
//  Keep Your Love
//
//  Created by Amelia Sihombing on 2018/12/31.
//  Copyright © 2018 Amelia Esra. All rights reserved.
//

import SpriteKit
class GameViewController: UIViewController {
    var scene: GameScene!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Configure the main view
        let skView = view as! SKView
        skView.showsFPS = true
        
        // 2. Create and configure our game scene
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        // 3. Show the scene.
        skView.presentScene(scene)
    }
    
    
}


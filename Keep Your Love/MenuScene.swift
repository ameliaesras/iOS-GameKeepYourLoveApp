//
//  MenuScene.swift
//  Keep Your Love
//
//  Created by Amelia Sihombing on 2019/1/6.
//  Copyright © 2019 Amelia Esra. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(size: CGSize, gameResult: Bool, score: Int) {
        super.init(size: size)
        
        //Adding background
        let backgroundNode = SKSpriteNode(imageNamed: "Sky Background")
        backgroundNode.size = CGSize(width: frame.size.width, height: frame.size.height)
        backgroundNode.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        backgroundNode.position = CGPoint(x: frame.size.width / 2, y: 0.0)
        addChild(backgroundNode)
        
        //Adding game result text
        let gameResultText = SKLabelNode(fontNamed: "Copperplate")
        gameResultText.text = "You Lose!"
        gameResultText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        gameResultText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        gameResultText.fontSize = 50
        gameResultText.fontColor = SKColor.red
        gameResultText.position = CGPoint(x: size.width / 2.0, y: size.height - 170)
        addChild(gameResultText)
        
        //Adding score display
        let currentScoreText = SKLabelNode(fontNamed: "Copperplate")
        currentScoreText.text = "YOUR SCORE : \(score)"
        currentScoreText.fontSize = 20
        currentScoreText.fontColor = SKColor.black
        currentScoreText.position = CGPoint(x: size.width / 2, y: gameResultText.position.y - 40.0)
        currentScoreText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        currentScoreText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        addChild(currentScoreText)
        
        //Adding Game Over Icon
        let gameOverIcon = SKSpriteNode(imageNamed: "Sad Love")
        gameOverIcon.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        gameOverIcon.position = CGPoint(x: frame.size.width / 2, y: currentScoreText.position.y - 80)
        addChild(gameOverIcon)
        
        //Adding text replay
        let playAgainText = SKLabelNode(fontNamed: "Copperplate")
        playAgainText.text = "TAP TO REPLAY"
        playAgainText.fontSize = 30
        playAgainText.fontColor = SKColor.black
        playAgainText.position = CGPoint(x: frame.size.width / 2, y: gameOverIcon.position.y - 120)
        addChild(playAgainText)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let transition = SKTransition.fade(withDuration: 2.0)
        let gameScene = GameScene(size: size)
        
        view?.presentScene(gameScene, transition: transition)
    }
}

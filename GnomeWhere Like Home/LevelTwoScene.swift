//
//  LevelTwoScene.swift
//  GnomeWhere Like Home
//
//  Created by Brooke Huntington on 11/25/18.
//  Copyright © 2018 Brooke Huntington. All rights reserved.
// code used from https://www.raywenderlich.com/1079-what-s-new-in-spritekit-on-ios-10-a-look-at-tile-maps


import SpriteKit
import GameplayKit
import UIKit

class LevelTwoScene: SKScene {
    var towerSpot1 = SKSpriteNode()
    var towerSpot2 = SKSpriteNode()
    var ladyBug = SKSpriteNode()
    var addEnemiesTime = 30
    var enemiesLeft = 10
    var waveTimer: Timer? = nil
    var prepareTimer: Timer? = nil
    var prepareTime = 3
    
    override func didMove(to view: SKView) {
//        let alert = UIAlertController(title: "GnomeWhere Like Home", message: "Defend the Garden!", preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: "Start", style: .default, handler: { action in
        
        startPrepareTimer()
//        }))
//        self.parent!.scene!.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)

    }
    
    func startPrepareTimer() {
        // have timer stop a 0 and start at 60
        prepareTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updatePrepareTimer), userInfo: nil, repeats: true)
    }
    
    func startWaveTimer() {
        // have timer stop a 0 and start at 60
        waveTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateWave), userInfo: nil, repeats: true)
    }
    
    @objc func updatePrepareTimer() {
        if prepareTime != 0 {
            prepareTime -= 1
        } else {
            startWaveTimer()
            prepareTimer?.invalidate()
        }
    }
    // stops the timer a 0
    @objc func updateWave() {
        if addEnemiesTime != 0 {
            addEnemy()
            addEnemiesTime -= 1
        } else {
            waveTimer?.invalidate()
        }
    }
    
    func addEnemy() {
        let enemy = SKSpriteNode(imageNamed:"Blue_Bird_Flying0001")
        enemy.scale(to: CGSize(width: 100, height: 100))
        
        addChild(enemy)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: -250, y: 200))
        path.addLine(to: CGPoint(x: 160, y: 200))
        path.addLine(to: CGPoint(x: 160, y: 0))
        path.addLine(to: CGPoint(x: -125, y: 0))
        path.addLine(to: CGPoint(x: -125, y: -100))
        path.addLine(to: CGPoint(x: 100, y: -100))
        path.addLine(to: CGPoint(x: 100, y: -200))
        path.addLine(to: CGPoint(x: -125, y: -200))
        path.addLine(to: CGPoint(x: -125, y: -350))
        
        
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 100)
        enemy.run(move)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered

        
        

    }
}

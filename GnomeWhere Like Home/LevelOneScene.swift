//
//  GameScene.swift
//  GnomeWhere Like Home
//
//  Created by Brooke Huntington on 11/25/18.
//  Copyright © 2018 Brooke Huntington. All rights reserved.
// bird is from cartoonsmart.com
// grass from kenney.nl

import SpriteKit
import GameplayKit

class LevelOneScene: SKScene {
    
    var theEnemy:SKSpriteNode = SKSpriteNode()
    let swipeDownRec = UISwipeGestureRecognizer()
    let swipeLeftRec = UISwipeGestureRecognizer()
    let swipeRightRec = UISwipeGestureRecognizer()
    let swipeUpRec = UISwipeGestureRecognizer()
    let rotateRec = UIRotationGestureRecognizer()
    
    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 1, dy: 0)
        
        rotateRec.addTarget(self, action: #selector(LevelOneScene.rotateView(_:)))
        
        swipeRightRec.addTarget(self, action: #selector(LevelOneScene.swipedRight))
        swipeRightRec.direction = .right
        self.view?.addGestureRecognizer(swipeRightRec)
        
        swipeLeftRec.addTarget(self, action: #selector(LevelOneScene.swipedLeft))
        swipeLeftRec.direction = .left
        self.view?.addGestureRecognizer(swipeLeftRec)
        
        swipeDownRec.addTarget(self, action: #selector(LevelOneScene.swipedDown))
        swipeDownRec.direction = .down
        self.view?.addGestureRecognizer(swipeDownRec)
        
        swipeUpRec.addTarget(self, action: #selector(LevelOneScene.swipedUp))
        swipeUpRec.direction = .up
        self.view?.addGestureRecognizer(swipeUpRec)
        
        if let someEnemy: SKSpriteNode = self.childNode(withName: "Bird") as? SKSpriteNode{
            theEnemy = someEnemy
            theEnemy.physicsBody?.isDynamic = false
            print("that worked")
            
        } else {
            print("that failed")
        }
        
        
    }
    
    @objc func swipedLeft() {
        print("swipeLeft")
        move(theXAmount: -50, theYAmount: 0, theAnimation: "WalkForward")
    }
    
    @objc func swipedRight() {
        print("swiperight")
        move(theXAmount: 50, theYAmount: 0, theAnimation: "WalkForward")
    }
    
    @objc func swipedUp() {
        print("swipe up")
        move(theXAmount: 0, theYAmount: 100, theAnimation: "WalkForward")
    }
    
    @objc func swipedDown() {
        print("swipe down")
        move(theXAmount: 0, theYAmount: -100, theAnimation: "WalkForward")
    }
    
    @objc func rotateView(_ sender: UIRotationGestureRecognizer) {
        if (sender.state == .began) {
            
        }
        
        if (sender.state == .began) {
            print("rotation began")
        }
        if (sender.state == .changed) {
            print("rotation changed")
        }
        if (sender.state == .ended) {
            print("rotation ended")
        }
    }
    
    func move(theXAmount:CGFloat, theYAmount: CGFloat, theAnimation:String) {
        let moveAction:SKAction = SKAction.moveBy(x: theXAmount, y: theYAmount, duration: 0.5)

        theEnemy.run(moveAction)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
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
        
        if (theEnemy.position.y > -244) {
            if ( theEnemy.position.x < 100 && theEnemy.position.y > 200) {
                move(theXAmount: 10, theYAmount: 0, theAnimation: "Fly")
            } else {
                if (theEnemy.position.x > 50 && theEnemy.position.y > 120) {
                    move(theXAmount: 0, theYAmount: -10, theAnimation: "Fly")
                } else {
                    if(theEnemy.position.y > 80 && theEnemy.position.x > -50) {
                        move(theXAmount: -10, theYAmount: 0, theAnimation: "Fly")
                    } else {
                        if(theEnemy.position.y > -60 && theEnemy.position.x < 17) {
                            move(theXAmount: 0, theYAmount: -10, theAnimation: "Fly")
                            print("x position: \(theEnemy.position.x)")
                            print("y pos: \(theEnemy.position.y)")
                        } else {
                            if(theEnemy.position.y > -150 && theEnemy.position.x < 0) {
                                move(theXAmount: 10, theYAmount: 0, theAnimation: "Fly")
                            }
                        }
                    }
                
            }
            
        }
    }
}
}

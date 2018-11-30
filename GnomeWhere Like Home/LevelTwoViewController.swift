//
//  LevelTwoViewController.swift
//  GnomeWhere Like Home
//
//  Created by Brooke Huntington on 11/29/18.
//  Copyright © 2018 Brooke Huntington. All rights reserved.
// Ladybug Image found at http://agavaceae.info/clipart/ladybug-clip-art-free.html
import UIKit
import SpriteKit
import GameplayKit

class LevelTwoViewController: UIViewController {
    let ladyBugTower = SKSpriteNode()
    
    @IBOutlet var cashLabel: UILabel!
    @IBOutlet var ladyBugImage: UIImageView!
    @IBOutlet var plantsLeftLabel: UILabel!
    
    @IBOutlet var wavesLeftLabel: UILabel!
    @IBAction func addLadybugTowerButton(_ sender: Any) {
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

            

    }
    


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

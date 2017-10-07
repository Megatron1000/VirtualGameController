//
//  GameViewController.swift
//  SceneKitShipDemo
//
//  Created by Rob Reuss on 10/6/17.
//  Copyright © 2017 Rob Reuss. All rights reserved.
//

import SceneKit
import QuartzCore
import GameController
import VirtualGameController

var ship: SCNNode!
var lightNode: SCNNode!
var cameraNode: SCNNode!
var sharedCode: SharedCode!

class GameViewController: NSViewController {
    
    @IBOutlet weak var gameView: GameView!
    
    override func awakeFromNib(){
        
        // Use a compiler flag to control the logging level, dropping it to just errors if this
        // is a release build.
        #if Release
            VgcManager.loggerLogLevel = .Error // Minimal logging
        #else
            VgcManager.loggerLogLevel = .Debug // Robust logging
        #endif
        
        VgcManager.startAs(.Central, appIdentifier: "vgc", customElements: nil, customMappings: nil)
        
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // create and add a camera to the scene
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLight.LightType.omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        lightNode.eulerAngles = SCNVector3Make(0.0, 3.1415/2.0, 0.0);
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        #if os(OSX)
            ambientLightNode.light!.color = NSColor.darkGray
        #endif
        #if os(iOS) || os(tvOS)
            ambientLightNode.light!.color = UIColor.darkGrayColor()
        #endif
        scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the ship node
        ship = scene.rootNode.childNode(withName: "ship", recursively: true)!
        
        // set the scene to the view
        gameView.scene = scene
        
        // allows the user to manipulate the camera
        gameView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        gameView.showsStatistics = true
        
        // configure the view
        gameView.backgroundColor = NSColor.black
        
        sharedCode = SharedCode()
        sharedCode.setup(scene: scene, ship: ship, lightNode: lightNode, cameraNode: cameraNode)
        
        //scnView.delegate = sharedCode
    }
    
}


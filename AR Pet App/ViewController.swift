//
//  ViewController.swift
//  AR Pet App
//
//  Created by Jacqualyn Blizzard-Caron on 3/6/19.
//  Copyright © 2019 Jacqualyn Blizzard-Caron. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    let config = ARWorldTrackingConfiguration()
    
     var petNode: SCNNode!
     var petNodeName = "shiba"
     // Extension - To swipe left to change pet
     var index = 0
     var petScene: SCNScene!
     var petNodeNameArray: [String] = ["shiba", "fox", "sheep", "pig", "chick", "cow", "dino", "dog", "duck", "goat", "horse"]
     var petSceneArray: [String] = ["Animals/ShibaInu.scn", "Animals/Fox.scn", "Animals/Sheep.scn", "Animals/pig.scn", "Animals/chick.scn", "Animals/cow.scn", "Animals/dino.scn", "Animals/dog.scn", "Animals/duck.scn", "Animals/goat.scn", "Animals/horse.scn"]
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        sceneView.session.run(config)
        addPet()
        welcomeText()
        //addTapGestureToSceneView()
    }

    func addPet(x: Float = 0, y: Float = 0, z: Float = -0.2) { //update in Part 5
        //add conditional logic for extension
        if index >= petNodeNameArray.count {
            index = 0
            petScene = SCNScene(named: petSceneArray[index])! //update for extension
            petNode = petScene.rootNode.childNode(withName: petNodeNameArray[index], recursively: true) //update for extension
            petNode.scale = SCNVector3(0.1, 0.1, 0.1)
            petNode.position = SCNVector3(x, y, z) //update in Part 5
            sceneView.scene.rootNode.addChildNode(petNode)
        } else {
            petScene = SCNScene(named: petSceneArray[index])! //update for extension
            petNode = petScene.rootNode.childNode(withName: petNodeNameArray[index], recursively: true) //update for extension
            print(petNode)
            petNode.scale = SCNVector3(0.1, 0.1, 0.1)
            petNode.position = SCNVector3(x, y, z) //update in Part 5
            sceneView.scene.rootNode.addChildNode(petNode)
        }
    }
    
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation)
        guard let node = hitTestResults.first?.node else {
            let hitTestResultsWithFeaturePoints = sceneView.hitTest(tapLocation, types: .featurePoint)
            if let hitTestResultsWithFeaturePoints = hitTestResultsWithFeaturePoints.first {
                let translation = hitTestResultsWithFeaturePoints.worldTransform.translation
                addPet(x: translation.x, y: translation.y, z: translation.z)
            }
            return
        }
        node.removeFromParentNode()
    }

    // Extension 1 - Add Welcome Text
    func welcomeText() {
        let text = SCNText(string: "Tap to add your pet!", extrusionDepth: 1)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.blue
        text.materials = [material]
        let textNode = SCNNode()
        textNode.position = SCNVector3(x: 0.0, y: 0.02, z: -0.1)
        textNode.scale = SCNVector3(x: 0.001, y: 0.001, z: 0.001)
        textNode.geometry = text
        sceneView.scene.rootNode.addChildNode(textNode)
        let fade = SCNAction.fadeOut(duration: 10.0)
        textNode.runAction(fade)
        
    }

    // Extension 3 - swipe left to change pet
    @IBAction func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        index += 1
        print(index)
    }
}
extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}


//
//  ViewController.swift
//  ARTest
//
//  Created by Jon Vogel on 6/6/17.
//  Copyright © 2017 Jon Vogel. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var arScene: ARSCNView!
    
    //MARK: ARKit variables
    var realityConfiguration: ARWorldTrackingSessionConfiguration?
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.prepare()
    }
    
    //MARK: Actions
    
    
    //MARK: Overides


}

extension ViewController {
    func prepare() {
        //Check to see if active reality is supported
        guard ARSessionConfiguration.isSupported else {
            AppDelegate.alert(title: "Not Supported", message: "Active Reality is not supported on this device")
            return
        }
        //Set up the ARSessionConfiguration
        self.realityConfiguration = ARWorldTrackingSessionConfiguration()
        self.realityConfiguration?.planeDetection = ARWorldTrackingSessionConfiguration.PlaneDetection.horizontal
        //Note: Horizontal plane detection is the default.
        //Set up the ARSCNView
        guard let config = self.realityConfiguration else {
            return
        }
        //Run the ARSCNView and set its delegate 
        self.arScene.session.run(config)
        self.arScene.delegate = self
    }
}

extension ViewController: ARSCNViewDelegate {
    
//Conflicts with the didAdd node method below. One or the other I guess
//    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//        return nil
//    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        
        let plane = SCNPlane(width: CGFloat(planAnchor.extent.x), height: CGFloat(planAnchor.extent.z))
        let planeNode = SCNNode(geometry: plane)
        planeNode.position = SCNVector3Make(planAnchor.center.x, 0, planAnchor.center.z)
        
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        
        node.addChildNode(planeNode)
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) {
        print("Will updated Node on Anchor: \(anchor.identifier)")
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        print("Did updated Node on Anchor: \(anchor.identifier)")
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        print("Removed Node on Anchor: \(anchor.identifier)")
    }
}


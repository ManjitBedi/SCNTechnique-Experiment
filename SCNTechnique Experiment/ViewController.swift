//
//  ViewController.swift
//  SCNTechnique Experiment
//
//  Created by Manjit Bedi on 2021-03-31.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self

        // This is to allow post processing effects
        if #available(iOS 13.0, *) {
            sceneView.rendersCameraGrain = false
        }

        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene

        let filterTechnique = makeTechnique(fromPlistNamed: "SceneFilterTechnique")
        sceneView.technique = filterTechnique
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - Private methods

    private func makeTechnique(fromPlistNamed plistName: String) -> SCNTechnique {
        guard let url = Bundle.main.url(forResource: plistName, withExtension: "plist") else {
            fatalError("\(plistName).plist does not exist in the main bundle")
        }

        guard let dictionary = NSDictionary(contentsOf: url) as? [String: Any] else {
            fatalError("Failed to parse \(plistName).plist as a dictionary")
        }

        guard let technique = SCNTechnique(dictionary: dictionary) else {
            fatalError("Failed to initialize a technique using \(plistName).plist")
        }

        return technique
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}

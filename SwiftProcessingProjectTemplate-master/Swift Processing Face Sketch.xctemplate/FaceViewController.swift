import UIKit
import SceneKit
import ARKit
import SwiftProcessing

class FaceViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    var sketch: Sketch?
    var layer: CALayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sketch = MySketch()
        sketch!.frame = CGRect(x: 0, y: 0, width: 1920, height: 1920)
        sketch!.sketchDelegate?.setup()
        sketch!.layer.bounds = CGRect(x: 0, y: 0, width: 1920  , height: 1920)
        
        sceneView.delegate = self
        sceneView.showsStatistics = false
        
        layer = sketch!.layer
        self.view.addSubview(sketch!)
        
        guard ARFaceTrackingConfiguration.isSupported else {
            fatalError("Face tracking is not supported on this device")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.geometry as? ARSCNFaceGeometry {
            faceGeometry.update(from: faceAnchor.geometry)
        }
    }
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let faceMesh = ARSCNFaceGeometry(device: sceneView.device!, fillMesh: sketch!.isFaceFill)
        
        let newMaterial = SCNMaterial()
        newMaterial.isDoubleSided = true
        newMaterial.diffuse.contents = layer!
        let scale: Float = Float(1.0 / UIScreen.main.scale)
        let scaleMatrix = SCNMatrix4MakeScale(scale, scale, scale)

        newMaterial.diffuse.contentsTransform = scaleMatrix
        
        let node = SCNNode(geometry: faceMesh)
        
        node.geometry?.materials = [newMaterial]
        node.geometry?.firstMaterial?.fillMode = .fill
        
        
        
        return node
    }
    
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

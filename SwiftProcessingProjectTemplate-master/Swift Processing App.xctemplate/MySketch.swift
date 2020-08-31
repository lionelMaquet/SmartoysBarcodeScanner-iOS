import SwiftProcessing
import UIKit

class MySketch: Sketch, SketchDelegate{
    
    func setup() {
        //Launches the Sketch in app mode
        appMode()
        //Launches the Sketch in augmented reality face mode. Works on iPhone X, XR, 11, 11 Pro, and iPad Pro Remove // on the next line to enable.
        //faceMode()
    }
    
    func draw() {
        background(255,255,255)
        fill(255, 0, 0)
        circle(125, 125, 50)
    }
    
}

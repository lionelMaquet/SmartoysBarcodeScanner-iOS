import SwiftProcessing
import UIKit

class MySketch: Sketch, SketchDelegate{
        
    func setup() {
        //Launches the Sketch in augmented reality face mode. Works on iPhone X, XR, 11, 11 Pro, and iPad Pro Remove
        faceMode()
        //sets the background to clear so we can see our normal face in the background
        background(255,255,255, 0)
    }
    
    /**
     The draw function code gets called at 60 times per second.
     The face filter runs at 1920 x 1920 pixels
     coordinate (0,0) is the top left of your face.
     coordinate (1920, 1920) is the bottom right of your face
     */
    func draw() {
        //whites of eyes
        fill(255, 255, 255)
        circle(576, 624, 288)
        circle(1344, 624, 288)
        
        //pupils of eyes
        fill(0, 0, 0)
        circle(576, 624, 96)
        circle(1344, 624, 96)
        
        //mouth
        fill(255, 0, 0)
        ellipse(960, 1200, 576, 192)
    }
}

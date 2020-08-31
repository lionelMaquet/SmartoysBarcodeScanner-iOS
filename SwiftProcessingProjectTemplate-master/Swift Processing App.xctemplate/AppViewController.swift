import UIKit

class AppViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    override func viewDidAppear(_ animated: Bool) {
        let sketch = self.view as! MySketch
        if sketch.isFaceMode {
            self.performSegue(withIdentifier: "presentFace", sender: nil)
            
        }
    }
    
    
}

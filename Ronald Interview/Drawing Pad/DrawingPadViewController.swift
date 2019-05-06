//
//  DrawingPadViewController.swift
//  Ronald Interview
//
//  Created by Ronald Kwok on 1/4/2019.
//  Copyright © 2019 Ronald Kwok. All rights reserved.
//

import UIKit

class DrawingPadViewController: UIViewController {

    private var canvasView: CanvasView? {
        get {
            return view as? CanvasView
        }
        set {
            view = newValue
        }
    }
    
    // MARK: - View lifecycle
    override func loadView() {
        self.title = "Drawing Pad"
        canvasView = CanvasView()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: canvasView, action: #selector(canvasView?.clear))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

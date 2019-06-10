//
//  ViewController.swift
//  SortingSimulator
//
//  Created by OrigamiDream on 10/06/2019.
//  Copyright © 2019 OrigamiDream. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var sortingDisplayView: SortingDisplayView!
    
    @IBOutlet weak var executeButton: NSButton!
    @IBOutlet weak var shuffleButton: NSButton!
    @IBOutlet weak var cancelButton: NSButton!
    
    @IBOutlet weak var sampleCounter: NSTextField!
    @IBOutlet weak var sampleStepper: NSStepper!
    
    @IBOutlet weak var algorithmPopupButton: NSPopUpButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        algorithmPopupButton.removeAllItems()
        for algorithm in Algorithms.ALGORITHMS {
            algorithmPopupButton.addItem(withTitle: algorithm.name())
        }
        sortingDisplayView.clearBackground()
        
        sampleCounter.stringValue = "1000"
        onSampleCount(sampleCounter as Any)
    }
    
    private func currentAlgorithm() -> Algorithm {
        return Algorithms.ALGORITHMS[algorithmPopupButton.indexOfSelectedItem]
    }

    override var representedObject: Any? {
        didSet {
        }
    }
    
    @IBAction func onExecute(_ sender: Any) {
        shuffleButton.isEnabled = false
        executeButton.isEnabled = false
        cancelButton.isTransparent = false
        sampleCounter.isEnabled = false
        sampleStepper.isEnabled = false
        algorithmPopupButton.isEnabled = false
        
        sortingDisplayView.startSorting(algorithm: currentAlgorithm()) {
            self.onCancel(self.executeButton as Any)
        }
    }
    
    @IBAction func onShuffle(_ sender: Any) {
        sortingDisplayView.shuffle()
    }
    
    @IBAction func onCancel(_ sender: Any) {
        shuffleButton.isEnabled = true
        executeButton.isEnabled = true
        cancelButton.isTransparent = true
        sampleCounter.isEnabled = true
        sampleStepper.isEnabled = true
        algorithmPopupButton.isEnabled = true
        
        sortingDisplayView.cancelSorting()
    }
    
    @IBAction func onAlgorithmChoose(_ sender: Any) {
        let algorithm = Algorithms.ALGORITHMS[algorithmPopupButton.indexOfSelectedItem]
        algorithmPopupButton.setTitle(algorithm.name())
    }
    
    @IBAction func onSampleStep(_ sender: NSStepper) {
        sampleCounter.stringValue = String(sender.integerValue)
        
        updateSampleSize()
    }
    
    @IBAction func onSampleCount(_ sender: Any) {
        sampleStepper.integerValue = Int.parse(from: sampleCounter.stringValue) ?? 0
        
        updateSampleSize()
    }
    
    func updateSampleSize() {
        sortingDisplayView.setSampleSize(samples: sampleStepper.integerValue)
    }
}


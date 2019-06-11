//
//  SortingDisplayView.swift
//  SortingSimulator
//
//  Created by OrigamiDream on 10/06/2019.
//  Copyright © 2019 OrigamiDream. All rights reserved.
//

import Cocoa

class SortingDisplayView: NSView {
    
    private var backgroundColor: NSColor!
    private var samples: [SortingValue] = [];
    
    private var cancellation = QueueCancellation()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        NSColor.black.setFill()
        NSBezierPath.fill(bounds)
        
        guard let _ = backgroundColor else {
            return
        }
        
        for i in 0..<samples.count {
            let sample = samples[i]
            sample.color.setFill()
            NSBezierPath.fill(NSRect(x: bounds.width / CGFloat(samples.count) * CGFloat(i), y: 0.0,
                                     width: bounds.width / CGFloat(samples.count), height: bounds.height * (CGFloat(sample.value) / CGFloat(samples.count))))
        }
    }
    
    func clearBackground() {
        backgroundColor = .black
        
        setNeedsDisplay(bounds)
    }
    
    func shuffle() {
        samples.shuffle()
        for sample in samples {
            sample.color = .white
        }
        setNeedsDisplay(bounds)
    }
    
    func setSampleSize(samples: Int) {
        self.samples.removeAll()
        for i in 1...samples {
            self.samples.append(SortingValue(value: i))
        }
        self.samples.shuffle()
        setNeedsDisplay(bounds)
    }
    
    func startSorting(algorithm: Algorithm, onComplete: @escaping () -> Void) {
        cancellation.isQueued = false
        for sample in samples {
            sample.color = .white
        }
        DispatchQueue(label: "Sorting display asynchronous").async {
            while !self.cancellation.isQueued {
                DispatchQueue.main.sync {
                    self.setNeedsDisplay(self.bounds)
                }
            }
        }
        DispatchQueue(label: "Sorting asynchronous").async {
            algorithm.sort(array: &self.samples, cancellation: self.cancellation)
            
            for sample in self.samples {
                if self.cancellation.isQueued {
                    break
                }
                usleep(1000)
                sample.color = .green
            }
            
            DispatchQueue.main.sync {
                onComplete()
                self.cancellation.isQueued = true
                self.setNeedsDisplay(self.bounds)
            }
        }
    }
    
    func cancelSorting() {
        self.cancellation.isQueued = true
    }
    
}

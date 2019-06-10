//
//  Algorithm.swift
//  SortingSimulator
//
//  Created by OrigamiDream on 10/06/2019.
//  Copyright © 2019 OrigamiDream. All rights reserved.
//

import Foundation

protocol Algorithm {
    
    func name() -> String
    
    func sort(array: inout [SortingValue], cancellation: QueueCancellation)
    
}

class Algorithms {
    
    public static var ALGORITHMS: [Algorithm] = [ QuickSort(), InsertionSort(), SelectionSort(), MergeSort(), RadixSort(), BubbleSort(), ShellSort(), HeapSort() ]
    
}

class QueueCancellation {
    
    private var queued = false
    var isQueued: Bool {
        get {
            return self.queued
        }
        
        set {
            self.queued = newValue
        }
    }
    
}

class QuickSort: Algorithm {
    
    func sort(array: inout [SortingValue], cancellation: QueueCancellation) {
        quicksort(array: &array, left: 0, right: array.count - 1, cancellation: cancellation)
    }
    
    func name() -> String {
        return "Quick Sort"
    }
    
    func quicksort(array: inout [SortingValue], left: Int, right: Int, cancellation: QueueCancellation) {
        if cancellation.isQueued {
            return
        }
        
        if left >= right {
            return
        }
        
        let pivot = left
        var i = pivot + 1
        var j = right
        var temp: SortingValue
        
        while i <= j {
            while i <= right && array[i].value <= array[pivot].value {
                i += 1
            }
            
            while j > left && array[j].value >= array[pivot].value {
                j -= 1
            }
            
            if i > j {
                temp = array[j]
                array[j] = array[pivot]
                array[pivot] = temp
            } else {
                temp = array[i]
                array[i] = array[j]
                array[j] = temp
            }
            
            usleep(5000)
        }
        
        quicksort(array: &array, left: left, right: j - 1, cancellation: cancellation)
        quicksort(array: &array, left: j + 1, right: right, cancellation: cancellation)
    }
    
    
}

class InsertionSort: Algorithm {
    
    func sort(array: inout [SortingValue], cancellation: QueueCancellation) {
        for x in 1..<array.count {
            var y = x
            let temp = array[y]
            
            while y > 0 && temp.value < array[y - 1].value {
                array[y] = array[y - 1]
                y -= 1
                
                if cancellation.isQueued {
                    return
                }
                
                usleep(100)
            }
            
            array[y] = temp
        }
    }
    
    func name() -> String {
        return "Insertion Sort"
    }
}

class SelectionSort: Algorithm {
    
    func sort(array: inout [SortingValue], cancellation: QueueCancellation) {
        var least: Int, temp: SortingValue
        
        for i in 0..<array.count - 1 {
            least = i
            
            for j in (i + 1)..<array.count {
                if array[j].value < array[least].value {
                    least = j
                }
                
                if cancellation.isQueued {
                    return
                }
            }
            
            if i != least {
                temp = array[i]
                array[i] = array[least]
                array[least] = temp
            }
            
            usleep(10000)
        }
    }
    
    func name() -> String {
        return "Selection Sort"
    }
}

class MergeSort: Algorithm {
    
    func name() -> String {
        return "Merge Sort"
    }
    
    func sort(array: inout [SortingValue], cancellation: QueueCancellation) {
        var sorted = [SortingValue?](repeating: nil, count: array.count)
        
        mergeSort(sorted: &sorted, array: &array, left: 0, right: array.count - 1, cancellation: cancellation)
    }
    
    func merge(sorted: inout [SortingValue?], array: inout [SortingValue], left: Int, mid: Int, right: Int, cancellation: QueueCancellation) {
        var i = left
        var j = mid + 1
        var k = left
        
        while i <= mid && j <= right {
            if array[i].value <= array[j].value {
                sorted[k] = array[i]
                
                k += 1
                i += 1
            } else {
                sorted[k] = array[j]
                
                k += 1
                j += 1
            }
            
            if cancellation.isQueued {
                return
            }
        }
        
        if i > mid {
            for l in j...right {
                sorted[k] = array[l]
                
                k += 1
            }
        } else {
            for l in i...mid {
                sorted[k] = array[l]
                
                k += 1
            }
        }
        
        for l in left...right {
            if cancellation.isQueued {
                return
            }
            
            if let value = sorted[l] {
                array[l] = value
            }
        }
        
        usleep(10000)
    }
    
    private func mergeSort(sorted: inout [SortingValue?], array: inout [SortingValue], left: Int, right: Int, cancellation: QueueCancellation) {
        if cancellation.isQueued {
            return
        }
        
        if left < right {
            let mid = (left + right) / 2
            
            mergeSort(sorted: &sorted, array: &array, left: left, right: mid, cancellation: cancellation)
            mergeSort(sorted: &sorted, array: &array, left: mid + 1, right: right, cancellation: cancellation)
            merge(sorted: &sorted, array: &array, left: left, mid: mid, right: right, cancellation: cancellation)
        }
    }
}

class RadixSort: Algorithm {
    func name() -> String {
        return "Radix Sort"
    }
    
    func sort(array: inout [SortingValue], cancellation: QueueCancellation) {
        let radix = 10
        var done = false
        var index: Int
        var digit = 1
        
        while !done {
            done = true
            
            var buckets: [[SortingValue]] = []
            for _ in 1...radix {
                buckets.append([])
            }
            
            for number in array {
                index = Int(number.value * 1000000000) / digit
                buckets[index % radix].append(number)
                if done && index > 0 {
                    done = false
                }
            }
            
            var i = 0
            
            for j in 0..<radix {
                let bucket = buckets[j]
                
                for number in bucket {
                    array[i] = number
                    i += 1
                    
                    usleep(1000)
                }
            }
            
            digit *= radix
        }
    }
    
}


class BubbleSort: Algorithm {
    
    func name() -> String {
        return "Bubble Sort"
    }
    
    func sort(array: inout [SortingValue], cancellation: QueueCancellation) {
        var temp: SortingValue
        
        for _ in 0..<array.count {
            for j in 1..<array.count - 1 {
                if array[j].value < array[j - 1].value {
                    temp = array[j - 1]
                    array[j - 1] = array[j]
                    array[j] = temp
                    
                    usleep(10)
                }
            }
        }
    }
    
}

class ShellSort: Algorithm {
    func name() -> String {
        return "Shell Sort"
    }
    
    func sort(array: inout [SortingValue], cancellation: QueueCancellation) {
        var h = 1
        
        while h <= array.count / 3 {
            h = h * 3 + 1
        }
        
        while h > 0 {
            for i in 0..<array.count {
                let tmp = array[i]
                var j = i
                
                while j > h - 1 && array[j - h].value >= tmp.value {
                    array[j] = array[j - h]
                    j -= h
                    
                    usleep(1000)
                }
                
                array[j] = tmp
            }
            h = (h - 1) / 3
        }
    }
}

class HeapSort: Algorithm {
    func name() -> String {
        return "Heap Sort"
    }
    
    func sort(array: inout [SortingValue], cancellation: QueueCancellation) {
        for i in 1..<array.count {
            var c = i
            repeat {
                let root = (c - 1) / 2
                if array[root].value < array[c].value {
                    let temp = array[root]
                    array[root] = array[c]
                    array[c] = temp
                }
                c = root
                
                usleep(100)
            } while c != 0
        }
        
        for i in (0..<array.count).reversed() {
            var temp = array[0]
            array[0] = array[i]
            array[i] = temp
            
            var root = 0
            var c = 1
            
            repeat {
                c = 2 * root + 1
                
                if c < i - 1 && array[c].value < array[c + 1].value {
                    c += 1
                }
                
                if c < i && array[root].value < array[c].value {
                    temp = array[root]
                    array[root] = array[c]
                    array[c] = temp
                }
                root = c
                
                usleep(100)
            } while c < i
        }
    }
    
}

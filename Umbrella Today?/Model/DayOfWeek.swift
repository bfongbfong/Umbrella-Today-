//
//  DayOfWeek.swift
//  Umbrella Today?
//
//  Created by Brandon Fong on 1/2/20.
//  Copyright © 2020 Fiesta Togo Inc. All rights reserved.
//

import Foundation

class DayOfWeek: Equatable {
    var value: String
    var next: DayOfWeek?
    init(_ value: String) {
        self.value = value
    }
    
    static func == (lhs: DayOfWeek, rhs: DayOfWeek) -> Bool {
        return lhs.value == rhs.value
    }
}

// Circular Singly Linked List
class Week {
    var head: DayOfWeek?
    var tail: DayOfWeek?
    
    init() {
        populateData()
    }
    
    private func populateData() {
        add(value: "MON")
        add(value: "TUE")
        add(value: "WED")
        add(value: "THU")
        add(value: "FRI")
        add(value: "SAT")
        add(value: "SUN")
    }
    
    private func add(value: String) {
        if head == nil {
            head = DayOfWeek(value)
            head!.next = head
            tail = head
        }
        else if head!.next === head {
            // there is only one element
            let newNode = DayOfWeek(value)
            head!.next = newNode
            newNode.next = head
            tail = newNode
        } else {
            let newNode = DayOfWeek(value)
            tail!.next = newNode
            newNode.next = head
            tail = newNode
        }
    }
    
    func generateWeekFrom(dayOfWeek: String, amountOfDays: Int) -> [String] {
        var returnArray = [String]()
        var current = head
        var counter = 0
        
        while current != nil && current!.value != dayOfWeek {
            counter += 1
            current = current!.next
            
            if counter > 14 {
                print("Looking for day of week went on infinite loop")
                return []
            }
        }
        
        for _ in 1...amountOfDays {
            returnArray.append(current!.value)
            current = current!.next
        }
        
        return returnArray
    }
}

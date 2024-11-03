//
//  CalendarView.swift
//  UICalendarView_SwiftUI
//
//  Created by Lori Rothermel on 11/2/24.
//

import SwiftUI

struct CalendarView: UIViewRepresentable {
    @ObservedObject var eventStore: EventStore
    @Binding var dateSelected: DateComponents?
    @Binding var displayEvents: Bool
    
    
    let interval: DateInterval

    func makeUIView(context: Context) -> UICalendarView {
        let view = UICalendarView()
        view.delegate = context.coordinator
        view.calendar = Calendar(identifier: .gregorian)
        view.availableDateRange = interval
        let dateSelection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        view.selectionBehavior = dateSelection
        return view
    }  // func makeUIView
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, eventStore: _eventStore)
        
    }  // func makeCoordinator()
    
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        if let changedEvent = eventStore.changedEvent {
            uiView.reloadDecorations(forDateComponents: [changedEvent.dateComponents], animated: true)
            eventStore.changedEvent = nil
        }  // if let - changedEvent
        
        if let movedEvent = eventStore.movedEvent {
            uiView.reloadDecorations(forDateComponents: [movedEvent.dateComponents], animated: true)
            eventStore.movedEvent = nil
        }  // if let - movedEvent
           
    }
    
    
    
       
    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
                 
        var parent: CalendarView
        @ObservedObject var eventStore: EventStore
                
        init(parent: CalendarView, eventStore: ObservedObject<EventStore>) {
            self.parent = parent
            self._eventStore = eventStore
        }  // init
                
        
        //@MainActor
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            let foundEvents = eventStore.events
                .filter { $0.date.startOfDay == dateComponents.date?.startOfDay }
            
            if foundEvents.isEmpty { return nil }
                                     
            if foundEvents.count > 1 {
                return .image(UIImage(systemName: "doc.on.doc.fill"), color: .red, size: .large)
            }  // if
            
            let singleEvent = foundEvents.first!
            return .customView {
                let icon = UILabel()
                icon.text = singleEvent.eventType.icon
                return icon
            }  // return customView
            
        }  // func calendarView
        
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            parent.dateSelected = dateComponents
            
            guard let dateComponents else { return }
            
            let foundEvents = eventStore.events
                .filter { $0.date.startOfDay == dateComponents.date?.startOfDay }
            
            if !foundEvents.isEmpty {
                parent.displayEvents.toggle()
            }  // if
            
        }  // func dateSelection - didSelectDate
        
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
            return true
        }  // func dateSelection - canSelectDate
        
    }
    
    
}  // struct CalendarView

//
//  DaysEventsListView.swift
//  UICalendarView_SwiftUI
//
//  Created by Lori Rothermel on 11/2/24.
//

import SwiftUI

struct DaysEventsListView: View {
    @EnvironmentObject var eventStore: EventStore
    @Binding var dateSelected: DateComponents?
    @State private var formType: EventFormType?
    
    
    var body: some View {
        NavigationStack {
            Group {
                if let dateSelected {
                    let foundEvents = eventStore.events
                        .filter { $0.date.startOfDay == dateSelected.date!.startOfDay}
                    List {
                        ForEach(foundEvents) { event in
                            ListViewRow(event: event, formType: $formType)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        eventStore.delete(event)
                                    } label: {
                                        Image(systemName: "trash")
                                    }  // Button
                                }  // .swipeActions
                                .sheet(item: $formType) { $0 }
                        }  // ForEach
                    }  // List
                }  // if let
            }  // Group
            .navigationTitle(dateSelected?.date?.formatted(date: .long, time: .omitted) ?? "")
        }  // NavigationStack
    }
}


struct DaysEventsListView_Previews: PreviewProvider {
 
    static var dateComponents: DateComponents {
        var dateComponents = Calendar.current.dateComponents(
            [.month,
             .day,
             .year,
             .hour,
             .minute],
            from: Date())
        
        dateComponents.timeZone = TimeZone.current
        dateComponents.calendar = Calendar(identifier: .gregorian)
        return dateComponents
    }
    
//    #Preview {
//        DaysEventsListView(dateSelected: .constant(dateComponents))
//            .environmentObject(EventStore(preview: true))
//    }
    
    
    
    static var previews: some View {
        DaysEventsListView(dateSelected: .constant(dateComponents))
            .environmentObject(EventStore(preview: true))
    }
}

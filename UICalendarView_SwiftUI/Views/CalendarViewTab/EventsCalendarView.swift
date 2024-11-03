
import SwiftUI

struct EventsCalendarView: View {
    @EnvironmentObject var eventStore: EventStore
    @State private var dateSelected: DateComponents?
    @State private var displayEvents = false
    @State private var formType: EventFormType?
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                CalendarView(eventStore: eventStore, dateSelected: $dateSelected, displayEvents: $displayEvents, interval: DateInterval(start: .distantPast, end: .distantFuture))
                Image("launchScreen")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
            }  // ScrollView
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        formType = .new
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                    }  // Button
                }  // ToolbarItem
            }  // .toolbar
            .sheet(item: $formType) { $0 }
            .sheet(isPresented: $displayEvents) {
                DaysEventsListView(dateSelected: $dateSelected)
                    .presentationDetents([.medium, .large])
            }  // .sheet
            .navigationTitle("Calendar View")
            
        }  // NavigationStack
       
        
    }  // some View
    
}  // EventsCalendarView



struct EventsCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        EventsCalendarView()
            .environmentObject(EventStore(preview: true))
    }
}

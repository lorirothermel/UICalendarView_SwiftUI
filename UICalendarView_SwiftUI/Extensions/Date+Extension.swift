
import Foundation

extension Date {
    func diff(numDays: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: numDays, to: self)!
    }  // func diff
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }  // startOfDay
    
}

import Foundation

struct DateManager {
    static func convertDateString(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        if let date = dateFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy年M月d日"
            let convertedDateString = outputFormatter.string(from: date)
            return convertedDateString
        } else {
            return dateString
        }
    }
}

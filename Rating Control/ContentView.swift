
import SwiftUI

enum Rating: CaseIterable, Comparable {
    case one, two, three, four, five
}

extension Rating: Identifiable {
    var id: Self { self }
}

extension Rating: CustomStringConvertible {
    var description: String {
        switch self {
        case .one: return "One"
        case .two: return "Two"
        case .three: return "Three"
        case .four: return "Four"
        case .five: return "Five"
        }
    }
}

struct ContentView: View {

    @State var value = Rating.one
    var body: some View {
        RatingControl(value: $value)
            .padding()
    }
}

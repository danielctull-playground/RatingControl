
import SwiftUI

enum Rating: CaseIterable, Comparable {
    case one, two, three, four, five
}

extension Rating: Identifiable {
    var id: Self { self }
}

struct ContentView: View {

    @State var value = Rating.one
    var body: some View {
        RatingControl(value: $value)
            .padding()
    }
}

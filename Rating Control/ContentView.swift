
import SwiftUI

struct ContentView: View {

    @State var value = RatingControl.Value.one
    var body: some View {
        RatingControl(value: $value)
            .padding()
    }
}

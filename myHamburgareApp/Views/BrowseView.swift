import SwiftUI

struct BrowseView: View {
    var body: some View {
        VStack {
            Image(systemName: "square.grid.2x2.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.accentColor)
            Text("Browse")
                .font(.largeTitle)
                .bold()
        }
    }
}

#Preview {
    BrowseView()
}

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.accentColor)
            Text("Profile")
                .font(.largeTitle)
                .bold()
        }
    }
}

#Preview {
    ProfileView()
}

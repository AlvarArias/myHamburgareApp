import SwiftUI

struct ScanView: View {
    var body: some View {
        VStack {
            Image(systemName: "qrcode.viewfinder")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.accentColor)
            Text("Scan")
                .font(.largeTitle)
                .bold()
        }
    }
}

#Preview {
    ScanView()
}

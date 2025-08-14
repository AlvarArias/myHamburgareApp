import SwiftUI

struct ScanView: View {
    var body: some View {
        
        NavigationView {
            
            VStack {
                Text( "Scan your QR code to get started")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.top, 30)
                
                Text("Upload a photo of your recept to addingredients and instructions.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 10)
                
                Button(action: {
                    // Acción de escanear
                }) {
                    VStack {
                        Image(systemName: "camera.viewfinder")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.accentColor)
                        Text("Camera")
                            .font(.largeTitle)
                            .bold()
                    }
                }
               
                .padding()
                Spacer()
            }
            .navigationTitle("Scan")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {
                // Acción de volver
            }) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.accentColor)
            })
            
        }

    }
}

#Preview {
    ScanView()
}

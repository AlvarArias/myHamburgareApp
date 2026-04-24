import SwiftUI
import VisionKit

struct ScanView: View {
    @EnvironmentObject var tabSelection: TabSelection
    @StateObject private var viewModel: ScanViewModel
    @State private var isScannerPresented = false

    init(viewModel: ScanViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Scan your QR code to get started")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.top, 30)

                Text("Scan a QR code containing recipe data and add it directly to your collection.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                if let recipe = viewModel.scannedRecipe {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Scanned recipe")
                            .font(.headline)
                        Text(recipe.nombreReceta)
                            .font(.title3)
                            .bold()
                        Text(recipe.descripcion)
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        HStack(spacing: 12) {
                            Button(action: {
                                viewModel.saveScannedRecipe()
                            }) {
                                Text(viewModel.isRecipeSaved ? "Receta guardada" : "Guardar receta")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(viewModel.isRecipeSaved ? Color.gray.opacity(0.3) : Color.accentColor)
                                    .foregroundColor(viewModel.isRecipeSaved ? .primary : .white)
                                    .cornerRadius(12)
                            }
                            .disabled(viewModel.isRecipeSaved)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    .padding(.horizontal)
                }

                if let errorMessage = viewModel.scanErrorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Button(action: {
                    viewModel.scanErrorMessage = nil
                    isScannerPresented = true
                }) {
                    VStack(spacing: 12) {
                        Image(systemName: "qrcode.viewfinder")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .foregroundColor(.accentColor)
                        Text("Start Scanner")
                            .font(.headline)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor.opacity(0.15))
                    .cornerRadius(16)
                    .padding(.horizontal)
                }

                Spacer()
            }
            .navigationTitle("Scan")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        tabSelection.selectedTab = 0
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .sheet(isPresented: $isScannerPresented) {
                QRScannerView(isPresented: $isScannerPresented) { result in
                    viewModel.handleScanResult(result)
                }
            }
        }
        .background(Color(.systemBackground))
    }
}

struct QRScannerView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let completion: (Result<String, Error>) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> DataScannerViewController {
        let recognizedTypes: [DataScannerViewController.RecognizedDataType] = [.barcode(), .text()]
        let controller = DataScannerViewController(recognizedDataTypes: Set(recognizedTypes),
                                                   qualityLevel: .balanced,
                                                   recognizesMultipleItems: false)
        controller.delegate = context.coordinator

        do {
            try controller.startScanning()
        } catch {
            completion(.failure(error))
        }

        return controller
    }

    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {}

    func dismantleUIViewController(_ uiViewController: DataScannerViewController, coordinator: Coordinator) {
        uiViewController.stopScanning()
    }

    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        let parent: QRScannerView

        init(parent: QRScannerView) {
            self.parent = parent
        }

        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            guard let item = addedItems.first else { return }
            handleRecognizedItem(item, dataScanner: dataScanner)
        }

        func dataScanner(_ dataScanner: DataScannerViewController, didUpdate updatedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            guard let item = updatedItems.first else { return }
            handleRecognizedItem(item, dataScanner: dataScanner)
        }

        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            handleRecognizedItem(item, dataScanner: dataScanner)
        }

        func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
            parent.completion(.failure(error))
            DispatchQueue.main.async { [weak self] in
                self?.parent.isPresented = false
            }
        }

        private func handleRecognizedItem(_ item: RecognizedItem, dataScanner: DataScannerViewController) {
            switch item {
            case .barcode(let barcode):
                guard let payload = barcode.payloadStringValue else { return }
                parent.completion(.success(payload))
            case .text(let text):
                parent.completion(.success(text.transcript))
            default:
                return
            }

            dataScanner.stopScanning()
            DispatchQueue.main.async { [weak self] in
                self?.parent.isPresented = false
            }
        }
    }
}

#Preview {
    ScanView(viewModel: ScanViewModel(recipeStore: RecipeStore(repository: JSONRecipeRepository(bundle: .main))))
        .environmentObject(TabSelection())
}

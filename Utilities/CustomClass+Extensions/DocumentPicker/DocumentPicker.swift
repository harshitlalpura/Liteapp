//
//  DocumentPicker.swift

import UIKit
import MobileCoreServices

/// DocumentDelegate Protocl to get Docuemnt  FIle in URL romtae
protocol DocumentDelegate: class {
    func didPickDocument(document: Document?)
}

/// Document For Fetch and checkec file and archive in data fomrate
class Document: UIDocument {
    var data: Data?
    override func contents(forType typeName: String) throws -> Any {
        guard let data = data else { return Data() }
        return try NSKeyedArchiver.archivedData(withRootObject:data,
                                                requiringSecureCoding: true)
    }
    override func load(fromContents contents: Any, ofType typeName:
        String?) throws {
        guard let data = contents as? Data else { return }
        self.data = data
    }
}

/*
How to Use
 Declare Gobal Object top of class
 var documentPicker: DocumentPicker?
 
 initialized in didload
 documentPicker = DocumentPicker(presentationController: self, delegate: self)

 for open picker controller
 documentPicker?.displayPicker()

 add this delegate method for ghet docuemnt file
 func didPickDocument(document: Document?) {
    if let pickedDoc = document {
        let fileURL = pickedDoc.fileURL
    }
 }
*/


/// DocumentPicker Class help to docuemnt pickup from Icloud and drive
open class DocumentPicker: NSObject {
    private var pickerController: UIDocumentPickerViewController?
    private weak var presentationController: UIViewController?
    private weak var delegate: DocumentDelegate?

    private var pickedDocument: Document?
    
    
    /// Intialise mathod
    /// - Parameters:
    ///   - presentationController: Pass Present controller
    ///   - delegate: assign delegate self for get Locationn Object

    init(presentationController: UIViewController, delegate: DocumentDelegate) {
        super.init()
        self.presentationController = presentationController
        self.delegate = delegate
    }
    
    /// For Preset Picker Controller
    public func displayPicker() {
     
        /// pick movies and images
        self.pickerController = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        self.pickerController!.delegate = self
        self.presentationController?.present(self.pickerController!, animated: true)
    }
}

extension DocumentPicker: UIDocumentPickerDelegate {

    /// delegate method, when the user selects a file
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else {
            return
        }
        documentFromURL(pickedURL: url)
        delegate?.didPickDocument(document: pickedDocument)
    }

    /// delegate method, when the user cancels
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        delegate?.didPickDocument(document: nil)
    }

    private func documentFromURL(pickedURL: URL) {
        
        /// start accessing the resource
        let shouldStopAccessing = pickedURL.startAccessingSecurityScopedResource()

        defer {
            if shouldStopAccessing {
                pickedURL.stopAccessingSecurityScopedResource()
            }
        }
        NSFileCoordinator().coordinate(readingItemAt: pickedURL, error: NSErrorPointer.none) { (readURL) in
            let document = Document(fileURL: readURL)
            pickedDocument = document
        }
    }
}

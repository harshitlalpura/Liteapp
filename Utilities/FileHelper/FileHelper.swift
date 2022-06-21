//
//  FileHandler.swift
//  StructureApp
//
//  Created by App on 24/11/18.
//  Copyright © 2018 App Infotech Ltd. All rights reserved.
//

import UIKit
import AVFoundation

let document = FileManager.SearchPathDirectory.documentDirectory
let library = FileManager.SearchPathDirectory.libraryDirectory
let cache = FileManager.SearchPathDirectory.cachesDirectory

let videoFolder = "SelfTape"
let chunksFolder = "Chunks"
let thumbFolder = "Thumb"

public class FileHelper: NSObject {

     /// This method returns path of document directory.
    class var documentDirectory: URL {
        let documentsPath = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        return documentsPath
    }

    /// This method returns file path from directory.
    ///
    /// - Parameter fileName: name of the file which resides in directory of application including its extension.
    /// - Returns: Path
    public class func getLocalFile(fileName: String?) -> String? {
        return self.getLocalFile(fileName: fileName, directoryName: nil)
    }

    /// This method returns path
    ///
    /// - Parameters:
    ///   - fileName: name of the file including its extension.
    ///   - directoryName: name of the directory directory, in which the file resides.
    /// - Returns: Path
    private class func getLocalFile(fileName: String?, directoryName: String?) -> String? {
        let filePath = FileHelper .getLocalFilePath(fileName: fileName, directoryName: directoryName)
        if FileManager.default.fileExists(atPath: filePath!) {
            let localFile = filePath
            return localFile
        } else {
            return nil
        }
    }

    /// This method returns contents of a file in application's main bundle.
    ///
    /// - Parameter fileName: name of the file(including extension) which is added as resource in application.
    /// - Returns: Path of bundle path
    private class func getResource(fileName: String?) -> String? {
        return FileHelper.getResource(fileName: fileName, type: nil)
    }

    /// This method returns contents of a file in application's main bundle.
    ///
    /// - Parameters:
    ///   - fileName: name of the file(excluding extension) which is added as resource in application.
    ///   - type: type of file whose contents have to be read. It is extension of the file for example, .txt
    /// - Returns: Bundle path of resource
    public class func getResource(fileName: String?, type: String?) -> String? {
        let filePath = Bundle.main.path(forResource: fileName, ofType: type)
        if filePath != nil && FileManager.default.fileExists(atPath: filePath!) {
            let localFile = filePath!
            return localFile
        } else {
            return nil
        }
    }

    /// This methods checks if a file exists, in application's main bundle.
    ///
    /// - Parameter fileName: name of the file(excluding extension) which is added as resource in application.
    /// - Returns: Check file is exist or not in bundle
    private class func resourceFileExists(fileName: String?) -> Bool {
        return FileHelper.resourceFileExists(fileName: fileName, fileType: nil)
    }

    /// This methods checks if a file exists, in application's main bundle
    ///
    /// - Parameters:
    ///   - fileName: name of the file(excluding extension) which is added as resource in application.
    ///   - fileType: type of file.It is extension of the file for example, .txt
    /// - Returns: Check file is exist or not in bundle
    public class func resourceFileExists(fileName: String?, fileType: String?) -> Bool {
        let filePath: String? = Bundle.main.path(forResource: fileName, ofType: fileType)
        return FileManager.default.fileExists(atPath: filePath!)
    }

    /// This methods checks if a file exists, in caches / document directory of application.
    ///
    /// - Parameter fileName: name of the file(including extension) in caches / document directory.
    /// - Returns: Path
    public class func localFileExists(fileName: String?) -> Bool {
        return FileHelper.localFileExists(fileName: fileName, directoryName: nil)
    }

    /// This methods checks if a file exists, in a directory of application
    ///
    /// - Parameters:
    ///   - fileName: name of the file(including extension) in caches directory.
    ///   - directoryName: name of the directory, in which file has to be searched.
    /// - Returns::Path of directory
    private class func localFileExists(fileName: String?, directoryName: String?) -> Bool {
        let documentsDirectory: String? = FileHelper.getLocalFilePath(fileName: fileName, directoryName: directoryName)
        return FileManager.default.fileExists(atPath: documentsDirectory!)
    }

    /// This methods creates a directory in specific directory of application
    ///
    /// - Parameter directoryName: name of the directory to be created
    /// - directory: Directory search path name
    /// - Returns: Return Bool if directory created else false

    public class func createLocalDirectory(directoryName: String?, directory: FileManager.SearchPathDirectory) -> Bool {
        let paths = NSSearchPathForDirectoriesInDomains(directory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory: AnyObject = paths[0] as AnyObject
        let folderName = documentsDirectory.appending("/\(directoryName!)")
        if FileManager.default.fileExists(atPath: folderName) {
            return true
        } else {
            do {
                try FileManager.default.createDirectory(atPath: folderName, withIntermediateDirectories: false, attributes: nil)
                return true
            } catch {
                return false
            }
        }
    }

    /// This method returns bool after deleteion successfully
    ///
    /// - Parameter directoryName: Directiory full name
    ///   - directory: Pass dictionary serach path
    /// - Returns: Return Bool if directory deleted else false

    public class func deleteDirectioryNFile(directoryName: String?, directory: FileManager.SearchPathDirectory) -> Bool {

        let paths = NSSearchPathForDirectoriesInDomains(directory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory: AnyObject = paths[0] as AnyObject
        let deletionPath = documentsDirectory.appending("/\(directoryName!)")
        if FileManager.default.fileExists(atPath: deletionPath) {
            do {
                try FileManager.default.removeItem(atPath: deletionPath)
                return true
            } catch {
                return false
            }

        } else {
            return false
        }
    }

    /// This method returns bool after deleteion file successfully
    /// - Parameters:
    ///   - fileName: File path which we have to delete
    public class func deleteFile(fileName: String) -> Bool {

        if FileManager.default.fileExists(atPath: fileName) {
            do {
                try FileManager.default.removeItem(at: URL(fileURLWithPath: fileName))
                return true
            } catch {
                return false
            }
        } else {
            return false
        }
    }

    /// This method returns array of files in caches directory of application.
    ///
    /// - directory: Directory search path name
    /// - Returns: returns array of files in caches directory of application.
    public class func getFiles(directoryName: String?, directory: FileManager.SearchPathDirectory) -> NSArray? {
        return FileHelper.getFilesinDirectory(directoryName: directoryName, directory: directory)
    }

    /// This method returns array of files in a directory in caches directory of application.
    ///
    /// - Parameter directoryName: name of the directory in cache directory
    /// - directory: Directory search path name
    /// - Returns: returns array of files in a directory in caches directory of application.
    private class func getFilesinDirectory(directoryName: String?, directory: FileManager.SearchPathDirectory) -> NSArray? {
        var path: String?
        path = NSSearchPathForDirectoriesInDomains(directory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        if let directoryName = directoryName {
            path = path?.appending("/\(directoryName)")
        }

        do {
            return try FileManager.default.contentsOfDirectory(atPath: path!) as NSArray
        } catch {
            return nil
        }
    }

    /// This method returns array of files with a extension(s) specified in "pathExtension" parameter, in caches directory of application.
    ///
    /// - Parameter pathExtension: It a string specifying a single path extension or an array of path extensions.
    /// - directory: Directory search path name
    /// - Returns: returns array of files with a extension(s) specified in "pathExtension" parameter, in caches directory of application.
    public class func getFilesByExtenstion(pathExtension: AnyObject?, directoryName: String?, directory: FileManager.SearchPathDirectory) -> NSArray? {
        return FileHelper.getFiles(pathExtension: pathExtension, directoryName: directoryName, directory: directory)
    }

    /// This method returns array of files with a extension(s) specified in "pathExtension" parameter, in a directory of caches directory of application.
    ///
    /// - Parameters:
    ///   - pathExtension: It a string specifying a single path extension or an array of path extensions.
    /// - directory: Directory search path name
    /// - Returns: returns array of files with a extension(s) specified in "pathExtension" parameter, in a directory of caches directory of application.
    private class func getFiles(pathExtension: AnyObject?, directoryName: String?, directory: FileManager.SearchPathDirectory) -> NSArray? {
        var aryPaths: NSMutableArray? = NSMutableArray()
        if pathExtension! is String {
            aryPaths?.add(pathExtension!)
        } else if pathExtension! is [String] {
            aryPaths = NSMutableArray(array: pathExtension! as! [Any], copyItems: true)
        }
        let aryFiles = NSMutableArray.init(array: FileHelper.getFilesinDirectory(directoryName: directoryName!, directory: directory)!)
        return aryFiles.pathsMatchingExtensions(aryPaths as! [String]) as NSArray
    }

    /// This method returns the date at which the file was created in caches directory of application.
    ///
    /// - Parameter fileName: name of the file in caches directory, whose creation date has to be returned.
    /// - Returns: returns file creation date.
    public class func getFileCreatedDate(fileName: String?) -> Date? {
        return FileHelper.getFileCreatedDate(fileName: fileName, directoryName: nil)
    }

    /// This method returns the date at which the file was created in a directory of caches directory of application.
    ///
    /// - Parameters:
    ///   - fileName: name of the file in a directory of caches directory, whose creation date has to be returned.
    ///   - directoryName: name directory in caches directory which contains the file.
    /// - Returns: returns file creation date.
    private class func getFileCreatedDate(fileName: String?, directoryName: String?) -> Date? {
        var attrs: NSDictionary?
        do {
            attrs = try FileManager.default.attributesOfItem(atPath: FileHelper.getLocalFilePath(fileName: fileName, directoryName: directoryName)!) as NSDictionary
        } catch {
            return nil
        }
        if attrs != nil {
            let date = attrs?.object(forKey: FileAttributeKey.creationDate) as? Date
            return date
        } else {
            return nil
        }
    }

    /// This method returned the time elapsed from creation date of the file in caches directory of application in seconds
    ///
    /// - Parameter fileName: name of the file in caches directory.
    /// - Returns: returns time difference since file creation date.
    public class func getTimeDifferenceSinceCreated(fileName: String?) -> Float? {
        return FileHelper.getTimeDifferenceSinceCreated(fileName: fileName, directoryName: nil)
    }

    /// This method returned the time elapsed from creation date of the file in a directory of  caches directory of application in seconds
    ///
    /// - Parameters:
    ///   - fileName: name of the file in caches directory.
    ///   - directoryName: name of the dicrectory in which file is located.
    /// - Returns: returns time difference since file creation date.
    private class func getTimeDifferenceSinceCreated(fileName: String?, directoryName: String?) -> Float? {
        let fileCreationDate = FileHelper.getFileCreatedDate(fileName: fileName, directoryName: directoryName)
        return Float(Date().timeIntervalSince(fileCreationDate! as Date))
    }

    /// This method returns fully qualified path of a file in caches directory or a directory in caches directory of application.
    ///
    /// - Parameters:
    ///   - fileName: name of the file.
    ///   - directoryName: name of the directory in caches directory which contains the file.If the file resides in caches directory itself directoryName should be given as nil.
    /// - Returns: returns path string of file.
    private class func getLocalFilePath(fileName: String?, directoryName: String?) -> String? {
        var documentsDirectory: String? = NSHomeDirectory()
        if let directoryName = directoryName {
            documentsDirectory = documentsDirectory?.appending(directoryName)
        }
        if let fileName = fileName {
            documentsDirectory = documentsDirectory?.appending(fileName)
        }
        return documentsDirectory! as String
    }

    /// This method returns contents of a file in a directory of caches directory, as an String.
    ///
    /// - Parameters:
    ///   - fileName: name of the whose contents has to be returned including its extension.
    ///   - directoryName: name of the directory in caches directory, in which the file resides.
    /// - Returns: returns path string of image.
    private class func getLocalFilePathForImage(fileName: String?, directoryName: String?) -> String? {
        var documentsDirectory: String? = NSHomeDirectory()
        if let directoryName = directoryName {
            documentsDirectory = documentsDirectory?.appending(directoryName)
        }
        if let fileName = fileName {
            documentsDirectory = documentsDirectory?.appending(fileName)
        }
        return documentsDirectory! as String
    }

    class func getDocumentDirectory() -> String? {
        let documentsDirectory: String? = NSHomeDirectory()
        return documentsDirectory?.appending("/Documents/")
    }

//    class func saveVideoThumbToDocumentDirectory(avAsset: AVURLAsset, timestamp: TimeInterval, completion: ((Bool, TimeInterval?) -> Void)) {
//
//        guard let thumbImage = Utility.sharedInstance.generateThumbnail(path: avAsset.url) else { return  }
//        let imageData = thumbImage.jpegData(compressionQuality: 0.5)
//
//        let newPath = getDocumentDirectory()?.appending("Thumb/\(timestamp).png")
//
//        do {
//            try imageData?.write(to: URL(fileURLWithPath: newPath!))
//            completion(true, timestamp)
//        } catch {
//            print(error)
//            completion(false, nil)
//        }
//
//    }

    class func updateVideoThumbToDocumentDirectory(oldName: String, newName: String, completion: ((Bool, TimeInterval?) -> Void)) {
        let timestamp = Date().timeIntervalSince1970

        let oldPathVideo = URL(fileURLWithPath: ((getDocumentDirectory()?.appending("SelfTape/\(oldName).mp4"))!))
        let oldPath = URL(fileURLWithPath: ((getDocumentDirectory()?.appending("Thumb/\(oldName).png"))!))
        let newPath = URL(fileURLWithPath: ((getDocumentDirectory()?.appending("Thumb/\(newName).png"))!))

        if "\(oldName)" == "\(newName)" {
            completion(true, timestamp)
        } else {
            if FileManager.default.fileExists(atPath: oldPath.path) {
                do {
                    try FileManager.default.copyItem(at: oldPath, to: newPath)
                    try _ = FileManager.default.removeItem(at: oldPath)
                    if FileManager.default.fileExists(atPath: oldPathVideo.path) {
                        try _ = FileManager.default.removeItem(at: oldPathVideo)
                    }

                    completion(true, timestamp)
                } catch {
                    print(error)
                    completion(false, nil)
                }

            }
        }
    }

    deinit {
        print("FileHelper Deinitialized successfully.")
    }

}

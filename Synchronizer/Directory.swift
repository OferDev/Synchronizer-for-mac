//
//  Directory.swift
//  Synchronizer
//
//  Created by Ofer tzafrir on 13/07/2020.
//  Copyright © 2020 B.I.S. All rights reserved.
//

import AppKit
//CustomDebugStringConvertible
public struct Metadata: Equatable {
    
    let name: String
    let modifiedDate: Date
    let createdDate: Date
    let seacurity: Bool
    let protectStatus: Bool
    let size: Int64
    let icon: NSImage
    let url: URL
    let type: String
    
    
    init(fileURL: URL, name: String, modifiedDate: Date, createdDate: Date, seacurity: Bool, protectStatus: Bool, size: Int64, icon: NSImage, type: String) {
        self.url = fileURL
        self.name = name
        self.modifiedDate = modifiedDate
        self.createdDate = createdDate
        self.seacurity = seacurity
        self.protectStatus = protectStatus
        self.size = size
        self.icon = icon
        self.type = type
    }
    
    //    public var debugDescription: String {
    //        return name + " " + "Folder: \(isFolder)" + " Size: \(size)"
    //    }
    
}

// MARK:  Metadata  Equatable

public func ==(lhs: Metadata, rhs: Metadata) -> Bool {
    return (lhs.url == rhs.url)
}


public struct Directory  {
    
    fileprivate var files: [Metadata] = []
    let url: URL
    
    public enum FileOrder: String {
        case Name
        case Date
        case Size
    }
    
    public init(folderURL: URL) {
        url = folderURL
        let requiredAttributes = [URLResourceKey.localizedNameKey, URLResourceKey.effectiveIconKey,
                                  URLResourceKey.typeIdentifierKey, URLResourceKey.contentModificationDateKey, URLResourceKey.creationDateKey,
                                  URLResourceKey.fileSizeKey, URLResourceKey.isDirectoryKey,
                                  URLResourceKey.isPackageKey, URLResourceKey.fileSecurityKey]
        if let enumerator = FileManager.default.enumerator(at: folderURL,
                                                           includingPropertiesForKeys: requiredAttributes,
                                                           options: [.skipsHiddenFiles, .skipsPackageDescendants, .skipsSubdirectoryDescendants],
                                                           errorHandler: nil) {
            
            while let url = enumerator.nextObject() as? URL {
                print("\(url)")
                
                do {
                    let properties = try  (url as NSURL).resourceValues(forKeys: requiredAttributes)
                    
                    files.append(Metadata(fileURL: url, name:
                        properties[URLResourceKey.localizedNameKey] as? String ?? "", modifiedDate: properties[URLResourceKey.contentModificationDateKey] as? Date ?? Date.distantPast, createdDate: properties[URLResourceKey.creationDateKey] as? Date ?? Date.distantPast, seacurity: false, protectStatus: false, size: properties[URLResourceKey.fileSizeKey] as! Int64, icon: properties[URLResourceKey.effectiveIconKey] as? NSImage  ?? NSImage(), type: properties[URLResourceKey.typeIdentifierKey] as? String ?? ""))
                }
                catch {
                    print("Error reading file attributes")
                }
            }
        }
    }
    
    
    func contentsOrderedBy(_ orderedBy: FileOrder, ascending: Bool) -> [Metadata] {
        let sortedFiles: [Metadata]
        switch orderedBy {
        case .Name:
            sortedFiles = files.sorted {
                return sortMetadata(lhsIsFolder:true, rhsIsFolder: true, ascending: ascending,
                                    attributeComparation:itemComparator(lhs:$0.name, rhs: $1.name, ascending:ascending))
            }
        case .Size:
            sortedFiles = files.sorted {
                return sortMetadata(lhsIsFolder:true, rhsIsFolder: true, ascending:ascending,
                                    attributeComparation:itemComparator(lhs:$0.size, rhs: $1.size, ascending: ascending))
            }
        case .Date:
            sortedFiles = files.sorted {
                return sortMetadata(lhsIsFolder:true, rhsIsFolder: true, ascending:ascending,
                                    attributeComparation:itemComparator(lhs:$0.modifiedDate, rhs: $1.modifiedDate, ascending:ascending))
            }
        }
        return sortedFiles
    }
    
}

// MARK: - Sorting

func sortMetadata(lhsIsFolder: Bool, rhsIsFolder: Bool,  ascending: Bool,
                  attributeComparation: Bool) -> Bool {
    if(lhsIsFolder && !rhsIsFolder) {
        return ascending ? true : false
    }
    else if (!lhsIsFolder && rhsIsFolder) {
        return ascending ? false : true
    }
    return attributeComparation
}

func itemComparator<T:Comparable>(lhs: T, rhs: T, ascending: Bool) -> Bool {
    return ascending ? (lhs < rhs) : (lhs > rhs)
}


public func ==(lhs: Date, rhs: Date) -> Bool {
    if lhs.compare(rhs) == .orderedSame {
        return true
    }
    return false
}

public func <(lhs: Date, rhs: Date) -> Bool {
    if lhs.compare(rhs) == .orderedAscending {
        return true
    }
    return false
}

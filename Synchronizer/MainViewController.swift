//
//  ViewController.swift
//  Synchronizer
//
//  Created by Ofer tzafrir on 05/07/2020.
//  Copyright © 2020 B.I.S. All rights reserved.
//

import Cocoa
      
class MainViewController: NSViewController {
    
    let sizeFormatter = ByteCountFormatter()
    var directoryItems: [Metadata]?
    var directory: Directory?
    var sortOrder = Directory.FileOrder.Name
    var sortAscending = true
    
    
    @IBOutlet weak var leftComboBox: NSComboBox!
    
    @IBOutlet weak var leftTableView: NSTableView!
    @IBOutlet weak var rightTableView: NSTableView!
    @IBOutlet weak var buttomTableView: NSTableView!
    
    // MARK: - View Lifecycle & error dialog utility
    
    override func viewDidLoad() {
    
       let completePath = "/"
       let completeUrl = URL(fileURLWithPath: completePath)
       self.selectedFolder = completeUrl
        
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        
    }
    
    override func viewWillAppear() {
        
    }
    
    // MARK: - Properties

    var filesList: [URL] = []
    var showInvisibles = false

    var selectedFolder: URL? {
      didSet {
        if let selectedFolder = selectedFolder {
          filesList = contentsOf(folder: selectedFolder)
          //selectedItem = nil
            
          self.leftTableView.reloadData()
          //self.leftTableView.scrollRowToVisible(0)
          //moveUpButton.isEnabled = true
           // self.leftComboBox.sele
          //view.window?.title = selectedFolder.lastPathComponent
        } else {
          //moveUpButton.isEnabled = false
          //view.window?.title = ""
        }
      }
    }
    
    

        override var representedObject: Any? {
            didSet {
                
                  let url = URL(fileURLWithPath: "file:///")
                  directory = Directory(folderURL: url)
                  reloadFileList(tableView:leftTableView)
                  //reloadFileList(tableView: self.rightTableView)
                
            }
        }
        
        func reloadFileList(tableView: NSTableView) {
          directoryItems = directory?.contentsOrderedBy(sortOrder, ascending: sortAscending)
          tableView.reloadData()
        }
    }

// MARK: - Getting file or folder information

    extension MainViewController {

      func contentsOf(folder: URL) -> [URL] {
        // 1
        let fileManager = FileManager.default

        // 2
        do {
          // 3
          let contents = try fileManager.contentsOfDirectory(atPath: folder.path)

          // 4
          let urls = contents.map { return folder.appendingPathComponent($0) }
          return urls
        } catch {
          // 5
          return []
        }
      }
    }

// MARK: - NSTableViewDataSource


extension MainViewController: NSTableViewDataSource {
  
  func numberOfRows(in tableView: NSTableView) -> Int {

    return filesList.count
    //return directoryItems?.count ?? 0
  }

}

// MARK: - NSTableViewDelegate

extension MainViewController: NSTableViewDelegate {

  fileprivate enum CellIdentifiers {
    static let NameCell = "NameCellID"
    static let SizeCell = "SizeCellID"
    static let TypeCell = "TypeCellID"
    static let ModifiedCell = "ModifiedCellID"
    static let CreatedCell = "CreatedCellID"
    static let SeacurityCell = "SeacurityCellID"
    static let ProtectStatusCell = "ProtectStatusCellID"
  }

  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
//    // 1
//       let item = filesList[row]
//
//       // 2
//       let fileIcon = NSWorkspace.shared.icon(forFile: item.path)
//
//       // 3
//       if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "FileCell"), owner: nil)
//         as? NSTableCellView {
//         // 4
//         cell.textField?.stringValue = item.lastPathComponent
//         cell.imageView?.image = fileIcon
//         return cell
//       }
//
//       // 5
//       return nil
//    }

    var image: NSImage?
    var text: String = ""
    var cellIdentifier: String = ""

    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .long
    dateFormatter.timeStyle = .long

    
    let item = filesList[row]
    let fileIcon = NSWorkspace.shared.icon(forFile: item.path)
//    // 1
//    guard let item = directoryItems?[row] else {
//      return nil
//    }
//
//    // 2
    if tableColumn == tableView.tableColumns[0] {
      image = fileIcon
      text = item.lastPathComponent
      cellIdentifier = CellIdentifiers.NameCell
    }
    
//    } else if tableColumn == tableView.tableColumns[1] {
//      text = sizeFormatter.string(fromByteCount: item.size)
//      cellIdentifier = CellIdentifiers.SizeCell
//    } else if tableColumn == tableView.tableColumns[2] {
//      text = item.type
//      cellIdentifier = CellIdentifiers.TypeCell
//    }else if tableColumn == tableView.tableColumns[3] {
//      text = dateFormatter.string(from: item.modifiedDate)
//      cellIdentifier = CellIdentifiers.ModifiedCell
//    }else if tableColumn == tableView.tableColumns[4] {
//      text = dateFormatter.string(from: item.createdDate)
//      cellIdentifier = CellIdentifiers.CreatedCell
//    }else if tableColumn == tableView.tableColumns[5] {
//        text = String(item.seacurity)
//      cellIdentifier = CellIdentifiers.SeacurityCell
//    }else if tableColumn == tableView.tableColumns[6] {
//        text = String(item.protectStatus)
//      cellIdentifier = CellIdentifiers.ProtectStatusCell
//    }
//
//
//    // 3
    if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
      cell.textField?.stringValue = text
      cell.imageView?.image = image ?? nil
      return cell
    }
    return nil
  }

}




//
//  ExportTimesheetPopupVC.swift
//  Liteapp
//
//  Created by Apurv Soni on 12/09/22.
//

import UIKit
import xlsxwriter
import PDFKit
import FirebaseAnalytics

struct TableDataItemPayPeriod {
    let empName: String
    let totalHrs: String
    let status: String
    
    init(empName: String, totalHrs: String, status: String) {
        self.empName = empName
        self.totalHrs = totalHrs
        self.status = status
    }
}

//

class ExportTimesheetPopupVC: UIViewController,StoryboardSceneBased {
    
    // MARK: - Outlets
    @IBOutlet weak var viewPopup: UIView!
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnExportCSV: UIButton!
    @IBOutlet weak var btnExportPDF: UIButton!
    @IBOutlet weak var btnExportExcel: UIButton!
    @IBOutlet weak var lblExportTimeSheet: UILabel!
    
    // MARK: - Variables
    var selectedTimesheetList : [PayPeriodTimesheet]?
    var payPeriodStr : String = ""
    var completion: ((Bool) -> ())?
    static let sceneStoryboard = UIStoryboard(name:Device.current.isPad ? StoryboardName.timesheetiPad.rawValue : StoryboardName.timesheet.rawValue, bundle: nil)
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewPopup.alpha = 0.0
        // Do any additional setup after loading the view.
        lblExportTimeSheet.text = NSLocalizedString("Export Timesheets", comment: "lblExportTimeSheet")
        btnClose.setTitle(NSLocalizedString("Close", comment: "btnClose"), for: .normal)
        btnExportCSV.setTitle(NSLocalizedString("Export to CSV", comment: "btnExportCSV"), for: .normal)
        btnExportPDF.setTitle(NSLocalizedString("Export to PDF", comment: "btnExportPDF"), for: .normal)
        btnExportExcel.setTitle(NSLocalizedString("Export to Excel", comment: "btnExportExcel"), for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.25) {
            self.viewPopup.alpha = 1.0
        }
    }
    
    // MARK: - Helper
    func hideView(){
        UIView.animate(withDuration: 0.2) {
            self.viewPopup.alpha = 0.0
        }completion: { completed in
            self.completion!(true)
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    // MARK: - Button
    @IBAction func btnCSVTapped(_ sender: Any) {
        LogFirebaseEvents(event_type: "CSV", event_name: "timesheet_exported", content_type: "button")
        createCSV()
    }
    
    @IBAction func btnPdfTapped(_ sender: Any) {
        LogFirebaseEvents(event_type: "PDF", event_name: "timesheet_exported", content_type: "button")
        createPDF()
    }
    
    @IBAction func btnExcelTapped(_ sender: Any) {
        LogFirebaseEvents(event_type: "XLS", event_name: "timesheet_exported", content_type: "button")
        createExcelSheet()
    }
    
    @IBAction func btnClosetapped(_ sender: Any) {
        hideView()
    }
    
    private func LogFirebaseEvents(event_type: String, event_name: String, content_type: String){
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
          AnalyticsParameterItemID: event_type,
          AnalyticsParameterItemName: event_name,
          AnalyticsParameterContentType: content_type,
        ])
    }
    
    // MARK: - Export Helper
    func createCSV() {
        ProgressHUD.show()
        let payPeriodWithoutComma = payPeriodStr.replace(string: ",", withString: "")
        var csvString = "Pay Period - " + payPeriodWithoutComma + "\n"
//        var csvString = "\("Employee"),\("Total Hours"),\("Status")\n"
        csvString = csvString.appending("\("Employee"),\("Total Hours"),\("Status")\n")
        
        if let list = selectedTimesheetList{
            for dct in list {
                let fname = dct.empFirstname ?? ""
                let lname = dct.empLastname ?? ""
                let fullname = fname + " " + lname
                let total = dct.total ?? ""
                var status = ""
                if dct.payperiodStatus ?? "" == "U"{
                    status = "Unapproved"
                    
                }else if dct.payperiodStatus ?? "" == "A"{
                    status = "Approved"
                }
                csvString = csvString.appending("\(fullname),\(total),\(status)\n")
            }
            
            let fileManager = FileManager.default
            do {
                let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
                let fileName = "Timesheet - " +  payPeriodStr + ".csv"
                let fileURL = path.appendingPathComponent(fileName)
                try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
                DispatchQueue.main.async {
                    let vc = UIActivityViewController(
                        activityItems: [fileURL],
                        applicationActivities: []
                    )
                    ProgressHUD.hide()
                    self.present(vc, animated: true, completion: nil)
                }
            } catch {
                ProgressHUD.hide()
                print("error creating file")
            }
        }
    }
    
    func createExcelFile(){
        
    }
    private func docDirectoryPath() -> String{
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                           .allDomainsMask,
                                                           true)
        return dirPaths[0]
    }
    
    func createExcelSheet(){
        ProgressHUD.show()
        /* Create a new workbook and add a worksheet. */
        let fileName = "/Timesheet -" + payPeriodStr + ".xlsx"
        var destination_path = docDirectoryPath()
        destination_path.append(fileName)
        let workbook = workbook_new(destination_path)
        let worksheet = workbook_add_worksheet(workbook, nil);
        
        /* Add a format. */
        let format = workbook_add_format(workbook);
        let centre_format = workbook_add_format(workbook);
        let centre_format_large = workbook_add_format(workbook);
        let centre_format_Med = workbook_add_format(workbook);
        
        /* Set the bold property for the format */
        format_set_align(format, 2)
        
        format_set_align(centre_format, 2)
        format_set_border(centre_format, 1)
        format_set_bold(centre_format);
        
        format_set_align(centre_format_large, 2)
        format_set_border(centre_format_large, 1)
        format_set_bold(centre_format_large);
        format_set_font_size(centre_format_large, 20.0)
        
        format_set_align(centre_format_Med, 2)
        format_set_border(centre_format_Med, 1)
        format_set_bold(centre_format_Med);
        format_set_font_size(centre_format_Med, 18.0)
        
        worksheet_merge_range(worksheet, 0, 0, 0, 3, nil, centre_format)
        worksheet_merge_range(worksheet, 1, 0, 1, 3, nil, centre_format)
        worksheet_merge_range(worksheet, 2, 0, 2, 3, nil, centre_format)
        
        
        
        /* Change the column width for clarity. */
        worksheet_set_row(worksheet, 0, 30, nil)
        worksheet_set_column(worksheet, 0, 0, 30, nil);
        worksheet_set_column(worksheet, 2, 0, 20, nil);
        worksheet_set_column(worksheet, 0, 1, 20, nil);
        worksheet_set_column(worksheet, 0, 2, 30, nil);
        
        let businessName = Defaults.shared.currentUser?.merchantName ?? ""
        worksheet_write_string(worksheet, 0, 0, businessName, centre_format_large);
        worksheet_write_string(worksheet, 2, 0, "Pay Period - " + payPeriodStr , centre_format_Med);
        
        //Set Titles
        worksheet_write_string(worksheet, 5, 0, "Employee", centre_format);
        worksheet_write_string(worksheet, 5, 1, "Total Hours", centre_format);
        worksheet_write_string(worksheet, 5, 2, "Status", centre_format);
        
        var rowNumber : Int = 6
        if let list = selectedTimesheetList{
            for dct in list {
                let fname = dct.empFirstname ?? ""
                let lname = dct.empLastname ?? ""
                let fullname = fname + " " + lname
                let total = dct.total ?? ""
                var status = ""
                if dct.payperiodStatus ?? "" == "U"{
                    status = "Unapproved"
                    
                }else if dct.payperiodStatus ?? "" == "A"{
                    status = "Approved"
                }
                worksheet_write_string(worksheet, lxw_row_t(rowNumber), 0, fullname, format);
                worksheet_write_string(worksheet, lxw_row_t(rowNumber), 1, total, format);
                worksheet_write_string(worksheet, lxw_row_t(rowNumber), 2, status, format);
                rowNumber = rowNumber + 1
            }
        }
        /* Write some simple text. */
        //        worksheet_write_string(worksheet, 5, 0, "Hello", nil);
        //
        //        /* Text with formatting. */
        //        worksheet_write_string(worksheet, 6, 0, "World", format);
        //
        //        /* Write some numbers. */
        //        worksheet_write_number(worksheet, 7, 0, 123,     nil);
        //        worksheet_write_number(worksheet, 8, 0, 123.456, nil);
        
        
#if arch(i386) || arch(x86_64)
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        NSLog("Document Path: %@", documentsPath)
#endif
        workbook_close(workbook);
        
        DispatchQueue.main.async {
            ProgressHUD.hide()
            let fileURL = NSURL(fileURLWithPath: destination_path)
            
            // Create the Array which includes the files you want to share
            var filesToShare = [Any]()
            
            // Add the path of the file to the Array
            filesToShare.append(fileURL)
            
            // Make the activityViewContoller which shows the share-view
            let activityViewController = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
            
            // Show the share-view
            self.present(activityViewController, animated: true, completion: nil)
        }
        
    }
    func createPDF() {
        ProgressHUD.show()
        var tableDataItems = [TableDataItemPayPeriod]()
        for itemIndex in 0..<self.selectedTimesheetList!.count {
            let dct = self.selectedTimesheetList![itemIndex]
            let fname = dct.empFirstname ?? ""
            let lname = dct.empLastname ?? ""
            let fullname = fname + " " + lname
            let total = dct.total ?? ""
            var status = ""
            if dct.payperiodStatus ?? "" == "U"{
                status = "Unapproved"
                
            }else if dct.payperiodStatus ?? "" == "A"{
                status = "Approved"
            }
            
            tableDataItems.append(TableDataItemPayPeriod(empName: fullname, totalHrs: total, status: status))
//            tableDataItems.append(TableDataItemPayPeriod(empName: fullname, totalHrs: total, status: status))
//            tableDataItems.append(TableDataItemPayPeriod(empName: fullname, totalHrs: total, status: status))
//            tableDataItems.append(TableDataItemPayPeriod(empName: fullname, totalHrs: total, status: status))
//            tableDataItems.append(TableDataItemPayPeriod(empName: fullname, totalHrs: total, status: status))
//            tableDataItems.append(TableDataItemPayPeriod(empName: fullname, totalHrs: total, status: status))
//            tableDataItems.append(TableDataItemPayPeriod(empName: fullname, totalHrs: total, status: status))
//            tableDataItems.append(TableDataItemPayPeriod(empName: fullname, totalHrs: total, status: status))
//            tableDataItems.append(TableDataItemPayPeriod(empName: fullname, totalHrs: total, status: status))
//            tableDataItems.append(TableDataItemPayPeriod(empName: fullname, totalHrs: total, status: status))
//            tableDataItems.append(TableDataItemPayPeriod(empName: fullname, totalHrs: total, status: status))
//            tableDataItems.append(TableDataItemPayPeriod(empName: fullname, totalHrs: total, status: status))
//            tableDataItems.append(TableDataItemPayPeriod(empName: fullname, totalHrs: total, status: status))
//            tableDataItems.append(TableDataItemPayPeriod(empName: fullname, totalHrs: total, status: status))
//            tableDataItems.append(TableDataItemPayPeriod(empName: fullname, totalHrs: total, status: status))
//            tableDataItems.append(TableDataItemPayPeriod(empName: fullname, totalHrs: total, status: status))
//            tableDataItems.append(TableDataItemPayPeriod(empName: fullname, totalHrs: total, status: status))
//            tableDataItems.append(TableDataItemPayPeriod(empName: fullname, totalHrs: total, status: status))
//            tableDataItems.append(TableDataItemPayPeriod(empName: fullname, totalHrs: total, status: status))
//            tableDataItems.append(TableDataItemPayPeriod(empName: fullname, totalHrs: total, status: status))
            
        }
       
        let tableDataHeaderTitles =  ["Employee", "Total Hours", "Status"]
        let pdfCreator = PDFCreator(tableDataItems: tableDataItems, tableDataHeaderTitles: tableDataHeaderTitles)
        pdfCreator.payPeriod = payPeriodStr
        let data = pdfCreator.create()
        let fileManager = FileManager.default
        do {
            let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            let fileName = "Timesheet - " +  payPeriodStr + ".pdf"
            let fileURL = path.appendingPathComponent(fileName)
            
            try data.write(to: fileURL)
            DispatchQueue.main.async {
                let vc = UIActivityViewController(
                    activityItems: [fileURL],
                    applicationActivities: []
                )
                ProgressHUD.hide()
                self.present(vc, animated: true, completion: nil)
            }
        } catch {
            ProgressHUD.hide()
            print("error creating file")
        }
        
    }
}

// inspired by Paul Hudson
extension Array {
    func chunkedElements(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
    
    func chunkedElements2(into size: Int, firstPageCount : Int) -> [[Element]] {
        return stride(from: firstPageCount, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
    
}

class PDFCreator: NSObject {
    let defaultOffset: CGFloat = 20
    let tableDataHeaderTitles: [String]
    let tableDataItems: [TableDataItemPayPeriod]
    var startPointFirstPage: CGFloat = 0.0
    var payPeriod : String = ""

    init(tableDataItems: [TableDataItemPayPeriod], tableDataHeaderTitles: [String]) {
        startPointFirstPage =  ((defaultOffset * 3) - defaultOffset) * 5
        self.tableDataItems = tableDataItems
        self.tableDataHeaderTitles = tableDataHeaderTitles
    }

    func create() -> Data {
        // default page format
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: UIGraphicsPDFRendererFormat())

        let numberOfElementsPerPage = calculateNumberOfElementsPerPage(with: pageRect)
        let numberOfElementsFirstPage = numberOfElementsPerPage - 4
        let firstArr = Array(tableDataItems[0..<min(numberOfElementsFirstPage, tableDataItems.count)])
        var tableDataChunked: [[TableDataItemPayPeriod]] = [firstArr]
        if tableDataItems.count > numberOfElementsFirstPage{
            let arr = tableDataItems.chunkedElements2(into: numberOfElementsPerPage, firstPageCount: numberOfElementsFirstPage)
            tableDataChunked.append(contentsOf: arr)
        }
//        let tableDataChunked: [[TableDataItemPayPeriod]] = tableDataItems.chunkedElements(into: numberOfElementsPerPage)

        let data = renderer.pdfData { context in
            
//            for tableDataChunk in tableDataChunked {
            for tableDataChunkIndex in 0..<tableDataChunked.count {
                let tableDataChunk = tableDataChunked[tableDataChunkIndex]
                context.beginPage()
                let cgContext = context.cgContext
                var isFirst : Bool = false
        
                if tableDataChunkIndex == 0{
                    
                    isFirst = true
                    //Draw Title
                    let textFont = UIFont.systemFont(ofSize: 40.0, weight: .medium)
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.alignment = .center
                    paragraphStyle.lineBreakMode = .byWordWrapping
                    let titleAttributes = [
                        NSAttributedString.Key.paragraphStyle: paragraphStyle,
                        NSAttributedString.Key.font: textFont
                    ]
                    let businessName = Defaults.shared.currentUser?.merchantName ?? ""
                    let attributedTitle = NSAttributedString(string: businessName, attributes: titleAttributes)
                    let textRect = CGRect(x: defaultOffset,
                                          y: defaultOffset * 2,
                                          width: (pageRect.width - defaultOffset * 2),
                                          height: defaultOffset * 3)
                    attributedTitle.draw(in: textRect)
                    
                    // Draw header's 1 top horizontal line
                    cgContext.move(to: CGPoint(x: defaultOffset, y: (defaultOffset * 5) + 8 ))
                    cgContext.addLine(to: CGPoint(x: pageRect.width - defaultOffset, y: (defaultOffset * 5) + 8))
                    cgContext.strokePath()
                    
                    //PayperiodDetails
                    let textFontP = UIFont.systemFont(ofSize: 18.0, weight: .medium)
                    let titleAttributesP = [
                        NSAttributedString.Key.paragraphStyle: paragraphStyle,
                        NSAttributedString.Key.font: textFontP
                    ]
                    let payPeriodStr = "Pay Period: " + self.payPeriod
                    let attributedTitleP = NSAttributedString(string: payPeriodStr, attributes: titleAttributesP)
                    let textRectP = CGRect(x: defaultOffset,
                                          y: (defaultOffset * 5) + 15,
                                          width: (pageRect.width - defaultOffset * 2),
                                          height: defaultOffset * 3)
                    attributedTitleP.draw(in: textRectP)
                                   
//                    // draw titles
//                    let tabWidth = (pageRect.width - defaultOffset * 2) / CGFloat(3)
//                    for titleIndex in 0..<titles.count {
//                        let attributedTitle = NSAttributedString(string: titles[titleIndex].capitalized, attributes: titleAttributes)
//                        let tabX = CGFloat(titleIndex) * tabWidth
//                        let textRect = CGRect(x: tabX + defaultOffset,
//                                              y: isForFirstPage ?  (( (startPointFirstPage) + defaultOffset * 3) - ( (defaultOffset * 3) / 2)) : (defaultOffset * 3) / 2,
//                                              width: tabWidth,
//                                              height: defaultOffset * 2)
//                        attributedTitle.draw(in: textRect)
//                    }
                    
                }
                drawTableHeaderRect(drawContext: cgContext, pageRect: pageRect , isForFirstPage: isFirst)
                drawTableHeaderTitles(titles: tableDataHeaderTitles, drawContext: cgContext, pageRect: pageRect, isForFirstPage: isFirst)
                drawTableContentInnerBordersAndText(drawContext: cgContext, pageRect: pageRect, tableDataItems: tableDataChunk, isForFirstPage: isFirst)
            }
        }
        return data
    }

    func calculateNumberOfElementsPerPage(with pageRect: CGRect) -> Int {
        let rowHeight = (defaultOffset * 3)
        let number = Int((pageRect.height - rowHeight) / rowHeight)
        return number
    }
}

// Drawings
extension PDFCreator {
    func drawTableHeaderRect(drawContext: CGContext, pageRect: CGRect , isForFirstPage : Bool = false) {
        drawContext.saveGState()
        drawContext.setLineWidth(3.0)

        // Draw header's 1 top horizontal line
        drawContext.move(to: CGPoint(x: defaultOffset, y: isForFirstPage ? startPointFirstPage  : defaultOffset))
        drawContext.addLine(to: CGPoint(x: pageRect.width - defaultOffset, y: isForFirstPage ? startPointFirstPage  : defaultOffset))
        drawContext.strokePath()

        // Draw header's 1 bottom horizontal line
        drawContext.move(to: CGPoint(x: defaultOffset, y: isForFirstPage ?  ( (startPointFirstPage) + defaultOffset * 3) : defaultOffset * 3))
        drawContext.addLine(to: CGPoint(x: pageRect.width - defaultOffset, y: isForFirstPage ?  ( (startPointFirstPage) + defaultOffset * 3) : defaultOffset * 3))
        drawContext.strokePath()

        // Draw header's 3 vertical lines
        drawContext.setLineWidth(2.0)
        drawContext.saveGState()
        let tabWidth = (pageRect.width - defaultOffset * 2) / CGFloat(3)
        for verticalLineIndex in 0..<4 {
            let tabX = CGFloat(verticalLineIndex) * tabWidth
            drawContext.move(to: CGPoint(x: tabX + defaultOffset, y: isForFirstPage ? startPointFirstPage  : defaultOffset))
            drawContext.addLine(to: CGPoint(x: tabX + defaultOffset, y: isForFirstPage ?  ( (startPointFirstPage) + defaultOffset * 3) : defaultOffset * 3))
            drawContext.strokePath()
        }
        drawContext.setFillColor(UIColor(named: "AccentColor")!.cgColor );
        drawContext.fill(CGRect.init(x: defaultOffset, y:  isForFirstPage ? startPointFirstPage : defaultOffset * 3, width:  pageRect.width - ( defaultOffset * 2), height: isForFirstPage ?  ( (startPointFirstPage) + defaultOffset * 3) - startPointFirstPage : defaultOffset - (defaultOffset * 3)))

        drawContext.restoreGState()
    }

    func drawTableHeaderTitles(titles: [String], drawContext: CGContext, pageRect: CGRect, isForFirstPage : Bool = false) {
        // prepare title attributes
        let textFont = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byWordWrapping
        let titleAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: UIColor.purple,
        ]

        // draw titles
        let tabWidth = (pageRect.width - defaultOffset * 2) / CGFloat(3)
        for titleIndex in 0..<titles.count {
            let attributedTitle = NSAttributedString(string: titles[titleIndex].capitalized, attributes: titleAttributes)
            let tabX = CGFloat(titleIndex) * tabWidth
            let textRect = CGRect(x: tabX + defaultOffset,
                                  y: isForFirstPage ?  (( (startPointFirstPage) + defaultOffset * 3) - ( (defaultOffset * 3) / 2)) : (defaultOffset * 3) / 2,
                                  width: tabWidth,
                                  height: defaultOffset * 2)
            attributedTitle.draw(in: textRect)
        }
    }

    func drawTableContentInnerBordersAndText(drawContext: CGContext, pageRect: CGRect, tableDataItems: [TableDataItemPayPeriod], isForFirstPage : Bool = false) {
        drawContext.setLineWidth(1.0)
        drawContext.saveGState()

        let defaultStartY = defaultOffset * 3

        for elementIndex in 0..<tableDataItems.count {
            let initialY =  isForFirstPage ? ((startPointFirstPage) + defaultOffset * 3) : defaultStartY
            var yPosition = CGFloat(elementIndex) * defaultStartY + initialY
            if isForFirstPage && elementIndex == 0 {
                yPosition = CGFloat(elementIndex) * defaultStartY + ((startPointFirstPage) + defaultOffset * 3)
            }

            // Draw content's elements texts
            let textFont = UIFont.systemFont(ofSize: 13.0, weight: .regular)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.lineBreakMode = .byWordWrapping
            let textAttributes = [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: textFont
            ]
            let tabWidth = (pageRect.width - defaultOffset * 2) / CGFloat(3)
            for titleIndex in 0..<3 {
                var attributedText = NSAttributedString(string: "", attributes: textAttributes)
                switch titleIndex {
                case 0: attributedText = NSAttributedString(string: tableDataItems[elementIndex].empName, attributes: textAttributes)
                case 1: attributedText = NSAttributedString(string: tableDataItems[elementIndex].totalHrs, attributes: textAttributes)
                case 2: attributedText = NSAttributedString(string: tableDataItems[elementIndex].status, attributes: textAttributes)
//                case 2: attributedText = NSAttributedString(string: String(format: "%.2f", tableDataItems[elementIndex].money), attributes: textAttributes)
                default:
                    break
                }
                let tabX = CGFloat(titleIndex) * tabWidth
                let textRect = CGRect(x: tabX + defaultOffset,
                                      y: yPosition + defaultOffset,
                                      width: tabWidth,
                                      height: defaultOffset * 3)
                attributedText.draw(in: textRect)
            }

            // Draw content's 3 vertical lines
            for verticalLineIndex in 0..<4 {
                let tabX = CGFloat(verticalLineIndex) * tabWidth
                drawContext.move(to: CGPoint(x: tabX + defaultOffset, y: yPosition))
                drawContext.addLine(to: CGPoint(x: tabX + defaultOffset, y: yPosition + defaultStartY))
                drawContext.strokePath()
            }

            // Draw content's element bottom horizontal line
            drawContext.move(to: CGPoint(x: defaultOffset, y: yPosition + defaultStartY))
            drawContext.addLine(to: CGPoint(x: pageRect.width - defaultOffset, y: yPosition + defaultStartY))
            drawContext.strokePath()
        }
        drawContext.restoreGState()
    }
}

extension ExportTimesheetPopupVC {
    class func showExportPopup(prevVC : UIViewController,selectedTimesheetArr : [PayPeriodTimesheet]?, payPeriodString : String  , completion: @escaping (Bool) -> () ) {
        
        let vc = ExportTimesheetPopupVC.instantiate()
        vc.selectedTimesheetList = selectedTimesheetArr
        vc.payPeriodStr = payPeriodString
        vc.completion = completion
        vc.modalPresentationStyle = .overCurrentContext
        prevVC.present(vc, animated: false, completion: nil)
    }
}


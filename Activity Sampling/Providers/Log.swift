//
//  Log.swift
//  Activity Sampling
//
//  Created by Falko Schumann on 03.09.18.
//  Copyright © 2018 Falko Schumann. All rights reserved.
//

import Foundation

protocol LogDelegate {
    func logSucceded(_ log: Log, activity: Activity)
    func logFailed(_ log: Log, message: String)
}

class Log {
    
    var delegate: LogDelegate?
    
    var fileURL: URL?
    
    func log(_ activity: Activity) {
        writeToCSV(activity)
    }
    
    private func writeToCSV(_ activity: Activity) {
        if let url = fileURL {
            do {
                if isNewLogFile(url) {
                    try writeHeader(to: url)
                }
                let entry = createEntry(activity)
                try writeEntry(entry, to: url)
                delegate?.logSucceded(self, activity: activity)
            } catch {
                print("Error writing log: \(error)")
                delegate?.logFailed(self, message: error.localizedDescription)
            }
        }
    }
    
    private func isNewLogFile(_ url: URL) -> Bool {
        let fileManager = FileManager.default
        return !fileManager.fileExists(atPath: url.path)
    }
    
    private func writeHeader(to: URL) throws {
        try "timestamp,period,activity\r\n".write(to: to, atomically: true, encoding: .utf8)
    }
    
    private func createEntry(_ activity: Activity) -> Data {
        var row: [String] = []
        let timestampFormatter = ISO8601DateFormatter()
        timestampFormatter.timeZone = TimeZone.current
        row.append(timestampFormatter.string(from: activity.timestamp))
        row.append(String(Int(activity.duration / 60)))
        row.append("\"".appending(activity.title).appending("\""))
        let seperator = ","
        return row.joined(separator: seperator).appending("\r\n").data(using: .utf8)!
    }
    
    private func writeEntry(_ entry: Data, to: URL) throws {
        let handle = try FileHandle(forWritingTo: to)
        handle.seekToEndOfFile()
        handle.write(entry)
        handle.closeFile()
    }
    
}

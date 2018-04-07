//
//  GeneralHelper.swift
//  SmartWallet
//
//  Created by Soheil on 07/04/2018.
//  Copyright © 2018 Soheil Novinfard. All rights reserved.
//

import Foundation

enum monthYearArrayType {
	case monthsStringArray
	case monthsIntArray
	case monthsWithyear
	case monthsWithyearExceptCurrent
	case monthsWithyearExceptCurrentTuple
}

enum recordType {
	case recordTypeCost
	case recordTypeIncome
	case recordTypeAll
}

let currencyLabel = "£"

func monthsBetweenDates(startDate: Date?, endDate: Date?, displayType: monthYearArrayType) -> Array<Any> {
	let dateFormtter = DateFormatter()
	
	var monthsStringArray = [String]()
	var monthsIntArray = [Int]()
	var monthsWithyear = [String]()
	var monthsWithyearExceptCurrent = [String]()
	var monthsWithyearExceptCurrentTuple = [(year: Int, month: Int, title: String)]()
	dateFormtter.dateFormat = "MM"
	
	if let startYear: Int = startDate?.year(), let endYear = endDate?.year() {
		
		if let startMonth: Int = startDate?.month(), let endMonth: Int = endDate?.month() {
			for i in startYear...endYear {
				for j in (i == startYear ? startMonth : 1)...(i < endYear ? 12 : endMonth) {
					let monthTitle = dateFormtter.monthSymbols[j - 1]
					monthsStringArray.append(monthTitle)
					monthsIntArray.append(j)
					
					let monthWithYear = "\(monthTitle) \(i)"
					monthsWithyear.append(monthWithYear)
					
					let exceptCurrent: String
					if(i == Date().year()) {
						exceptCurrent = monthTitle
					} else {
						exceptCurrent = monthWithYear
					}
					monthsWithyearExceptCurrent.append(exceptCurrent)
					monthsWithyearExceptCurrentTuple.append((i,j, exceptCurrent))
				}
			}
		}
		
	}
	
	switch displayType {
	case .monthsWithyear:
		return monthsWithyear
	case .monthsWithyearExceptCurrent:
		return monthsWithyearExceptCurrent
	case .monthsStringArray:
		return monthsStringArray
	case .monthsIntArray:
		return monthsIntArray
	case .monthsWithyearExceptCurrentTuple:
		return monthsWithyearExceptCurrentTuple
	}
}

func getMonthDuration(year: Int, month: Int, considerCurrent: Bool) -> Int {
	let dateComponents = DateComponents(year: year, month: month)
	let calendar = Calendar.current
	let date = calendar.date(from: dateComponents)!
	
	let range = calendar.range(of: .day, in: .month, for: date)!
	var numDays = range.count
	
	if(considerCurrent) {
		if year == Date().year() && month == Date().month() {
			numDays = Date().day()
		}
	}
	
	return numDays
}

func getRecordString(_ value: Double, _ type: recordType) -> String {
	var prefix = ""
	if type == .recordTypeAll {
		if(value >= 0) {
			prefix = "+"
		}
		else {
			prefix = "-"
		}
	} else if type == .recordTypeIncome {
		prefix = "+"
	} else {
		prefix = "-"
	}
	let absValue = abs(value)

	return "\(prefix) \(currencyLabel) \(absValue.format(f: ".2"))"
}


extension Date {
	func month() -> Int {
		let month = Calendar.current.component(.month, from: self)
		return month
	}
	
	func year() -> Int {
		let year = Calendar.current.component(.year, from: self)
		return year
	}
	
	func day() -> Int {
		let day = Calendar.current.component(.day, from: self)
		return day
	}
	
	func startOfMonth() -> Date {
		return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
	}
	
	func endOfMonth() -> Date {
		return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
	}
}

extension Int {
	func format(f: String) -> String {
		return String(format: "%\(f)d", self)
	}
}

extension Double {
	func format(f: String) -> String {
		return String(format: "%\(f)f", self)
	}
}

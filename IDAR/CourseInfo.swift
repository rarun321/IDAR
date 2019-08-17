//
//  CourseInfo.swift
//  IDAR
//
//  Created by Rithvik Arun on 8/14/19.
//  Copyright © 2019 Projects. All rights reserved.
//

import Foundation

struct Element: Decodable {
    let id: Int?
    let name: String?
    let accountID: Int?
    let uuid: String?
    let startAt: Date?
    let gradingStandardID: Int?
    let isPublic: Bool?
    let createdAt: Date?
    let courseCode, defaultView: String?
    let rootAccountID, enrollmentTermID: Int?
    let license: String?
    let endAt: Date?
    let publicSyllabus, publicSyllabusToAuth: Bool?
    let storageQuotaMB: Int?
    let isPublicToAuthUsers, applyAssignmentGroupWeights: Bool?
    let calendar: Calendar?
    let timeZone: String?
    let blueprint: Bool?
    let enrollments: [Enrollment]?
    let hideFinalGrades: Bool?
    let workflowState, courseFormat: String?
    let restrictEnrollmentsToCourseDates: Bool?
    let overriddenCourseVisibility: String?
}

struct Calendar: Decodable {
    let ics: String?
}

struct Enrollment: Decodable {
    let type, role: String?
    let roleID, userID: Int?
    let enrollmentState: String?
    let computed_current_grade: String?
    let computed_current_score: Double?
    let computed_final_grade: String?
    let computed_final_score: Double?
}


//
//  TODOInfo.swift
//  IDAR
//
//  Created by Rithvik Arun on 9/16/19.
//  Copyright © 2019 Projects. All rights reserved.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let empty = try? newJSONDecoder().decode(Empty.self, from: jsonData)

import Foundation

// MARK: - Element
struct TODOInfo: Decodable {
    let contextType: String?
    let courseID: Int?
    let type: String?
    let ignore, ignorePermanently: String?
    let assignment: Assignment?
    let htmlURL: String?
}

// MARK: - Assignment
struct Assignment: Decodable {
    let id: Int?
    let assignmentDescription: String?
    let dueAt: Date?
    let pointsPossible: Int?
    let gradingType: String?
    let assignmentGroupID: Int?
    let createdAt, updatedAt: Date?
    let peerReviews, automaticPeerReviews: Bool?
    let position: Int?
    let gradeGroupStudentsIndividually, anonymousPeerReviews: Bool?
    let postToSis, moderatedGrading, omitFromFinalGrade, intraGroupPeerReviews: Bool?
    let anonymousInstructorAnnotations, anonymousGrading, gradersAnonymousToGraders: Bool?
    let graderCount: Int?
    let graderCommentsVisibleToGraders: Bool?
    let graderNamesVisibleToFinalGrader: Bool?
    let allowedAttempts: Int?
    let secureParams: String?
    let courseID: Int?
    let name: String?
    let submissionTypes: [String]?
    let hasSubmittedSubmissions, dueDateRequired: Bool?
    let maxNameLength: Int?
    let inClosedGradingPeriod, isQuizAssignment, canDuplicate: Bool?
    let workflowState: String?
    let muted: Bool?
    let htmlURL: String?
    let allowedExtensions: [String]?
    let published, onlyVisibleToOverrides, lockedForUser: Bool?
    let submissionsDownloadURL: String?
    let anonymizeStudents: Bool?
}

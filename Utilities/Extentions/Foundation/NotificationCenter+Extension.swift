//  NotificationCenter+Extension.swift
//  Bryte
//
//  Copyright © Bryte All rights reserved.
//  Created on 02/02/2021
//
import Foundation

extension Notification.Name {
    static let fundingTeamMember = Notification.Name("fundingTeamMember")
    static let fundingEdit = Notification.Name("fundingedit")
    static let confirmFundingDetails = Notification.Name("confirmfunding")
    static let profileContainerViewHeight = Notification.Name("profileContainerViewHeight")
    static let postNotificationToContainer = Notification.Name("postNotificationToContainer")
    static let postNotificationToChild = Notification.Name("postNotificationToChild")
    static let videoPauseOnFeed = Notification.Name("videoPauseOnFeed")
    static let refreshPage = Notification.Name("refreshPage")
    static let meetingDataAddUpdated = Notification.Name("meetingDataAddUpdated")
}

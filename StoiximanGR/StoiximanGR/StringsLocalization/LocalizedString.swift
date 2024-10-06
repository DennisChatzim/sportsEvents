//
//  LocalizedString.swift
//  Stoiximan
//
//  Created by Dionisis Chatzimarkakis on 4/10/24.
//

import Foundation

struct LocalizedString {
    
    static let errorNetworkAlertTitle = NSLocalizedString("errorNetworkAlertTitle", comment: "The alert title that we should show when a network error occured")
    static let urlIsInvalid = NSLocalizedString("urlIsInvalid", comment: "The alert message that we should show when url is invalid")
    static let networkRequestfailedGeneral = NSLocalizedString("networkRequestfailedGeneral", comment: "The alert message that we should show when network request failed but not sure why")
    static let notConnectedMessage = NSLocalizedString("notConnectedMessage", comment: "The alert message that we should show when device is not connected to internet")
    static let serverResponseNotValid = NSLocalizedString("serverResponseNotValid", comment: "The alert message that we should show when server response data seems not valid or compatible with our code")
    static let decodingErrorMessage = NSLocalizedString("decodingErrorMessage", comment: "The alert message that we should show when the app can't decode the data received from server")
    static let serverStatusCodeError = NSLocalizedString("serverStatusCodeError", comment: "The alert message that we should show when the status code was not valid")
    static let loadingText = NSLocalizedString("loadingText", comment: "Please wait text")
    
}

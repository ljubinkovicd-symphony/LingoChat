//
//  Constants.swift
//  LingoChat
//
//  Created by Dorde Ljubinkovic on 11/26/17.
//  Copyright © 2017 Dorde Ljubinkovic. All rights reserved.
//

import Foundation

struct Constants {
 
    // According to the Terms of Use for the Yandex.Translate service, the text “Powered by Yandex.Translate” must be shown above or below the translation result, with a clickable link to the page http://translate.yandex.com/.
    /*
     
     Requirements for placing this text
     
     This text must be shown:
     
     In the description of the software product (on the About page).
     In the help for the software product.
     On the official website of the software product.
     On all pages or screens where data from the service is used.
     
     Requirements for font color
     
     The font color of this text must match the font color of the main text.
     
     Requirements for font size
     
     The font size of this text must not be smaller than the font size of the main text.

     */
    struct IbmWatsonApi {
        public static let baseUrl = "https://gateway.watsonplatform.net/language-translator/api/v2/translate" // get rid of /v2/translate
        public static let username = "5fa49ba0-5f7e-445b-b38e-ba9a59bab760"
        public static let password = "CDHkNRWvKsfz"
    }
    
    struct UserFields {
        public static let uid = "uid"
        public static let username = "username"
        public static let email = "email"
        public static let password = "password"
        public static let profileImageUrl = "profileImageUrl"
    }
}

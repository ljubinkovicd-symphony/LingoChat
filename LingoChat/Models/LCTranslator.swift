//
//  LCTranslator.swift
//  LingoChat
//
//  Created by Dorde Ljubinkovic on 12/4/17.
//  Copyright © 2017 Dorde Ljubinkovic. All rights reserved.
//

import Foundation
// TEST
import LanguageTranslatorV2

/* Conversational: Targeted at conversational colloquialisms. Translate English to and from Arabic, Brazilian Portuguese, French, Italian, and Spanish. */
enum Languages: String {
    case arabic = "ar"
    case english = "en"
    case spanish = "es"
    case french = "fr"
    case portuguese = "pt"
}

class LCTranslator {
    
    public static func translateText(_ text: String, fromLanguage: Languages, toLanguage: Languages) {
        // TEST____________________________________________________________________________________________________________________________________________________________________
        let languageTranslator = LanguageTranslator(username: Constants.IbmWatsonApi.username, password: Constants.IbmWatsonApi.password)
        let failure = { (error: Error) in print(error) }
        
        let listOfInputs: [String] = [text]
        
        var translatedText: String = "NOTHING TRANSLATED YET"
        
        languageTranslator.translate(listOfInputs, from: fromLanguage.rawValue, to: toLanguage.rawValue, failure: failure) { translation in
            
            print(translation)
            
            //            for i in 0..<translation.translations.count {
            //                print(translation.translations[i].translation)
            //            }
            
            translatedText = translation.translations[0].translation
        }
        //_________________________________________________________________________________________________________________________________________________________________________
    }

}

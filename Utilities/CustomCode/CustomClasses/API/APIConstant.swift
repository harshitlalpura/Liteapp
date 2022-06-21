    import Foundation
    
    /// This is the Structure for API
    internal struct API {
        
        // MARK: - API URL
        
        /// Structure for URL. This will have the API end point for the server.
        struct URL {
            
            /// Live Server Base URL
            ///
            ///     API.URL.live
            ///
            private static let live                                  = "https://app.bryteportal.com/"
            
            
            /// Development Server Base URL - Bryte
            ///
            ///      API.URL.staging
            ///
            private static let staging                               = "https://app.bryteportal.com/"
            
            
            /// development Server Base URL
            ///
            ///      API.URL.development
            ///
            private static let development                           = "https://app.bryteportal.com/"
            
            
             static let imgURL                           = "https://app.bryteportal.com/images/profiles/"
            
            
            #if DEBUG
            // Development version
            static let BASE_URL                                      = API.URL.development
            
            #elseif STAGING
            // Staging version
            static let BASE_URL                                      = API.URL.staging
            
            #elseif RELEASE
            // APPSTORE version
            static let BASE_URL                                      = API.URL.live
            
            #else
            // APPSTORE version
            static let BASE_URL                                      = API.URL.development
            
            #endif
            
            
        }
        
        
        
        // MARK: - Basic Response keys
        
        /// Structure for API Response Keys. This will use to get the data or anything based on the key from the repsonse. Do not directly use the key rather define here and use it.
        struct Response {
            static let status                                = "status"
            
            static let statuscodesucess                                = 1

            
            static let emp_data                                     = "emp_data"
            
            static let data                                     = "data"
            
            static let error                                    = "error"
            
            static let message                                  = "message"
            
            static let meta                                     = "meta"
            
            static let extraMeta                                = "extra_meta"
            
            static let token                                    = "token"
            
            static let verificationCode                         = "verificationCode"
            
            static let resultData                               = "resultData"
            
            static let id                                       = "id"
            
            static let list                                     = "list"
            
            static let fileViewBasepath                         = "fileViewBasepath"
            
            static let isExist                                  = "isExist"
        }
        
        struct Key {
            static let emp_username                                  = "emp_username"
            
            static let emp_password                                  = "emp_password"
            
            static let merchant_id                                  = "merchant_id"
            static let timeline_date                                  = "timeline_date"
            
            static let corrections                                  = "corrections"
            
            static let emp_id                                  = "emp_id"
            static let emp_token                                  = "emp_token"
            static let event_type                                  = "event_type"
         

            static let timeline_id                                  = "timeline_id"
            static let correction_date                                  = "correction_date"
            static let corrected_time                                  = "corrected_time"
            static let comments                                  = "comments"
            
        }
        
    }
    struct GradientColor {
        var GradientArray = ["#FECC69/#FCA75A","#FD875C/#FD5168","#2EFBFB/#4ACDCC","#2EB4FB/#4A7CCD","#E0A0F3/#D66AEF","#A6E344/#60C10F","#80AFFE/#6661FF","#9DEBF5/#009DFF","#C7A4EF/#A47AE3","#F2B5B5/#DE6464","#2DFAFD/#49CCCC","#FD875C/#FD5168"]
    }

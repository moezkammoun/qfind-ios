//
//  AppDelegate.swift
//  QFind
//
//  Created by Exalture on 12/01/18.
//  Copyright © 2018 Exalture. All rights reserved.
//

import Alamofire
import CoreData
import UIKit
let tokenDefault = UserDefaults.standard
var languageKey = 1

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var historyDetailsArray:[HistoryEntity]?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.shared.statusBarStyle = .lightContent
          AppLocalizer.DoTheMagic()
        getAccessTokenFromServer()
        deletePreviousMonthHistoryFromCoreData()
        return true
        
    
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        if #available(iOS 10.0, *) {
            self.saveContext()
        } else {
            // Fallback on earlier versions
        }
    }

    // MARK: - Core Data stack

    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "QFind")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    // iOS 9 and below
    lazy var applicationDocumentsDirectory: URL = {
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "coreDataTestForPreOS", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    // MARK: - Core Data Saving support

   
    func saveContext () {
         if #available(iOS 10.0, *) {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
         }else{
            // iOS 9.0 and below - however you were previously handling it
            if managedObjectContext.hasChanges {
                do {
                    try managedObjectContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                    abort()
                }
            }
            
        }
    }

    func getAccessTokenFromServer()
    {
        
        if ((LocalizationLanguage.currentAppleLanguage()) == "en"){
            languageKey = 1
        }
        else{
            languageKey = 2
        }
        if (tokenDefault.value(forKey: "accessTokenString") == nil)
        {
        Alamofire.request(QFindRouter.getAccessToken(["clientid": "DEB47D9B-61DD-25A6-CB6F-46F310F78130",
                                                      "clientsecret": "7B446C1F-94F4-967D-25BF-45A63DBC2BAF"]))
            .responseObject { (response: DataResponse<TokenData>) -> Void in
                switch response.result {
                case .success(let data):
                    if let token = data.accessToken{
                           tokenDefault.set(token, forKey: "accessTokenString")
                        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let initialViewController : HomeViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: "homeId") as! HomeViewController
                        self.window = UIWindow(frame: UIScreen.main.bounds)
                        self.window?.rootViewController = initialViewController
                        self.window?.makeKeyAndVisible()
                        
                    }
                case .failure(let error):
                    print(error)
                }
                
        }
    }
    }
    func deletePreviousMonthHistoryFromCoreData() {
        let monthsToAdd = -1
        let minimumDate = Calendar.current.date(byAdding: .month, value: monthsToAdd, to: Date())
        
        
        var managedContext : NSManagedObjectContext?
        if #available(iOS 10.0, *) {
            managedContext =
                persistentContainer.viewContext
        } else {
            // Fallback on earlier versions
            managedContext = managedObjectContext
        }
        let historyFetchRequest =  NSFetchRequest<NSFetchRequestResult>(entityName: "HistoryEntity")

        do {
            historyDetailsArray = try managedContext?.fetch(historyFetchRequest) as? [HistoryEntity]

        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        if (historyDetailsArray?.count != 0){
            for fetchResult in historyDetailsArray! {
                if (((fetchResult.date_history?.compare(minimumDate!)) == .orderedAscending) && (!(Calendar.current.isDate(fetchResult.date_history!, inSameDayAs:minimumDate!)))) {
                    managedContext?.delete(fetchResult)
                    do {
                        try managedContext?.save()
                    } catch let error as NSError {
                        print(error)
                    }
            }
            }
        }
       
    }
    

}


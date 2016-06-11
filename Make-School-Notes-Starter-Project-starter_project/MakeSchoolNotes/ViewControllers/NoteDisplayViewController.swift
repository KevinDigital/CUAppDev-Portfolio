//
//  NoteDisplayViewController.swift
//  MakeSchoolNotes
//
//  Created by Kevin Li on 6/6/16.
//  Copyright © 2016 Chris Orcutt. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class NoteDisplayViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    var note: Note? {
        didSet {
            displayNote(note)
        }
    }
    
    
    var edit = false
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var toolbarBottomSpace: NSLayoutConstraint!
    
    //var keyboardNotificationHandler: KeyboardNotificationHandler?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //keyboardNotificationHandler = KeyboardNotificationHandler()
        
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        
        if edit {
            deleteButton.enabled = false
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        displayNote(note)
        
        titleTextField.returnKeyType = .Next
        titleTextField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func displayNote(note: Note?) {
        if let note = note, titleTextField = titleTextField, contentTextView = contentTextView {
            titleTextField.text = note.title
            contentTextView.text = note.content
            
            if note.title.characters.count == 0 && note.content.characters.count == 0 {
                titleTextField.becomeFirstResponder()
            }
        }
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        saveNote()
    }
    
    func saveNote() {
        if let note = note {
            do {
                let realm = try Realm()
                
                try realm.write {
                    if (note.title != self.titleTextField.text || note.content != self.contentTextView.text) {
                        note.title = self.titleTextField.text!
                        note.content = self.contentTextView.text
                        note.modificationDate = NSDate()
                    }
                }
            } catch {
                print("handle error")
            }
        }
    }
}

extension NoteDisplayViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField == titleTextField) {
            contentTextView.returnKeyType = .Done
            contentTextView.becomeFirstResponder()
        }
        
        return false
        
    }
}


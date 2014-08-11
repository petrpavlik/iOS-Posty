//
//  ContactsTextViewDelegate.m
//  MailClient
//
//  Created by Petr Pavlik on 06/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "ContactsTextViewDelegate.h"
#import "ContactsTextView.h"

@implementation ContactsTextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    ContactsTextView* contactsTextView = (ContactsTextView*)textView;
    
    NSParameterAssert(contactsTextView.prefix.length);
    
    if (textView.text.length == contactsTextView.prefix.length) { //'To: '
        return;
    }
    
    NSString* text = textView.text;
    
    NSRange rangeOfLastSeparator = [text rangeOfString:@"," options:NSBackwardsSearch];
    
    if (rangeOfLastSeparator.location != NSNotFound) {
        
        NSString* lastComponent = [text substringFromIndex:rangeOfLastSeparator.location+1];
        
        NSString* trimmedLastComponent = [lastComponent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if (![self NSStringIsValidEmail:trimmedLastComponent]) {
            textView.text = [text substringToIndex:rangeOfLastSeparator.location];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    ContactsTextView* contactsTextView = (ContactsTextView*)textView;
    
    NSParameterAssert(contactsTextView.prefix.length);
    
    if ([text isEqualToString:@"\n"]) {
        
        NSString* text = textView.text;
         
        NSString* lastComponent = [[text componentsSeparatedByString:@","] lastObject];
        
        NSString* trimmedLastComponent = [lastComponent stringByReplacingOccurrencesOfString:contactsTextView.prefix withString:@""];
        trimmedLastComponent = [trimmedLastComponent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
         
        if (trimmedLastComponent.length) {
         
            if ([self NSStringIsValidEmail:trimmedLastComponent]) {
         
                text = [text stringByAppendingString:@", "];
                textView.text = text;
                //[textView resignFirstResponder];
                return NO;
            }
            else {
         
                text = [text stringByReplacingOccurrencesOfString:lastComponent withString:@""];
         
                if ([[text substringFromIndex:text.length-1] isEqualToString:@","]) {
                    text = [text substringToIndex:text.length-1];
                }
                
                textView.text = text;
                
                [textView resignFirstResponder];
                
                return NO;
            }
        }
        else {
            
            [textView resignFirstResponder];
            return NO;
        }
    }
    
    if (range.location < contactsTextView.prefix.length) {
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    
    ContactsTextView* contactsTextView = (ContactsTextView*)textView;
    
    NSParameterAssert(contactsTextView.prefix.length);
    
    NSRange range = textView.selectedRange;
    
    if (range.location < contactsTextView.prefix.length) {
        
        NSInteger diff = contactsTextView.prefix.length - range.location;
    
        textView.selectedRange = NSMakeRange(range.location+diff, range.length-diff);
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange {
    return YES;
}

#pragma mark -

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

@end

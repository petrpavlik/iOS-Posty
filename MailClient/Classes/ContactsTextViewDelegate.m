//
//  ContactsTextViewDelegate.m
//  MailClient
//
//  Created by Petr Pavlik on 06/08/14.
//  Copyright (c) 2014 Petr Pavlik. All rights reserved.
//

#import "ContactsTextViewDelegate.h"

@implementation ContactsTextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    /*NSString* text = textView.text;
    
    NSString* lastComponent = [[text componentsSeparatedByString:@","] lastObject];
    
    if (lastComponent) {
        
        NSString* trimmedLastComponent = [lastComponent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([self NSStringIsValidEmail:trimmedLastComponent]) {
          
            textView.text = [textView.text stringByAppendingString:@", "];
            return NO;
        }
        else {
            
            textView.text = [textView.text stringByReplacingOccurrencesOfString:lastComponent withString:@""];
            
            if ([[textView.text substringFromIndex:textView.text.length-1] isEqualToString:@","]) {
                textView.text = [textView.text substringToIndex:textView.text.length-1];
            }
            
            return YES;
        }
    }
    else {
        return YES;
    }*/
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        NSString* text = textView.text;
         
        NSString* lastComponent = [[text componentsSeparatedByString:@","] lastObject];
        
        NSString* trimmedLastComponent = [lastComponent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        trimmedLastComponent = [lastComponent stringByReplacingOccurrencesOfString:@"To: " withString:@""];
         
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
    
    if (range.location < 4) {
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    
    NSRange range = textView.selectedRange;
    
    if (range.location < 4) {
        
        NSInteger diff = 4 - range.location;
    
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

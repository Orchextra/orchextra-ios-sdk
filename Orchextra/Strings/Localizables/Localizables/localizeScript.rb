#!/usr/bin/env ruby

system 'localize'

full_path_file = File.expand_path('LocalizableConstants.swift')

File.open(full_path_file) { |source_file|
  contents = source_file.read
  contents.gsub!(/NSLocalizedString/, 'Bundle.localize')
  contents.gsub!(/let/, '@objc public static let')
  contents.gsub!(/import Foundation/, "import Foundation\n\n@objc public class LocalizableConstants: NSObject {")
  contents.insert(-1, '}')
  File.open(full_path_file, "w+") { |f| f.write(contents) }
}

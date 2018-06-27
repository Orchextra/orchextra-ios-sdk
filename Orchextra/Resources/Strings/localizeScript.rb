system 'localize'

full_path_file = File.expand_path('LocalizableConstants.swift')

File.open(full_path_file) { |source_file|
  contents = source_file.read
  contents.gsub!(/NSLocalizedString/, 'localize')
  File.open(full_path_file, "w+") { |f| f.write(contents) }
}

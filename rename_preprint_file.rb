issue_id = ENV["ISSUE_ID"]
journal_alias = ENV["JOURNAL_ALIAS"]
paper_path  = ENV["PAPER_PATH"]

preprint_path = File.join(File.dirname(paper_path), "paper.preprint.tex")
new_preprint_path = File.join(File.dirname(paper_path), "#{journal_alias}-#{issue_id}.preprint.tex")

if File.exist?(preprint_path)
  FileUtils.mv preprint_path, new_preprint_path
  system("echo '::set-output name=preprint_file_path::#{new_preprint_path}'")
else
  system("echo 'CUSTOM_ERROR=Preprint file could not be created.' >> $GITHUB_ENV")
  raise "   !! ERROR: Preprint file not found"
end

require "theoj"
require "yaml"

issue_id = ENV["ISSUE_ID"]
repo_url = ENV["REPO_URL"]
repo_branch = ENV["PAPER_BRANCH"]
journal_alias = ENV["JOURNAL_ALIAS"]

journal = Theoj::Journal.new(Theoj::JOURNALS_DATA[journal_alias.to_sym])
issue = Theoj::ReviewIssue.new(journal.data[:reviews_repository], issue_id)
issue.paper = Theoj::Paper.from_repo(repo_url, repo_branch)
submission = Theoj::Submission.new(journal, issue, issue.paper)

paper_path = issue.paper.paper_path
if paper_path.nil?
  system("echo 'CUSTOM_ERROR=Paper file not found.' >> $GITHUB_ENV")
  raise "   !! ERROR: Paper file not found"
else
  system("echo '::set-output name=paper_file_path::#{paper_path}'")
end

metadata = submission.article_metadata
metadata[:submitted_at] = "0000-00-00" if metadata[:submitted_at].to_s.strip.empty?
metadata[:published_at] = "0000-00-00"

metadata[:editor].transform_keys!(&:to_s)
metadata[:authors].each {|author| author.transform_keys!(&:to_s) }
metadata.transform_keys!(&:to_s)

metadata_file_path = File.dirname(paper_path)+"/paper-metadata.yaml"

File.open(metadata_file_path, "w") do |f|
  f.write metadata.to_yaml
end

if File.exist?(metadata_file_path)
  title = metadata["title"]
  system("echo '::set-output name=paper_title::#{title}'")
  system("echo 'Metadata created for paper preprint: #{title}'")
else
  system("echo 'CUSTOM_ERROR=Preprint metadata file could not be generated.' >> $GITHUB_ENV")
  raise "   !! ERROR: Preprint metadata file could not be generated"
end

inara_args = "-m #{metadata_file_path} -l -o preprint"

system("echo '::set-output name=inara_args::#{inara_args}'")

# Open Journals :: Preprint

This action looks for a `paper.md` file in the specified repository and uses it to generate a simple LaTeX file suitable to send to preprint archives.

Under the hood it uses the [openjournals/inara action](https://github.com/openjournals/inara) to generate the output file.

## Usage

Usually this action is used from an ongoing review on an Open Journal's repository

### Inputs

The action accepts the following inputs:

- **issue_id**: Required. The review issue id of the submission for the paper.
- **repository_url**: Required. The repository URL of the submission containing the paper file.
- **branch**: Optional. Git branch where the paper is located.
- **journal**: Optional. The journal data to use for the paper. Default value is `joss`.

### Outputs

- **preprint_file_path**: The path to the generated LaTeX file
- **preprint_file_name**: The name of the generated LaTeX file

### Example

Use it adding it as a step in a workflow `.yml` file in your repo's `.github/workflows/` directory and passing your custom input values.

````yaml
on:
  workflow_dispatch:
   inputs:
      issue_id:
        description: 'The issue number of the submission'
jobs:
  preprint:
    runs-on: ubuntu-latest
    steps:
      - name: Generate preprint
        uses: xuanxu/preprint-action@main
        with:
          issue_id: {{ github.event.inputs.issue_id }}
          repository_url: http://github.com/${{ github.repository }}
          branch: docs
          journal: joss
```

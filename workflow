name: LGTM.md

on:
  schedule:
    - cron: "30 0 * * *"   # every night, just after midnight UTC
  workflow_dispatch:
  push:
    paths: [.github/workflows/lgtm-md.yml]   # also runs as soon as you commit this file

permissions:
  contents: write

concurrency: lgtm-md

jobs:
  draw:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: eliorpom-cmd/lgtm.md@v1.2.0
        with:
          token: ${{ secrets.LGTM_MD_TOKEN || github.token }}
          widgets: |
            grass
            flame
            counter
            donut
          output-dir: widgets
      - name: Commit the widgets if they changed
        shell: bash
        run: |
          git add widgets
          git diff --cached --quiet && exit 0
          git config user.name "github-actions[bot]"
          git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
          git commit --quiet --message "widgets: draw the day's widgets"
          git push --quiet

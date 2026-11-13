# Erken Hasat

Small, browser-only tools for testing and producing olive oil, published at
**https://havan.github.io/erkenhasat/**. Every tool is bilingual (English / Türkçe),
works without a server, and has a printable field sheet for places with no internet.

## Tools

| Tool | Path | What it does |
| --- | --- | --- |
| Acidity titration | [`site/acidity/`](site/acidity/) | Free acidity (% oleic acid) by NaOH titration (ISO 660 / EU 2568/91), with a step-by-step guide, live calculation and a PDF field sheet. |

## Layout

```
site/                    # everything here is published to GitHub Pages as-is
  index.html             # landing page listing the tools
  assets/                # shared files (favicon, ...)
  acidity/index.html     # one self-contained page per tool
scripts/build-pdfs.sh    # renders each tool's field sheet to PDF (EN + TR) with headless Chrome
.github/workflows/pages.yml
```

There is no build step for the pages themselves: each tool is a single HTML file with
inline CSS and JS, so it also works when saved to a phone and opened offline.

## Offline field sheet

Each tool has a print stylesheet that turns the page into a field sheet (procedure with
tick boxes, record boxes for the runs, a lookup table and the grading table).

- **On the page:** *Field sheet (PDF)* opens the browser's print dialog; choose *Save as PDF*.
  The sheet uses the settings currently entered (e.g. titrant normality, expected acidity).
- **Ready-made:** the deploy workflow also builds `field-sheet-en.pdf` and `field-sheet-tr.pdf`
  next to each tool with default settings, linked from the page.

## Local development

```sh
python3 -m http.server -d site 8000   # then open http://localhost:8000
scripts/build-pdfs.sh                 # optional: build the PDFs locally (needs Chrome/Chromium)
```

`?lang=en` or `?lang=tr` on a tool URL forces the language (used by the PDF build).

## Adding a tool

1. Create `site/<tool>/index.html` (copy the colour tokens, the `.en` / `.tr` language
   pattern and the print stylesheet from `site/acidity/`).
2. Add a card for it to `site/index.html`.
3. If it has a field sheet, add `<tool>` to `TOOLS` in `scripts/build-pdfs.sh`.

Push to `main` and the workflow publishes it.

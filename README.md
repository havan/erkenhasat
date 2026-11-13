<p><img src="site/assets/logo.svg" alt="Erken Hasat" height="56"></p>

# Erken Hasat

Small, browser-only tools for testing and producing olive oil, published at
**https://havan.github.io/erkenhasat/**. Every tool is bilingual (English / Türkçe),
works without a server, and has a printable field sheet for places with no internet.

## Tools

| Tool | Path | What it does |
| --- | --- | --- |
| Acidity titration | [`site/acidity/`](site/acidity/) | Free acidity (% oleic acid) by NaOH titration (ISO 660 / EU 2568/91), with a step-by-step guide, live calculation, a PDF field sheet, optional oil details (variety, harvest and pressing, mill, malaxation, storage), an A4 test report and bottle labels. |

## Layout

```
site/                    # everything here is published to GitHub Pages as-is
  index.html             # landing page listing the tools
  assets/                # shared files (favicon, ...)
  acidity/index.html     # one self-contained page per tool
scripts/build-pdfs.sh    # renders each tool's field sheet to PDF (EN + TR) with headless Chrome
scripts/stamp-build.sh   # CI: writes the build date and commit into each page footer ("Version …")
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

## Report and bottle labels

After a test, the acidity tool prints either a one-page A4 report (result, oil details, every
run, method and a signature line) or bottle labels. Labels come in two sizes laid out for common
A4 sticker sheets: 99.1 × 67.7 mm, 8 per sheet (Avery L7165 or compatible), and 63.5 × 38.1 mm,
21 per sheet (L7160). You can set the number of labels and the start position for part-used
sheets, and turn on cut lines for plain paper. Print at 100% scale.

Ctrl+P on its own always prints the field sheet; the report and labels have their own buttons.

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

## License

Erken Hasat is free to use, change and share for **non-commercial** purposes under the
[PolyForm Noncommercial License 1.0.0](LICENSE.md). Commercial use needs a separate license
from the author.

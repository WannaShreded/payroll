import sys
import os
import re
from pathlib import Path

MD_PATH = sys.argv[1] if len(sys.argv) > 1 else 'Laporan_UAS_Pemrograman_Perangkat_Bergerak.md'
OUT_PATH = sys.argv[2] if len(sys.argv) > 2 else Path(MD_PATH).with_suffix('.pdf')


def ensure_reportlab():
    try:
        import reportlab
        return True
    except Exception:
        try:
            import subprocess, sys
            subprocess.check_call([sys.executable, '-m', 'pip', 'install', 'reportlab'])
            return True
        except Exception:
            return False


def strip_markdown(md_text: str) -> str:
    # Remove code blocks
    text = re.sub(r'```.*?```', '', md_text, flags=re.S)
    # Remove inline code
    text = re.sub(r'`([^`]*)`', r"\1", text)
    # Remove headings markup
    text = re.sub(r'^#{1,6}\s*', '', text, flags=re.M)
    # Replace lists with bullets
    text = re.sub(r'^\s*[-*+]\s+', '• ', text, flags=re.M)
    # Replace multiple newlines with paragraph separator
    text = re.sub(r'\n{3,}', '\n\n', text)
    return text


def create_pdf(input_md: str, output_pdf: str):
    from reportlab.lib.pagesizes import A4
    from reportlab.lib.units import mm
    from reportlab.pdfbase import pdfmetrics
    from reportlab.pdfbase.ttfonts import TTFont
    from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
    from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer

    # Try to register a standard font if available
    try:
        font_path = None
        # Common Windows font path
        possible = [r'C:\Windows\Fonts\arial.ttf', r'C:\Windows\Fonts\times.ttf']
        for p in possible:
            if os.path.exists(p):
                font_path = p
                break
        if font_path:
            pdfmetrics.registerFont(TTFont('Custom', font_path))
            base_font = 'Custom'
        else:
            base_font = 'Helvetica'
    except Exception:
        base_font = 'Helvetica'

    doc = SimpleDocTemplate(output_pdf, pagesize=A4,
                            rightMargin=20*mm, leftMargin=20*mm,
                            topMargin=20*mm, bottomMargin=20*mm)
    styles = getSampleStyleSheet()
    normal = ParagraphStyle('Normal', parent=styles['Normal'], fontName=base_font, fontSize=11, leading=14)
    story = []

    with open(input_md, 'r', encoding='utf-8') as f:
        md = f.read()

    text = strip_markdown(md)
    paragraphs = [p.strip() for p in text.split('\n\n') if p.strip()]

    for para in paragraphs:
        # Escape special characters for Paragraph
        para = para.replace('&', '&amp;').replace('<', '&lt;').replace('>', '&gt;')
        story.append(Paragraph(para.replace('\n', '<br/>'), normal))
        story.append(Spacer(1, 6))

    doc.build(story)


def main():
    md = MD_PATH
    out = str(OUT_PATH)
    if not os.path.exists(md):
        print(f"ERROR: File tidak ditemukan: {md}")
        sys.exit(2)

    ok = ensure_reportlab()
    if not ok:
        print('ERROR: Tidak dapat menginstal atau mengimpor reportlab. Silakan pasang paket reportlab.')
        sys.exit(3)

    try:
        create_pdf(md, out)
        print(f'SUKSES: PDF dibuat di {out}')
    except Exception as e:
        print('ERROR: Gagal membuat PDF:', e)
        sys.exit(4)


if __name__ == '__main__':
    main()

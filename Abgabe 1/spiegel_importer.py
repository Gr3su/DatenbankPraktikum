import psycopg
import json
from pathlib import Path

from psycopg.types.json import Jsonb

BASE_DIR = Path(__file__).resolve().parent
ARTICLES_DIR = BASE_DIR / "src" / "articles"

def import_articles():
    with psycopg.connect("host=localhost dbname=postgres user=postgres password=postgres") as conn:
        print(f"Importiere Artikel aus {ARTICLES_DIR}...")
        with conn.cursor() as cur:
            rows = []
            for path in Path(ARTICLES_DIR).glob("*.json"):
                with open(path, encoding="utf-8") as f:
                    rows.append((Jsonb(json.load(f)),))
            
            print(f"{len(rows)} Artikel geladen. Starte Datenbank-Import...")
            cur.executemany("INSERT INTO articles (article, isEnglishArticle) VALUES (%s, false)", rows)

            conn.commit()


if __name__ == "__main__":
    import_articles()

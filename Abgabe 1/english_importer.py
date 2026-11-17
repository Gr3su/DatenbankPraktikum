import psycopg
import json
from pathlib import Path

from psycopg.types.json import Jsonb


def import_articles():
    with psycopg.connect("host=localhost dbname=postgres user=postgres password=postgres") as conn:
        rows = []
        with conn.cursor() as cur:
            for path in Path("../src/articles_eng").glob("*.json"):
                with open(path, encoding="utf-8") as f:
                    rows.append((Jsonb(json.load(f)),))
            
            print(f"{len(rows)} Artikel geladen. Starte Datenbank-Import...")
            cur.executemany("INSERT INTO articles (article, isEnglishArticle) VALUES (%s, true)", rows)

            conn.commit()


if __name__ == "__main__":
    import_articles()

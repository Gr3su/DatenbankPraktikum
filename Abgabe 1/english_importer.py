import psycopg
import json
from pathlib import Path

from psycopg.types.json import Jsonb


def import_articles():
    with psycopg.connect("host=localhost dbname=postgres user=postgres password=postgres") as conn:
        with conn.cursor() as cur:
            for path in Path("").glob("*.json"):
                with open(path, encoding="utf-8") as f:
                    d = json.load(f)
                print("Inserting JSON with id: " + d["id"])
                raise NotImplementedError()
                cur.execute("INSERT INTO articles (article) VALUES (%s)", [Jsonb(d)])

            conn.commit()


if __name__ == "__main__":
    import_articles()

import psycopg
import json
from pathlib import Path

from psycopg.types.json import Jsonb


def import_articles():

    with psycopg.connect("host=localhost dbname=postgres user=postgres password=postgres") as conn:
        # Open a cursor to perform database operations
        with conn.cursor() as cur:

            for path in Path("../articles").glob("*.json"):
                with open(path, encoding="utf-8") as f:
                    d = json.load(f)

                print("Inserting Article with id: " + d["id"])

                cur.execute(
                    "INSERT INTO articles (article) VALUES (%s)", [Jsonb(d)])

            # Make the changes to the database persistent
            conn.commit()

if __name__ == "__main__":
    import_articles()


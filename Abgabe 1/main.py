import psycopg



with psycopg.connect("user=postgres password=postgres host=localhost") as conn:
    with conn.cursor() as cur:
        cur.execute("CREATE TABLE IF NOT EXISTS articles(" \
                    "article JSONB NOT NULL)")
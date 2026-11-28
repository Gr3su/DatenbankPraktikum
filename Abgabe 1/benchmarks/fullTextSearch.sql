\set q random(1, 6)

\if :q = 1
    SELECT COALESCE(article->'headline'->>'main', article->>'title') AS title
    FROM articles
    WHERE (
        CASE
        WHEN isenglisharticle THEN to_tsvector('english', article->>'title')
        ELSE to_tsvector('german', article->'headline'->>'main')
        END
        ) @@ to_tsquery('english', 'Obama');

\elif :q = 2
    SELECT COALESCE(article->'headline'->>'main', article->>'title') AS title
    FROM articles
    WHERE (
        CASE
        WHEN isenglisharticle THEN to_tsvector('english', article->>'title')
        ELSE to_tsvector('german', article->'headline'->>'main')
        END
        ) @@ phraseto_tsquery('english', 'climate change policy');

\elif :q = 3
    SELECT COALESCE(article->'headline'->>'main', article->>'title') AS title
    FROM articles
    WHERE (
        CASE
            WHEN isenglisharticle THEN to_tsvector('english', article->>'title')
            ELSE to_tsvector('german', article->'headline'->>'main')
        END
        ) @@ phraseto_tsquery('german','Union Berlin');

\elif :q = 4
    SELECT article->>'text' AS text
    FROM articles
    WHERE (
        CASE
            WHEN isenglisharticle THEN to_tsvector('english', article->>'text')
            ELSE to_tsvector('german', article->>'text')
        END
        )@@ to_tsquery('english', 'Obama');

\elif :q = 5
    SELECT article->>'text' AS text
    FROM articles
    WHERE (
        CASE
            WHEN isenglisharticle THEN to_tsvector('english', article->>'text')
            ELSE to_tsvector('german', article->>'text')
        END
        ) @@ phraseto_tsquery('english', 'climate change policy');

\elif :q = 6
    SELECT article->>'text' AS text
    FROM articles
    WHERE (
        CASE
            WHEN isenglisharticle THEN to_tsvector('english', article->>'text')
            ELSE to_tsvector('german', article->>'text')
        END
        ) @@ phraseto_tsquery('german', 'Union Berlin');
\endif
SELECT COALESCE(article->'headline'->>'main', article->>'title') AS title
FROM articles
WHERE (
    CASE
    WHEN isenglisharticle THEN to_tsvector('english', article->>'title')
    ELSE to_tsvector('german', article->'headline'->>'main')
    END
    ) @@ to_tsquery('english', 'Obama');
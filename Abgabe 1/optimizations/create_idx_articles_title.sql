CREATE INDEX idx_articles_title_fts ON articles USING GIN (
    (CASE 
        WHEN isenglisharticle THEN to_tsvector('english', article->>'title')
        ELSE to_tsvector('german', article->'headline'->>'main')
    END)
);
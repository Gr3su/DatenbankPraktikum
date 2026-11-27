CREATE INDEX idx_articles_text_fts ON articles USING GIN (
    (CASE 
        WHEN isenglisharticle THEN to_tsvector('english', article->>'text')
        ELSE to_tsvector('german', article->>'text')
    END)
);
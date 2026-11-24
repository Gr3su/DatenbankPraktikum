CREATE INDEX idx_articles_ohne_autor
    ON articles (isenglisharticle)
    WHERE NOT isenglisharticle
      AND NOT jsonb_path_exists(article, '$.author.names[*] ? (@ != "")')
      AND COALESCE(TRIM(jsonb_extract_path_text(article, 'author', 'abbreviation')), '') = '';

\set idx random(1, 8)

SELECT (ARRAY['trump', 'biden', 'climate', 'economy', 'germany', 'helene fischer', 'fish', 'datacenter'])[:idx] AS search_word \gset

SELECT SUM((LENGTH(article->>'text') - LENGTH(REPLACE(LOWER(article->>'text'), LOWER('trump'), ''))) / LENGTH('trump')) AS word_counted
FROM articles
ORDER BY word_counted desc;

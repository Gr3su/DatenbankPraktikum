/* 
* Full-text search
* Exact Search
*
*/
SELECT COALESCE(article->'headline'->>'main', article->>'title') AS title
FROM articles
WHERE to_tsvector(COALESCE(article->'headline'->>'main', article->>'title')) @@ to_tsquery('Obama');

SELECT COALESCE(article->'headline'->>'main', article->>'title') AS title
FROM articles
WHERE to_tsvector(COALESCE(article->'headline'->>'main', article->>'title')) @@ phraseto_tsquery('climate change policy');

SELECT COALESCE(article->'headline'->>'main', article->>'title') AS title
FROM articles
WHERE to_tsvector(COALESCE(article->'headline'->>'main', article->>'title')) @@ phraseto_tsquery('Union Berlin');

SELECT article->>'text' AS text
FROM articles
WHERE to_tsvector(article->>'text') @@ to_tsquery('Obama');

SELECT article->>'text' AS text
FROM articles
WHERE to_tsvector(article->>'text') @@ phraseto_tsquery('climate change policy');

SELECT article->>'text' AS text
FROM articles
WHERE to_tsvector(article->>'text') @@ phraseto_tsquery('Union Berlin');

/* 
*
* RegEx Search
*
*/
SELECT COALESCE(article->'headline'->>'main', article->>'title') AS title
FROM articles
WHERE COALESCE(article->'headline'->>'main', article->>'title') ~* '\yPoliti[a-z]\y';

SELECT COALESCE(article->'headline'->>'main', article->>'title') AS title
FROM articles
WHERE COALESCE(article->'headline'->>'main', article->>'title') ~* '\y202[0-9]\y';

SELECT COALESCE(article->'headline'->>'main', article->>'title') AS title
FROM articles
WHERE COALESCE(article->'headline'->>'main', article->>'title') ~* '\y [a-zA-Z]{5} \y';

SELECT article->>'text' AS text
FROM articles
WHERE article->>'text' ~* '\yPoliti[a-z]\y';

SELECT article->>'text' AS text
FROM articles
WHERE article->>'text' ~* '\y202[0-9]\y';

SELECT article->>'text' AS text
FROM articles
WHERE article->>'text' ~* '\y [a-zA-Z]{10} \y';


-- length of texts
SELECT LENGTH(article->>'text')
FROM articles;

-- number of occurrences of strings in texts
SELECT SUM((LENGTH(article->>'text') - LENGTH(REPLACE(LOWER(article->>'text'), LOWER('trump'), ''))) / LENGTH('trump')) AS word_counted
FROM articles
ORDER BY word_counted desc;

-- number of words in texts
SELECT REGEXP_COUNT(article->>'text', '\S+') AS word_count
FROM articles;

-- number of words in texts, with title
SELECT REGEXP_COUNT(article->>'text', '\S+') AS word_count, COALESCE(article->'headline'->>'main', article->>'title') AS title FROM articles;

-- number of sentences in texts
SELECT REGEXP_COUNT(article->>'text', '[A-Z][^.A-Z]*\.') AS num_sentences
FROM articles;

-- number of sentences in texts, with title
SELECT REGEXP_COUNT(article->>'text', '[A-Z][^.A-Z]*\.') AS num_sentences, COALESCE(article->'headline'->>'main', article->>'title')AS title
FROM articles;

-- ######################################
-- Own queries
-- ######################################

-- Authors that appear in both the fake and the Spiegel articles:
SELECT autor,
    COUNT(*) FILTER (WHERE NOT isenglisharticle) AS Spiegel,
    COUNT(*) FILTER (WHERE isenglisharticle) AS fake
FROM articles,
     jsonb_array_elements_text(COALESCE(article->'author'->'names', to_jsonb(ARRAY[article->>'author']))) AS autor
WHERE autor <> ''
GROUP BY 1
HAVING COUNT(DISTINCT isenglisharticle) = 2
ORDER BY 2 + 3 DESC;

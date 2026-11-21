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
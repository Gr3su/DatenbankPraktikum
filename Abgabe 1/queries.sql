/* Full-text search */
/* Exact Search */
SELECT COALESCE(article->'headline'->>'main', article->>'title') AS title
FROM articles
WHERE (
    CASE
    WHEN isenglisharticle THEN to_tsvector('english', article->>'title')
    ELSE to_tsvector('german', article->'headline'->>'main')
    END
    ) @@ to_tsquery('english', 'Obama');

SELECT COALESCE(article->'headline'->>'main', article->>'title') AS title
FROM articles
WHERE (
    CASE
    WHEN isenglisharticle THEN to_tsvector('english', article->>'title')
    ELSE to_tsvector('german', article->'headline'->>'main')
    END
    ) @@ phraseto_tsquery('english', 'climate change policy');

SELECT COALESCE(article->'headline'->>'main', article->>'title') AS title
FROM articles
WHERE (
    CASE
        WHEN isenglisharticle THEN to_tsvector('english', article->>'title')
        ELSE to_tsvector('german', article->'headline'->>'main')
    END
    ) @@ phraseto_tsquery('german','Union Berlin');

SELECT article->>'text' AS text
FROM articles
WHERE (
    CASE
        WHEN isenglisharticle THEN to_tsvector('english', article->>'text')
        ELSE to_tsvector('german', article->>'text')
    END
    )@@ to_tsquery('english', 'Obama');

SELECT article->>'text' AS text
FROM articles
WHERE (
    CASE
        WHEN isenglisharticle THEN to_tsvector('english', article->>'text')
        ELSE to_tsvector('german', article->>'text')
    END
    ) @@ phraseto_tsquery('english', 'climate change policy');

SELECT article->>'text' AS text
FROM articles
WHERE (
    CASE
        WHEN isenglisharticle THEN to_tsvector('english', article->>'text')
        ELSE to_tsvector('german', article->>'text')
    END
    ) @@ phraseto_tsquery('german', 'Union Berlin');

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
WHERE COALESCE(article->'headline'->>'main', article->>'title') ~* '\y[a-zA-Z]{5}\y';

SELECT article->>'text' AS text
FROM articles
WHERE article->>'text' ~* '\yPoliti[a-z]\y';

SELECT article->>'text' AS text
FROM articles
WHERE article->>'text' ~* '\y202[0-9]\y';

SELECT article->>'text' AS text
FROM articles
WHERE article->>'text' ~* '\y[a-zA-Z]{10}\y';


/* 
* length of texts
*/
SELECT LENGTH(article->>'text')
FROM articles;

/* 
* number of occurrences of strings in texts
*/
SELECT SUM((LENGTH(article->>'text') - LENGTH(REPLACE(LOWER(article->>'text'), LOWER('trump'), ''))) / LENGTH('trump')) AS word_counted
FROM articles
ORDER BY word_counted desc;

/* 
* number of words in texts
*/
SELECT REGEXP_COUNT(article->>'text', '\S+') AS word_count
FROM articles;

/* 
* number of words in texts, with title
*/
SELECT REGEXP_COUNT(article->>'text', '\S+') AS word_count, COALESCE(article->'headline'->>'main', article->>'title') AS title FROM articles;

/* 
* number of sentences in texts
*/
SELECT REGEXP_COUNT(article->>'text', '[A-Z][^.A-Z]*\.') AS num_sentences
FROM articles;

/* 
* number of sentences in texts, with title
*/
SELECT REGEXP_COUNT(article->>'text', '[A-Z][^.A-Z]*\.') AS num_sentences, COALESCE(article->'headline'->>'main', article->>'title')AS title
FROM articles;

/*
* ######################################
* Own queries
* ######################################
*/

/*
* Authors that appear in both the fake and the Spiegel articles:
*/
SELECT autor,
    COUNT(*) FILTER (WHERE NOT isenglisharticle) AS Spiegel,
    COUNT(*) FILTER (WHERE isenglisharticle) AS fake
FROM articles,
     jsonb_array_elements_text(COALESCE(article->'author'->'names', to_jsonb(ARRAY[article->>'author']))) AS autor
WHERE autor <> ''
GROUP BY 1
HAVING COUNT(DISTINCT isenglisharticle) = 2
ORDER BY 2 + 3 DESC;

/*
* Monthly counts of English and German articles, 
* in addition to deciding which language has the majority of articles for each month:
*/
WITH monthly_counts AS (
    SELECT
        DATE_TRUNC('month', (COALESCE(article->>'date_published', article->>'published'))::timestamptz)::date AS datum,
        COUNT(*) FILTER (WHERE isenglisharticle = true) AS englisch,
        COUNT(*) FILTER (WHERE isenglisharticle = false) AS deutsch
    FROM articles
    WHERE COALESCE(article->>'date_published', article->>'published') IS NOT NULL
    GROUP BY 1
)
SELECT
    TO_CHAR(datum, 'MM-YYYY') AS jahr_monat,
    englisch,
    deutsch,
    CASE
        WHEN englisch > deutsch THEN 'Englisch'
        WHEN deutsch > englisch THEN 'Deutsch'
        ELSE 'Gleichstand'
    END AS mehrheit
FROM monthly_counts
ORDER BY datum DESC;
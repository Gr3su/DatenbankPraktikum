SELECT t.topic, COUNT(*) AS Anzahl
FROM articles a
         CROSS JOIN LATERAL jsonb_array_elements_text(a.article -> 'topics') AS t(topic) -- Extract JSON ARRAY as PG LIST
WHERE isenglisharticle = false
  AND COALESCE(TRIM(jsonb_extract_path_text(article, 'author', 'abbreviation')), '') = ''
  AND NOT jsonb_path_exists(article, '$.author.names[*] ? (@ != "")')
GROUP BY t.topic
ORDER BY anzahl DESC;

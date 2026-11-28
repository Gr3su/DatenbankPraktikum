SELECT autor,
    COUNT(*) FILTER (WHERE NOT isenglisharticle) AS Spiegel,
    COUNT(*) FILTER (WHERE isenglisharticle) AS fake
FROM articles,
     jsonb_array_elements_text(COALESCE(article->'author'->'names', to_jsonb(ARRAY[article->>'author']))) AS autor
WHERE autor <> ''
GROUP BY 1
HAVING COUNT(DISTINCT isenglisharticle) = 2
ORDER BY 2 + 3 DESC;

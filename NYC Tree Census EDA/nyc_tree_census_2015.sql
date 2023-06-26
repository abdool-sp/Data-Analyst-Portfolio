SELECT *
FROM `bigquery-public-data.new_york_trees.tree_census_2015` LIMIT 5

--number of trees
SELECT COUNT(DISTINCT tree_id) AS no_of_trees,COUNT(DISTINCT block_id) AS no_of_blocks 
FROM `bigquery-public-data.new_york_trees.tree_census_2015`

--tree distribution
SELECT spc_common AS species,latitude,longitude,health,status
FROM `bigquery-public-data.new_york_trees.tree_census_2015`
WHERE latitude IS NOT NULL AND longitude IS NOT NULL
ORDER BY RAND()
LIMIT 68000

--number of distinct species
SELECT COUNT(DISTINCT spc_common) AS no_of_species
FROM `bigquery-public-data.new_york_trees.tree_census_2015`

--percentage of each species 
SELECT spc_common,COUNT(*) AS total_counts,
       COUNT(*) / (
        SELECT COUNT(tree_id)
        FROM `bigquery-public-data.new_york_trees.tree_census_2015`
       )*100 AS percentage
FROM `bigquery-public-data.new_york_trees.tree_census_2015`
GROUP BY spc_common
ORDER BY total_counts DESC

SELECT zipcode,spc_common,COUNT(tree_id) AS total_trees --for the cluster map
FROM `bigquery-public-data.new_york_trees.tree_census_2015`
WHERE spc_common IS NOT NULl
GROUP BY zipcode,spc_common

--number of trees per block
select block_id,count(distinct tree_id) AS no_of_trees
FROM `bigquery-public-data.new_york_trees.tree_census_2015` 
GROUP BY block_id
ORDER BY no_of_trees DESC

select block_id,count(distinct tree_id) AS no_of_trees,
       SUM(CASE WHEN status = 'Alive' THEN 1 ELSE 0 END) AS alive_count,
       SUM(CASE WHEN status = 'Dead' THEN 1 ELSE 0 END) AS dead_count,
       SUM(CASE WHEN status = 'Stump' THEN 1 ELSE 0 END) AS stump_count
FROM `bigquery-public-data.new_york_trees.tree_census_2015` 
GROUP BY block_id
ORDER BY alive_count DESC

--by borough
SELECT boroname,COUNT(tree_id) AS total_trees,
       SUM(CASE WHEN status = 'Alive' THEN 1 ELSE 0 END) AS alive_count,
       SUM(CASE WHEN status = 'Dead' THEN 1 ELSE 0 END) AS dead_count,
       SUM(CASE WHEN status = 'Stump' THEN 1 ELSE 0 END) AS stump_count,
       SUM(CASE WHEN health = 'Fair' THEN 1 ELSE 0 END) AS health_fair,
       SUM(CASE WHEN health = 'Good' THEN 1 ELSE 0 END) AS good_health,
       SUM(CASE WHEN health = 'Poor' THEN 1 ELSE 0 END) AS poor_health,
FROM `bigquery-public-data.new_york_trees.tree_census_2015`
GROUP BY boroname

SELECT boroname, COUNT(DISTINCT spc_common),COUNT(*) AS tree_count
FROM `bigquery-public-data.new_york_trees.tree_census_2015`
WHERE spc_common IS NOT NULL
GROUP BY boroname
ORDER BY boroname

--to get the top species in each borough
SELECT boroname, spc_common, total_count
FROM (
  SELECT boroname, spc_common, COUNT(*) AS total_count,
         ROW_NUMBER() OVER (PARTITION BY boroname ORDER BY COUNT(*) DESC) AS rn
  FROM `bigquery-public-data.new_york_trees.tree_census_2015`
  WHERE boroname IS NOT NULL AND spc_common IS NOT NULL
  GROUP BY boroname, spc_common
) AS sub
WHERE rn <= 1
ORDER BY boroname, total_count DESC;

SELECT boroname, spc_common, status, health, COUNT(*) AS tree_count
FROM `bigquery-public-data.new_york_trees.tree_census_2015`
WHERE boroname IS NOT NULL AND status="Dead"
GROUP BY boroname, spc_common, status, health
ORDER BY boroname, spc_common, tree_count DESC;



--by health and status
SELECT health,COUNT(tree_id) AS total_trees,
       ROUND(COUNT(tree_id)/(
         SELECT COUNT(tree_id)
         FROM `bigquery-public-data.new_york_trees.tree_census_2015`
       ) * 100,1) AS percentage
FROM `bigquery-public-data.new_york_trees.tree_census_2015`
GROUP BY health

SELECT boroname,health,COUNT(tree_id) AS total_trees,
       ROUND(COUNT(tree_id)/(
         SELECT COUNT(tree_id)
         FROM `bigquery-public-data.new_york_trees.tree_census_2015`
       ) * 100,1) AS percentage
FROM `bigquery-public-data.new_york_trees.tree_census_2015`
GROUP BY boroname,health

SELECT status,COUNT(tree_id) AS total_trees,
       ROUND(COUNT(tree_id)/(
         SELECT COUNT(tree_id)
         FROM `bigquery-public-data.new_york_trees.tree_census_2015`
       ) * 100,1) AS percentage
FROM `bigquery-public-data.new_york_trees.tree_census_2015`
GROUP BY status

--species
SELECT COUNT(distinct spc_common) AS number_of_species
FROM `bigquery-public-data.new_york_trees.tree_census_2015`
WHERE spc_common IS NOT NULl

SELECT spc_common,COUNT(tree_id) AS total_trees
FROM `bigquery-public-data.new_york_trees.tree_census_2015`
WHERE spc_common IS NOT NULl
GROUP BY spc_common

SELECT boroname,COUNT(*) AS total_count
FROM `bigquery-public-data.new_york_trees.tree_census_2015`
WHERE spc_common="Japanese maple"
GROUP BY boroname

SELECT boroname,COUNT(*) AS total_count
FROM `bigquery-public-data.new_york_trees.tree_census_2015`
WHERE spc_common="weeping willow"
GROUP BY boroname



SELECT boroname, spc_common, COUNT(*) AS total_count
FROM `bigquery-public-data.new_york_trees.tree_census_2015`
WHERE boroname IS NOT NULL AND spc_common IS NOT NULL
GROUP BY boroname, spc_common
ORDER BY boroname, total_count DESC;



--diameter
--avg diamter per borough
SELECT boroname,zipcode,ROUND(AVG(tree_dbh),2) AS tree_diameter,ROUND(AVG(stump_diam),2) AS stump_diameter
FROM `bigquery-public-data.new_york_trees.tree_census_2015`
GROUP BY boroname,zipcode
--percentages
SELECT tree_id,boroname,spc_common,health,status
FROM `bigquery-public-data.new_york_trees.tree_census_2015`

SELECT zipcode, COUNT(tree_id) AS total_trees
FROM `bigquery-public-data.new_york_trees.tree_census_2015`
GROUP BY zipcode




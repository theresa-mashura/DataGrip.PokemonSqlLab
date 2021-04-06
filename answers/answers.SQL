-- PART 2

-- What are all the types of pokemon that a pokemon can have?
SELECT * 
FROM types; 

-- What is the name of the pokemon with id 45?
SELECT * 
FROM Pokemons
WHERE id = 45; 

-- How many pokemon are there? 656
SELECT COUNT(1) AS Count
FROM Pokemons; 

-- How many types are there? 18
SELECT COUNT(1) AS Count
FROM types;

-- How many pokemon have a secondary type? 316
SELECT COUNT(1) AS Count
FROM Pokemons
WHERE secondary_type IS NOT NULL; 

-- PART 3

-- What is each pokemon's primary type?
SELECT 
  p.name AS Pokemon_Name, 
  t.name AS Primary_Type_Name
FROM Pokemons p
LEFT JOIN types t
ON p.primary_type = t.id; 
  
-- What is Rufflet's secondary type? Normal
SELECT
  p.name AS Pokemon_Name, 
  t.name AS Primary_Type_Name
FROM Pokemons p
LEFT JOIN types t
ON p.primary_type = t.id
WHERE p.name = "Rufflet"; 

-- What are the names of the pokemon that belong to the trainer with trainerID 303? Wailord, Vileplum
SELECT
  name AS Pokemon_Name
FROM Pokemons p
WHERE EXISTS (SELECT 1 FROM pokemon_trainer pt WHERE pt.trainerID = 303 AND pt.pokemon_id = p.id);

-- How many pokemon have a secondary type Poison 31
SELECT
  COUNT(1) AS Count_Poison
FROM Pokemons p
WHERE EXISTS (SELECT 1 FROM types t WHERE name = "Poison" AND t.id = p.secondary_type);  

-- What are all the primary types and how many pokemon have that type?
SELECT
  t.name,
  COUNT(p.primary_type) AS Count_Primary_Type
FROM Pokemons p
LEFT JOIN types t
ON p.primary_type = t.id
GROUP BY t.name, p.primary_type;

-- How many pokemon at level 100 does each trainer with at least one level 100 pokemone have? (Hint: your query should not display a trainer
SELECT
  trainerid, 
  COUNT(1) AS Count_Pokemon_Lvl100
FROM Pokemon_trainer
WHERE pokelevel = 100
GROUP BY trainerID;

-- How many pokemon only belong to one trainer and no other? 13
SELECT
  COUNT(pokemon_id) AS COUNT
  FROM (
    SELECT
       pokemon_id, 
       COUNT(trainerID) AS Count_One_Trainer
    FROM pokemon_trainer
    GROUP BY pokemon_id
    HAVING Count_One_Trainer = 1
) x; 

-- PART 4
-- each trainer an have >1 pokemon, some may share same pokemon
SELECT 
  p.id, 
  pt.trainerID, 
  p.name AS Pokemon_Name, 
  t.trainername AS Trainer_Name, 
  pt.pokelevel AS Level, 
  pt.attack AS Attack, 
  SUM(pt.pokeLevel) OVER (PARTITION BY pt.trainerID) AS Sum_Level,
  SUM(pt.attack) OVER (PARTITION BY pt.trainerID) AS Sum_Attack,
  t1.name AS Primary_Type, 
  t2.name AS Secondary_Type
FROM Pokemons p
LEFT JOIN types t1
ON p.primary_type = t1.id
LEFT JOIN types t2
ON p.secondary_type = t2.id
LEFT JOIN pokemon_trainer pt
ON p.id = pt.pokemon_id
LEFT JOIN trainers t           
ON pt.trainerId = t.trainerID
ORDER BY Sum_Level DESC, Sum_Attack DESC, pt.trainerID  -- Best trainer has pokemen whose levels sum to highest number, tiebreaker is sum of pokemon's attack
;



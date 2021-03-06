--the first thing I want to do is create two tables with a relationship
--(using primary keys and foreign keys)

--This schema will be used to track exotic pets and their owners

--owners table
CREATE TABLE owners(
	owner_id serial PRIMARY KEY, --The primary key uniquely identifies each record in a table. it's typically an ID.
	--serial is an auto-incrementing int data type. We don't need to give it a value when we insert data. It's automatic
	--whenever we insert a new owner, the owner_id will be generated for us.
	owner_name TEXT NOT NULL --since this has a not null constraint, we have to provide values for name
);

--pets table
CREATE TABLE pets(
	pet_id serial PRIMARY KEY,	
	species TEXT,
	age int CHECK (age > 1), --no baby animals are allowed in this exotic animal trade. 
	--this check makes it so that we can't insert a new pet with an age field less than 1.
	
	owner_id_fk int REFERENCES owners (owner_id) --this is a FOREIGN KEY. (note the use of "references")
	--this is saying, this foreign key is bound to the primary key (owner_id) of the owners table
	--THIS IS HOW WE ESTABLISH RELATIONSHIPS BETWEEN OUR TABLES OF DATA 
);

--You want to create the tables that other tables depend on FIRST
--Notice how we can't create a pets table if the owners table doesn't exist first (the foreign key depends on it)

DROP TABLE owners;

--we can't drop the owners table, it's a problem because the pets table depends on it

--we COULD drop (or update) the owners table witht the CASCADE keyword

DROP TABLE owners CASCADE; --this CASCADEs the changes to all dependent tables. the changes cascade over
DROP TABLE pets;

--you could also just drop the dependent tables first, then the table you want to drop, then recreate them all

--DML-------------------------------------------------------------------------------------------------------------

--Now, let's use some Data Manipulation Language (DML): Select, Insert, Update, Delete

--INSERT some data into the owners table, and the pets table

--in INSERT statements, we specify what table and what column we're inserting data into
--and then, we can specify one or many records to insert
--we need to surround each unique record with ('parenthesis')
INSERT INTO owners (owner_name) 
VALUES ('You'), ('Jeremy'), ('Perry'), ('Rakan');

--we can use SELECT to view the data in the table

--I want to return all the owners records that we just inserted
SELECT * FROM owners; --we use * to select every column from the records (as opposed to selecting only certain columns)

--Ben will try to violate some of these constraints when we insert data

--Now I want to insert some pets
INSERT INTO pets (species, age, owner_id_fk)
VALUES ('Platypus', 10, 2), ('Pangolin', 7, 1), 
	   ('Liger', 18, 3), ('Axolotl', 2, 2);

SELECT * FROM pets;

--Notice how every pet needs an owner_id_fk, but an owner doesn't NEED to have a pet associated with them.
--This is by design. the pets table has a column that depends on the owners, but the owners don't have any pet column.
--This is a one-to-many relationship! (more on cardinalty later)
--In this case, one owner can have many (or zero pets). Pets can only have one owner, and they MUST have one owner.

--we can also SELECT data from specific columns instead of all columns

SELECT owner_name FROM owners; --this only select the names, not the ids

SELECT species, age FROM pets; --this only selects the species and age from pets.

--The WHERE Clause--------

--all pets who are Pangolins (=)
SELECT * FROM pets WHERE species = 'Pangolin';

--all pets who are not pangolins (!=)
SELECT * FROM pets WHERE  species != 'Pangolin';

--pets younger than 12 (<)
SELECT * FROM pets WHERE age < 12;

--pets whose species names start with P (like) (%)
SELECT * FROM pets WHERE species LIKE 'P%';

--pets with L somewhere in the middle of their species name
SELECT * FROM pets WHERE species LIKE '%1%';

--pets whose ages are between 10 and 20 (between)
SELECT * FROM pets p  WHERE age BETWEEN 10 AND 20;

--pets whose species are axolotl or liger (or) (in)
SELECT  * FROM pets WHERE species = 'Axolotl' OR species = 'Liger'; --(expression) OR (expression) OR etc...
SELECT  * FROM pets WHERE species IN ('Axolotl', 'Liger'); --checks IF the VALUES ARE WITHIN an ARRAY OF VALUES

--pets who aren't axoltls or liger
SELECT * FROM pets WHERE species NOT IN ('Axolotl', 'Liger');

--Also important is the ORDER BY clause, which lets us return data in some ORDER 

SELECT * FROM pets ORDER BY; --numerical ORDER ascending

SELECT * FROM pets ORDER BY age DESC; --alphabetical ORDER descending

SELECT * FROM pets ORDER BY age, species; --IF the age IS the same, THEN those matching COLUMNS ARE ordered BY species

SELECT * FROM pets ORDER BY random(); 

--------------------------------------------------------------------

--we can also UPDATE  values in our tables
--Be careful!! You should always use WHERE clause, or every single row in the table will be updated

--This will update Platypu's age to 11
UPDATE pets SET age = 11 WHERE pet_id =1;

SELECT * FROM pets; 

--increment every pet's age by 1
UPDATE pets SET age = age + 1;

SELECT * FROM pets;

--we can DELETE rows too. 
--like with update, you should always sepcify a WHERE clause, or else all your data will be deleted
DELETE FROM pets WHERE age > 15;

SELECT * FROM pets;





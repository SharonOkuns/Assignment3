-- Create the database if it doesn't exist and switch to it
CREATE DATABASE IF NOT EXISTS Data1;
USE Data1;

-- Check the existing usernames in the Directors table
 SELECT username FROM Directors;

-- Create the Rating_Platform table
CREATE TABLE IF NOT EXISTS Rating_Platform (
    platform_id INT,
    platform_name VARCHAR(255) NOT NULL UNIQUE,
    PRIMARY KEY (platform_id)
);

-- Create the Audience table
CREATE TABLE IF NOT EXISTS Audience (
    username VARCHAR(255),
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    surname VARCHAR(255),
    PRIMARY KEY (username)
);

-- Create the Directors table
CREATE TABLE IF NOT EXISTS Directors (
    username VARCHAR(255),
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    surname VARCHAR(255),
    nation VARCHAR(255) NOT NULL,
    platform_id INT,
    PRIMARY KEY(username),
    FOREIGN KEY(platform_id) REFERENCES Rating_Platform(platform_id) ON DELETE CASCADE
);

SELECT username FROM Directors;

-- Create the Genre table
CREATE TABLE IF NOT EXISTS Genre (
    genre_id INT,
    genre_name VARCHAR(255) NOT NULL UNIQUE,
    PRIMARY KEY(genre_id)
);

-- Check for missing movie IDs in Predecessor_Movies
SELECT DISTINCT movie_id FROM Predecessor_Movies WHERE movie_id NOT IN (SELECT movie_id FROM Movie);

-- Check for missing movie IDs in Movie_Genre
SELECT DISTINCT movie_id FROM Movie_Genre WHERE movie_id NOT IN (SELECT movie_id FROM Movie);

-- Check for missing movie IDs in Movie_Sessions
SELECT DISTINCT movie_id FROM Movie_Sessions WHERE movie_id NOT IN (SELECT movie_id FROM Movie);

-- Check for missing movie IDs in Movie_Time
SELECT DISTINCT session_id FROM Movie_Time WHERE session_id NOT IN (SELECT session_id FROM Movie_Sessions);

SELECT movie_id FROM Movie;
SELECT movie_id FROM Movie_Sessions;


-- Create the Movie table
CREATE TABLE IF NOT EXISTS Movie (
    movie_id INT,
    movie_name VARCHAR(255) NOT NULL,
    duration_minutes INT NOT NULL,
    overall_rating INT,
    director_username VARCHAR(255) NOT NULL,
    PRIMARY KEY (movie_id),
    FOREIGN KEY (director_username) REFERENCES Directors(username) ON DELETE CASCADE
);

-- Create the Predecessor_Movies table
CREATE TABLE IF NOT EXISTS Predecessor_Movies (
    movie_id INT,
    predecessor_movie_id INT,
    PRIMARY KEY (movie_id, predecessor_movie_id),
    FOREIGN KEY (movie_id) REFERENCES Movie(movie_id) ON DELETE CASCADE,
    FOREIGN KEY (predecessor_movie_id) REFERENCES Movie(movie_id) ON DELETE CASCADE
);
-- Create the Movie_Genre table
CREATE TABLE IF NOT EXISTS Movie_Genre (
    movie_id INT,
    genre_id INT,
    PRIMARY KEY(movie_id, genre_id),
    FOREIGN KEY(movie_id) REFERENCES Movie(movie_id) ON DELETE CASCADE,
    FOREIGN KEY(genre_id) REFERENCES Genre(genre_id) ON DELETE CASCADE
);

-- Check for  movie_id values in Movie_Genre that do not exist in the Movie table
SELECT DISTINCT mg.movie_id
FROM Movie_Genre mg
LEFT JOIN Movie m ON mg.movie_id = m.movie_id
WHERE m.movie_id IS NULL;

-- Create the Theater table
CREATE TABLE IF NOT EXISTS Theater (
    theater_id INT,
    theater_name VARCHAR(255) NOT NULL,
    theater_capacity INT NOT NULL,
    theater_district VARCHAR(255),
    PRIMARY KEY (theater_id)
);

-- Create the Movie_Sessions table
CREATE TABLE IF NOT EXISTS Movie_Sessions (
    session_id INT,
    movie_id INT NOT NULL,
    theater_id INT NOT NULL,
    PRIMARY KEY(session_id),
    FOREIGN KEY(movie_id) REFERENCES Movie(movie_id) ON DELETE CASCADE,
    FOREIGN KEY(theater_id) REFERENCES Theater(theater_id) ON DELETE CASCADE
);

-- Create the Buy_Ticket table
CREATE TABLE IF NOT EXISTS Buy_Ticket (
    username VARCHAR(255),
    session_id INT,
    PRIMARY KEY(username, session_id),
    FOREIGN KEY(username) REFERENCES Audience(username) ON DELETE CASCADE,
    FOREIGN KEY(session_id) REFERENCES Movie_Sessions(session_id) ON DELETE CASCADE
);

-- Create the Movie_Time table
CREATE TABLE IF NOT EXISTS Movie_Time (
    session_id INT,
    _date DATE,
    time_slot INT,
    PRIMARY KEY(session_id),
    FOREIGN KEY(session_id) REFERENCES Movie_Sessions(session_id) ON DELETE CASCADE
);

-- Create the Database_Managers table
CREATE TABLE IF NOT EXISTS Database_Managers (
    username VARCHAR(255),
    _password VARCHAR(255) NOT NULL,
    PRIMARY KEY(username)
);

-- Create the Rate table
CREATE TABLE IF NOT EXISTS Rate (
    rating_id INT AUTO_INCREMENT PRIMARY KEY,
    movie_id INT NOT NULL,
    username VARCHAR(255) NOT NULL,
    rating DECIMAL(3, 1) NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES Movie(movie_id) ON DELETE CASCADE,
    FOREIGN KEY (username) REFERENCES Audience(username) ON DELETE CASCADE
);

-- Create the Subscribed_To table
CREATE TABLE IF NOT EXISTS Subscribed_To (
    subscription_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    platform_id INT NOT NULL,
    subscription_date DATE NOT NULL,
    FOREIGN KEY (username) REFERENCES Audience(username) ON DELETE CASCADE,
    FOREIGN KEY (platform_id) REFERENCES Rating_Platform(platform_id) ON DELETE CASCADE
);

-- Add the missing column "duration" to the Movie table
ALTER TABLE Movie ADD COLUMN duration VARCHAR(10);

-- Insert data into Rating_Platform table
INSERT INTO Rating_Platform (platform_id, platform_name) VALUES (10001, 'Rotten Tomatoes'), (10002, 'IMDb'), (10003, 'Metacritic');
INSERT INTO Rating_Platform (platform_id, platform_name) VALUES (10004, 'Letterboxd'), (10005, 'Criticker'), (10006, 'FilmAffinity');
INSERT INTO Rating_Platform (platform_id, platform_name) VALUES (10007, 'Youtube'), (10008, 'Reddit');

-- Insert data into Audience table
INSERT INTO Audience (username, password, first_name, surname) VALUES ('shelton.benny', 'arsenal01', 'Shelton', 'Benny');
INSERT INTO Audience (username, password, first_name, surname) VALUES ('earlenita007', 'liverpool02', 'Earle', 'Nita');
INSERT INTO Audience (username, password, first_name, surname) VALUES ('mami.mimi', 'mancity.03', 'Mimi', 'Marni');
INSERT INTO Audience (username, password, first_name, surname) VALUES ('francesl247', 'aston.villa04', 'Frances', 'Leeann');
INSERT INTO Audience (username, password, first_name, surname) VALUES ('layne.alger', 'tottenham05', 'Layne', 'Alger');
INSERT INTO Audience (username, password, first_name, surname) VALUES ('allana.legend', 'man.united06', 'Allana', 'Legend');
INSERT INTO Audience (username, password, first_name, surname) VALUES ('audrey m234', 'wolves.09', 'Monte', 'Aubrey');
INSERT INTO Audience (username, password, first_name, surname) VALUES ('torin.c196', 'newcastle10', 'Christopher', 'Torin');
INSERT INTO Audience (username, password, first_name, surname) VALUES ('parks.d_809', 'chelsea11', 'Daniel', 'Parks');

-- Insert data into Directors table
INSERT INTO Directors (username, password, first_name, surname, nation, platform_id) VALUES ('kathy.ryan_', 'foxtail-chess', 'Kathy', 'Ryan', 'British', 10001);
INSERT INTO Directors (username, password, first_name, surname, nation, platform_id) VALUES ('tomasa_vico', 'mustangazure', 'Vico', 'Tomasa', 'Spanish', 10002);
INSERT INTO Directors (username, password, first_name, surname, nation, platform_id) VALUES ('feijoo.sergio13', 'falconetalesman', 'Feijoo', 'Sergio', 'Spanish', 10003);
INSERT INTO Directors (username, password, first_name, surname, nation, platform_id) VALUES ('desirefevre_987', 'tinycarousal', 'Desire', 'Fevre', 'French', 10004);
INSERT INTO Directors (username, password, first_name, surname, nation, platform_id) VALUES ('schererpaul43', 'northernlights', 'Paul', 'Scherer', 'German', 10005);
INSERT INTO Directors (username, password, first_name, surname, nation, platform_id) VALUES ('amie.squires96', 'jasminestar', 'Amie', 'Squires', 'British', 10006);
INSERT INTO Directors (username, password, first_name, surname, nation, platform_id) VALUES ('femerj964', 'batmanrobin', 'Jurrien', 'Femer', 'Dutch', 10007);
INSERT INTO Directors (username, password, first_name, surname, nation, platform_id) VALUES ('aarni_junnila40', 'doctorwho', 'Aarni', 'Junnila', 'Finnish', 10008);

-- Insert data into Genre table
INSERT INTO Genre (genre_id, genre_name) VALUES (20003, 'Adventure'), (20004, 'Comedy'), (20005, 'Crime');
INSERT INTO Genre (genre_id, genre_name) VALUES (20006, 'Documentary'), (20007, 'Drama'), (20008, 'Fantasy');
INSERT INTO Genre (genre_id, genre_name) VALUES (20009, 'Horror'), (20010, 'Musical'), (20011, 'Romance');
INSERT INTO Genre (genre_id, genre_name) VALUES (20012, 'Sci-Fi'), (20013, 'Thriller');

-- Insert data into Movie table
INSERT INTO Movie (movie_id, movie_name, duration_minutes, director_username) VALUES (11111, 'Kung Fu Panda 4', 94, 'shelton.benny');
INSERT INTO Movie (movie_id, movie_name, duration_minutes, director_username) VALUES (11112, 'GhostBusters: Frozen Empire', 115, 'mami.mimi');
INSERT INTO Movie (movie_id, movie_name, duration_minutes, director_username) VALUES (11113, 'Dune: Part two', 167, 'layne.alger');
INSERT INTO Movie (movie_id, movie_name, duration_minutes, director_username) VALUES (11114, 'Mothers'' instinct', 94, 'aubrey_m234');
INSERT INTO Movie (movie_id, movie_name, duration_minutes, director_username) VALUES (11115, 'Bob Marley: One love', 104, 'jacqueline.tiara1');
INSERT INTO Movie (movie_id, movie_name, duration_minutes, director_username) VALUES (11116, 'Immaculate', 89, 'parks.d_809');
INSERT INTO Movie (movie_id, movie_name, duration_minutes, director_username) VALUES (11117, 'Godzilla x Kong: The New Empire', 115, 'torin.c196');
INSERT INTO Movie (movie_id, movie_name, duration_minutes, director_username) VALUES (11118, 'Little Eggs: A Frozen Rescue', 91, 'francesl247');

-- Insert data into Predecessor_Movies table
INSERT INTO Predecessor_Movies (movie_id, predecessor_movie_id) VALUES (11112, 11113);

-- Insert data into Movie_Genre table
INSERT INTO Movie_Genre (movie_id, genre_id) VALUES (11111, 20003), (11112, 20004), (11113, 20005);
INSERT INTO Movie_Genre (movie_id, genre_id) VALUES (11114, 20006), (11115, 20007), (11116, 20008);
INSERT INTO Movie_Genre (movie_id, genre_id) VALUES (11117, 20009), (11118, 20010);

-- Insert data into Theater table
INSERT INTO Theater (theater_id, theater_name, theater_capacity, theater_district) VALUES (90001, 'London_1', 100, 'London');
INSERT INTO Theater (theater_id, theater_name, theater_capacity, theater_district) VALUES (90002, 'London_2', 200, 'London');
INSERT INTO Theater (theater_id, theater_name, theater_capacity, theater_district) VALUES (90003, 'London3', 250, 'London');
INSERT INTO Theater (theater_id, theater_name, theater_capacity, theater_district) VALUES (90004, 'London4', 300, 'London');

-- Insert data into Movie_Sessions table
INSERT INTO Movie_Sessions (session_id, movie_id, theater_id) VALUES (32123, 11111, 90001);
INSERT INTO Movie_Sessions (session_id, movie_id, theater_id) VALUES (32124, 11112, 90002);
INSERT INTO Movie_Sessions (session_id, movie_id, theater_id) VALUES (32125, 11113, 90003);
INSERT INTO Movie_Sessions (session_id, movie_id, theater_id) VALUES (32126, 11114, 90004);
INSERT INTO Movie_Sessions (session_id, movie_id, theater_id) VALUES (32127, 11115, 90005);
INSERT INTO Movie_Sessions (session_id, movie_id, theater_id) VALUES (32128, 11116, 90006);
INSERT INTO Movie_Sessions (session_id, movie_id, theater_id) VALUES (32130, 11118, 90008);


-- Insert data into Movie_Time table
INSERT INTO Movie_Time (session_id, _date, time_slot) VALUES (32123, '2024-03-25', 3);
INSERT INTO Movie_Time (session_id, _date, time_slot) VALUES (32124, '2024-03-25', 2);
INSERT INTO Movie_Time (session_id, _date, time_slot) VALUES (32125, '2024-03-25', 4);
INSERT INTO Movie_Time (session_id, _date, time_slot) VALUES (32126, '2024-03-25', 3);
INSERT INTO Movie_Time (session_id, _date, time_slot) VALUES (32127, '2024-03-25', 4);
INSERT INTO Movie_Time (session_id, _date, time_slot) VALUES (32128, '2024-03-25', 2);
INSERT INTO Movie_Time (session_id, _date, time_slot) VALUES (32130, '2024-03-25', 2);

-- Insert data into Database_Managers table
INSERT INTO Database_Managers (username, _password) VALUES ('manager01', 'manageradmin02');
INSERT INTO Database_Managers (username, _password) VALUES ('manager02', 'manageradmin05');
INSERT INTO Database_Managers (username, _password) VALUES ('manager03', 'manageradmin07');

-- Add constraints to Rate table
ALTER TABLE Rate ADD CONSTRAINT FK_Movie_Rate FOREIGN KEY (movie_id) REFERENCES Movie(movie_id) ON DELETE CASCADE;
ALTER TABLE Rate ADD CONSTRAINT FK_Audience_Rate FOREIGN KEY (username) REFERENCES Audience(username) ON DELETE CASCADE;

-- Add constraints to Subscribed_To table
ALTER TABLE Subscribed_To ADD CONSTRAINT FK_Audience_Subscribed FOREIGN KEY (username) REFERENCES Audience(username) ON DELETE CASCADE;
ALTER TABLE Subscribed_To ADD CONSTRAINT FK_Rating_Platform_Subscribed FOREIGN KEY (platform_id) REFERENCES Rating_Platform(platform_id) ON DELETE CASCADE;

-- Show the tables
SELECT * 
FROM Audience;

SELECT * 
FROM Directors;

SELECT * 
FROM Genre;

SELECT * 
FROM Movie_Genre;

SELECT * 
FROM Movie;

SELECT * 
FROM Rating_Platform;

SELECT * 
FROM Rate;

SELECT * 
FROM Subscribed_To;

SELECT * 
FROM Theater;

SELECT * 
FROM Movie_Sessions;

SELECT * 
FROM Buy_Ticket;

SELECT * 
FROM Movie_Time;

SELECT * 
FROM Database_Managers;

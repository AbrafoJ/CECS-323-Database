
/**
 * 
 * In this SQL file, we created three tables, Writing Group, Publisher, and Books. Once we created the tables,
 * we inserted fake data based on bands and their record labels.
 * 
 * Author:  Abram Villanueva <abramvillan@gmail.com> and Caren Briones <carenpbriones@gmail.com>
 * Created: Oct 18 , 2016
 */


CREATE TABLE WritingGroup(
    groupName       VARCHAR(20) NOT NULL,
    headWriter      VARCHAR(30),
    yearFormed      VARCHAR(20),
    subject         VARCHAR(20));

CREATE TABLE Publisher(
    publisherName       VARCHAR(20) NOT NULL,
    publisherAddress    VARCHAR(40),
    publisherPhone      VARCHAR(20),
    publisherEmail      VARCHAR(30));

ALTER TABLE WritingGroup
    ADD CONSTRAINT WritingGroup_pk
    PRIMARY KEY (groupName);

ALTER TABLE Publisher
    ADD CONSTRAINT Publisher_pk
    PRIMARY KEY (publisherName);

CREATE TABLE Books(
    groupName           VARCHAR(20) NOT NULL,
    bookTitle           VARCHAR(30) NOT NULL,
    publisherName       VARCHAR(20) NOT NULL,
    yearPublished       VARCHAR(4),
    numberPages         VARCHAR(4));

ALTER TABLE Books
    ADD CONSTRAINT Books_pk
    PRIMARY KEY (groupName, bookTitle);

ALTER TABLE Books
    ADD CONSTRAINT Book_WritingGroup_fk
    FOREIGN KEY (groupName)
    REFERENCES WritingGroup(groupName);

ALTER TABLE Books
    ADD CONSTRAINT Book_Publisher_fk
    FOREIGN KEY (publisherName)
    REFERENCES Publisher(publisherName);

INSERT INTO WritingGroup (groupName, headWriter, yearFormed, subject) values
    ('PATD', 'Brendon Urie', '2004', 'Mystery'),
    ('Fall Out Boy', 'Patrick Stump', '2001', 'Drama'),
    ('My Chemical Romance', 'Gerard Way', '2001', 'Romance'),
    ('Blink 182', 'Tom DeLonge', '1992', 'Action'),
    ('All American Rejects', 'Tyson Ritter', '1999', 'Mystery'),
    ('Simple Plan', 'Pierre Bouvier', '1999', 'Thriller');

INSERT INTO Publisher (publisherName, publisherAddress, publisherPhone, publisherEmail) values
    ('Fueled By Ramen', '1290 Ave of America', '2127072000', 'privacy@fbr.com'),
    ('Warner Bros.', '3300 Warner Blvd.', '2122754952', 'policy@wmg.com'),
    ('Geffen', '2220 Colorado Ave', '18885837176', 'communications@umusic.com'),
    ( 'Atlantic' , '1635 N Cahuenga Blvd' , '3234660103', 'privacy@atlantic.com'),
    ('DreamWorks', '9268 West 3rd Street', '3102887700', 'privacy@dw.com');

INSERT INTO Books (groupName, bookTitle, publisherName, yearPublished, numberPages) values
    ('Fall Out Boy', 'Infinity on High', 'Fueled By Ramen', '2007', '474'),
    ('My Chemical Romance', 'The Black Parade', 'Warner Bros.', '2006', '515'),
    ('PATD', 'Pretty. Odd.', 'Fueled By Ramen', '2008', '484'),
    ('PATD', 'Death of a Bachelor', 'Fueled By Ramen', '2016', '360'),
    ('Blink 182', 'Enema of the State', 'Geffen', '1999', '351'),
    ('All American Rejects', 'Move Along', 'DreamWorks', '2005', '420'),
    ('All American Rejects', 'Kids in the Street', 'Geffen', '2012', '431'),
    ('Simple Plan', 'Still Not Getting Any...', 'Atlantic', '2004', '442'),
    ('Simple Plan', 'Get Your Heart On!', 'Atlantic', '2011', '374'),
    ('All American Rejects', 'When the World Comes Down', 'Geffen', '2008', '453'),
    ('Blink 182', 'Still Not Getting Any...', 'Atlantic', '2004', '442');

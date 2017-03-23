/**
 *
 * SQL file for the Automotive Repair Shop for CECS 323 Term Project.
 * The tables in this file was constructed based on our class diagrams and relation schemes.
 * After creating our tables, we inserted fictional data that we created to help us generate
 * queries and views.
 * 
 * Author:  Abram Villanueva <abramvillan@gmail.com>, Caren Briones <carenpbriones@gmail.com>
 * Gregory Abellanosa <gregoryabellanosa@gmail.com>, and Ryan Luong <ryanluong911@gmail.com>
 * Created: Nov 29 , 2016
 */

CREATE TABLE customers 
(
    c_id        VARCHAR(10) NOT NULL,
    c_fname     VARCHAR(20) NOT NULL,
    c_lname     VARCHAR(20) NOT NULL,
    c_email     VARCHAR(50) NOT NULL,
    cType       VARCHAR(20) NOT NULL,
    CONSTRAINT pk_customers PRIMARY KEY (c_id)
);

CREATE TABLE vehicles 
(
    c_id            VARCHAR(10)    NOT NULL,
    v_id            VARCHAR(10)    NOT NULL,
    vinNum          VARCHAR(17)    NOT NULL,
    plateNum        VARCHAR(20)    NOT NULL,
    make            VARCHAR(20)    NOT NULL,
    mileage         INTEGER        NOT NULL,
    model           VARCHAR(20)    NOT NULL,
    color           VARCHAR(40)    NOT NULL,
    yearMade        INTEGER        NOT NULL,
    serviceFreq     VARCHAR(30),
    numOfAccidents  INTEGER,
    CONSTRAINT pk_vehicles PRIMARY KEY (c_id, v_id),
    CONSTRAINT vehicles_customers_fk FOREIGN KEY (c_id) REFERENCES customers (c_id)
);

CREATE TABLE employees
(
    e_id          VARCHAR(10) NOT NULL,
    efname        VARCHAR(20) NOT NULL,
    elname        VARCHAR(20) NOT NULL,
    eEmail        VARCHAR(50) NOT NULL,
    workPhone     VARCHAR(20),
    timeContract  VARCHAR(50),
    salary        VARCHAR(20),
    CONSTRAINT pk_employees PRIMARY KEY (e_id) 
);

CREATE TABLE addresses
(
    c_id        VARCHAR(10) NOT NULL,
    addr_id     VARCHAR(10) NOT NULL,
    addrType    VARCHAR(10) NOT NULL,
    street      VARCHAR(40) NOT NULL,
    city        VARCHAR(20) NOT NULL,
    state       VARCHAR(20) NOT NULL,
    zipCode     VARCHAR(20) NOT NULL,
    CONSTRAINT pk_addresses PRIMARY KEY (c_id, addr_id),
    CONSTRAINT addresses_customers_fk FOREIGN KEY (c_id) REFERENCES customers (c_id)
);

CREATE TABLE phones
(
    c_id      VARCHAR(10)  NOT NULL,
    phoneType VARCHAR(10)  NOT NULL,
    phoneNum  VARCHAR(20)  NOT NULL,
    CONSTRAINT pk_phones PRIMARY KEY (c_id, phoneNum),
    CONSTRAINT phones_customers_fk FOREIGN KEY (c_id) REFERENCES customers (c_id)
);

CREATE TABLE prospective_c
(
    c_id           VARCHAR(10)  NOT NULL,
    referralDate   DATE,
    CONSTRAINT pk_prospective_c PRIMARY KEY (c_id),
    CONSTRAINT prospectivec_customers_fk FOREIGN KEY (c_id) REFERENCES customers (c_id)
);

CREATE TABLE existing_c
(
    c_id      VARCHAR(10)  NOT NULL,
    joinDate  DATE         NOT NULL,
    CONSTRAINT pk_existing_c PRIMARY KEY (c_id),
    CONSTRAINT existingc_customers_fk FOREIGN KEY (c_id) REFERENCES customers (c_id)
);

CREATE TABLE premier_c
(
    c_id            VARCHAR(10)     NOT NULL,
    CONSTRAINT pk_premier_c PRIMARY KEY (c_id),
    CONSTRAINT premierc_existingc_fk FOREIGN KEY (c_id) REFERENCES existing_c (c_id)
);

CREATE TABLE steady_c
(
    c_id            VARCHAR(10) NOT NULL,
    lastVisit       VARCHAR(20),
    CONSTRAINT pk_steady_c PRIMARY KEY (c_id),
    CONSTRAINT steadyc_existingc_fk FOREIGN KEY (c_id) REFERENCES existing_c (c_id)
);

CREATE TABLE referral_c
(
    proC_id        VARCHAR(10) NOT NULL,
    sc_id          VARCHAR(10) NOT NULL,
    CONSTRAINT pk_referralContacts PRIMARY KEY (proC_id, sc_id),
    CONSTRAINT referralc_prospectivec_fk FOREIGN KEY (proC_id) REFERENCES prospective_c (c_id),
    CONSTRAINT referralc_steadyc_fk FOREIGN KEY (sc_id) REFERENCES steady_c (c_id)
);

CREATE TABLE specials 
(
    s_id           VARCHAR(10)   NOT NULL,
    discountRate   DECIMAL(2,2)  NOT NULL,
    CONSTRAINT pk_specials PRIMARY KEY (s_id)
);

CREATE TABLE offers
(
    proC_id        VARCHAR(10)  NOT NULL,
    s_id           VARCHAR(10)  NOT NULL,
    offer          VARCHAR(20)  NOT NULL,
    contactDate    DATE         NOT NULL,
    expirationDate DATE         NOT NULL,
    CONSTRAINT pk_offers PRIMARY KEY (proC_id, s_id),
    CONSTRAINT offers_prospectivec_fk FOREIGN KEY (proC_id) REFERENCES prospective_c (c_id),
    CONSTRAINT offers_specials_fk FOREIGN KEY (s_id) REFERENCES specials (s_id)
);

CREATE TABLE monthlyInstallments
(
    c_id              VARCHAR(10)       NOT NULL,
    v_id              VARCHAR(10)       NOT NULL,
    preC_id           VARCHAR(10)       NOT NULL,
    monthStarted      VARCHAR(15)       NOT NULL,
    amountDue         DECIMAL(15,2)     NOT NULL,
    CONSTRAINT pk_monthlyInstallments PRIMARY KEY (c_id, v_id, preC_id),
    CONSTRAINT monthlyInstallments_vehicles_fk FOREIGN KEY (c_id, v_id) REFERENCES vehicles (c_id, v_id),
    CONSTRAINT monthlyInstallments_premierc_fk FOREIGN KEY (preC_id) REFERENCES premier_c (c_id)
);

CREATE TABLE notifications
(
    c_id            VARCHAR(10)    NOT NULL,
    v_id            VARCHAR(10)    NOT NULL,
    sc_id           VARCHAR(10)    NOT NULL,
    emailDate       DATE           NOT NULL,
    CONSTRAINT pk_notifications PRIMARY KEY (c_id, v_id, sc_id, emailDate),
    CONSTRAINT notifications_steadyc_fk FOREIGN KEY (sc_id) REFERENCES steady_c (c_id),
    CONSTRAINT notifications_vehicles_FK FOREIGN KEY (c_id, v_id) REFERENCES vehicles (c_id, v_id)
);

CREATE TABLE serviceTechnicians
(
    st_id                  VARCHAR(10)     NOT NULL,
    consultationOffice     VARCHAR(10),
    CONSTRAINT pk_serviceTechnicians PRIMARY KEY (st_id),
    CONSTRAINT serviceTechnicians_employees_fk FOREIGN KEY (st_id) REFERENCES employees (e_id)
);


CREATE TABLE mechanics
(
    mech_id     VARCHAR(10)    NOT NULL,
    station     VARCHAR(20)    NOT NULL,
    CONSTRAINT pk_mechanics PRIMARY KEY (mech_id),
    CONSTRAINT mechanics_employees_fk FOREIGN KEY (mech_id) REFERENCES employees (e_id)
);

CREATE TABLE certifications
(
    cert_id     VARCHAR(10)     NOT NULL,
    certName    VARCHAR(50)     NOT NULL,
    CONSTRAINT pk_certifications PRIMARY KEY (cert_id)
);

CREATE TABLE mechanicCertifications
(
    cert_id         VARCHAR(10)     NOT NULL,
    mech_id         VARCHAR(10)     NOT NULL,
    dateReceived    VARCHAR(20),
    CONSTRAINT pk_mechanicCertifications PRIMARY KEY (cert_id, mech_id),
    CONSTRAINT mechanicCertifications_mechanics_fk FOREIGN KEY (mech_id) REFERENCES mechanics (mech_id),
    CONSTRAINT mechanicCertifications_certifications_fk FOREIGN KEY (cert_id) REFERENCES certifications (cert_id)
);

CREATE TABLE skills
(
    mech_id     VARCHAR(10)  NOT NULL,
    skillName   VARCHAR(50)  NOT NULL,
    CONSTRAINT pk_skills PRIMARY KEY (mech_id, skillName),
    CONSTRAINT skills_mechanics_fk FOREIGN KEY (mech_id) REFERENCES mechanics (mech_id)
);

CREATE TABLE mentorships
(
    mentee_eid        VARCHAR(10)     NOT NULL,
    mentor_eid        VARCHAR(10)     NOT NULL,
    startDate         DATE            NOT NULL,
    endDate           DATE,
    CONSTRAINT pk_mentorships PRIMARY KEY (mentee_eid, mentor_eid, startDate),
    CONSTRAINT mentorships_mentees_fk FOREIGN KEY (mentee_eid) REFERENCES mechanics (mech_id),
    CONSTRAINT mentorships_mentors_fk FOREIGN KEY (mentor_eid) REFERENCES mechanics (mech_id)
);

CREATE TABLE skillsLearned
(
    mentee_eid     VARCHAR(10)  NOT NULL,
    mentor_eid     VARCHAR(10)  NOT NULL,
    startDate      DATE         NOT NULL,
    skillName      VARCHAR(50)  NOT NULL,
    CONSTRAINT pk_skillsLearned PRIMARY KEY (mentee_eid, mentor_eid, startDate, skillName),
    CONSTRAINT skillsLearned_mentorships_fk FOREIGN KEY (mentee_eid, mentor_eid, startDate) REFERENCES mentorships (mentee_eid, mentor_eid, startDate)
);

CREATE TABLE appointments
(
    app_id      VARCHAR(10)  NOT NULL,
    c_id        VARCHAR(10)  NOT NULL,
    v_id        VARCHAR(10)  NOT NULL,
    visitDate   DATE         NOT NULL,
    CONSTRAINT pk_appointments PRIMARY KEY (c_id, v_id, app_id),
    CONSTRAINT appointments_fk FOREIGN KEY (c_id, v_id) REFERENCES vehicles (c_id, v_id)
);

CREATE TABLE maintenanceOrders
(
    app_id       VARCHAR(10)      NOT NULL,
    c_id         VARCHAR(10)      NOT NULL,
    v_id         VARCHAR(10)      NOT NULL,
    mo_id        VARCHAR(10)      NOT NULL,
    st_id        VARCHAR(10)      NOT NULL,
    CONSTRAINT pk_maintenanceOrders PRIMARY KEY (c_id, v_id, app_id, st_id, mo_id),
    CONSTRAINT maintenanceOrders_appointment_fk FOREIGN KEY (c_id, v_id, app_id) REFERENCES appointments (c_id, v_id, app_id),
    CONSTRAINT maintenanceOrders_serviceTechnicians_fk FOREIGN KEY (st_id) REFERENCES serviceTechnicians (st_id)
);


CREATE TABLE maintenancePackages
(
    mp_id       VARCHAR(10) NOT NULL,
    packageName VARCHAR(50) NOT NULL,
    CONSTRAINT pk_maintenancePackage PRIMARY KEY (mp_id)
);

CREATE TABLE maintenanceItems
(
    mi_id       VARCHAR(10) NOT NULL,
    app_id      VARCHAR(10) NOT NULL,
    c_id        VARCHAR(10) NOT NULL,
    v_id        VARCHAR(10) NOT NULL,
    mo_id       VARCHAR(10) NOT NULL,
    mp_id       VARCHAR(10) NOT NULL,
    st_id       VARCHAR(10) NOT NULL,
    repairName  VARCHAR(50) NOT NULL,
    price       DECIMAL(5, 2) NOT NULL,
    CONSTRAINT pk_maintenanceItems PRIMARY KEY (mi_id, app_id, c_id, v_id, mo_id, mp_id, st_id),
    CONSTRAINT maintenanceItems_maintenanceOrders_fk FOREIGN KEY (c_id, v_id, app_id, st_id, mo_id) REFERENCES maintenanceOrders (c_id, v_id, app_id, st_id, mo_id),
    CONSTRAINT maintenanceItems_maintenancePackages_fk FOREIGN KEY (mp_id) REFERENCES maintenancePackages (mp_id)
);

CREATE TABLE assignments
(
    mi_id            VARCHAR(10) NOT NULL,
    app_id           VARCHAR(10) NOT NULL,
    c_id             VARCHAR(10) NOT NULL,
    v_id             VARCHAR(10) NOT NULL,
    mo_id            VARCHAR(10) NOT NULL,
    mp_id            VARCHAR(10) NOT NULL,
    st_id            VARCHAR(10) NOT NULL,
    mech_id          VARCHAR(10) NOT NULL,
    assignmentDate   DATE        NOT NULL,
    CONSTRAINT pk_assignments PRIMARY KEY (app_id, mi_id, c_id, v_id, mo_id, st_id, mp_id, mech_id),
    CONSTRAINT assignments_maintenanceItems_fk FOREIGN KEY (mi_id, app_id, c_id, v_id, mo_id, mp_id, st_id) REFERENCES maintenanceItems (mi_id, app_id, c_id, v_id, mo_id, mp_id, st_id),
    CONSTRAINT assignments_mechanics_fk FOREIGN KEY (mech_id) REFERENCES mechanics (mech_id)
);

CREATE TABLE skills_needed
(
    mi_id     VARCHAR(10) NOT NULL,
    app_id    VARCHAR(10) NOT NULL,
    c_id      VARCHAR(10) NOT NULL,
    v_id      VARCHAR(10) NOT NULL,
    mo_id     VARCHAR(10) NOT NULL,
    st_id     VARCHAR(10) NOT NULL,
    mp_id     VARCHAR(10) NOT NULL,
    skillName VARCHAR(50) NOT NULL,
    CONSTRAINT pk_skills_needed PRIMARY KEY (mi_id, app_id, c_id, v_id, mo_id, st_id, mp_id, skillName),
    CONSTRAINT skillsneeded_maintenanceItems_fk FOREIGN KEY (mi_id, app_id, c_id, v_id, mo_id, mp_id, st_id) REFERENCES maintenanceItems (mi_id, app_id, c_id, v_id, mo_id, mp_id, st_id)
);

INSERT INTO customers (c_id, c_fname, c_lname, c_email, cType) VALUES
    ('0URKY', 'Gergory', 'Abellanosa', 'gergoryabellanosa@gmail.com', 'private'),
    ('0RLU1', 'Caren', 'Rionesbay', 'carenprionesbay@gmail.com', 'private'),
    ('0QPG7', 'Ablam', 'Villanueva', 'ablamvillan00@thebobatruck.com', 'company'),
    ('0Q5EO', 'Ryan', 'Luong', 'ryanluong411@gmail.com', 'private'),
    ('0FM12', 'Aiko', 'Doggo', 'aikoruffsyou@flyingbathtub.com', 'company'),
    ('0JK90', 'Fate', 'Yap', 'fy@safelink.com', 'company'),
    ('07FR3', 'Duke', 'Borks', 'dukeborks@ruffmail.com', 'private'),
    ('0L56H', 'Bruno', 'Rionesbay', 'brunomars@dogmail.com', 'private'),
    ('0P75G', 'Soulja', 'Boy', 'crankdat@youuuuu.com', 'private'),
    ('0LD4F', 'Drake', 'Grahm', 'jimmybrooks@degrassi.edu', 'private'),
    ('0IK3G', 'Lobelt', 'Rim', 'robert.lim@hotkoala.com', 'private'),
    ('0IK3Y', 'Hyorin', 'Trouble', 'doubletroublemakerhyuna@hotmail.com', 'private');

INSERT INTO addresses (c_id, addr_id, addrType, street, city, state, zipCode) VALUES
    ('0URKY', 'AJG8', 'home', '1248 Binary Ave', 'Boolia', 'CA', '97061'),              
    ('0RLU1', 'AMG9', 'home', '87601 Bae Blvd', 'San Fransokyo', 'CA', '97234'),        
    ('0QPG7', 'AJQE', 'home', '7834 Hamaro St', 'Big Pakka', 'CA', '98451'),            
    ('0Q5EO', 'AE5V', 'work', '3487 Crystal Cove Ave', 'Luong Beach', 'CA', '98732'),   
    ('0FM12', 'AEU2', 'work', '99879 Ceasar St', 'Tails Gate', 'NV', '75483'),          
    ('0JK90', 'AW47', 'home', '7838 Piero St', 'Big Pakka', 'CA', '98541'),             
    ('07FR3', 'AHWX', 'work', '2232 Bitt Ave', 'San Fransokyo', 'CA', '97061'),         
    ('0L56H', 'A3A6', 'home', '87601 Bae Blvd', 'San Fransokyo', 'CA', '97234'),        
    ('0P75G', 'AR2F', 'home', '4455 Wave Ave', 'Luong Beach', 'CA', '98732'),           
    ('0LD4F', 'AT62', 'home', '9567 Poonai Blvd', 'Big Pakka', 'CA', '98541'),          
    ('0IK3G', 'AVHN', 'home', '3476 Compy St', 'Boolia', 'CA', '97061'),                
    ('0IK3Y', 'A4T6', 'home', '3787 Mayonaka Ave', 'Big Pakka', 'CA', '98541');      

INSERT INTO phones (c_id, phoneType, phoneNum) VALUES
    ('0URKY', 'cell', '5622191769'), 
    ('0RLU1', 'cell', '8188188118'), 
    ('0QPG7', 'cell', '5622655626'), 
    ('0Q5EO', 'cell', '8188188118'), 
    ('0FM12', 'work', '8008888888'), 
    ('0JK90', 'cell', '8188188118'), 
    ('07FR3', 'cell', '5627459822'), 
    ('0L56H', 'cell', '8184577623'), 
    ('0P75G', 'cell', '6789998212'), 
    ('0LD4F', 'cell', '8004685462'), 
    ('0IK3G', 'cell', '3234572389'), 
    ('0IK3Y', 'cell', '6261234567'); 

INSERT INTO prospective_c (c_id, referralDate) VALUES
    ('07FR3', '2016-02-05'),
    ('0JK90', '2016-03-04'),
    ('0IK3Y', '2016-04-15');

INSERT INTO existing_c (c_id, joinDate) VALUES
    ('0URKY', '2015-12-21'),
    ('0RLU1', '2013-01-10'),
    ('0QPG7', '2016-01-05'),
    ('0Q5EO', '2016-05-28'),
    ('0FM12', '2014-11-14'),
    ('0L56H', '2015-06-07'),
    ('0P75G', '2015-12-01'),
    ('0LD4F', '2015-08-08'),
    ('0IK3G', '2016-08-08');

INSERT INTO steady_c (c_id, lastVisit) VALUES
    ('0URKY', '2016-01-13'),
    ('0QPG7', '2016-04-15'),
    ('0P75G', '2016-01-05'),
    ('0Q5EO', '2016-08-19'),
    ('0LD4F', '2016-04-08'),
    ('0IK3G', '2016-09-11');

INSERT INTO premier_c (c_id) VALUES
    ('0RLU1'),
    ('0FM12'),
    ('0L56H');

INSERT INTO employees (e_id, efname, elname, eEmail, workPhone, timeContract, salary) VALUES
    ('0074WA', 'Bob', 'Builder', 'bobthebuilder@hotwheels.com', '2025550190', 'part time both', '50000'),
    ('004X7E', 'Haffi', 'Work', 'haffiworkx5@hotwheels.com', '2025550167', 'part time both', '45000'),
    ('0022TK', 'Lightning', 'McQueen', 'lmcqueen@hotwheels.com', '2025550103', 'full time service technician', '59500'),
    ('002IR0', 'Herbie', 'Volks', 'hvolks@hotwheels.com', '2025551119', 'part time service technician', '34000'),
    ('00O0QT', 'Lindsay', 'Lohannon', 'llohannon@hotwheels.com', '2025557896', 'part time mechanic', '20000'),
    ('00B21W', 'Dominic', 'Torretto', 'dom@hotwheels.com', '2025555710', 'full time mechanic', '57000'),
    ('0097N2', 'Paul', 'Walker', 'seeyouagain@hotwheels', '2025551129', 'full time mechanic', '47000'),
    ('00JNKS', 'Letty', 'Rodriguez', 'letty@hotwheels.com', '2025550098', 'full time mechanic', '50050'),
    ('00V5KL', 'Mater', 'Rusty', 'matertrucks@gmail.com', '2025551234', 'full time mechanic', '49710'),
    ('00RYVF', 'Doc', 'Hudson', 'docodoc@hotwheels.com', '2025556709', 'full time mechanic', '51000'),
    ('00Q3HU', 'Suki', 'Suki', 'suki2@gmail.com', '2025558711', 'part time both', '45060'),
    ('00UT75', 'Nich', 'Dich', 'ditchnich@hotwheels.com', '2025550901', 'part time service technician', '20100');

INSERT INTO serviceTechnicians (st_id, consultationOffice) VALUES
    ('0074WA', '100'),
    ('004X7E', '102'),
    ('0022TK', '104'),
    ('002IR0', '106'),
    ('00Q3HU', '108'),
    ('00UT75', '110');

INSERT INTO mechanics (mech_id, station) VALUES
    ('0074WA', '1'), 
    ('004X7E', '2'), 
    ('00O0QT', '3'), 
    ('00B21W', '4'), 
    ('0097N2', '5'), 
    ('00JNKS', '6'), 
    ('00V5KL', '7'),  
    ('00RYVF', '8'), 
    ('00Q3HU', '9'); 

INSERT INTO certifications (cert_id, certName) VALUES
    ('CERT001', 'A1 Engine Repair'), 
    ('CERT002', 'A2 Automatic Transmission/Transaxle'),
    ('CERT003', 'A3 Manual Drive Train and Axles'),
    ('CERT004', 'A4 Suspension and Steering'),
    ('CERT005', 'A5 Brakes'),
    ('CERT006', 'A6 Electrical/Electronic Systems'),
    ('CERT007', 'A7 Heating and Air Conditioning'),
    ('CERT008', 'A8 Engine Performance');

INSERT INTO mechanicCertifications (cert_id, mech_id, dateReceived) VALUES
    ('CERT001', '0074WA', '1985-08-23'),
    ('CERT002', '0074WA', '1987-01-03'),
    ('CERT003', '0074WA', '1989-02-19'),
    ('CERT004', '0074WA', '1989-07-05'),
    ('CERT005', '0074WA', '1998-09-04'),
    ('CERT006', '0074WA', '2002-01-02'),
    ('CERT008', '0074WA', '2010-04-09'),
    ('CERT001', '004X7E', '1980-04-01'),
    ('CERT005', '004X7E', '1981-07-20'),
    ('CERT007', '004X7E', '1994-06-24'),
    ('CERT001', '00O0QT', '1997-11-04'),
    ('CERT004', '00O0QT', '2005-09-11'),
    ('CERT005', '00O0QT', '2007-03-16'),
    ('CERT007', '00O0QT', '2012-11-05'),
    ('CERT001', '00B21W', '1983-09-03'),
    ('CERT004', '00B21W', '1984-10-05'),
    ('CERT005', '00B21W', '1986-08-17'),
    ('CERT006', '00B21W', '1994-12-18'),
    ('CERT007', '00B21W', '1989-09-29'),
    ('CERT008', '00B21W', '2009-04-25'),
    ('CERT001', '0097N2', '1996-07-09'),
    ('CERT005', '0097N2', '2002-10-23'),
    ('CERT006', '0097N2', '1980-09-09'),
    ('CERT001', '00JNKS', '2000-04-23'),
    ('CERT002', '00JNKS', '2002-08-23'),
    ('CERT003', '00JNKS', '2008-01-23'),
    ('CERT004', '00JNKS', '1965-11-28'),
    ('CERT005', '00JNKS', '1998-05-30'),
    ('CERT008', '00JNKS', '2014-06-28'),
    ('CERT001', '00V5KL', '1969-12-21'),
    ('CERT004', '00V5KL', '1971-11-21'),
    ('CERT006', '00V5KL', '1975-06-23'),
    ('CERT008', '00V5KL', '1975-12-29'),
    ('CERT002', '00RYVF', '1995-06-01'),
    ('CERT003', '00RYVF', '2006-04-27'),
    ('CERT004', '00RYVF', '2008-04-08'),
    ('CERT006', '00RYVF', '2012-10-10'),
    ('CERT002', '00Q3HU', '1997-06-21'),
    ('CERT003', '00Q3HU', '2003-05-17'),
    ('CERT004', '00Q3HU', '1996-05-17');

INSERT INTO skills (mech_id, skillName) VALUES 
    ('0074WA', 'change oil'),
    ('0074WA', 'change tires'),
    ('0074WA', 'align tires'),
    ('0074WA', 'replace spark plugs'),
    ('0074WA', 'replace brake fluid'),
    ('0074WA', 'replace ignition wires'),
    ('0074WA', 'replace transmission fluid'),
    ('0074WA', 'replace propeller shaft'),
    ('0074WA', 'inspect battery'),
    ('004X7E', 'change oil'),
    ('004X7E', 'change tires'),
    ('004X7E', 'align tires'),
    ('004X7E', 'replace spark plugs'),
    ('004X7E', 'replace brake fluid'),
    ('00O0QT', 'change oil'),
    ('00O0QT', 'change tires'),
    ('00O0QT', 'align tires'),
    ('00O0QT', 'inspect brakes'),
    ('00O0QT', 'replace brake fluid'),
    ('00O0QT', 'replace brake pads'),
    ('00O0QT', 'replace light bulbs'),
    ('00O0QT', 'replace battery'),
    ('00B21W', 'change oil'),
    ('00B21W', 'change tires'),
    ('00B21W', 'align tires'),
    ('00B21W', 'replace brake pads'),
    ('00B21W', 'inspect brakes'),
    ('00B21W', 'replace light bulbs'),
    ('00B21W', 'replace ignition wires'),
    ('00B21W', 'inspect smog'),
    ('0097N2', 'change oil'),
    ('0097N2', 'change tires'),
    ('0097N2', 'align tires'),
    ('0097N2', 'replace light bulbs'),
    ('0097N2', 'replace ignition wires'),
    ('0097N2', 'replace catalytic converter'),
    ('0097N2', 'inspect battery'),
    ('0097N2', 'replace battery'),
    ('0097N2', 'inspect brakes'),
    ('00JNKS', 'change oil'),
    ('00JNKS', 'change tires'),
    ('00JNKS', 'align tires'),
    ('00JNKS', 'replace catalytic converter'),
    ('00JNKS', 'replace transmission fluid'),
    ('00JNKS', 'inspect smog'),
    ('00JNKS', 'inspect brakes'),
    ('00V5KL', 'change oil'),
    ('00V5KL', 'change tires'),
    ('00V5KL', 'align tires'),
    ('00V5KL', 'replace transmission fluid'),
    ('00V5KL', 'inspect smog'),
    ('00V5KL', 'inspect battery'),
    ('00RYVF', 'change oil'),
    ('00RYVF', 'change tires'),
    ('00RYVF', 'align tires'),
    ('00RYVF', 'replace light bulbs'),
    ('00RYVF', 'replace ignition wires'),
    ('00RYVF', 'replace battery'),
    ('00Q3HU', 'change oil'),
    ('00Q3HU', 'align tires');

INSERT INTO mentorships (mentee_eid, mentor_eid, startDate, endDate) VALUES
    ('0074WA', '00Q3HU', '2015-04-09', '2015-07-17'),
    ('0074WA', '00Q3HU', '2015-06-17', '2015-09-15'),
    ('0097N2', '00JNKS', '2015-07-20', '2015-11-25'),
    ('004X7E', '00O0QT', '2015-10-01', '2016-02-25'),
    ('0097N2', '00RYVF', '2016-09-18', '2016-12-04'),
    ('0097N2', '00RYVF', '2016-12-05', NULL);

INSERT INTO skillsLearned (mentee_eid, mentor_eid, startDate, skillName) VALUES
    ('0074WA', '00Q3HU', '2015-04-09', 'change oil'),
    ('0074WA', '00Q3HU', '2015-06-17', 'align tires'),
    ('0097N2', '00JNKS', '2015-07-20', 'replace catalytic converter'),
    ('004X7E', '00O0QT', '2015-10-01', 'replace brake fluid'),
    ('0097N2', '00RYVF', '2016-09-18', 'change tires');

INSERT INTO vehicles (c_id, v_id, vinNum, plateNum, make, mileage, model, color, yearMade, serviceFreq, numOfAccidents) VALUES
    ('0URKY', 'V30S7', '1HGFA16808LL01292', '6KAY876', 'Honda', 106972, 'Civic', 'Cosmic Blue Metallic', 2008, '10000', 0),
    ('0URKY', 'V0T3A', 'I5L3OP04JFMNT85J6', '4OOD713', 'Toyota', 163215, 'Prius', 'Sea Glass Pearl', 2008, '15000', 0),
    ('0RLU1', 'VYYPG', '1HGCT2B83FA000162', '9BYM093', 'Honda', 14639, 'Accord', 'San Marino Red', 2015, '20000', 0),
    ('0RLU1', 'VZENX', '48GH529DJRIEMG04J', '5UED833', 'Hyundai', 45213, 'Santa Fe', 'Juniper Green', 2014, '20000', 0),
    ('0QPG7', 'VKWMP', '4T1BE32K95U637166', '4VEI922', 'Toyota', 156972, 'Camry', 'Lunar Mist Metallic', 2005, '15000', 2),
    ('0Q5EO', 'V7ZXT', 'JF4K3ODLR5MT0GLT6', '30T70U3', 'Ford', 163492, 'Transit', 'Oxford White', 2008, '14000', 0),
    ('0FM12', 'V53JY', 'MG01LD5M4KRL5OT98', '94B472', 'Ford', 63851, 'Focus', 'Ingot Silver', 2013, '19000', 1),
    ('0JK90', 'V86A0', 'SF4914J596KGJQ91J', 'DQNF178', 'Honda', 249850, 'Odyssey', 'White', 1999, '10000', 0),
    ('07FR3', 'V0005', 'FMDL2K39FJ5UTIGHJ', '7A00005', 'Mazda', 75699, 'RX-8', 'Brilliant Black', 2011, '15000', 1),
    ('0L56H', 'VT479', 'MLP104JR7FH5MGJSI', 'T4793KV', 'Scion', 146690, 'TC', 'Flint Mica', 2008, '19000', 0),
    ('0P75G', 'V3KVQ', 'ZMXI34K5K4M5KF0PT', 'QF24I25', 'Mazda', 189913, '3', 'Meteor Gray Mica', 2008, '19000', 0),
    ('0P75G', 'VF421', 'PEPE4C0LT1LEP4O95', 'FM0A1RA', 'Mercedes', 38551, 'GLA', 'Night Black', 2014, '20000', 4),
    ('0LD4F', 'V25EM', 'P34M5FCLO394JF8XJ', 'QP8V8Y1', 'Nissan', 14990, '350z', 'Le Mans Sunset', 2007, '18000', 0),
    ('0IK3G', 'V091R', '3M5LF02KJR749DMFU', 'J194HFV', 'Acura', 32970, 'Tsx', 'Premium White Pearl', 2014, '20000', 0),
    ('0IK3Y', 'VRLIR', 'LF02LPORM4JFAMWIF', '55GIKFW', 'Mercedes', 300957, 'C 200', 'Polar White', 1997, '10000', 2);

INSERT INTO appointments (app_id, c_id, v_id, visitDate) VALUES 
    ('APP0010', '0URKY', 'V30S7', '2015-12-21'),
    ('APP0016', '0URKY', 'V30S7', '2016-03-10'),
    ('APP0019', '0URKY', 'V0T3A', '2016-05-11'),
    ('APP0013', '0RLU1', 'VYYPG', '2016-01-10'),
    ('APP0001', '0RLU1', 'VZENX', '2013-03-05'),
    ('APP0012', '0QPG7', 'VKWMP', '2016-01-05'),
    ('APP0018', '0QPG7', 'VKWMP', '2016-04-13'),
    ('APP0020', '0Q5EO', 'V7ZXT', '2016-05-28'),
    ('APP0022', '0Q5EO', 'V7ZXT', '2016-07-09'),
    ('APP0024', '0Q5EO', 'V7ZXT', '2016-08-17'),
    ('APP0002', '0FM12', 'V53JY', '2014-11-14'),
    ('APP0003', '0FM12', 'V53JY', '2015-04-08'),
    ('APP0004', '0FM12', 'V53JY', '2015-05-05'),
    ('APP0005', '0L56H', 'VT479', '2015-06-07'),
    ('APP0008', '0L56H', 'VT479', '2015-12-12'),
    ('APP0007', '0P75G', 'V3KVQ', '2015-12-01'),
    ('APP0011', '0P75G', 'VF421', '2016-01-01'),
    ('APP0006', '0LD4F', 'V25EM', '2015-08-08'),
    ('APP0009', '0LD4F', 'V25EM', '2015-12-13'),
    ('APP0014', '0LD4F', 'V25EM', '2016-02-09'),
    ('APP0017', '0LD4F', 'V25EM', '2016-04-06'),
    ('APP0023', '0IK3G', 'V091R', '2016-08-08'),
    ('APP0026', '0IK3G', 'V091R', '2016-09-09'),
    ('APP0025', '07FR3', 'V0005', '2016-09-01'),
    ('APP0015', '0JK90', 'V86A0', '2016-03-08'),
    ('APP0021', '0IK3Y', 'VRLIR', '2016-06-09');

INSERT INTO maintenanceOrders (app_id, c_id, v_id, mo_id, st_id) VALUES 
    ('APP0010', '0URKY', 'V30S7', 'MO0010', '0074WA'),
    ('APP0016', '0URKY', 'V30S7', 'MO0016', '0074WA'),
    ('APP0019', '0URKY', 'V0T3A', 'MO0019', '0074WA'),
    ('APP0013', '0RLU1', 'VYYPG', 'MO0013', '0022TK'),
    ('APP0001', '0RLU1', 'VZENX', 'MO0001', '0022TK'),
    ('APP0012', '0QPG7', 'VKWMP', 'MO0012', '004X7E'),
    ('APP0018', '0QPG7', 'VKWMP', 'MO0018', '00UT75'),
    ('APP0020', '0Q5EO', 'V7ZXT', 'MO0020', '00Q3HU'),
    ('APP0022', '0Q5EO', 'V7ZXT', 'MO0022', '00Q3HU'),
    ('APP0024', '0Q5EO', 'V7ZXT', 'MO0024', '002IR0'),
    ('APP0002', '0FM12', 'V53JY', 'MO0002', '00UT75'),
    ('APP0003', '0FM12', 'V53JY', 'MO0003', '00UT75'),
    ('APP0004', '0FM12', 'V53JY', 'MO0004', '0074WA'),
    ('APP0005', '0L56H', 'VT479', 'MO0005', '0074WA'),
    ('APP0008', '0L56H', 'VT479', 'MO0008', '002IR0'),
    ('APP0007', '0P75G', 'V3KVQ', 'MO0007', '004X7E'),
    ('APP0011', '0P75G', 'VF421', 'MO0011', '00Q3HU'),
    ('APP0006', '0LD4F', 'V25EM', 'MO0006', '0022TK'),
    ('APP0009', '0LD4F', 'V25EM', 'MO0009', '0022TK'),
    ('APP0014', '0LD4F', 'V25EM', 'MO0014', '0022TK'),
    ('APP0017', '0LD4F', 'V25EM', 'MO0017', '00UT75'),
    ('APP0023', '0IK3G', 'V091R', 'MO0023', '002IR0'),
    ('APP0026', '0IK3G', 'V091R', 'MO0026', '002IR0');

INSERT INTO maintenancePackages (mp_id, packageName) VALUES
    ('000', 'not a package'),
    ('001', 'Tired of Tires'), 
    ('010', 'Simple Changes'), 
    ('011', 'Brake Up'),       
    ('100', 'Brakes & Tires'),
    ('101', 'Oil & Catalytic Converter');  


INSERT INTO maintenanceItems (mi_id, app_id, c_id, v_id, mo_id, mp_id, st_id, repairName, price) VALUES
    ('MI2Z', 'APP0010', '0URKY', 'V30S7', 'MO0010', '100', '0074WA', 'tire replacement', 200),
    ('MIQL', 'APP0010', '0URKY', 'V30S7', 'MO0010', '100', '0074WA', 'tire alignment', 60),
    ('MIR5', 'APP0010', '0URKY', 'V30S7', 'MO0010', '100', '0074WA', 'brake fluid replacement', 85),
    ('MIZS', 'APP0010', '0URKY', 'V30S7', 'MO0010', '100', '0074WA', 'brake pad replacement', 150),
    ('MI29', 'APP0016', '0URKY', 'V30S7', 'MO0016', '101', '0074WA', 'oil change', 20),
    ('MIXX', 'APP0016', '0URKY', 'V30S7', 'MO0016', '101', '0074WA', 'catalytic converter replacement', 900),
    ('MI4X', 'APP0016', '0URKY', 'V30S7', 'MO0016', '000', '0074WA', 'smog check', 50),
    ('MIOF', 'APP0019', '0URKY', 'V0T3A', 'MO0019', '000', '0074WA', 'spark plugs replacement', 300),
    ('MIXD', 'APP0013', '0RLU1', 'VYYPG', 'MO0013', '010', '0022TK', 'oil change', 20),
    ('MIMV', 'APP0013', '0RLU1', 'VYYPG', 'MO0013', '010', '0022TK', 'tire replacement', 200),
    ('MIJV', 'APP0013', '0RLU1', 'VYYPG', 'MO0013', '010', '0022TK', 'tire alignment', 60),
    ('MILK', 'APP0013', '0RLU1', 'VYYPG', 'MO0013', '010', '0022TK', 'battery replacement', 200),
    ('MILO', 'APP0001', '0RLU1', 'VZENX', 'MO0001', '000', '0022TK', 'spark plugs replacement', 300),
    ('MI6Y', 'APP0012', '0QPG7', 'VKWMP', 'MO0012', '000', '004X7E', 'light bulb replacement', 100),
    ('ML0M', 'APP0012', '0QPG7', 'VKWMP', 'MO0012', '000', '004X7E', 'battery replacement', 200),
    ('MIWR', 'APP0018', '0QPG7', 'VKWMP', 'MO0018', '000', '00UT75', 'transmission fluid replacement', 100),
    ('MIIX', 'APP0022', '0Q5EO', 'V7ZXT', 'MO0022', '011', '00Q3HU', 'brake fluid replacement', 85),
    ('MIEI', 'APP0022', '0Q5EO', 'V7ZXT', 'MO0022', '011', '00Q3HU', 'brake pad replacement', 150),
    ('MIFO', 'APP0024', '0Q5EO', 'V7ZXT', 'MO0024', '000', '002IR0', 'ignition wire replacement', 250),
    ('MAC1', 'APP0024', '0Q5EO', 'V7ZXT', 'MO0024', '000', '002IR0', 'smog check', 50),
    ('MOMY', 'APP0024', '0Q5EO', 'V7ZXT', 'MO0024', '010', '002IR0', 'battery replacement', 200),
    ('MIQ0', 'APP0002', '0FM12', 'V53JY', 'MO0002', '100', '00UT75', 'tire replacement', 200),
    ('MIFG', 'APP0002', '0FM12', 'V53JY', 'MO0002', '100', '00UT75', 'tire alignment', 60),
    ('MIMT', 'APP0002', '0FM12', 'V53JY', 'MO0002', '100', '00UT75', 'brake pad replacement', 150),
    ('MZAC', 'APP0002', '0FM12', 'V53JY', 'MO0002', '100', '00UT75', 'brake fluid replacement', 85),
    ('MIQA', 'APP0003', '0FM12', 'V53JY', 'MO0003', '000', '00UT75', 'oil change', 20),
    ('MICP', 'APP0005', '0L56H', 'VT479', 'MO0005', '100', '0074WA', 'tire replacement', 200),
    ('MIAA', 'APP0005', '0L56H', 'VT479', 'MO0005', '100', '0074WA', 'tire alignment', 60),
    ('MILE', 'APP0005', '0L56H', 'VT479', 'MO0005', '100', '0074WA', 'brake fluid replacement', 85),
    ('MI06', 'APP0005', '0L56H', 'VT479', 'MO0005', '100', '0074WA', 'brake pad replacement', 150),
    ('MI65', 'APP0008', '0L56H', 'VT479', 'MO0008', '000', '002IR0', 'spark plugs replacement', 300),
    ('MI9Y', 'APP0007', '0P75G', 'V3KVQ', 'MO0007', '000', '004X7E', 'transmission fluid replacement', 100),
    ('MITY', 'APP0011', '0P75G', 'VF421', 'MO0011', '101', '00Q3HU', 'oil change', 20),
    ('MIJS', 'APP0011', '0P75G', 'VF421', 'MO0011', '101', '00Q3HU', 'catalytic converter replacement', 900),
    ('MIS3', 'APP0006', '0LD4F', 'V25EM', 'MO0006', '000', '0022TK', 'ignition wire replacement', 250),
    ('MIZ3', 'APP0006', '0LD4F', 'V25EM', 'MO0006', '000', '0022TK', 'smog check', 50),
    ('MI68', 'APP0009', '0LD4F', 'V25EM', 'MO0009', '101', '0022TK', 'oil change', 20),
    ('MI2J', 'APP0009', '0LD4F', 'V25EM', 'MO0009', '101', '0022TK', 'catalytic converter replacement', 900),
    ('MIUO', 'APP0014', '0LD4F', 'V25EM', 'MO0014', '000', '0022TK', 'brake fluid replacement', 85),
    ('MID1', 'APP0017', '0LD4F', 'V25EM', 'MO0017', '000', '00UT75', 'oil change', 20),
    ('MI3H', 'APP0023', '0IK3G', 'V091R', 'MO0023', '010', '002IR0', 'oil change', 20),
    ('MI04', 'APP0023', '0IK3G', 'V091R', 'MO0023', '010', '002IR0', 'tire replacement', 200),
    ('MIDK', 'APP0023', '0IK3G', 'V091R', 'MO0023', '010', '002IR0', 'tire alignment', 60),
    ('MI1S', 'APP0023', '0IK3G', 'V091R', 'MO0023', '010', '002IR0', 'battery replacement', 200),
    ('MIZ8', 'APP0026', '0IK3G', 'V091R', 'MO0026', '000', '002IR0', 'oil change', 20),
    ('MI42', 'APP0020', '0Q5EO', 'V7ZXT', 'MO0020', '000', '00Q3HU', 'catalytic converter replacement', 900),
    ('MILY', 'APP0004', '0FM12', 'V53JY', 'MO0004', '000', '0074WA', 'oil change', 20),
    ('MSAI', 'APP0024', '0Q5EO', 'V7ZXT', 'MO0024', '010', '002IR0', 'tire replacement', 200),
    ('MD6Y', 'APP0024', '0Q5EO', 'V7ZXT', 'MO0024', '010', '002IR0', 'tire alignment', 60),
    ('MDQY', 'APP0024', '0Q5EO', 'V7ZXT', 'MO0024', '010', '002IR0', 'oil change', 20);


INSERT INTO skills_needed (mi_id, app_id, c_id, v_id, mo_id, mp_id, st_id, skillName) VALUES
    ('MI2Z', 'APP0010', '0URKY', 'V30S7', 'MO0010', '100', '0074WA', 'change tires'),
    ('MIQL', 'APP0010', '0URKY', 'V30S7', 'MO0010', '100', '0074WA', 'align tires'),
    ('MIR5', 'APP0010', '0URKY', 'V30S7', 'MO0010', '100', '0074WA', 'inspect brakes'),
    ('MIR5', 'APP0010', '0URKY', 'V30S7', 'MO0010', '100', '0074WA', 'replace brake fluid'),
    ('MIZS', 'APP0010', '0URKY', 'V30S7', 'MO0010', '100', '0074WA', 'inspect brakes'),
    ('MIZS', 'APP0010', '0URKY', 'V30S7', 'MO0010', '100', '0074WA', 'replace brake pads'),
    ('MI29', 'APP0016', '0URKY', 'V30S7', 'MO0016', '101', '0074WA', 'change oil'),
    ('MIXX', 'APP0016', '0URKY', 'V30S7', 'MO0016', '101', '0074WA', 'replace catalytic converter'),
    ('MI4X', 'APP0016', '0URKY', 'V30S7', 'MO0016', '000', '0074WA', 'inspect smog'),
    ('MIOF', 'APP0019', '0URKY', 'V0T3A', 'MO0019', '000', '0074WA','replace spark plugs'),
    ('MIXD', 'APP0013', '0RLU1', 'VYYPG', 'MO0013', '010', '0022TK', 'change oil'),
    ('MIMV', 'APP0013', '0RLU1', 'VYYPG', 'MO0013', '010', '0022TK', 'change tires'),
    ('MIJV', 'APP0013', '0RLU1', 'VYYPG', 'MO0013', '010', '0022TK', 'align tires'),
    ('MILK', 'APP0013', '0RLU1', 'VYYPG', 'MO0013', '010', '0022TK', 'inspect battery'),
    ('MILK', 'APP0013', '0RLU1', 'VYYPG', 'MO0013', '010', '0022TK', 'replace battery'),
    ('MILO', 'APP0001', '0RLU1', 'VZENX', 'MO0001', '000', '0022TK', 'replace spark plugs'),
    ('MI6Y', 'APP0012', '0QPG7', 'VKWMP', 'MO0012', '000', '004X7E', 'replace light bulbs'),
    ('ML0M', 'APP0012', '0QPG7', 'VKWMP', 'MO0012', '000', '004X7E', 'replace battery'),
    ('ML0M', 'APP0012', '0QPG7', 'VKWMP', 'MO0012', '000', '004X7E', 'inspect battery'),
    ('MIWR', 'APP0018', '0QPG7', 'VKWMP', 'MO0018', '000', '00UT75', 'replace transmission fluid'),
    ('MIIX', 'APP0022', '0Q5EO', 'V7ZXT', 'MO0022', '011', '00Q3HU', 'replace brake fluid'),
    ('MIIX', 'APP0022', '0Q5EO', 'V7ZXT', 'MO0022', '011', '00Q3HU', 'inspect brakes'),
    ('MIEI', 'APP0022', '0Q5EO', 'V7ZXT', 'MO0022', '011', '00Q3HU', 'replace brake pads'),
    ('MIEI', 'APP0022', '0Q5EO', 'V7ZXT', 'MO0022', '011', '00Q3HU', 'inspect brakes'),
    ('MIFO', 'APP0024', '0Q5EO', 'V7ZXT', 'MO0024', '000', '002IR0', 'replace ignition wires'),
    ('MAC1', 'APP0024', '0Q5EO', 'V7ZXT', 'MO0024', '000', '002IR0', 'inspect smog'),
    ('MOMY', 'APP0024', '0Q5EO', 'V7ZXT', 'MO0024', '010', '002IR0', 'inspect battery'),
    ('MOMY', 'APP0024', '0Q5EO', 'V7ZXT', 'MO0024', '010', '002IR0', 'replace battery'),
    ('MIQ0', 'APP0002', '0FM12', 'V53JY', 'MO0002', '100', '00UT75', 'change tires'),
    ('MIFG', 'APP0002', '0FM12', 'V53JY', 'MO0002', '100', '00UT75', 'align tires'),
    ('MIMT', 'APP0002', '0FM12', 'V53JY', 'MO0002', '100', '00UT75', 'inspect brakes'),
    ('MIMT', 'APP0002', '0FM12', 'V53JY', 'MO0002', '100', '00UT75', 'replace brake pads'),
    ('MIQA', 'APP0003', '0FM12', 'V53JY', 'MO0003', '000', '00UT75', 'change oil'),
    ('MICP', 'APP0005', '0L56H', 'VT479', 'MO0005', '100', '0074WA', 'change tires'),
    ('MIAA', 'APP0005', '0L56H', 'VT479', 'MO0005', '100', '0074WA', 'align tires'),
    ('MILE', 'APP0005', '0L56H', 'VT479', 'MO0005', '100', '0074WA', 'inspect brakes'),
    ('MILE', 'APP0005', '0L56H', 'VT479', 'MO0005', '100', '0074WA', 'replace brake fluid'),
    ('MI06', 'APP0005', '0L56H', 'VT479', 'MO0005', '100', '0074WA', 'inspect brakes'),
    ('MI06', 'APP0005', '0L56H', 'VT479', 'MO0005', '100', '0074WA', 'replace brake pads'),
    ('MI65', 'APP0008', '0L56H', 'VT479', 'MO0008', '000', '002IR0', 'replace spark plugs'),
    ('MI9Y', 'APP0007', '0P75G', 'V3KVQ', 'MO0007', '000', '004X7E', 'replace transmission fluid'),
    ('MITY', 'APP0011', '0P75G', 'VF421', 'MO0011', '101', '00Q3HU', 'change oil'),
    ('MIJS', 'APP0011', '0P75G', 'VF421', 'MO0011', '101', '00Q3HU', 'replace catalytic converter'),
    ('MIS3', 'APP0006', '0LD4F', 'V25EM', 'MO0006', '000', '0022TK', 'replace ignition wires'),
    ('MIZ3', 'APP0006', '0LD4F', 'V25EM', 'MO0006', '000', '0022TK', 'inspect smog'),
    ('MI68', 'APP0009', '0LD4F', 'V25EM', 'MO0009', '101', '0022TK', 'change oil'),
    ('MI2J', 'APP0009', '0LD4F', 'V25EM', 'MO0009', '101', '0022TK', 'replace catalytic converter'),
    ('MIUO', 'APP0014', '0LD4F', 'V25EM', 'MO0014', '000', '0022TK', 'inspect brakes'),
    ('MIUO', 'APP0014', '0LD4F', 'V25EM', 'MO0014', '000', '0022TK','replace brake fluid'),
    ('MID1', 'APP0017', '0LD4F', 'V25EM', 'MO0017', '000', '00UT75', 'change oil'),
    ('MI3H', 'APP0023', '0IK3G', 'V091R', 'MO0023', '010', '002IR0', 'change oil'),
    ('MI04', 'APP0023', '0IK3G', 'V091R', 'MO0023', '010', '002IR0', 'change tires'),
    ('MIDK', 'APP0023', '0IK3G', 'V091R', 'MO0023', '010', '002IR0', 'align tires'),
    ('MI1S', 'APP0023', '0IK3G', 'V091R', 'MO0023', '010', '002IR0', 'inspect battery' ),
    ('MI1S', 'APP0023', '0IK3G', 'V091R', 'MO0023', '010', '002IR0', 'replace battery'),
    ('MIZ8', 'APP0026', '0IK3G', 'V091R', 'MO0026', '000', '002IR0', 'change oil'),
    ('MI42', 'APP0020', '0Q5EO', 'V7ZXT', 'MO0020', '000', '00Q3HU', 'replace catalytic converter'), 
    ('MILY', 'APP0004', '0FM12', 'V53JY', 'MO0004', '000', '0074WA', 'change oil'),
    ('MSAI', 'APP0024', '0Q5EO', 'V7ZXT', 'MO0024', '010', '002IR0', 'change tires'),
    ('MD6Y', 'APP0024', '0Q5EO', 'V7ZXT', 'MO0024', '010', '002IR0','align tires'),
    ('MDQY', 'APP0024', '0Q5EO', 'V7ZXT', 'MO0024', '010', '002IR0','change oil'), 
    ('MZAC', 'APP0002', '0FM12', 'V53JY', 'MO0002', '100', '00UT75', 'inspect brakes'),
    ('MZAC', 'APP0002', '0FM12', 'V53JY', 'MO0002', '100', '00UT75', 'replace brake fluid');


INSERT INTO assignments (mi_id, app_id, c_id, v_id, mo_id, mp_id, st_id, mech_id, assignmentDate) VALUES
 ('MI2Z', 'APP0010', '0URKY', 'V30S7', 'MO0010', '100', '0074WA', '0074WA', '2015-12-21'),
 ('MIR5', 'APP0010', '0URKY', 'V30S7', 'MO0010', '100', '0074WA', '004X7E', '2015-12-21'),
 ('MIZS', 'APP0010', '0URKY', 'V30S7', 'MO0010', '100', '0074WA', '00B21W', '2015-12-23'),
 ('MI29', 'APP0016', '0URKY', 'V30S7', 'MO0016', '101', '0074WA', '0097N2', '2016-03-12'),
 ('MIXX', 'APP0016', '0URKY', 'V30S7', 'MO0016', '101', '0074WA', '0097N2', '2016-03-11'),
 ('MI4X', 'APP0016', '0URKY', 'V30S7', 'MO0016', '000', '0074WA', '00B21W', '2016-03-11'),
 ('MIOF', 'APP0019', '0URKY', 'V0T3A', 'MO0019', '000', '0074WA', '004X7E', '2016-05-11'),
 ('MIXD', 'APP0013', '0RLU1', 'VYYPG', 'MO0013', '010', '0022TK', '00RYVF', '2016-01-10'),
 ('MIMV', 'APP0013', '0RLU1', 'VYYPG', 'MO0013', '010', '0022TK', '00JNKS', '2016-01-14'),
 ('MIJV', 'APP0013', '0RLU1', 'VYYPG', 'MO0013', '010', '0022TK', '00JNKS', '2016-01-11'),
 ('MILK', 'APP0013', '0RLU1', 'VYYPG', 'MO0013', '010', '0022TK', '0097N2', '2016-01-11'),
 ('MILO', 'APP0001', '0RLU1', 'VZENX', 'MO0001', '000', '0022TK', '004X7E', '2013-03-06'),
 ('MI6Y', 'APP0012', '0QPG7', 'VKWMP', 'MO0012', '000', '004X7E', '00O0QT', '2016-01-07'),
 ('ML0M', 'APP0012', '0QPG7', 'VKWMP', 'MO0012', '000', '004X7E', '00B21W', '2016-01-07'),
 ('MIWR', 'APP0018', '0QPG7', 'VKWMP', 'MO0018', '000', '00UT75', '0074WA', '2016-04-13'),
 ('MI42', 'APP0020', '0Q5EO', 'V7ZXT', 'MO0020', '000', '00Q3HU', '00RYVF', '2016-05-29'),
 ('MIIX', 'APP0022', '0Q5EO', 'V7ZXT', 'MO0022', '011', '00Q3HU', '00O0QT', '2016-07-10'),
 ('MIEI', 'APP0022', '0Q5EO', 'V7ZXT', 'MO0022', '011', '00Q3HU', '00B21W', '2016-07-09'),
 ('MIFO', 'APP0024', '0Q5EO', 'V7ZXT', 'MO0024', '000', '002IR0', '00B21W', '2016-08-17'),
 ('MAC1', 'APP0024', '0Q5EO', 'V7ZXT', 'MO0024', '000', '002IR0', '00RYVF', '2016-08-18'),
 ('MOMY', 'APP0024', '0Q5EO', 'V7ZXT', 'MO0024', '010', '002IR0', '00JNKS', '2016-08-17'), 
 ('MSAI', 'APP0024', '0Q5EO', 'V7ZXT', 'MO0024', '010', '002IR0', '00JNKS', '2016-08-17'),  
 ('MD6Y', 'APP0024', '0Q5EO', 'V7ZXT', 'MO0024', '010', '002IR0', '00JNKS', '2016-08-17'),  
 ('MDQY', 'APP0024', '0Q5EO', 'V7ZXT', 'MO0024', '010', '002IR0', '00JNKS', '2016-08-17'),  
 ('MIQ0', 'APP0002', '0FM12', 'V53JY', 'MO0002', '100', '00UT75', '004X7E', '2014-11-14'),
 ('MIFG', 'APP0002', '0FM12', 'V53JY', 'MO0002', '100', '00UT75', '00V5KL', '2014-11-15'),
 ('MIMT', 'APP0002', '0FM12', 'V53JY', 'MO0002', '100', '00UT75', '00B21W', '2014-11-14'),
 ('MIQA', 'APP0003', '0FM12', 'V53JY', 'MO0003', '000', '00UT75', '0097N2', '2015-04-08'),
 ('MILY', 'APP0004', '0FM12', 'V53JY', 'MO0004', '000', '0074WA', '00O0QT', '2015-05-05'),
 ('MICP', 'APP0005', '0L56H', 'VT479', 'MO0005', '100', '0074WA', '00RYVF', '2015-06-07'),
 ('MILE', 'APP0005', '0L56H', 'VT479', 'MO0005', '100', '0074WA', '004X7E', '2015-06-07'),
 ('MI06', 'APP0005', '0L56H', 'VT479', 'MO0005', '100', '0074WA', '00O0QT', '2015-06-07'),
 ('MI65', 'APP0008', '0L56H', 'VT479', 'MO0008', '000', '002IR0', '0074WA', '2015-12-12'),
 ('MI9Y', 'APP0007', '0P75G', 'V3KVQ', 'MO0007', '000', '004X7E', '00JNKS', '2015-12-02'),
 ('MITY', 'APP0011', '0P75G', 'VF421', 'MO0011', '101', '00Q3HU', '00Q3HU', '2016-01-02'),
 ('MIJS', 'APP0011', '0P75G', 'VF421', 'MO0011', '101', '00Q3HU', '00JNKS', '2016-01-03'),
 ('MIS3', 'APP0006', '0LD4F', 'V25EM', 'MO0006', '000', '0022TK', '0097N2', '2015-08-08'),
 ('MIZ3', 'APP0006', '0LD4F', 'V25EM', 'MO0006', '000', '0022TK', '00V5KL', '2015-08-08'),
 ('MI68', 'APP0009', '0LD4F', 'V25EM', 'MO0009', '101', '0022TK', '00RYVF', '2015-12-13'),
 ('MI2J', 'APP0009', '0LD4F', 'V25EM', 'MO0009', '101', '0022TK', '00JNKS', '2015-12-14'),
 ('MIUO', 'APP0014', '0LD4F', 'V25EM', 'MO0014', '000', '0022TK', '00O0QT', '2016-02-10'),
 ('MID1', 'APP0017', '0LD4F', 'V25EM', 'MO0017', '000', '00UT75', '00JNKS', '2016-04-06'),
 ('MI3H', 'APP0023', '0IK3G', 'V091R', 'MO0023', '010', '002IR0', '00Q3HU', '2016-08-08'),
 ('MI04', 'APP0023', '0IK3G', 'V091R', 'MO0023', '010', '002IR0', '004X7E', '2016-08-08'),
 ('MIDK', 'APP0023', '0IK3G', 'V091R', 'MO0023', '010', '002IR0', '00V5KL', '2016-08-09'),
 ('MI1S', 'APP0023', '0IK3G', 'V091R', 'MO0023', '010', '002IR0', '00O0QT', '2016-08-09'),
 ('MIZ8', 'APP0026', '0IK3G', 'V091R', 'MO0026', '000', '002IR0', '00V5KL', '2016-09-09'),
 ('MZAC', 'APP0002', '0FM12', 'V53JY', 'MO0002', '100', '00UT75', '00JNKS', '2014-11-14');



INSERT INTO referral_c (proC_id, sc_id) VALUES
   ('07FR3', '0URKY'),
   ('0JK90', '0Q5EO'),
   ('0IK3Y', '0LD4F');

INSERT INTO specials (s_id, discountRate) VALUES
   ('SP01', 0.05),
   ('SP02', 0.10),
   ('SP03', 0.15),
   ('SP04', 0.20),
   ('SP05', 0.50);

INSERT INTO offers (proC_id, s_id, offer, contactDate, expirationDate) VALUES
   ('07FR3', 'SP01', 'battery replacement', '2015-02-05', '2015-03-05'),
   ('07FR3', 'SP03', 'oil change', '2014-05-23', '2015-06-23'),
   ('07FR3', 'SP05', 'tire replacement', '2014-08-15', '2015-09-15'),
   ('0JK90', 'SP02', 'tire alignment', '2016-03-16', '2016-04-16'),
   ('0IK3Y', 'SP02', 'tire replacement', '2016-04-15', '2016-05-15'),
   ('0IK3Y', 'SP04', 'oil change', '2016-07-29', '2016-08-29');

INSERT INTO monthlyInstallments (c_id, v_id, preC_id, monthStarted, amountDue) VALUES
    ('0RLU1', 'VYYPG', '0RLU1', 'Febuary', 80.00),
    ('0RLU1', 'VZENX', '0RLU1', 'March', 80.00),
    ('0FM12', 'V53JY', '0FM12', 'June', 70.00),
    ('0L56H', 'VT479', '0L56H', 'November', 50.00);

INSERT INTO notifications (c_id, v_id, sc_id, emailDate) VALUES
    ('0URKY', 'V30S7', '0URKY', '2017-01-21'),
    ('0URKY', 'V0T3A', '0URKY', '2017-01-21'),
    ('0QPG7', 'VKWMP', '0QPG7', '2017-02-05'),
    ('0P75G', 'V3KVQ', '0P75G', '2017-01-01'),
    ('0Q5EO', 'V7ZXT', '0Q5EO', '2017-01-28'),
    ('0LD4F', 'V25EM', '0LD4F', '2017-01-05'),
    ('0IK3G', 'V091R', '0IK3G', '2017-01-05');


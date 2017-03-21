/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cecs.pkg323.jdbc.project;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

/**
 *
 * @author Caren Briones <carenpbriones@gmail.com>
 * @author Abram Villanueva <abramvillan@gmail.com>
 * @author Professor Mimi Opkins and Professor Dave Brown
 */
public class CECS323JDBCProject {
    //  Database credentials
    static final String USER = "CECS323";
    static final String PASS = "mimi";
    static final String DBNAME = "CECS 323 JDBC";

    //each % denotes the start of a new field.
    //The - denotes left justification.
    //The number indicates how wide to make the field.
    //The "s" denotes that it's a string.
    static final String WRITING_DISPLAY_FORMAT ="%-25s%-35s%-25s%-20s\n";
    static final String PUBLISHER_DISPLAY_FORMAT = "%-25s%-45s%-25s%-30s\n";
    static final String BOOK_DISPLAY_FORMAT = "%-25s%-35s%-20s%-20s%-4s\n";
        
    // Error messages
    static final String INTEGER_ERROR = "Input invalid.  Please enter an integer.";
    static final String PHONE_ERROR = "Input invalid.  Please enter a valid phone number.";
    
    // JDBC driver name and database URL
    static final String JDBC_DRIVER = "org.apache.derby.jdbc.ClientDriver";
    static String DB_URL = "jdbc:derby://localhost:1527/";
    
/**
 * Takes the input string and outputs "N/A" if the string is empty or null.
 * @param input The string to be mapped.
 * @return  Either the input string or "N/A" as appropriate.
 */
    public static String dispNull (String input) {
        //because of short circuiting, if it's null, it never checks the length.
        if (input == null || input.length() == 0)
            return "N/A";
        else
            return input;
    }
    
    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);
        
        //Constructing the database URL connection string
        DB_URL = DB_URL + DBNAME + ";user="+ USER + ";password=" + PASS;
        Connection conn = null; //initialize the connection
        Statement stmt = null;  //initialize the statement that we're using
        
        try {
            // Register JDBC driver
            Class.forName("org.apache.derby.jdbc.ClientDriver");

            // Open a connection
            ResultSet rs;
            conn = DriverManager.getConnection(DB_URL);
            
            int choice = 0;
            boolean flag = true;
            System.out.println("Welcome!  Select an option:");
            
                do{
                    // Menu options
                    System.out.println("1.  List a database");
                    System.out.println("2.  List specified data from a database");
                    System.out.println("3.  Insert information into database");
                    System.out.println("4.  Remove a book");
                    System.out.println("5.  Quit\n");

                    // Checks whether the user's input matches is of the desired type
                    choice = checkInt(INTEGER_ERROR);
                    System.out.println();

                    // Checks if the user's input is from the choices 1-3
                    while (choice < 1 || choice > 5){
                        System.out.println("Please enter \"1\", \"2\", \"3\", \"4\", or \"5\".\n");
			choice = in.nextInt();
                    }

                    switch(choice){

			case 1: //User displays whole table of their choice
                            
                            System.out.println("Which database would you like to display?");
                            System.out.println("1.  Writing Groups");
                            System.out.println("2.  Publishers");
                            System.out.println("3.  Books\n");
                            
                            //Validates user input for menu choice
                            int DBChoice = checkInt(INTEGER_ERROR);
                            while (DBChoice < 1 || DBChoice > 3){
                                System.out.println("Please enter \"1\", \"2\", or \"3\".\n");
                                DBChoice = checkInt(INTEGER_ERROR);
                            }
                            
                            if (DBChoice == 1){ //Displays WritingGroup
                                displayWritingGroup();                              
                            } else if (DBChoice == 2){ //Displays Publisher
                                displayPublisher();
                            } else{ // Displays Books
                                displayBooks();                                                           
                            }
                            
                            break;
                            
                        case 2:
                            
                            int dataChoice;
                            String dataEntry;
                            String sql;
                            boolean display = false;
                            boolean displayAtt = false;
                            
                            //Displays choices
                            System.out.println( "Which database do you want to select from? " );
                            System.out.println( "1.  Writing Groups" );
                            System.out.println( "2.  Publishers" );
                            System.out.println( "3.  Books" );
                            System.out.println( "4.  Go Back\n");
                            System.out.println();
                            
                            //Gets user input and checks validation
                            dataChoice = checkInt(INTEGER_ERROR);
                            while ( dataChoice < 1 || dataChoice > 4 ){
                                System.out.println( "Please enter \"1\", \"2\", \"3\", or \"4\".\n" );
                                dataChoice = in.nextInt();
                            }
                            
                            switch ( dataChoice ){
                                case 1:
                                    // Prompts the User 
                                    stmt = conn.createStatement();
                                    System.out.println( "Please enter the Writing Group you want to display:" );
                                    dataEntry = in.nextLine();
                                    System.out.println();
                                    
                                    // Creates SQL statement and executes it.
                                    sql = "SELECT groupName, headWriter, yearFormed, subject "
                                            + "FROM WritingGroup WHERE groupName =" + "\'" + dataEntry +"\'";                                   
                                    rs = stmt.executeQuery(sql);
                                    
                                    // Goes through the result of the SQL query
                                    while(rs.next()){
                                        // Retrieve data by their name
                                        String name = rs.getString( "groupName" );
                                        String head = rs.getString( "headWriter" );
                                        String year = rs.getString( "yearFormed" );
                                        String subject = rs.getString( "subject" );
                                    
                                        // If the writng group name has matched the user's input it will display.
                                        if ( name.equals( dataEntry ) ){
                                            display = true;
                                            

                                            // Displays the header of the table once
                                            if ( displayAtt == false ){
                                                System.out.printf(WRITING_DISPLAY_FORMAT, "Group Name", "Head Writer", 
                                                        "Year Formed", "Subject" );
                                                displayAtt = true;
                                            }
                                            System.out.printf(WRITING_DISPLAY_FORMAT,
                                            dispNull( name ), dispNull( head ), dispNull( year ), dispNull( subject ) );
                                        }                                                   
                                    }
                                    
                                    // If it did not display anything, it will display an error message
                                    if ( display == false )
                                    {
                                        System.out.println( "Sorry, " + dataEntry + " was not in the Writing Group database" );
                                    }
                                    
                                    System.out.println();                                    
                                    break;
                                    
                                case 2:
                                    
                                    stmt = conn.createStatement();
                                    System.out.println( "Please enter the Publisher you want to display" );
                                    dataEntry = in.nextLine();
                                    System.out.println();
                                    
                                    // Creates SQL statement and executes it
                                    sql= "SELECT publisherName, publisherAddress, publisherPhone, publisherEmail FROM Publisher"
                                            + " WHERE publisherName =" + "\'" + dataEntry +"\'";
                                    rs = stmt.executeQuery(sql);
                                    
                                    // Goes through the result of the SQL query
                                    while(rs.next())
                                    {
                                        // Retrieve data by their name
                                        String name = rs.getString("publisherName");
                                        String address = rs.getString("publisherAddress");
                                        String phone = rs.getString("publisherPhone");
                                        String email = rs.getString("publisherEmail");
                                    
                                        // If the publisher name has matched the user's input it will display.
                                        if ( name.equals( dataEntry ) )
                                        {
                                            display = true;
                                            
                                            // Displays the header of the table once
                                            if ( displayAtt == false )
                                            {
                                                System.out.printf(PUBLISHER_DISPLAY_FORMAT, "Publisher Name", "Address", 
                                                        "Phone Number", "Email" );
                                                displayAtt = true;
                                            }
                                            System.out.printf(PUBLISHER_DISPLAY_FORMAT,
                                                dispNull(name), dispNull(address), dispNull(phone), dispNull(email));
                                        }
                                                   
                                    }
                                    
                                    // Displays the error message if it did not display anything
                                    // from the database
                                    if ( display == false )
                                    {
                                        System.out.println( "Sorry, " + dataEntry + " was not in the Publisher database" );
                                    }
                                    
                                    System.out.println();
                                    break;
                                case 3:
                                                                    	
                                    stmt = conn.createStatement();
                                    System.out.println( "Please enter the Book you want to display:" );
                                    dataEntry = in.nextLine();
                                    System.out.println();
                                    
                                    // Creates SQL statement and executes it
                                    sql= "SELECT groupName, bookTitle, publisherName, yearPublished, numberPages"
                                    		+ " FROM Books"+ " WHERE bookTitle =" + "\'" + dataEntry +"\'";
                                    
                                    rs = stmt.executeQuery(sql);
                                    
                                    // Goes through the result of the SQL query

                                    while(rs.next())
                                    {
                                        // Retrieve data by their name
                                    	String groupName = rs.getString("groupName");
                                        String bookTitle = rs.getString("bookTitle");
                                        String pubName = rs.getString("publisherName");
                                        String year = rs.getString("yearPublished");
                                        String pages = rs.getString("numberPages");
                                    
                                        // If the book title has matched the user's input it will display.
                                        if ( bookTitle.equals( dataEntry ) )
                                        {
                                            display = true;
                                            
                                            // Displays the header of the table once
                                            if ( displayAtt == false )
                                            {
                                                System.out.printf(BOOK_DISPLAY_FORMAT, "Group Name", "Book Title", 
                                                        "Publisher Name", "Year Published", "Number of Pages" );
                                                displayAtt = true;
                                            }
                                            
                                            System.out.printf(BOOK_DISPLAY_FORMAT,
                                                dispNull(groupName), dispNull(bookTitle), dispNull(pubName), 
                                                dispNull(year), dispNull(pages) );
                                        }
                                                   
                                    }
                                    
                                    // If it did not display anything, it will display an error message
                                    if ( display == false )
                                    {
                                        System.out.println( "Sorry " + dataEntry + " was not in the Book database" );
                                    }
                                    
                                    System.out.println();
                                    break;
                                
                                default:
                                    System.out.println();
                                    break;
                                    
                            }
                            
                            break;
                            
                        case 3:
                            System.out.println( "What kind of information do you wish to insert into the database?" );
                            System.out.println( "1. Insert a new book" );
                            System.out.println( "2. Insert a new publisher that will replace an old publisher"
							+ " (Doing this will update the book's publisher that is being replaced)" );
                            System.out.println( "3. Go back" ); 
                            System.out.println();

                            int insertChoice = checkInt(INTEGER_ERROR);

                            // Checks user input
                            while ( insertChoice < 1 || insertChoice > 3 ){
                                System.out.println( "Sorry you did not enter a valid option." );
                                System.out.println("Please enter \"1\", \"2\", or \"3\".");
                                insertChoice = checkInt(INTEGER_ERROR);
                            }

                            // If user wants to add a new Book
                            if ( insertChoice == 1 ){
                                boolean validBook = true;
                                boolean validPub = false;
                                boolean validWriting = false;

                                String bookTitle;
                                String pubName;
                                String writerName;
                                String insertBookSQL;

                                System.out.println( "What is the name of the book you wish to add into the database?" );
                                bookTitle = in.nextLine();
                                                
                                while ( bookTitle.length() > 30 ){
                                    System.out.println( "The name of the book you wish to add is too long" );
                                    System.out.println( "Please enter a different name for " + bookTitle );
                                    bookTitle = in.nextLine();
                                }

                                // Prompts the user to enter the publisher's name. Creates
                                // and exectures a SQL statement based on user's input
                                System.out.println( "What is the publisher of your book?" );
                                pubName = in.nextLine();


                                stmt = conn.createStatement();
                                String pubSQL = "SELECT publisherName FROM Publisher";
                                rs = stmt.executeQuery( pubSQL );

                                // Goes through each publisher to see if the publisher the
                                // user entered is in the database
                                while ( rs.next() ){
                                    //Retrieve by column name
                                    String pub = rs.getString( "publisherName" );
                                    if ( pub.equals ( pubName ) ){
                                        validPub = true;
                                    }
                                }

                                // If the user's publisher is not in the database, it will prompt the user
                                // if they want to add it to the database or not.
                                if ( validPub == false ){
                                    int input;
                                    System.out.println( "Sorry the publisher that you entered does not exist in the database" );
                                    System.out.println( "Do you want to add it to the database?" );
                                    System.out.println( "1. Yes " );
                                    System.out.println( "2. No") ;
                                    System.out.println();
                                    input = checkInt(INTEGER_ERROR);

                                    while ( input != 1 && input != 2 ){
                                        System.out.println( "Sorry you did not enter a valid option." );
                                        System.out.println( "Please enter again." );
                                        input = checkInt(INTEGER_ERROR);
                                    }

                                    // Procedure to add the user's publisher to the database
                                    if ( input == 1 ){
                                        String pubAddress;
                                        String pubPhone;
                                        String pubEmail;
                                        // validPub becomes true since the user's publisher will now
                                        // be in the database
                                        validPub = true;

                                        // Checks the length of the user's publisher name in order to not get
                                        // any error messages for passing the length
                                        while ( pubName.length() > 20 ){
                                            System.out.println( "Sorry the name of " + pubName + " is too long." );
                                            System.out.println( "Please enter a different name for " + pubName );
                                            pubName = in.nextLine();
                                        }

                                        // Asks the user for the address of their publisher and checks validation
                                        System.out.println( "What is the address of " + pubName + "?" );
                                        pubAddress = in.nextLine();

                                        while ( pubAddress.length() > 40 ){
                                            System.out.println( "Sorry the address of " + pubName + " is too long." );
                                            System.out.println( "Please enter a different address" );
                                            pubAddress = in.nextLine();
                                        }

                                        // Asks the user for the phone number of the publisher and checks validation
                                        System.out.println( "What is the phone number of " + pubName + "?" );
                                        pubPhone = in.nextLine();

                                        while ( pubPhone.length() > 20 ){
                                            System.out.println( "Sorry the phone number of " + pubName + " is too long." );
                                            System.out.println( "Please enter a different phone number" );
                                            pubPhone = in.nextLine();
                                        }
                                        
                                        System.out.println( "What is the email of " + pubName + "?" );
                                        pubEmail = in.nextLine();

                                        while ( pubEmail.length() > 30 )
                                        {
                                            System.out.println( "Sorry the email address of " + pubName + " is too long." );
                                            System.out.println( "Please enter a email address" );
                                            pubEmail = in.nextLine();
                                        }

                                        // Creates a SQL statement based on the user's input about the publisher
                                        // and executes it
                                        stmt = conn.createStatement();
                                        String insertPubSQL = "INSERT INTO Publisher (publisherName, publisherAddress, "
                                                + "publisherPhone, publisherEmail) " + "values ( '" + pubName + "', '" 
                                                + pubAddress +"', '" + pubPhone +  "', '" + pubEmail + "')";
                                        stmt.executeUpdate( insertPubSQL );

                                        System.out.println( "The publisher " + pubName + " has been added "
                                                + "to the database." );
                                        System.out.println();
                                    }
                                }

                                // If they decide not to add their publisher, it will display an error message
                                // and redirects them to the main menu
                                if ( validPub == false )
                                {
                                    System.out.println( "Sorry you can't continue without a publisher" );
                                    System.out.println();
                                }
                                // Continues the procedure
                                else
                                {
                                    // Prompts the user to enter the writing group's name and 
                                    // creates a SQL statement and executes it.
                                    System.out.println( "What is the writing group of your book?" );
                                    writerName = in.nextLine();
                                    stmt = conn.createStatement();
                                    String writerSQL = "SELECT groupName FROM WritingGroup";
                                    rs = stmt.executeQuery( writerSQL );

                                    // Goes through each writing group to see if the 
                                    // writing group the user entered is in the database                                        
                                    while ( rs.next() ){
                                        
                                        //Retrieve by column name
                                        String writer = rs.getString( "groupName" );
                                        if ( writer.equals ( writerName ) ){
                                                validWriting = true;
                                        }
                                    }

                                    // If the user's writing group is not in the database, it will display
                                    // an error message and prompt them if they want to add it into
                                    // the database
                                    if ( validWriting == false ){
                                        int input;
                                        System.out.println( "Sorry the writing group that you entered does not exist in the database" );
                                        System.out.println( "Do you want to add it to the database?" );
                                        System.out.println( "1. Yes " );
                                        System.out.println( "2. No") ;
                                        System.out.println();
                                        input = checkInt(INTEGER_ERROR);

                                        while ( input != 1 && input != 2 ){
                                            System.out.println( "Sorry you did not enter a valid option." );
                                            System.out.println( "Please enter again." );
                                            input = checkInt(INTEGER_ERROR);
                                        }
                                        // If they said yes, it will ask the writing group's information
                                        if ( input == 1 ){
                                            validWriting = true;
                                            String headWriter;
                                            int yearFormed;
                                            String checkYear;
                                            String subject;

                                            // Checks the length of the user's writing group and asks
                                            // them to enter again in order to avoid error messages
                                            // when adding.
                                            while ( writerName.length() > 20 ){
                                                System.out.println( "Sorry the name for " + writerName + " is too long." );
                                                System.out.println( "Please enter a different name for " +writerName );
                                                writerName = in.nextLine();
                                            }

                                            // Prompts the user to enter the head writer's name for their writing group
                                            // and checks for validation.
                                            System.out.println( "Who is the headWriter for " + writerName + "?" );
                                            headWriter = in.nextLine();
                                            while ( headWriter.length() > 30 ){
                                                System.out.println( "Sorry, the name of the head writer for " + writerName + " is too long." );
                                                System.out.println( "Please enter a different name for " + headWriter );
                                                headWriter = in.nextLine();
                                            }

                                            // Prompts the user to enter the year when the writing group was formed
                                            // and checks for validation.
                                            System.out.println( "What year was " + writerName + " formed?" );
                                            yearFormed = checkInt(INTEGER_ERROR);
                                            checkYear = "" + yearFormed;
                                            while ( checkYear.length() > 20 )
                                            {
                                                System.out.println( "Sorry the year when " + writerName + " formed is too long." );
                                                System.out.println( "Please enter a different year" );
                                                yearFormed = checkInt(INTEGER_ERROR);
                                                checkYear = "" + yearFormed;
                                            }

                                            // Prompts the user to enter the subject the writing group writes
                                            // and checks for validation.
                                            System.out.println( "What subject does " + writerName + " write?" );
                                            subject = in.nextLine();
                                            while ( checkYear.length() > 20 ){
                                                System.out.println( "Sorry, the subject that " + writerName + " writes is too long." );
                                                System.out.println( "Please enter a different subject" );
                                                subject = in.nextLine();
                                            }

                                            // Creates a SQL statement based on user's input and executes it
                                            stmt = conn.createStatement();
                                            String insertWriterSQL = "INSERT INTO WritingGroup (groupName, headWriter, "
                                                    + "yearFormed, subject) values ( '" + writerName + "', '" 
                                            + headWriter +"', '" + yearFormed +  "', '" + subject + "')";
                                            stmt.executeUpdate( insertWriterSQL );

                                            System.out.println( "The writing group, " + writerName + ", has been added "
                                            + "to the database.");
                                            System.out.println();
                                        }

                                    }

                                    if ( validWriting == false ){
                                        System.out.println( "Sorry you cannot continue without a writing group \n" );
                                    }
                                    else{
                                        stmt = conn.createStatement();
                                        String bookSQL = "SELECT groupName, bookTitle FROM Books";
                                        rs = stmt.executeQuery( bookSQL );

                                        while ( rs.next() ){
                                            String book = rs.getString( "bookTitle" );
                                            String group = rs.getString( "groupName" );
                                            if ( book.equals( bookTitle ) && group.equals( writerName ) ){
                                                validBook = false;
                                            }
                                        }

                                        if ( validBook == false){
                                            System.out.println( "Sorry the book you entered already exists" );
                                            System.out.println();
                                        }
                                        else{
                                            System.out.println( "What year was this book published? (Up to 4 digits)" );
                                            int year = checkInt(INTEGER_ERROR);
                                            String checkInput = "" + year;
                                            while ( checkInput.length() > 4 ){
                                                System.out.println( "Sorry the year you entered is not valid. Please enter again" );
                                                year = checkInt(INTEGER_ERROR);
                                                checkInput = "" + year;
                                            }

                                            System.out.println( "How many pages is your book??" );
                                            int pages = checkInt(INTEGER_ERROR);
                                            checkInput = "" + pages;
                                            while ( checkInput.length() > 4 ){
                                                System.out.println( "Sorry the number of pages you entered is too long. Please enter again" );
                                                pages = checkInt(INTEGER_ERROR);
                                                checkInput = "" + pages;
                                            }

                                            stmt = conn.createStatement();
                                            insertBookSQL = " INSERT INTO Books (groupName, bookTitle, publisherName, yearPublished, numberPages) "
                                                            + "values ( '" + writerName + "', '" + bookTitle +"', '" + pubName + 
                                                            "', '" + year + "', '" + pages +"' )";
                                            stmt.executeUpdate( insertBookSQL );
                                        }
                                    }
                                }
                            }

                            else if ( insertChoice == 2 ){
                            	System.out.println("Enter the name of the publisher you would like to insert:");
                                String newPublisher = in.nextLine();
                                
                                System.out.println("\nEnter the name of the publisher you would like to replace:");
                                String oldPublisher = in.nextLine();
                                
                                boolean publisherInTable = false;
                                stmt = conn.createStatement();
                                String publisherSQL = "SELECT publisherName FROM Publisher";
                                rs = stmt.executeQuery( publisherSQL );
                                
                                // Goes through each book title to see if the same book title
                                while (rs.next()){
                                    //Retrieve by column name
                                    String publisher = rs.getString("publisherName");
                                    
                                    // Sets validBook to false if the user's book title
                                    // matches with a book in the database.
                                    if ( publisher.equals (oldPublisher) ){
                                        publisherInTable = true;
                                    }
                                }
                                
                                if (publisherInTable == true){
                                    //Updates books from Books table to new publisher where necessary
                                    stmt = conn.createStatement();
                                    String booksSQL = "UPDATE Books " +
                                            "SET publisherName = '" + newPublisher +
                                            "' WHERE publisherName = '" + oldPublisher + "'";
                                    stmt.executeUpdate(booksSQL);                                  
                                    
                                    //Displays the updated Books table
                                    System.out.println("Here is the updated Books table:");
                                    displayBooks();
                                } 
                                else{
                                    System.out.println("This publisher does not exist in the table."
                                            + " You will be brought back to the main menu.");
                                }
                            }
                            break;
                            
                        case 4:
                            boolean validBook = false;
                            boolean validWriting = false;

                            String bookTitle;
                            String writerName;

                            //Prompts user for book
                            System.out.println( "What is the name of the book you want to delete from the database?" );
                            bookTitle = in.nextLine();
                            stmt = conn.createStatement();
                            String bookSQL = "SELECT bookTitle FROM Books";
                            rs = stmt.executeQuery( bookSQL );
                            
                            // Goes through each book title to see if the same book title
                            while (rs.next()){
                                //Retrieve by column name
                                String book = rs.getString("bookTitle");

                                // Sets validBook to false if the user's book title
                                // matches with a book in the database.
                                if ( book.equals ( bookTitle) ){
                                    validBook = true;
                                }
                            }

                            // If validBook is false, it will prompt a message that the book already exists and
                            // it will finish the procedure since book is a primary unique key
                            if ( validBook == false ){
                                 System.out.println( "Sorry, the book that you entered does not exist in the database. \n" );
                            }
                            else{
                                // Prompts the user to enter the writing group's name and 
                                // creates a SQL statement and executes it.
                                System.out.println( "What is the writing group of your book?" );
                                writerName = in.nextLine();
                                stmt = conn.createStatement();
                                String groupSQL;
                                groupSQL = "SELECT groupName FROM Books WHERE groupName = '" + writerName +"'";
                                rs = stmt.executeQuery( groupSQL );

                                // Goes through each writing group to see if the 
                                // writing group the user entered is in the database                                        
                                while ( rs.next() ){
                                    //Retrieve by column name
                                    String writer = rs.getString( "groupName" );
                                    if ( writer.equals ( writerName ) ){
                                        validWriting = true;
                                    }
                                }

                                if ( validWriting == false ){
                                    System.out.println( "Sorry, the writing group that you entered does not exist in the database. \n" );
                                }
                                else{
                                    stmt = conn.createStatement();
                                    String deleteSQL = "DELETE FROM Books WHERE bookTitle = '" 
                                            + bookTitle + "' AND groupName = '" + writerName + "'";
                                    stmt.executeUpdate( deleteSQL );

                                    System.out.println( "\nYour book " + bookTitle 
                                            + " has been deleted from the database");
                                    
                                    System.out.println("\nHere is the updated Books table: \n");
                                    displayBooks();
                                }
                            }

                            break;
                            
                        case 5: //Exits the program
                            flag = false;
                            break;
                            
                        default:
                            System.out.println("Input is invalid.");
                        }
                }while (flag != false);
        } 
        catch (SQLException se) {
            //Handle errors for JDBC
            se.printStackTrace();
        } catch (Exception e) {
            //Handle errors for Class.forName
            e.printStackTrace();
        } finally {
            //finally block used to close resources
            try {
                if (stmt != null) {
                    stmt.close();
                }
            }catch (SQLException se2) {
            }// nothing we can do
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException se) {
                se.printStackTrace();
            }//end finally try
        }//end try
        System.out.println("Goodbye!");
    }//end main
    
    /**
     * Returns an integer entered by the user; if the user does not enter an integer,
     * they will be prompted until they enter a user.
     * @param errorMessage message to be displayed if the user inputs invalid information
     * @return integer inputted by user
     */
    	public static int checkInt( String errorMessage ){
            Scanner in = new Scanner(System.in);
            boolean valid = false;
            int validNum = 0;

            while(!valid){
                if(in.hasNextInt()){
                    // Ensures that the user's input is an integer
                    validNum = in.nextInt();
                    valid = true;
                } else{
                    // Clear buffer of junk input
                    in.next();
                    System.out.print( errorMessage );
                }
            }
            return validNum;
        }
        
        /**
         * Displays the WritingGroup table
         */
        public static void displayWritingGroup()
        {

            try{
                DB_URL = DB_URL + DBNAME + ";user="+ USER + ";password=" + PASS;
                Class.forName("org.apache.derby.jdbc.ClientDriver");

                Connection conn = DriverManager.getConnection(DB_URL);
                Statement stmt = conn.createStatement();
                String writingGroupSql;
                writingGroupSql = "SELECT groupName, headWriter, yearFormed, subject FROM WritingGroup";
                ResultSet rs = stmt.executeQuery(writingGroupSql);

                //Extract data from result set
                System.out.println();
                System.out.printf(WRITING_DISPLAY_FORMAT, "Group name", "Head Writer", "Year Formed", "Subject\n");

                while (rs.next()) {
                    //Retrieve by column name
                    String name = rs.getString("groupName");
                    String writer = rs.getString("headWriter");
                    String year = rs.getString("yearFormed");
                    String subject = rs.getString("subject");

                    //Display values
                    System.out.printf(WRITING_DISPLAY_FORMAT,
                    dispNull(name), dispNull(writer), dispNull(year), dispNull(subject));
                }
                System.out.println();
                
                //Clean up
                rs.close();
                stmt.close();
                conn.close();
                
            } catch (SQLException se) {
            //Handle errors for JDBC
            se.printStackTrace();
            }catch (Exception e) {
               //Handle errors for Class.forName
               e.printStackTrace();
            }
        }
        
        /**
         * Displays the Publisher Table
         */
        public static void displayPublisher()
        {

            try{
                DB_URL = DB_URL + DBNAME + ";user="+ USER + ";password=" + PASS;
                Class.forName("org.apache.derby.jdbc.ClientDriver");

                Connection conn = DriverManager.getConnection(DB_URL);
                Statement stmt = conn.createStatement();
                String publisherSql;
                publisherSql = "SELECT publisherName, publisherAddress, publisherPhone, publisherEmail FROM Publisher";
                ResultSet rs = stmt.executeQuery(publisherSql);

                //Extract data from result set
                System.out.println();
                System.out.printf(PUBLISHER_DISPLAY_FORMAT, "Publisher Name", "Publisher Address", "Publisher Phone", "Publisher Email\n");

                while (rs.next()) {
                    //Retrieve by column name
                    String name = rs.getString("publisherName");
                    String address = rs.getString("publisherAddress");
                    String phone = rs.getString("publisherPhone");
                    String email = rs.getString("publisherEmail");

                    //Display values
                    System.out.printf(PUBLISHER_DISPLAY_FORMAT,
                    dispNull(name), dispNull(address), dispNull(phone), dispNull(email));
                }
                System.out.println();
                
                //Clean up
                rs.close();
                stmt.close();
                conn.close();
            } catch (SQLException se) {
            //Handle errors for JDBC
            se.printStackTrace();
            }catch (Exception e) {
               //Handle errors for Class.forName
               e.printStackTrace();
            }
        }
        
        /**
         * Displays the Books table
         */
        public static void displayBooks()
        {
            try{
                DB_URL = DB_URL + DBNAME + ";user="+ USER + ";password=" + PASS;
                Class.forName("org.apache.derby.jdbc.ClientDriver");

                Connection conn = DriverManager.getConnection(DB_URL);
                Statement stmt = conn.createStatement();
                String booksSql;
                booksSql = "SELECT groupName, bookTitle, publisherName, yearPublished, numberPages FROM Books";
                ResultSet rs = stmt.executeQuery(booksSql);

                //Extract data from result set
                System.out.println();
                System.out.printf(BOOK_DISPLAY_FORMAT, "Group Name", "Book Title", "Publisher name", "Year Published", "Number of Pages\n");

                while (rs.next()) {
                    //Retrieve by column name
                    String name = rs.getString("groupName");
                    String title = rs.getString("bookTitle");
                    String publisher = rs.getString("publisherName");
                    String year = rs.getString("yearPublished");
                    String pages = rs.getString("numberPages");

                    //Display values
                    System.out.printf(BOOK_DISPLAY_FORMAT,
                    dispNull(name), dispNull(title), dispNull(publisher), dispNull(year), dispNull(pages));
                }
                System.out.println();
                
                //Clean up
                rs.close();
                stmt.close();
                conn.close();
            } catch (SQLException se) {
            //Handle errors for JDBC
            se.printStackTrace();
            }catch (Exception e) {
               //Handle errors for Class.forName
               e.printStackTrace();
            }            
        }
}


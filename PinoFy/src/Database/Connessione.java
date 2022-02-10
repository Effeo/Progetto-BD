package Database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Connessione {

	private static Connessione instance;
	private Connection connection = null;
	private String nome = "postgres";
	private String password = "francesco";
	private String url = "jdbc:postgresql://localhost:5432/prova";
	private String driver = "org.postgresql.Driver";

	// COSTRUTTORE
	public Connessione() throws SQLException {
		try {
			Class.forName(driver);
			connection = DriverManager.getConnection(url, nome, password);

		} catch (ClassNotFoundException ex) {
			System.out.println("Database Connection Creation Failed : " + ex.getMessage());
			ex.printStackTrace();
		}

	}

	public Connection getConnection() {
			return connection;
	}
	
	public static Connessione getInstance() throws SQLException {
		if (instance == null) {
			instance = new Connessione();
		} else if (instance.getConnection().isClosed()) {
			instance = new Connessione();
		}
		return instance;
	}
}

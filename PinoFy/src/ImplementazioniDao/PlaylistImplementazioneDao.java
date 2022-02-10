package ImplementazioniDao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;

import ConnessioneDatabase.Connessione;
import DAO.PlaylistDAO;
import Model.Playlist;
import Model.Utente;

public class PlaylistImplementazioneDao implements PlaylistDAO {
	private Connection connection;
	
	public PlaylistImplementazioneDao()
	{
		try {
			connection = Connessione.getInstance().getConnection();
		}
		catch (SQLException e){
			e.printStackTrace();
		}
	}
	
	public Playlist takePlaylist(int codP) {
		Playlist p=null;
		String titolo = "";
		int numTracce = 0;
		boolean visibilita = false;
		Time durata = null;
		Utente u;
		String utente = "";
		// devo creare pure le variabili per Utente
		String nickname = "";
		String mail = "";
		String password = "";
		String nome = "";
		String cognome = "";
		String nazione = "";
		String descrizione = "";
		String sesso = "";
		Date datan = null;
		boolean isPremium = false;
		boolean isAdmin = false;
		
		try {PreparedStatement queryTakePlaylist=connection.prepareStatement("SELECT * FROM PLAYLIST WHERE CodP= "+codP);
		ResultSet rs=queryTakePlaylist.executeQuery();
		while(rs.next()) {
			titolo=rs.getString("Titolo");
			numTracce=rs.getInt("Ntracce");
			visibilita=rs.getBoolean("Visibilita"); //nel DB sta l'accento
			durata=rs.getTime("Durata");
			utente=rs.getString("NickName");
		}//ora se visibilita e' true dobbiamo dargli la Playlist , ma nel model io passo un riferimento ad utente,ora ho una stringa...
		
		if(visibilita) {
			PreparedStatement queryTakeUtente=connection.prepareStatement("SELECT * FROM UTENTE WHERE NickName='"+utente+"'");
			ResultSet rs1=queryTakeUtente.executeQuery();
			while(rs1.next()) {
				nickname=rs1.getString("NickName");
				mail=rs1.getString("Email");
				password=rs1.getString("Password");
				nome=rs1.getString("Nome");
				cognome=rs1.getString("Cognome");
				nazione=rs1.getString("Nazione");
				descrizione=rs1.getString("Descrizione");
				sesso=rs1.getString("Sesso");
				datan=rs1.getDate("DataN");
				isPremium=rs1.getBoolean("IsPremium");
				isAdmin=rs1.getBoolean("IsAdmin");
			}
			u=new Utente(nickname,mail,password,nome,cognome,nazione,descrizione,sesso,datan,isPremium,isAdmin);
			
			p=new Playlist(titolo,numTracce,visibilita,durata,u);
			}
		else {System.out.println("Esiste ma e' privata,veditela con quel fecato di "+ utente);}
		}
		
		catch(SQLException e) {
			e.printStackTrace();
		}
		return p;
	}

}

package Model;

import java.sql.Date;

public class Utente {
	
	private String nickname;
	private String mail;
	private String password;
	private String nome;
	private String cognome;
	private String nazione;
	private String descrizione;
	private String sesso;
	private Date datan;
	private boolean isPremium;
	private boolean isAdmin;
	
	public Utente(String nickname, String mail, String password, String nome, String cognome, String nazione,
			String descrizione, String sesso, Date datan, boolean isPremium, boolean isAdmin){
		
		this.nickname = nickname;
		this.mail = mail;
		this.password = password;
		this.nome = nome;
		this.cognome = cognome;
		this.nazione = nazione;
		this.descrizione = descrizione;
		this.sesso = sesso;
		this.datan = datan;
		this.isPremium = isPremium;
		this.isAdmin = isAdmin;
	}
	public String getNickname() {return nickname;}
	
	public String getMail() {return mail;}
	
	public String getPassword() {return password;}
	
	public String getNome() {return nome;}
	
	public String getCognome() {return cognome;}
	
	public String getNazione() {return nazione;}
	
	public String getDescrizione() {return descrizione;}
	
	public Date getDatan() {return datan;}
	
	public boolean getIspremium() {return isPremium;}

	public boolean getIsadmin() {return isAdmin;}
	
	public String getSesso() {return sesso;}
	
	
}

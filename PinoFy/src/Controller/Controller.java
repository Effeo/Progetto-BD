package Controller;

import java.sql.Date;
import java.util.ArrayList;

import ImplementazioniDao.*;
import Model.*;

public class Controller {
	private Utente u;
	private UtenteImplementazioneDao ui;
	private TracciaImplementazioneDao ti;
	
	public Controller() {
		ui = new UtenteImplementazioneDao();
		ti = new TracciaImplementazioneDao();
	}
	
	public Utente login(String email, String password)
	{
		u = ui.login(email, password);
		
		return u;
	}
	
	public int signUp(String nickname, String mail, String password, String nome, String cognome, String nazione,
			String descrizione, String sesso, String datan, String isPremium, String isAdmin)
	{
		int esito;
		
		esito = ui.sign_Up(nickname, mail, password, nome, cognome, nazione, descrizione, sesso, datan, isPremium, isAdmin);
		
		return esito;
	}
	
	public boolean checkEmail(String email)
	{
		boolean esito = ui.checkEmail(email);
		
		return esito;
	}
	
	public boolean checkNickName(String nickName)
	{
		boolean esito = ui.checkNickName(nickName);
		
		return esito;
	}
	
	public ArrayList<Traccia> takeTraccia(String query)
	{
		ArrayList<Traccia> tracce = null;
		
		tracce = ti.takeTraccia(query);
		
		return tracce;
	}
}

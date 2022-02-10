package DAO;

import java.sql.Date;

import Model.Utente;

public interface UtenteDAO {
	Utente login(String email, String password);
	int sign_Up(String nickname,String mail,String password,String nome,String cognome,String nazione,String descrizione, String sesso, String datan,String isPremium,String isAdmin);
	boolean checkNickName(String nickName);
	boolean checkEmail(String email);
	int AggiornaUtente(String nikname,String nome,String cognome,String nazione,
			String descrizione, String sesso,boolean isPremium, boolean isAdmin);
}

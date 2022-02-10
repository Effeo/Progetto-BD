package Model;

public class Voto {
	
	private Utente utente;
	private Traccia traccia;
	private int voto;
	
	public Voto(Utente utente, Traccia traccia, int voto) {
		this.utente = utente;
		this.traccia = traccia;
		this.voto = voto;
	}

	public Utente getUtente() {return utente;}

	public Traccia getTraccia() {return traccia;}
	
	public int getVoto() {return voto;}
}

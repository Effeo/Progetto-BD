package Model;

public class Ascolto {
	
	private Utente utente;
	private Traccia traccia;
	private int fascia;
	
	public Ascolto(Utente utente, Traccia traccia, int fascia) {
		this.utente = utente;
		this.traccia = traccia;
		this.fascia = fascia;
	}

	public Utente getUtente() {return utente;}

	public Traccia getTraccia() {return traccia;}
	
	public int getFascia() {return fascia;}	
}

package Model;

import java.sql.Time;

public class Traccia {
	
	private String titolo;
	private Time durata;
	private String etichetta;
	private int annoU;
	private String genere;
	private String link;
	private String formato;
	private int qualita;
	private int voto;
	private boolean isCover;
	private boolean isRemastered;
	private Album album;
	private Traccia tr;
	private Traccia tc;
	
	public Traccia(String titolo, Time durata, String etichetta, int annoU, String genere, String link, String formato, int qualita, int voto,boolean isCover,boolean isRemastered,Album album,Traccia tr,Traccia tc) {
		this.titolo=titolo;
		this.durata=durata;
		this.etichetta=etichetta;
		this.annoU=annoU;
		this.genere=genere;
		this.link=link;
		this.formato=formato;
		this.qualita=qualita;
		this.voto=voto;
		this.isCover=isCover;
		this.isRemastered=isRemastered;
		this.album=album;
		this.tr=tr;
		this.tc=tc;
	}
	
	public String getTitolo() {return titolo;}

	public Time getDurata() {return durata;}

	public String getEtichetta() {return etichetta;}

	public int getAnnoU() {return annoU;}

	public String getGenere() {return genere;}

	public String getLink() {return link;}

	public String getFormato() {return formato;}

	public int getQualita() {return qualita;}

	public int getVoto() {return voto;}

	public boolean getIsIsCover() {return isCover;}
	
	public boolean getIsIsRemastered() {return isRemastered;}
	
	public Album getAlbum() {return album;}

	public Traccia getTr() {return tr;}

	public Traccia getTc() {return tc;}
}
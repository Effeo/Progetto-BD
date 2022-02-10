package GUI;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;

import Controller.Controller;
import Model.Utente;
import javax.swing.JLabel;
import java.awt.Font;
import javax.swing.JTextField;
import javax.swing.BorderFactory;
import javax.swing.DefaultListModel;
import javax.swing.JButton;
import javax.swing.SwingConstants;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.util.ArrayList;

import Model.*;
import javax.swing.JList;
import javax.swing.JOptionPane;
import javax.swing.JScrollPane;

public class Home extends JFrame {

	private JPanel contentPane;
	private JTextField ricercaField;
	private ArrayList<Traccia> tracce;
	private JFrame home;
	
	
	public Home(JFrame login, Utente utente, Controller controller) 
	{
		login.setVisible(false);
		home = this;
		home.setVisible(true);
		
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 1067, 667);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		contentPane.setLayout(null);
		contentPane.setBackground(new Color(224, 255, 255));
		setContentPane(contentPane);
		
		JLabel lblRicerca = new JLabel("Ricerca:");
		lblRicerca.setFont(new Font("Arial", Font.PLAIN, 26));
		lblRicerca.setBounds(10, 192, 99, 37);
		contentPane.add(lblRicerca);
		
		ricercaField = new JTextField();
		ricercaField.setFont(new Font("Arial", Font.PLAIN, 22));
		ricercaField.setColumns(10);
		ricercaField.setBounds(10, 225, 453, 45);
		contentPane.add(ricercaField);
		
		JButton btnCercaAlbum = new JButton("Cerca Album");
		btnCercaAlbum.setForeground(Color.BLACK);
		btnCercaAlbum.setFont(new Font("Arial", Font.BOLD, 26));
		btnCercaAlbum.setBackground(new Color(176, 196, 222));
		btnCercaAlbum.setBounds(10, 344, 314, 37);
		contentPane.add(btnCercaAlbum);
		
		JButton btnCercaArtisti = new JButton("Cerca Artisti");
		btnCercaArtisti.setForeground(Color.BLACK);
		btnCercaArtisti.setFont(new Font("Arial", Font.BOLD, 26));
		btnCercaArtisti.setBackground(new Color(176, 196, 222));
		btnCercaArtisti.setBounds(10, 392, 314, 37);
		contentPane.add(btnCercaArtisti);
		
		JButton btnCercaPlaylist = new JButton("Cerca Playlist");
		btnCercaPlaylist.setForeground(Color.BLACK);
		btnCercaPlaylist.setFont(new Font("Arial", Font.BOLD, 26));
		btnCercaPlaylist.setBackground(new Color(176, 196, 222));
		btnCercaPlaylist.setBounds(10, 440, 314, 37);
		contentPane.add(btnCercaPlaylist);
		
		JButton btnCercaUtenti = new JButton("Cerca Utenti");
		btnCercaUtenti.setForeground(Color.BLACK);
		btnCercaUtenti.setFont(new Font("Arial", Font.BOLD, 26));
		btnCercaUtenti.setBackground(new Color(176, 196, 222));
		btnCercaUtenti.setBounds(10, 488, 314, 37);
		contentPane.add(btnCercaUtenti);
		
		JLabel lblHome = new JLabel("Home");
		lblHome.setHorizontalAlignment(SwingConstants.LEFT);
		lblHome.setForeground(new Color(34, 139, 34));
		lblHome.setFont(new Font("Arial", Font.PLAIN, 50));
		lblHome.setBounds(20, 11, 273, 54);
		contentPane.add(lblHome);
		
		JLabel lblHome_1 = new JLabel("Benvenuto " + utente.getNickname());
		lblHome_1.setHorizontalAlignment(SwingConstants.LEFT);
		lblHome_1.setForeground(Color.BLACK);
		lblHome_1.setFont(new Font("Arial", Font.PLAIN, 38));
		lblHome_1.setBounds(20, 90, 701, 54);
		contentPane.add(lblHome_1);
		
		JButton btnLeMiePlaylist = new JButton("Le mie Playlist");
		btnLeMiePlaylist.setForeground(Color.BLACK);
		btnLeMiePlaylist.setFont(new Font("Arial", Font.BOLD, 26));
		btnLeMiePlaylist.setBackground(new Color(240, 230, 140));
		btnLeMiePlaylist.setBounds(727, 28, 314, 37);
		contentPane.add(btnLeMiePlaylist);
		
		JButton btnEsciDallaccount = new JButton("Esci dall'account");
		btnEsciDallaccount.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				login.setVisible(true);
				System.out.println("Ti trovi in login");
				home.dispose();
			}
		});
		btnEsciDallaccount.setForeground(Color.BLACK);
		btnEsciDallaccount.setFont(new Font("Arial", Font.BOLD, 26));
		btnEsciDallaccount.setBackground(Color.RED);
		btnEsciDallaccount.setBounds(727, 124, 314, 37);
		contentPane.add(btnEsciDallaccount);
		
		JButton btnIlMioProfilo = new JButton("Il mio profilo");
		btnIlMioProfilo.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				
			}
		});
		btnIlMioProfilo.setForeground(Color.BLACK);
		btnIlMioProfilo.setFont(new Font("Arial", Font.BOLD, 26));
		btnIlMioProfilo.setBackground(new Color(0, 128, 0));
		btnIlMioProfilo.setBounds(727, 76, 314, 37);
		contentPane.add(btnIlMioProfilo);
		
		JScrollPane scrollPane = new JScrollPane();
		scrollPane.setBounds(494, 296, 547, 229);
		scrollPane.setBackground(new Color(224, 255, 255));
		contentPane.add(scrollPane);
		
		JList list = new JList();
		list.setFont(new Font("Arial", Font.PLAIN, 26));
		scrollPane.setViewportView(list);
		list.setBackground(new Color(224, 255, 255));
		list.setBorder(BorderFactory.createEtchedBorder());
		
		JButton btnDettagli = new JButton("Dettagli");
		btnDettagli.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				System.out.println(list.getSelectedIndex());
			}
		});
		btnDettagli.setForeground(Color.BLACK);
		btnDettagli.setFont(new Font("Arial", Font.BOLD, 26));
		btnDettagli.setBackground(new Color(244, 164, 96));
		btnDettagli.setBounds(494, 558, 154, 37);
		contentPane.add(btnDettagli);
		btnDettagli.setVisible(false);
		
		JButton btnAscolta = new JButton("Ascolta");
		btnAscolta.setForeground(Color.BLACK);
		btnAscolta.setFont(new Font("Arial", Font.BOLD, 26));
		btnAscolta.setBackground(new Color(244, 164, 96));
		btnAscolta.setBounds(692, 558, 154, 37);
		contentPane.add(btnAscolta);
		btnAscolta.setVisible(false);
		
		JButton btnVota = new JButton("Vota");
		btnVota.setForeground(Color.BLACK);
		btnVota.setFont(new Font("Arial", Font.BOLD, 26));
		btnVota.setBackground(new Color(244, 164, 96));
		btnVota.setBounds(887, 558, 154, 37);
		contentPane.add(btnVota);
		btnVota.setVisible(false);
		
		list.setVisible(false);
		scrollPane.setVisible(false);
		
		JButton btnCercaTracce = new JButton("Cerca Tracce");
		btnCercaTracce.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				if(utente.getIsIspremium() || utente.getIsIsadmin())
				{
					tracce = controller.takeTraccia("SELECT * FROM TRACCIA WHERE TITOLO = '"+ ricercaField.getText() + "'");
					
				}
				else
				{
					tracce = controller.takeTraccia("SELECT * FROM TRACCIA WHERE TITOLO = '"+ ricercaField.getText() + "' AND qualita = 128;");
				}
				System.out.println(tracce.size());
				if(tracce.size() != 0)
				{
					btnDettagli.setVisible(true);
					btnAscolta.setVisible(true);
					scrollPane.setVisible(true);
					list.setVisible(true);
					if(utente.getIsIspremium() || utente.getIsIspremium())
					{
						btnVota.setVisible(true);
					}
					int i;
					DefaultListModel mdl = new DefaultListModel();
					for(i = 0; i < tracce.size(); i++)
					{
						mdl.addElement(""+ tracce.get(i).getTitolo() + ", " + tracce.get(i).getFormato() + ", " + tracce.get(i).getQualita());
					}
					
					list.setModel(mdl);
				}
				else
				{
					JOptionPane.showMessageDialog(btnCercaTracce, "Non esistono tracce con il titolo inserito");
				}
			}
		});
		btnCercaTracce.setForeground(Color.BLACK);
		btnCercaTracce.setFont(new Font("Arial", Font.BOLD, 26));
		btnCercaTracce.setBackground(new Color(176, 196, 222));
		btnCercaTracce.setBounds(10, 296, 314, 37);
		contentPane.add(btnCercaTracce);
		
		
	}
}

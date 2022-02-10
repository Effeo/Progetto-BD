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
import javax.swing.SwingConstants;
import javax.swing.JTextField;
import javax.swing.JButton;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import javax.swing.JCheckBox;

public class MyUtente extends JFrame {

	private JPanel contentPane;
	
	private JFrame myUtente;
	private JTextField NikName;
	private JTextField Nome;
	private JTextField DataN;
	private JTextField Descrizione;
	private JTextField Email;
	private JTextField Cognome;
	private JTextField Sesso;
	private JTextField Password;
	private JTextField Nazione;


	public MyUtente(JFrame home, Utente utente, Controller controller) {
		System.out.println("Sei in MyUtente");
		
		home.setVisible(false);
		myUtente=this;
		myUtente.setVisible(true);
		
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 1067, 667);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		contentPane.setLayout(null);
		contentPane.setBackground(new Color(224, 255, 255));
		setContentPane(contentPane);
		
		JLabel lblNickName = new JLabel("Nickname:");
		lblNickName.setFont(new Font("Arial", Font.PLAIN, 26));
		lblNickName.setBounds(10, 89, 144, 37);
		contentPane.add(lblNickName);
		
		JLabel lblMyUtente = new JLabel("Il mio profilo");
		lblMyUtente.setHorizontalAlignment(SwingConstants.LEFT);
		lblMyUtente.setForeground(new Color(34, 139, 34));
		lblMyUtente.setFont(new Font("Arial", Font.PLAIN, 50));
		lblMyUtente.setBounds(10, 10, 329, 54);
		contentPane.add(lblMyUtente);
		
		NikName = new JTextField();
		NikName.setEditable(false);
		NikName.setFont(new Font("Arial", Font.PLAIN, 22));
		NikName.setColumns(10);
		NikName.setBounds(0, 136, 227, 45);
		contentPane.add(NikName);
		NikName.setText(utente.getNickname());
		
		JLabel lblNome = new JLabel("Nome:");
		lblNome.setFont(new Font("Arial", Font.PLAIN, 26));
		lblNome.setBounds(10, 193, 99, 37);
		contentPane.add(lblNome);
		
		Nome = new JTextField();
		Nome.setEditable(false);
		Nome.setFont(new Font("Arial", Font.PLAIN, 22));
		Nome.setColumns(10);
		Nome.setBounds(0, 240, 227, 45);
		contentPane.add(Nome);
		Nome.setText(utente.getNome());
		
		JLabel lblEmail = new JLabel("Email:");
		lblEmail.setFont(new Font("Arial", Font.PLAIN, 26));
		lblEmail.setBounds(10, 420, 129, 37);
		contentPane.add(lblEmail);
		
		JLabel lblCognome = new JLabel("Cognome:");
		lblCognome.setFont(new Font("Arial", Font.PLAIN, 26));
		lblCognome.setBounds(10, 300, 144, 37);
		contentPane.add(lblCognome);
		
		JLabel lblDataN = new JLabel("DataN:");
		lblDataN.setFont(new Font("Arial", Font.PLAIN, 26));
		lblDataN.setBounds(314, 89, 99, 37);
		contentPane.add(lblDataN);
		
		JLabel lblSesso = new JLabel("Sesso:");
		lblSesso.setFont(new Font("Arial", Font.PLAIN, 26));
		lblSesso.setBounds(314, 193, 99, 37);
		contentPane.add(lblSesso);
		
		JLabel lblDescrizione = new JLabel("Descrizione:");
		lblDescrizione.setFont(new Font("Arial", Font.PLAIN, 26));
		lblDescrizione.setBounds(314, 420, 227, 37);
		contentPane.add(lblDescrizione);
		
		JLabel lblIsAdmin = new JLabel("Admin:");
		lblIsAdmin.setFont(new Font("Arial", Font.PLAIN, 26));
		lblIsAdmin.setBounds(314, 593, 81, 37);
		contentPane.add(lblIsAdmin);
		
		JLabel lblNazione = new JLabel("Nazione:");
		lblNazione.setFont(new Font("Arial", Font.PLAIN, 26));
		lblNazione.setBounds(314, 300, 144, 37);
		contentPane.add(lblNazione);
		
		JLabel lblIsPremium = new JLabel("Premium:");
		lblIsPremium.setFont(new Font("Arial", Font.PLAIN, 26));
		lblIsPremium.setBounds(314, 535, 116, 37);
		contentPane.add(lblIsPremium);
		
		JLabel lblPassword = new JLabel("Password:");
		lblPassword.setFont(new Font("Arial", Font.PLAIN, 26));
		lblPassword.setBounds(10, 532, 159, 37);
		contentPane.add(lblPassword);
		
		DataN = new JTextField();
		DataN.setEditable(false);
		DataN.setFont(new Font("Arial", Font.PLAIN, 22));
		DataN.setColumns(10);
		DataN.setBounds(314, 136, 227, 45);
		contentPane.add(DataN);
		DataN.setText(utente.getDatan()); //Data e'di tipo Data ma nel text vuole stringhe...
		
		Descrizione = new JTextField();
		Descrizione.setEditable(false);
		Descrizione.setFont(new Font("Arial", Font.PLAIN, 22));
		Descrizione.setColumns(10);
		Descrizione.setBounds(314, 480, 227, 45);
		contentPane.add(Descrizione);
		Descrizione.setText(utente.getDescrizione());
		
		Email = new JTextField();
		Email.setEditable(false);
		Email.setFont(new Font("Arial", Font.PLAIN, 22));
		Email.setColumns(10);
		Email.setBounds(0, 469, 227, 45);
		contentPane.add(Email);
		Email.setText(utente.getMail());
		
		Cognome = new JTextField();
		Cognome.setEditable(false);
		Cognome.setFont(new Font("Arial", Font.PLAIN, 22));
		Cognome.setColumns(10);
		Cognome.setBounds(0, 347, 227, 45);
		contentPane.add(Cognome);
		Cognome.setText(utente.getCognome());
		
		Sesso = new JTextField();
		Sesso.setEditable(false);
		Sesso.setFont(new Font("Arial", Font.PLAIN, 22));
		Sesso.setColumns(10);
		Sesso.setBounds(314, 240, 227, 45);
		contentPane.add(Sesso);
		Sesso.setText(utente.getSesso());
		
		Password = new JTextField();
		Password.setEditable(false);
		Password.setFont(new Font("Arial", Font.PLAIN, 22));
		Password.setColumns(10);
		Password.setBounds(0, 585, 227, 45);
		contentPane.add(Password);
		Password.setText(utente.getPassword());
		
		Nazione = new JTextField();
		Nazione.setEditable(false);
		Nazione.setFont(new Font("Arial", Font.PLAIN, 22));
		Nazione.setColumns(10);
		Nazione.setBounds(314, 347, 227, 45);
		contentPane.add(Nazione);
		Nazione.setText(utente.getNazione());
		
		
		
		JButton btnConferma = new JButton("Conferma"); //NN ho capito ceh cazzo di errore est
		btnConferma.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
			
			
				
			
				Nome.setEditable(false);
				Cognome.setEditable(false);
				Descrizione.setEditable(false);
				Nazione.setEditable(false);
				Sesso.setEditable(false);
				btnConferma.setVisible(true);
				// non so come dirgli ceh dopo modifica deve aggiornare i valori di isPremium e isAdmin(dovrebbe essere lopposto di ckcbox=utente.getIsBool)
				// ho creato un metodo sta in Utentemplementazione Dao per aggiornare , ma n ho capito come passarlgi i valori,buona notte
				
				
			}
		});
		btnConferma.setForeground(Color.BLACK);
		btnConferma.setFont(new Font("Arial", Font.BOLD, 26));
		btnConferma.setBackground(Color.RED);
		btnConferma.setBounds(527, 535, 314, 37);
		contentPane.add(btnConferma);
		btnConferma.setVisible(false);
		
		JButton btnModifica = new JButton("Modifica");
		btnModifica.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				btnConferma.setVisible(true);
				
				Nome.setEditable(true);
				Cognome.setEditable(true);
				Descrizione.setEditable(true);
				Nazione.setEditable(true);
				Sesso.setEditable(true);
				
			}
		});
		btnModifica.setForeground(Color.BLACK);
		btnModifica.setFont(new Font("Arial", Font.BOLD, 26));
		btnModifica.setBackground(Color.RED);
		btnModifica.setBounds(729, 587, 314, 37);
		contentPane.add(btnModifica);
		
		JButton btnTornaIndietro = new JButton("Torna Indietro");
		btnTornaIndietro.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				home.setVisible(true);
				System.out.println("Sono tornato in home");
				myUtente.dispose();
				
			}
		});
		btnTornaIndietro.setForeground(Color.BLACK);
		btnTornaIndietro.setFont(new Font("Arial", Font.BOLD, 26));
		btnTornaIndietro.setBackground(Color.RED);
		btnTornaIndietro.setBounds(729, 102, 314, 37);
		contentPane.add(btnTornaIndietro);
		
		JButton btnCancellaAccount = new JButton("Elimina Account");
		btnCancellaAccount.setForeground(Color.BLACK);
		btnCancellaAccount.setFont(new Font("Arial", Font.BOLD, 26));
		btnCancellaAccount.setBackground(Color.RED);
		btnCancellaAccount.setBounds(471, 587, 247, 37);
		contentPane.add(btnCancellaAccount);
		
		JCheckBox chckbxPremium = new JCheckBox("");
		chckbxPremium.setBounds(422, 545, 21, 21);
		contentPane.add(chckbxPremium);
		chckbxPremium.setSelected(utente.getIspremium());
		
		JCheckBox chckbxAdmin = new JCheckBox("");
		chckbxAdmin.setBounds(401, 603, 21, 21);
		contentPane.add(chckbxAdmin);
		chckbxAdmin.setSelected(utente.getIsadmin());
	}
}

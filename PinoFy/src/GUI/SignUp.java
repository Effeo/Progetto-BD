package GUI;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;

import Controller.Controller;
import javax.swing.JLabel;
import javax.swing.JOptionPane;

import java.awt.Font;
import javax.swing.JTextField;
import javax.swing.SwingConstants;
import javax.swing.JRadioButton;
import javax.swing.JButton;
import javax.swing.JPasswordField;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import junit.extensions.RepeatedTest;
import junit.framework.Test;
import com.toedter.calendar.JCalendar;
import com.toedter.calendar.JDayChooser;
import com.toedter.calendar.JMonthChooser;
import com.toedter.calendar.JYearChooser;

public class SignUp extends JFrame {

	private JPanel contentPane;
	private JFrame signUp;
	private Controller controller;
	private JTextField nickNameField;
	private JTextField nomeField;
	private JTextField cognomeField;
	private JTextField DescrizioneField;
	private JTextField emailField;
	private JPasswordField passwordField;
	private JPasswordField passwordConfField;
	private JTextField nazField;
	
	public SignUp(Controller controller, JFrame login) {
		setTitle("SignUp");
		System.out.println("Ti trovi in sign up");
		signUp = this;
		this.controller = controller;
		login.setVisible(false);
		this.setVisible(true);
		
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 1161, 851);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		contentPane.setLayout(null);
		contentPane.setBackground(new Color(224, 255, 255));
		setContentPane(contentPane);
		
		JLabel lblNewLabel = new JLabel("Registrazione nuovo utente");
		lblNewLabel.setForeground(new Color(34, 139, 34));
		lblNewLabel.setFont(new Font("Arial", Font.BOLD, 30));
		lblNewLabel.setBounds(391, 11, 392, 34);
		contentPane.add(lblNewLabel);
		
		JLabel lblNewLabel_1 = new JLabel("NickName:");
		lblNewLabel_1.setFont(new Font("Arial", Font.PLAIN, 26));
		lblNewLabel_1.setBounds(78, 61, 136, 34);
		contentPane.add(lblNewLabel_1);
		
		nickNameField = new JTextField();
		nickNameField.setFont(new Font("Arial", Font.PLAIN, 22));
		nickNameField.setColumns(10);
		nickNameField.setBounds(78, 90, 311, 45);
		contentPane.add(nickNameField);
		
		JLabel lblNewLabel_1_1 = new JLabel("Nome:");
		lblNewLabel_1_1.setFont(new Font("Arial", Font.PLAIN, 26));
		lblNewLabel_1_1.setBounds(78, 147, 136, 34);
		contentPane.add(lblNewLabel_1_1);
		
		nomeField = new JTextField();
		nomeField.setFont(new Font("Arial", Font.PLAIN, 22));
		nomeField.setColumns(10);
		nomeField.setBounds(78, 181, 311, 45);
		contentPane.add(nomeField);
		
		JLabel lblNewLabel_1_1_1 = new JLabel("Cognome:");
		lblNewLabel_1_1_1.setFont(new Font("Arial", Font.PLAIN, 26));
		lblNewLabel_1_1_1.setBounds(78, 237, 136, 34);
		contentPane.add(lblNewLabel_1_1_1);
		
		cognomeField = new JTextField();
		cognomeField.setFont(new Font("Arial", Font.PLAIN, 22));
		cognomeField.setColumns(10);
		cognomeField.setBounds(77, 269, 311, 45);
		contentPane.add(cognomeField);
		
		JLabel dataNField = new JLabel("Data di nascita:");
		dataNField.setFont(new Font("Arial", Font.PLAIN, 26));
		dataNField.setBounds(77, 325, 217, 34);
		contentPane.add(dataNField);
		
		JLabel lblNewLabel_1_1_1_1_1 = new JLabel("Descrizione:");
		lblNewLabel_1_1_1_1_1.setFont(new Font("Arial", Font.PLAIN, 26));
		lblNewLabel_1_1_1_1_1.setBounds(634, 325, 178, 34);
		contentPane.add(lblNewLabel_1_1_1_1_1);
		
		DescrizioneField = new JTextField();
		DescrizioneField.setFont(new Font("Arial", Font.PLAIN, 22));
		DescrizioneField.setColumns(10);
		DescrizioneField.setBounds(634, 370, 311, 45);
		contentPane.add(DescrizioneField);
		
		JLabel lblNewLabel_2 = new JLabel("*");
		lblNewLabel_2.setHorizontalAlignment(SwingConstants.LEFT);
		lblNewLabel_2.setFont(new Font("Arial", Font.BOLD, 36));
		lblNewLabel_2.setBounds(391, 90, 50, 46);
		contentPane.add(lblNewLabel_2);
		
		JLabel lblNewLabel_2_1 = new JLabel("*");
		lblNewLabel_2_1.setHorizontalAlignment(SwingConstants.LEFT);
		lblNewLabel_2_1.setFont(new Font("Arial", Font.BOLD, 36));
		lblNewLabel_2_1.setBounds(391, 181, 50, 46);
		contentPane.add(lblNewLabel_2_1);
		
		JLabel lblNewLabel_2_2 = new JLabel("*");
		lblNewLabel_2_2.setHorizontalAlignment(SwingConstants.LEFT);
		lblNewLabel_2_2.setFont(new Font("Arial", Font.BOLD, 36));
		lblNewLabel_2_2.setBounds(391, 269, 50, 46);
		contentPane.add(lblNewLabel_2_2);
		
		JLabel lblNewLabel_2_3 = new JLabel("*");
		lblNewLabel_2_3.setHorizontalAlignment(SwingConstants.LEFT);
		lblNewLabel_2_3.setFont(new Font("Arial", Font.BOLD, 36));
		lblNewLabel_2_3.setBounds(259, 325, 50, 46);
		contentPane.add(lblNewLabel_2_3);
		
		JLabel lblNewLabel_1_1_1_1_1_1 = new JLabel("I campi con l'asterisco (*) sono obbligatori.");
		lblNewLabel_1_1_1_1_1_1.setFont(new Font("Arial", Font.PLAIN, 26));
		lblNewLabel_1_1_1_1_1_1.setBounds(10, 767, 493, 34);
		contentPane.add(lblNewLabel_1_1_1_1_1_1);
		
		JLabel lbl = new JLabel("Email (nomeutente@dominio.it o altro):");
		lbl.setFont(new Font("Arial", Font.PLAIN, 26));
		lbl.setBounds(634, 56, 462, 34);
		contentPane.add(lbl);
		
		emailField = new JTextField();
		emailField.setFont(new Font("Arial", Font.PLAIN, 22));
		emailField.setColumns(10);
		emailField.setBounds(634, 90, 311, 45);
		contentPane.add(emailField);
		
		JLabel lblNewLabel_1_1_2 = new JLabel("Password:");
		lblNewLabel_1_1_2.setFont(new Font("Arial", Font.PLAIN, 26));
		lblNewLabel_1_1_2.setBounds(634, 147, 136, 34);
		contentPane.add(lblNewLabel_1_1_2);
		
		JLabel lblNewLabel_1_1_2_1 = new JLabel("Conferma password:");
		lblNewLabel_1_1_2_1.setFont(new Font("Arial", Font.PLAIN, 26));
		lblNewLabel_1_1_2_1.setBounds(634, 237, 251, 34);
		contentPane.add(lblNewLabel_1_1_2_1);
		
		JRadioButton premiumRdb = new JRadioButton("Utente premium");
		premiumRdb.setBackground(new Color(224, 255, 255));
		premiumRdb.setFont(new Font("Arial", Font.PLAIN, 26));
		premiumRdb.setBounds(634, 637, 217, 34);
		contentPane.add(premiumRdb);
		
		JLabel lblNewLabel_2_4 = new JLabel("*");
		lblNewLabel_2_4.setHorizontalAlignment(SwingConstants.LEFT);
		lblNewLabel_2_4.setFont(new Font("Arial", Font.BOLD, 36));
		lblNewLabel_2_4.setBounds(948, 89, 50, 46);
		contentPane.add(lblNewLabel_2_4);
		
		JLabel lblNewLabel_2_5 = new JLabel("*");
		lblNewLabel_2_5.setHorizontalAlignment(SwingConstants.LEFT);
		lblNewLabel_2_5.setFont(new Font("Arial", Font.BOLD, 36));
		lblNewLabel_2_5.setBounds(948, 181, 50, 46);
		contentPane.add(lblNewLabel_2_5);
		
		JLabel lblNewLabel_2_6 = new JLabel("*");
		lblNewLabel_2_6.setHorizontalAlignment(SwingConstants.LEFT);
		lblNewLabel_2_6.setFont(new Font("Arial", Font.BOLD, 36));
		lblNewLabel_2_6.setBounds(948, 269, 50, 46);
		contentPane.add(lblNewLabel_2_6);
		
		passwordField = new JPasswordField();
		passwordField.setFont(new Font("Arial", Font.PLAIN, 22));
		passwordField.setBounds(634, 181, 311, 44);
		contentPane.add(passwordField);
		
		passwordConfField = new JPasswordField();
		passwordConfField.setFont(new Font("Arial", Font.PLAIN, 22));
		passwordConfField.setBounds(634, 269, 311, 44);
		contentPane.add(passwordConfField);
		
		JCalendar calendar = new JCalendar();
		calendar.setBounds(78, 370, 400, 200);
		contentPane.add(calendar);
		
		JLabel lblNazionalit = new JLabel("Nazionalit\u00E0:");
		lblNazionalit.setFont(new Font("Arial", Font.PLAIN, 26));
		lblNazionalit.setBounds(78, 594, 136, 34);
		contentPane.add(lblNazionalit);
		
		nazField = new JTextField();
		nazField.setFont(new Font("Arial", Font.PLAIN, 22));
		nazField.setColumns(10);
		nazField.setBounds(78, 634, 311, 45);
		contentPane.add(nazField);
		
		JLabel lblNewLabel_2_2_1 = new JLabel("*");
		lblNewLabel_2_2_1.setHorizontalAlignment(SwingConstants.LEFT);
		lblNewLabel_2_2_1.setFont(new Font("Arial", Font.BOLD, 36));
		lblNewLabel_2_2_1.setBounds(391, 634, 50, 46);
		contentPane.add(lblNewLabel_2_2_1);
		
		JLabel lblSesso = new JLabel("Sesso:");
		lblSesso.setFont(new Font("Arial", Font.PLAIN, 26));
		lblSesso.setBounds(634, 426, 83, 34);
		contentPane.add(lblSesso);
		
		JLabel lblNewLabel_2_2_1_1 = new JLabel("*");
		lblNewLabel_2_2_1_1.setHorizontalAlignment(SwingConstants.LEFT);
		lblNewLabel_2_2_1_1.setFont(new Font("Arial", Font.BOLD, 36));
		lblNewLabel_2_2_1_1.setBounds(720, 426, 50, 46);
		contentPane.add(lblNewLabel_2_2_1_1);
		
		JRadioButton uomoRb = new JRadioButton("Uomo");
		uomoRb.setFont(new Font("Arial", Font.PLAIN, 26));
		uomoRb.setBackground(new Color(224, 255, 255));
		uomoRb.setBounds(634, 468, 217, 34);
		contentPane.add(uomoRb);
		
		JRadioButton rdbtnDonna = new JRadioButton("Donna");
		rdbtnDonna.setFont(new Font("Arial", Font.PLAIN, 26));
		rdbtnDonna.setBackground(new Color(224, 255, 255));
		rdbtnDonna.setBounds(853, 468, 217, 34);
		contentPane.add(rdbtnDonna);
		
		JRadioButton rdbtnTransgender = new JRadioButton("Transgender");
		rdbtnTransgender.setFont(new Font("Arial", Font.PLAIN, 26));
		rdbtnTransgender.setBackground(new Color(224, 255, 255));
		rdbtnTransgender.setBounds(634, 505, 217, 34);
		contentPane.add(rdbtnTransgender);
		
		JRadioButton rdbtnLampadina = new JRadioButton("Lampadina");
		rdbtnLampadina.setFont(new Font("Arial", Font.PLAIN, 26));
		rdbtnLampadina.setBackground(new Color(224, 255, 255));
		rdbtnLampadina.setBounds(853, 505, 217, 34);
		contentPane.add(rdbtnLampadina);
		
		JRadioButton rdbtnUnicorno = new JRadioButton("Unicorno");
		rdbtnUnicorno.setFont(new Font("Arial", Font.PLAIN, 26));
		rdbtnUnicorno.setBackground(new Color(224, 255, 255));
		rdbtnUnicorno.setBounds(634, 542, 217, 34);
		contentPane.add(rdbtnUnicorno);
		
		JLabel lblTipoDiUtente = new JLabel("Tipo di Utente:");
		lblTipoDiUtente.setFont(new Font("Arial", Font.PLAIN, 26));
		lblTipoDiUtente.setBounds(634, 594, 178, 34);
		contentPane.add(lblTipoDiUtente);
		
		JRadioButton rdbtnUtenteBase = new JRadioButton("Utente base");
		rdbtnUtenteBase.setFont(new Font("Arial", Font.PLAIN, 26));
		rdbtnUtenteBase.setBackground(new Color(224, 255, 255));
		rdbtnUtenteBase.setBounds(853, 637, 217, 34);
		contentPane.add(rdbtnUtenteBase);
		
		JButton confermaBTN = new JButton("Conferma");
		confermaBTN.setForeground(Color.BLACK);
		confermaBTN.setFont(new Font("Arial", Font.BOLD, 26));
		confermaBTN.setBackground(new Color(0, 128, 0));
		confermaBTN.setBounds(634, 689, 330, 45);
		contentPane.add(confermaBTN);
		confermaBTN.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				String premium = "False";
				String sesso = "";
				JMonthChooser mm;
				JDayChooser gg;
				JYearChooser aa;
				String data = "";
				boolean existsNickName, existsEmail;
				int esito;
				
				if(premiumRdb.isSelected()) {
					premium = "True";
				}
				
				if(uomoRb.isSelected())
				{
					sesso = "Uomo";
				}
				
				if(rdbtnDonna.isSelected())
				{
					sesso = "Donna";
				}
				
				if(rdbtnTransgender.isSelected())
				{
					sesso = "Transgender";
				}
				
				if(rdbtnLampadina.isSelected())
				{
					sesso = "Lampadina";
				}
				
				if(rdbtnUnicorno.isSelected())
				{
					sesso = "Unicorno";
				}
				
				mm = calendar.getMonthChooser();
				gg = calendar.getDayChooser();
				aa = calendar.getYearChooser();
				data = String.valueOf(aa.getYear()) + "-" + String.valueOf(mm.getMonth() + 1) + "-" + String.valueOf(gg.getDay()); 
				
				if(passwordField.getText().equals(passwordConfField.getText()))
				{
					existsNickName = controller.checkNickName(nickNameField.getText());
					existsEmail = controller.checkEmail(emailField.getText());
					
					if(!existsNickName && !existsEmail)
					{
						esito = controller.signUp(nickNameField.getText(), emailField.getText(), passwordField.getText(), nomeField.getText(), cognomeField.getText(), nazField.getText(), DescrizioneField.getText(), sesso, data, premium, "False");
						if(esito > 0)
						{
							JOptionPane.showMessageDialog(confermaBTN, "Creazione avvenuta con successo!");
							login.setVisible(true);
							System.out.println("Ti trovi in login in");
							signUp.dispose();
						}
						else
						{
							JOptionPane.showMessageDialog(confermaBTN, "Errore: controlla di aver compilato tutti i campi obbligatori e aver rispettato i vincoli");
						}
					}
					else if(existsNickName && !existsEmail)
					{
						JOptionPane.showMessageDialog(confermaBTN, "Errore: NickName già in uso");
					}
					else if(!existsNickName && existsEmail)
					{
						JOptionPane.showMessageDialog(confermaBTN, "Errore: Email già in uso");
					}
					else
					{
						JOptionPane.showMessageDialog(confermaBTN, "Errore: Email e NickName già in uso");
					}
				}
				else
				{
					JOptionPane.showMessageDialog(confermaBTN, "Le password non corrispondono");
				}
			}
		});
	}
}

package GUI;

import java.awt.BorderLayout;
import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;

import Controller.Controller;
import Model.Utente;

import java.awt.GridLayout;
import javax.swing.BoxLayout;
import java.awt.GridBagLayout;
import javax.swing.JLabel;
import javax.swing.JOptionPane;

import java.awt.Font;
import java.awt.Color;
import javax.swing.JPasswordField;
import javax.swing.SwingConstants;
import javax.swing.JTextField;
import javax.swing.JButton;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import javax.swing.UIManager;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import javax.swing.JToggleButton;
import javax.swing.JCheckBox;
import javax.swing.ImageIcon;

public class Login extends JFrame {

	private JPanel contentPane;
	private JPasswordField passwordField;
	private JTextField emailField;
	private Controller controller;
	private JFrame login;
	private Utente utente; 
	
	public Login(Controller controller)
	{
		System.out.println("ti trovi in login");
		this.controller = controller;
		initialize();
		login.setVisible(true);
	}
	
	private void initialize() {
		login = new JFrame();
		login.setBackground(new Color(0, 0, 0));
		login.setTitle("Login");
		login.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		login.setBounds(100, 100, 1067, 667);
		contentPane = new JPanel();
		contentPane.setBackground(new Color(224, 255, 255));
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		login.setContentPane(contentPane);
		contentPane.setLayout(null);
		
		JLabel emailLB = new JLabel("Email:");
		emailLB.setFont(new Font("Arial", Font.PLAIN, 26));
		emailLB.setBounds(426, 126, 99, 37);
		contentPane.add(emailLB);
		
		JLabel passwordLB = new JLabel("Password:");
		passwordLB.setFont(new Font("Arial", Font.PLAIN, 26));
		passwordLB.setBounds(426, 226, 151, 37);
		contentPane.add(passwordLB);
		
		passwordField = new JPasswordField();
		passwordField.setFont(new Font("Arial", Font.PLAIN, 22));
		passwordField.setHorizontalAlignment(SwingConstants.LEFT);
		passwordField.setBounds(426, 258, 311, 45);
		contentPane.add(passwordField);
		
		emailField = new JTextField();
		emailField.setText("francesco.orlando3@studenti.unina.it");
		emailField.setFont(new Font("Arial", Font.PLAIN, 22));
		emailField.setBounds(426, 160, 311, 45);
		contentPane.add(emailField);
		emailField.setColumns(10);
		
		JLabel lblLogin = new JLabel("PinoFy");
		lblLogin.setForeground(new Color(34, 139, 34));
		lblLogin.setHorizontalAlignment(SwingConstants.CENTER);
		lblLogin.setFont(new Font("Arial", Font.PLAIN, 50));
		lblLogin.setBounds(447, 23, 273, 54);
		contentPane.add(lblLogin);
		
		JButton loginBTN = new JButton("Sign in");
		loginBTN.setForeground(new Color(0, 0, 0));
		loginBTN.setBackground(new Color(0, 128, 0));
		loginBTN.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
			}
		});
		loginBTN.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				utente = controller.login(emailField.getText(), passwordField.getText());
				
				if(utente == null) 
				{
					JOptionPane.showMessageDialog(loginBTN, "Email o password errata");
				}
				else 
				{
					Home home = new Home(login, utente, controller);
					passwordField.setText("");
					emailField.setText("");
					System.out.println(utente.getCognome());
				}
				
			}
		});
		loginBTN.setFont(new Font("Arial", Font.BOLD, 26));
		loginBTN.setBounds(426, 338, 314, 37);
		contentPane.add(loginBTN);
		
		JButton registratiBTN = new JButton("Sign up");
		registratiBTN.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				SignUp signUp = new SignUp(controller, login);
				passwordField.setText("");
				emailField.setText("");
			}
		});
		registratiBTN.setBackground(new Color(220, 20, 60));
		registratiBTN.setFont(new Font("Arial", Font.BOLD, 26));
		registratiBTN.setBounds(426, 396, 314, 37);
		contentPane.add(registratiBTN);
		
		JPanel panel = new JPanel();
		panel.setBackground(new Color(224, 255, 255));
		panel.setForeground(new Color(255, 255, 255));
		panel.setBounds(55, 38, 187, 281);
		contentPane.add(panel);
		panel.setLayout(null);
		
		JLabel lblNewLabel = new JLabel("");
		lblNewLabel.setBackground(new Color(176, 224, 230));
		lblNewLabel.setIcon(new ImageIcon(Login.class.getResource("/images/pino.jpg")));
		lblNewLabel.setBounds(0, 0, 195, 279);
		panel.add(lblNewLabel);
		
	}
}

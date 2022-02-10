package DAO;

import java.util.ArrayList;

import Model.Traccia;

public interface TracciaDAO {
	ArrayList<Traccia> takeTraccia(String query);
}

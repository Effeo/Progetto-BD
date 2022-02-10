package DAO;

import java.util.ArrayList;

import Model.Album;

public interface AlbumDAO {
	ArrayList<Album> takeAlbum(String query);
}

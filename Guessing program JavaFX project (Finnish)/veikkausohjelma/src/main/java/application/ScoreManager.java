package application;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public class ScoreManager {

    // Laskee ja tallentaa pisteet tietokantaan kisa-, ottelu- ja osallistujaID:n perusteella.
    public static void calculateAndSaveScores() throws SQLException {
        try {
            // Hae kaikki tarvittavat tiedot yhdellä kyselyllä
            List<Map<String, Integer>> data = FetchData.haeKaikkiKisatOsallistujatJaOttelut();

            // Käy läpi jokainen kisa, ottelu ja osallistuja
            for (Map<String, Integer> row : data) {
                int kisaId = row.get("kisa_id");
                int otteluId = row.get("ottelu_id");
                int osallistujaId = row.get("osallistuja_id");

                // Tarkista, onko pisteet jo olemassa
                if (isScoreAlreadySaved(osallistujaId, kisaId, otteluId)) {
                    continue; // Ohita, jos pisteet on jo tallennettu
                }

                // Hae veikkaukset ja ottelut tälle yhdistelmälle
                ResultSet resultSet = FetchData.getVeikkauksetAndOttelut(kisaId, osallistujaId, otteluId);

                // Laske pisteet
                Map<Integer, Piste> scores = ScoreCalculator.calculateScores(resultSet);

                // Tallenna pisteet tietokantaan
                saveScoresToDatabase(scores, kisaId, otteluId);
            }

            System.out.println("Pisteet laskettu ja tallennettu onnistuneesti kaikille kisoille ja otteluille.");
        } catch (SQLException e) {
            System.err.println("Virhe pisteiden laskennassa tai tallentamisessa: " + e.getMessage());
            throw e; // Heitä virhe eteenpäin
        }
    }

    // Tallentaa pisteet tietokantaan
    private static void saveScoresToDatabase(Map<Integer, Piste> scores, int kisaId, int otteluId) throws SQLException {
        String query = "INSERT INTO pisteet (osallistuja_id, kisa_id, ottelu_id, pisteet, pisteet1x2, pisteetLisapisteet) " +
                       "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection connection = Database.connect();
             PreparedStatement statement = connection.prepareStatement(query)) {

            for (Map.Entry<Integer, Piste> entry : scores.entrySet()) {
                Piste piste = entry.getValue();

                statement.setInt(1, piste.getOsallistujaId());
                statement.setInt(2, kisaId);
                statement.setInt(3, otteluId);
                statement.setInt(4, piste.getPisteet());
                statement.setInt(5, piste.getPisteet1x2());
                statement.setInt(6, piste.getPisteetLisapisteet());
                statement.addBatch(); // Käytä batch-prosessointia
            }
            statement.executeBatch(); // Suorita kaikki kyselyt yhdellä kertaa
        }
    }

    // Tarkistaa, onko pisteet jo tallennettu tietokantaan osallistuja-, kisa- ja otteluID-triolla.
    private static boolean isScoreAlreadySaved(int osallistujaId, int kisaId, int otteluId) throws SQLException {
        String query = "SELECT COUNT(*) FROM pisteet WHERE osallistuja_id = ? AND kisa_id = ? AND ottelu_id = ?";

        try (Connection connection = Database.connect();
             PreparedStatement statement = connection.prepareStatement(query)) {

            statement.setInt(1, osallistujaId);
            statement.setInt(2, kisaId);
            statement.setInt(3, otteluId);

            ResultSet resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0; // Palauta true, jos rivi löytyy
            }
        }

        return false; // Palauta false, jos riviä ei löydy
    }
}
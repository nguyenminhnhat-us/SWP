package utils;

import controller.DBUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class OTPDao {

    private static final String INSERT_OTP_SQL = "INSERT INTO otp_codes (email, otp) VALUES (?, ?)";

    public void saveOTP(String email, String otp) throws SQLException, ClassNotFoundException {
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_OTP_SQL)) {
            preparedStatement.setString(1, email);
            preparedStatement.setString(2, otp);
            preparedStatement.executeUpdate();
        }
    }
}

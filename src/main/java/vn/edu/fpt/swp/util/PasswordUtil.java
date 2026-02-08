package vn.edu.fpt.swp.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

/**
 * Utility class for password hashing and verification using SHA-256 with salt
 */
public class PasswordUtil {
    private static final String HASH_ALGORITHM = "SHA-256";
    private static final int SALT_LENGTH = 16;
    
    /**
     * Hash a password with a randomly generated salt
     * @param password Plain text password
     * @return Hashed password in format: salt:hash (both Base64 encoded)
     */
    public static String hashPassword(String password) {
        try {
            // Generate random salt
            byte[] salt = generateSalt();
            
            // Hash password with salt
            byte[] hash = hashWithSalt(password, salt);
            
            // Encode both salt and hash to Base64 and combine
            String saltBase64 = Base64.getEncoder().encodeToString(salt);
            String hashBase64 = Base64.getEncoder().encodeToString(hash);
            
            return saltBase64 + ":" + hashBase64;
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }
    
    /**
     * Verify a password against a stored hash
     * @param password Plain text password to verify
     * @param storedHash Stored hash in format salt:hash
     * @return true if password matches, false otherwise
     */
    public static boolean verifyPassword(String password, String storedHash) {
        try {
            // Split stored hash into salt and hash
            String[] parts = storedHash.split(":");
            if (parts.length != 2) {
                return false;
            }
            
            // Decode salt and hash from Base64
            byte[] salt = Base64.getDecoder().decode(parts[0]);
            byte[] expectedHash = Base64.getDecoder().decode(parts[1]);
            
            // Hash the provided password with the same salt
            byte[] actualHash = hashWithSalt(password, salt);
            
            // Compare hashes
            return MessageDigest.isEqual(expectedHash, actualHash);
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * Generate a random salt
     * @return Random salt bytes
     */
    private static byte[] generateSalt() {
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[SALT_LENGTH];
        random.nextBytes(salt);
        return salt;
    }
    
    /**
     * Hash password with salt using SHA-256
     * @param password Plain text password
     * @param salt Salt bytes
     * @return Hashed password bytes
     */
    private static byte[] hashWithSalt(String password, byte[] salt) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance(HASH_ALGORITHM);
        md.update(salt);
        return md.digest(password.getBytes());
    }
}

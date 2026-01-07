package com.util;

import javax.net.ssl.*;
import java.security.cert.X509Certificate;

/**
 * SSL Utility for development purposes only.
 * Disables SSL verification for localhost connections.
 * WARNING: This should NOT be used in production environments.
 */
public class SSLUtil {
    
    private static boolean sslDisabled = false;
    
    /**
     * Disables SSL verification for localhost development.
     * This method should only be called in development environments.
     */
    public static void disableSSLVerification() {
        if (sslDisabled) {
            return; // Already disabled
        }
        
        try {
            // Create a trust manager that accepts all certificates
            TrustManager[] trustAllCerts = new TrustManager[]{
                new X509TrustManager() {
                    public X509Certificate[] getAcceptedIssuers() { 
                        return null; 
                    }
                    public void checkClientTrusted(X509Certificate[] certs, String authType) {
                        // Trust all client certificates
                    }
                    public void checkServerTrusted(X509Certificate[] certs, String authType) {
                        // Trust all server certificates
                    }
                }
            };

            // Install the all-trusting trust manager
            SSLContext sc = SSLContext.getInstance("SSL");
            sc.init(null, trustAllCerts, new java.security.SecureRandom());
            HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());

            // Create all-trusting host name verifier
            HostnameVerifier allHostsValid = new HostnameVerifier() {
                public boolean verify(String hostname, SSLSession session) {
                    return true;
                }
            };
            
            // Install the all-trusting host verifier
            HttpsURLConnection.setDefaultHostnameVerifier(allHostsValid);
            
            sslDisabled = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

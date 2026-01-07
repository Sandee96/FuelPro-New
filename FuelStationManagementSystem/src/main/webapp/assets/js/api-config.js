/**
 * WSO2 API Manager Configuration
 * 
 * This file contains configuration for integrating with WSO2 API Manager.
 * Update the WSO2_GATEWAY_URL and ACCESS_TOKEN based on your WSO2 setup.
 */

const API_CONFIG = {
    // WSO2 API Manager Gateway URL
    // For HTTPS: https://localhost:8243
    // For HTTP: http://localhost:8280
    // For production: Update with your production WSO2 server URL
    WSO2_GATEWAY_URL: 'https://localhost:8243',
    
    // API Version
    API_VERSION: 'v1',
    
    // Access Token (will be set after authentication)
    // In production, this should be obtained securely and stored securely
    ACCESS_TOKEN: '',
    
    // OAuth2 Client Credentials (from WSO2 Developer Portal)
    CLIENT_ID: '', // Set this from WSO2 Developer Portal
    CLIENT_SECRET: '', // Set this from WSO2 Developer Portal
    
    // API Contexts (as configured in WSO2 Publisher)
    AUTH_API: '/fuelstation/auth/v1',
    USER_API: '/fuelstation/user/v1',
    PAYMENT_API: '/fuelstation/payment/v1',
    REFILL_API: '/fuelstation/refill/v1',
    SERVICE_API: '/fuelstation/service/v1',
    ADMIN_API: '/fuelstation/admin/v1',
    
    // Use WSO2 Gateway (set to false to use direct API calls for testing)
    USE_WSO2_GATEWAY: true
};

/**
 * Get full API URL
 * @param {string} context - API context (e.g., API_CONFIG.AUTH_API)
 * @param {string} endpoint - API endpoint (e.g., '/login')
 * @returns {string} Full API URL
 */
function getApiUrl(context, endpoint) {
    if (API_CONFIG.USE_WSO2_GATEWAY && API_CONFIG.ACCESS_TOKEN) {
        // Use WSO2 Gateway
        return `${API_CONFIG.WSO2_GATEWAY_URL}${context}${endpoint}`;
    } else {
        // Use direct backend (for testing or fallback)
        const contextPath = window.location.pathname.split('/').slice(0, -3).join('/') || '';
        return `${contextPath}${context.replace('/fuelstation/', '/api/').replace('/v1', '')}${endpoint}`;
    }
}

/**
 * Get Authorization Header
 * @returns {Object} Headers object with Authorization
 */
function getAuthHeaders() {
    const headers = {
        'Content-Type': 'application/x-www-form-urlencoded'
    };
    
    if (API_CONFIG.USE_WSO2_GATEWAY && API_CONFIG.ACCESS_TOKEN) {
        headers['Authorization'] = `Bearer ${API_CONFIG.ACCESS_TOKEN}`;
    }
    
    return headers;
}

/**
 * Get OAuth2 Access Token using Client Credentials Grant
 * @returns {Promise<string>} Access token
 */
async function getAccessToken() {
    if (!API_CONFIG.CLIENT_ID || !API_CONFIG.CLIENT_SECRET) {
        console.error('CLIENT_ID and CLIENT_SECRET must be set in API_CONFIG');
        throw new Error('OAuth2 credentials not configured');
    }
    
    const tokenUrl = `${API_CONFIG.WSO2_GATEWAY_URL}/token`;
    const credentials = btoa(`${API_CONFIG.CLIENT_ID}:${API_CONFIG.CLIENT_SECRET}`);
    
    try {
        const response = await fetch(tokenUrl, {
            method: 'POST',
            headers: {
                'Authorization': `Basic ${credentials}`,
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: 'grant_type=client_credentials'
        });
        
        if (!response.ok) {
            throw new Error(`Failed to get access token: ${response.status} ${response.statusText}`);
        }
        
        const data = await response.json();
        API_CONFIG.ACCESS_TOKEN = data.access_token;
        
        // Store token in sessionStorage (for page refresh)
        if (data.access_token) {
            sessionStorage.setItem('wso2_access_token', data.access_token);
            sessionStorage.setItem('wso2_token_expires', Date.now() + (data.expires_in * 1000));
        }
        
        return data.access_token;
    } catch (error) {
        console.error('Error getting access token:', error);
        throw error;
    }
}

/**
 * Load access token from sessionStorage if available and not expired
 */
function loadAccessToken() {
    const token = sessionStorage.getItem('wso2_access_token');
    const expires = sessionStorage.getItem('wso2_token_expires');
    
    if (token && expires && Date.now() < parseInt(expires)) {
        API_CONFIG.ACCESS_TOKEN = token;
        return true;
    }
    
    return false;
}

/**
 * Initialize API configuration
 * Loads token from storage or gets a new one
 */
async function initAPIConfig() {
    // Try to load from sessionStorage first
    if (!loadAccessToken()) {
        // If no valid token, get a new one
        if (API_CONFIG.USE_WSO2_GATEWAY && API_CONFIG.CLIENT_ID && API_CONFIG.CLIENT_SECRET) {
            try {
                await getAccessToken();
            } catch (error) {
                console.warn('Failed to get WSO2 access token, falling back to direct API calls');
                API_CONFIG.USE_WSO2_GATEWAY = false;
            }
        }
    }
}

// Auto-initialize on load
if (typeof window !== 'undefined') {
    window.addEventListener('DOMContentLoaded', initAPIConfig);
}



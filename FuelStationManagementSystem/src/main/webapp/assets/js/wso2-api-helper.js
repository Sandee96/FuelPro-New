/**
 * WSO2 API Manager Helper Functions
 * 
 * This file provides helper functions for making API calls through WSO2 API Manager Gateway.
 * Include this file after api-config.js in your HTML pages.
 */

/**
 * Make API call through WSO2 Gateway or direct backend
 * @param {string} context - API context (e.g., API_CONFIG.AUTH_API)
 * @param {string} endpoint - API endpoint (e.g., '/login')
 * @param {string} method - HTTP method (GET, POST, PUT, DELETE)
 * @param {Object|FormData|URLSearchParams} data - Request data
 * @param {Object} options - Additional fetch options
 * @returns {Promise<Object>} Response data as JSON
 */
async function callWSO2API(context, endpoint, method = 'POST', data = null, options = {}) {
    const url = getApiUrl(context, endpoint);
    const headers = getAuthHeaders();
    
    // Merge custom headers if provided
    if (options.headers) {
        Object.assign(headers, options.headers);
    }
    
    const fetchOptions = {
        method: method,
        headers: headers,
        credentials: 'include', // Include cookies for session management
        ...options
    };
    
    // Handle request body
    if (data) {
        if (data instanceof FormData) {
            // For FormData, don't set Content-Type (browser will set it with boundary)
            delete fetchOptions.headers['Content-Type'];
            fetchOptions.body = data;
        } else if (data instanceof URLSearchParams) {
            fetchOptions.body = data;
        } else if (typeof data === 'object') {
            // Convert object to URLSearchParams for form-encoded data
            const params = new URLSearchParams();
            for (const key in data) {
                if (data[key] !== null && data[key] !== undefined) {
                    params.append(key, data[key]);
                }
            }
            fetchOptions.body = params;
        } else {
            fetchOptions.body = data;
        }
    }
    
    try {
        const response = await fetch(url, fetchOptions);
        
        // Handle 401 Unauthorized - token might be expired
        if (response.status === 401 && API_CONFIG.USE_WSO2_GATEWAY) {
            console.warn('Access token expired, attempting to refresh...');
            try {
                await getAccessToken();
                // Retry the request with new token
                fetchOptions.headers['Authorization'] = `Bearer ${API_CONFIG.ACCESS_TOKEN}`;
                const retryResponse = await fetch(url, fetchOptions);
                if (!retryResponse.ok) {
                    throw new Error(`API call failed: ${retryResponse.status} ${retryResponse.statusText}`);
                }
                return await retryResponse.json();
            } catch (refreshError) {
                console.error('Failed to refresh token:', refreshError);
                throw new Error('Authentication failed. Please refresh the page.');
            }
        }
        
        if (!response.ok) {
            const errorData = await response.json().catch(() => ({ message: response.statusText }));
            throw new Error(errorData.message || `API call failed: ${response.status} ${response.statusText}`);
        }
        
        return await response.json();
    } catch (error) {
        console.error('API Error:', error);
        throw error;
    }
}

/**
 * Authentication API Calls
 */
const AuthAPI = {
    /**
     * User login
     * @param {string} email - User email
     * @param {string} password - User password
     * @returns {Promise<Object>} Login response
     */
    login: async function(email, password) {
        return await callWSO2API(API_CONFIG.AUTH_API, '/login', 'POST', { email, password });
    }
};

/**
 * User Management API Calls
 */
const UserAPI = {
    /**
     * Register new user
     * @param {Object} userData - User registration data
     * @returns {Promise<Object>} Registration response
     */
    register: async function(userData) {
        return await callWSO2API(API_CONFIG.USER_API, '/', 'POST', userData);
    },
    
    /**
     * Update user profile
     * @param {Object} userData - User update data
     * @returns {Promise<Object>} Update response
     */
    updateProfile: async function(userData) {
        return await callWSO2API(API_CONFIG.USER_API, '/update', 'POST', userData);
    },
    
    /**
     * Delete user account
     * @param {number} userId - User ID
     * @returns {Promise<Object>} Delete response
     */
    deleteUser: async function(userId) {
        return await callWSO2API(API_CONFIG.USER_API, '/delete', 'POST', { userId });
    },
    
    /**
     * Change user password
     * @param {Object} passwordData - Password change data
     * @returns {Promise<Object>} Change password response
     */
    changePassword: async function(passwordData) {
        return await callWSO2API(API_CONFIG.USER_API, '/changepassword', 'POST', passwordData);
    }
};

/**
 * Payment API Calls
 */
const PaymentAPI = {
    /**
     * Get all payments (admin only)
     * @returns {Promise<Object>} Payments list
     */
    getAllPayments: async function() {
        return await callWSO2API(API_CONFIG.PAYMENT_API, '/', 'GET');
    },
    
    /**
     * Create payment
     * @param {Object} paymentData - Payment data
     * @returns {Promise<Object>} Payment response
     */
    createPayment: async function(paymentData) {
        return await callWSO2API(API_CONFIG.PAYMENT_API, '/', 'POST', paymentData);
    },
    
    /**
     * Update payment (admin only)
     * @param {Object} paymentData - Payment update data
     * @returns {Promise<Object>} Update response
     */
    updatePayment: async function(paymentData) {
        return await callWSO2API(API_CONFIG.PAYMENT_API, '/update', 'POST', paymentData);
    },
    
    /**
     * Delete payment (admin only)
     * @param {string} id - Payment ID
     * @returns {Promise<Object>} Delete response
     */
    deletePayment: async function(id) {
        return await callWSO2API(API_CONFIG.PAYMENT_API, '/delete', 'POST', { id });
    }
};

/**
 * Refill API Calls
 */
const RefillAPI = {
    /**
     * Create refill request
     * @param {Object} refillData - Refill data
     * @returns {Promise<Object>} Refill response
     */
    createRefill: async function(refillData) {
        return await callWSO2API(API_CONFIG.REFILL_API, '/', 'POST', refillData);
    },
    
    /**
     * Delete refill request
     * @param {Object} refillData - Refill data
     * @returns {Promise<Object>} Delete response
     */
    deleteRefill: async function(refillData) {
        return await callWSO2API(API_CONFIG.REFILL_API, '/delete', 'POST', refillData);
    }
};

/**
 * Service Booking API Calls
 */
const ServiceBookingAPI = {
    /**
     * Create service booking
     * @param {Object} bookingData - Booking data
     * @returns {Promise<Object>} Booking response
     */
    createBooking: async function(bookingData) {
        return await callWSO2API(API_CONFIG.SERVICE_API, '/booking', 'POST', bookingData);
    }
};

/**
 * Admin API Calls
 */
const AdminAPI = {
    /**
     * Admin login
     * @param {string} username - Admin username
     * @param {string} password - Admin password
     * @returns {Promise<Object>} Login response
     */
    login: async function(username, password) {
        return await callWSO2API(API_CONFIG.ADMIN_API, '/', 'POST', { username, password });
    },
    
    /**
     * Get all services (admin only)
     * @returns {Promise<Object>} Services list
     */
    getAllServices: async function() {
        return await callWSO2API(API_CONFIG.ADMIN_API, '/', 'GET');
    },
    
    /**
     * Get service by ID (admin only)
     * @param {number} id - Service ID
     * @returns {Promise<Object>} Service data
     */
    getService: async function(id) {
        return await callWSO2API(API_CONFIG.ADMIN_API, `/service/${id}`, 'GET');
    },
    
    /**
     * Create service (admin only)
     * @param {Object} serviceData - Service data
     * @returns {Promise<Object>} Create response
     */
    createService: async function(serviceData) {
        return await callWSO2API(API_CONFIG.ADMIN_API, '/service', 'POST', serviceData);
    },
    
    /**
     * Update service (admin only)
     * @param {Object} serviceData - Service update data
     * @returns {Promise<Object>} Update response
     */
    updateService: async function(serviceData) {
        return await callWSO2API(API_CONFIG.ADMIN_API, '/service/update', 'POST', serviceData);
    },
    
    /**
     * Delete service (admin only)
     * @param {number} id - Service ID
     * @returns {Promise<Object>} Delete response
     */
    deleteService: async function(id) {
        return await callWSO2API(API_CONFIG.ADMIN_API, '/service/delete', 'POST', { id });
    }
};

// Export for use in other scripts
if (typeof window !== 'undefined') {
    window.AuthAPI = AuthAPI;
    window.UserAPI = UserAPI;
    window.PaymentAPI = PaymentAPI;
    window.RefillAPI = RefillAPI;
    window.ServiceBookingAPI = ServiceBookingAPI;
    window.AdminAPI = AdminAPI;
    window.callWSO2API = callWSO2API;
}


